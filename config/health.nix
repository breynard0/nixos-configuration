{ pkgs, ... }:
let
  watchdog = pkgs.writeShellApplication {
    name = "health-watchdog";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
      libnotify
      procps
      systemd
    ];
    text = ''
      state="$XDG_RUNTIME_DIR/health-watchdog"
      mkdir -p "$state"

      # One notification per problem until it clears.
      report() {
        local key=$1 active=$2 title=$3 body=$4
        if [ "$active" = 1 ]; then
          [ -e "$state/$key" ] && return
          notify-send -a "System health" "$title" "$body"
          touch "$state/$key"
        else
          rm -f "$state/$key"
        fi
      }

      # GNOME Shell's GPU memory only ever grows when an extension leaks
      # (GPU-MEMORY-LEAK.md). fds share buffers, so take the largest entry.
      shell=$(pgrep -u "$UID" -f 'gnome-shell( |$)' | head -n1 || true)
      gpu_kib=0
      if [ -n "$shell" ]; then
        gpu_kib=$(grep -hs drm-resident-gtt "/proc/$shell/fdinfo/"* | awk '$2 > m { m = $2 } END { print m + 0 }')
      fi
      report gpu "$((gpu_kib > 4 * 1024 * 1024))" "GNOME Shell is leaking GPU memory" \
        "$((gpu_kib / 1048576)) GiB held. Log out and back in to free it."

      free_gib=$(df --output=avail -BG / | tail -n1 | tr -dc 0-9)
      report disk "$((free_gib < 30))" "Disk space is low" "$free_gib GiB free on /."

      failed=$( (systemctl --failed --no-legend --plain; systemctl --user --failed --no-legend --plain) | awk '{ print $1 }' | paste -sd' ')
      report units "$([ -n "$failed" ] && echo 1 || echo 0)" "Failed units" "$failed"

      stamp=/var/lib/backup/last-success
      age_days=0
      [ -e "$stamp" ] && age_days=$((($(date +%s) - $(stat -c %Y "$stamp")) / 86400))
      report backup "$((age_days >= 3))" "Backup is stale" "The last successful backup was $age_days days ago."
    '';
  };

  weeklySummary = pkgs.writeShellScript "health-summary" ''
    PATH=${
      pkgs.lib.makeBinPath (
        with pkgs;
        [
          coreutils
          gawk
          smartmontools
        ]
      )
    }
    bat=/sys/class/power_supply/BAT0
    health=$(awk -v f="$(cat $bat/energy_full)" -v d="$(cat $bat/energy_full_design)" 'BEGIN { printf "%.1f", f / d * 100 }')
    cycles=$(cat $bat/cycle_count)

    stamp=/var/lib/backup/last-success
    if [ -e "$stamp" ]; then
      backup="$((($(date +%s) - $(stat -c %Y "$stamp")) / 86400)) days ago"
    else
      backup="never recorded"
    fi

    wear=$(smartctl -A /dev/nvme0n1 | awk -F: '/Percentage Used/ { gsub(/ /, "", $2); print $2 }')

    ${pkgs.sudo}/bin/sudo -u breynard \
      DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send -a "System health" "Weekly health summary" \
      "Battery: $health% of design, $cycles cycles
    Last backup: $backup
    SSD wear: $wear used"
  '';
in
{
  systemd.user.services.health-watchdog = {
    description = "Check for GPU memory leaks, low disk space, failed units and stale backups";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.lib.getExe watchdog;
    };
  };
  systemd.user.timers.health-watchdog = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "5min";
      OnUnitActiveSec = "15min";
    };
  };

  systemd.services.health-summary = {
    description = "Weekly battery, backup and SSD summary";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = weeklySummary;
    };
    startAt = "Mon 10:00";
  };
  systemd.timers.health-summary.timerConfig.Persistent = true;
}

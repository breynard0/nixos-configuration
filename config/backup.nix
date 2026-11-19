{ lib, pkgs, ... }:
let
  # TPM-sealed copies in /etc/credstore.encrypted take over as soon as they
  # exist; until then the plaintext files in /etc are used.
  loadCredentials = ''
    set -a
    if [ -f "''${CREDENTIALS_DIRECTORY:-/nonexistent}/restic-env" ]; then
      source "$CREDENTIALS_DIRECTORY/restic-env"
      RESTIC_PASSWORD_FILE="$CREDENTIALS_DIRECTORY/restic-password"
    else
      source /etc/restic-env
    fi
    set +a
  '';

  resticService = script: {
    path = [ pkgs.restic ];
    script = loadCredentials + script;
    unitConfig.OnFailure = "notify-failure@%N.service";
    serviceConfig = {
      Type = "oneshot";

      # Without a cache restic re-reads repo metadata every run: the Sep 10
      # backup took 4h29m to process 93 GiB for 1.8 GiB of new data.
      CacheDirectory = "restic";
      Environment = "RESTIC_CACHE_DIR=/var/cache/restic";
      StateDirectory = "backup";
      ImportCredential = [
        "restic-env"
        "restic-password"
      ];

      # Yield to interactive work rather than competing with it.
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
      Nice = 19;
    };
  };

  timer = calendar: {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = calendar;
      Persistent = true;
      # Stops a catch-up run from starting the moment you log in.
      RandomizedDelaySec = "2h";
    };
  };
in
{
  systemd.services.backup = resticService ''
    # Only removes locks whose owning process is gone.
    restic unlock
    ${builtins.readFile ./restic-backup.sh}
    touch /var/lib/backup/last-success
  '';
  systemd.services.backup-prune = resticService "restic --retry-lock 2h prune";
  systemd.services.backup-check = resticService "restic --retry-lock 2h check --read-data-subset=5%";

  systemd.timers.backup = timer "daily";
  systemd.timers.backup-prune = timer "Sun 12:00";
  systemd.timers.backup-check = timer "*-*-01 15:00";

  systemd.tmpfiles.rules = [
    "z /etc/restic-env 0600 root root -"
    "z /etc/restic-password 0600 root root -"
  ];

  systemd.services."notify-failure@" = {
    description = "Desktop notification for failed %i";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.escapeShellArgs [
        "${pkgs.sudo}/bin/sudo"
        "-u"
        "breynard"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
        "${pkgs.libnotify}/bin/notify-send"
        "-a"
        "System"
        "%i failed"
        "journalctl -u %i has the details."
      ];
    };
  };
}

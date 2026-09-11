{ pkgs, ... }:
let
  # uid 1000; the session bus is where notify-send has to land.
  notify = pkgs.writeShellScript "backup-failed-notify" ''
    ${pkgs.sudo}/bin/sudo -u breynard \
      DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send --urgency=critical \
      "Backup failed" \
      "restic did not complete. Check: journalctl -u backup.service"
  '';
in
{
  systemd.services.backup = {
    script = builtins.readFile ./restic-backup.sh;
    path = [ pkgs.restic ];
    onFailure = [ "backup-failed.service" ];

    serviceConfig = {
      Type = "oneshot";

      # Without a cache restic re-reads repo metadata every run: the Sep 10
      # backup took 4h29m to process 93 GiB for 1.8 GiB of new data.
      CacheDirectory = "restic";
      Environment = "RESTIC_CACHE_DIR=/var/cache/restic";

      # Yield to interactive work rather than competing with it.
      IOSchedulingClass = "idle";
      Nice = 19;
    };
  };

  systemd.services.backup-failed = {
    description = "Notify that the restic backup failed";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = notify;
    };
  };

  systemd.timers.backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      # Stops a catch-up run from starting the moment you log in.
      RandomizedDelaySec = "2h";
    };
  };
}

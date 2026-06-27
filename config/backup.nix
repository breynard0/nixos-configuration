{ pkgs, ... }:
{
  systemd.services.backup = {
    script = builtins.readFile ./restic-backup.sh;
    serviceConfig.Type = "oneshot";
    path = [ pkgs.restic ];
  };

  systemd.timers.backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}

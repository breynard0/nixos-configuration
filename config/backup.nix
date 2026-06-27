{ ... }:
{
  systemd.services.backup = {
    script = builtins.readFile ./restic-backup.sh;
    serviceConfig.Type = "oneshot";
  };

  systemd.timers.backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}

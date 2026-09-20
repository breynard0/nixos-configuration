{ pkgs, ... }:
{
  systemd.services.backup = {
    script = builtins.readFile ./restic-backup.sh;
    path = [ pkgs.restic ];
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

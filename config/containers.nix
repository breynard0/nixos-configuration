{ config, pkgs, ... }:
let
  docker = "${config.virtualisation.docker.package}/bin/docker";
in
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  systemd.services.docker-cache-prune = {
    description = "Prune stale Docker build cache and dangling images";
    unitConfig.ConditionACPower = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${docker} builder prune --all --force --filter until=168h"
        "${docker} image prune --force"
      ];
    };
    startAt = "weekly";
  };
  systemd.timers.docker-cache-prune.timerConfig.Persistent = true;

  virtualisation.podman.enable = true;
  environment.systemPackages = [ pkgs.distrobox ];
}

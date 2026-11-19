{ lib, pkgs, ... }:
let
  # smartd exports SMARTD_DEVICESTRING and SMARTD_MESSAGE to -M exec.
  smartdNotify = pkgs.writeShellScript "smartd-notify" ''
    ${pkgs.sudo}/bin/sudo -u breynard \
      DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send --urgency=critical \
      "SMART failure: $SMARTD_DEVICESTRING" \
      "$SMARTD_MESSAGE"
  '';

  background = {
    Nice = 19;
    CPUSchedulingPolicy = "idle";
    IOSchedulingClass = "idle";
    MemoryHigh = "4G";
  };
in
{
  programs.nh = {
    enable = true;
    flake = "/home/breynard/nixos-configuration";
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  systemd.services =
    lib.genAttrs
      [
        "nix-optimise"
        "nh-clean"
        "update-locatedb"
        "flatpak-managed-install"
      ]
      (_: {
        serviceConfig = background;
        unitConfig.ConditionACPower = true;
      })
    // {
      # Not gated on AC: a missed trim costs more than the power.
      fstrim.serviceConfig = background;
    };

  services.smartd = {
    enable = true;

    # There is no MTA, so mail notification would silently go nowhere.
    # The built-in notifiers are all off and the desktop notification is
    # attached directly, because the module only emits "-M exec" for its own
    # generated script when mail, wall or x11 is enabled.
    notifications = {
      mail.enable = false;
      wall.enable = false;
      x11.enable = false;
    };

    defaults.monitored = "-a -m <nomailer> -M exec ${smartdNotify}";
  };
}

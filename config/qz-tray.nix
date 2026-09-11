{ pkgs, ... }:
let
  qz-tray = pkgs.callPackage ../pkgs/qz-tray.nix { };
in
{
  home.packages = [ qz-tray ];

  # Web pages can only reach QZ while it is running, so it has to come up with
  # the session rather than on demand
  systemd.user.services.qz-tray = {
    Unit = {
      Description = "QZ Tray print/scan/serial connector";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${qz-tray}/bin/qz-tray";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}

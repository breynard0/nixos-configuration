{ pkgs, pkgs-unstable, config, inputs, ... }:
{
    imports = [ ];

    wayland.windowManager.hyprland = {
     enable = true;
     package = pkgs-unstable.hyprland;

     settings = {
       monitor = ",1920x1200@60,auto,1";
     };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs-unstable; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
}

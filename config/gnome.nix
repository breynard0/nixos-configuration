{ lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.compact-top-bar
    gnomeExtensions.appindicator
    gnomeExtensions.mosaic
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.color-picker
    gnomeExtensions.emoji-copy
    gnomeExtensions.battery-time-percentage-compact
    gnomeExtensions.gsconnect
    gnomeExtensions.vitals
    gnomeExtensions.claude-code-usage
    gnomeExtensions.spotify-controls
    gnomeExtensions.user-themes

    # Also expose the theme system-wide so root-run and non-home-manager apps
    # resolve it.
    qogir-theme
    qogir-icon-theme
  ];

  qt = {
    enable = true;
    # qt5ct pulls in both qt5ct and qt6ct; kvantum sets QT_STYLE_OVERRIDE, which
    # is what actually applies Qogir to Qt 5 and Qt 6 alike.
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # qt6ct only registers under its own key, and most Qt apps here are Qt 6.
  # Qt 5 apps still pick up Qogir through QT_STYLE_OVERRIDE.
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";

  services.power-profiles-daemon.enable = false;
}

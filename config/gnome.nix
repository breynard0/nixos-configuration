{ lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.forge
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.color-picker
    gnomeExtensions.battery-time-percentage-compact
    gnomeExtensions.vitals
    gnomeExtensions.spotify-controls
    gnomeExtensions.user-themes
    gnomeExtensions.brightness-control-using-ddcutil
    gnomeExtensions.caffeine
    gnomeExtensions.quick-settings-audio-devices-hider
    gnomeExtensions.audio-switch-shortcuts

    # appindicator spawns gjs for some tray menus.
    gjs
    eyedropper
    qadwaitadecorations
    qadwaitadecorations-qt6

    # Also expose the theme system-wide so root-run and non-home-manager apps
    # resolve it. The override must match config/theme.nix or the two halves
    # resolve to different store paths and only one of them has the blue variant.
    (whitesur-gtk-theme.override {
      themeVariants = [ "blue" ];
      colorVariants = [ "dark" ];
    })
    whitesur-icon-theme
  ];

  qt = {
    enable = true;
    # qt5ct pulls in both qt5ct and qt6ct; kvantum sets QT_STYLE_OVERRIDE, which
    # is what actually applies WhiteSur to Qt 5 and Qt 6 alike.
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # qt6ct only registers under its own key, and most Qt apps here are Qt 6.
  # Qt 5 apps still pick up WhiteSur through QT_STYLE_OVERRIDE.
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";

  environment.sessionVariables.QT_WAYLAND_DECORATION = "adwaita";

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    yelp
    gnome-maps
    gnome-contacts
  ];

  # Mutter reads this for the login screen too, so the LG gets full-range RGB
  # there. ~/.config/monitors.xml still wins inside the session.
  environment.etc."xdg/monitors.xml".source = ../resources/monitors.xml;

  services.power-profiles-daemon.enable = false;
}

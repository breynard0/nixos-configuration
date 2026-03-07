# SDDM Configuration by lawrab's nixos-config

# sddm.nix - SDDM Display Manager Configuration with Catppuccin Theme
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Custom Hyprland session that uses home-manager's start-hyprland wrapper
  hyprland-session = pkgs.writeTextDir "share/wayland-sessions/hyprland.desktop" ''
    [Desktop Entry]
    Name=Hyprland
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=start-hyprland
    Type=Application
    DesktopNames=Hyprland
    Keywords=tiling;wayland;compositor;
  '';
in
{
  # SDDM Display Manager Configuration
  services.displayManager.sddm = {
    enable = true;

    # Enable Wayland support
    wayland = {
      enable = true;
      compositor = "kwin"; # Can also use weston if kwin doesn't work
    };

    # Use KDE6 version for better Wayland support
    package = pkgs.kdePackages.sddm;

    settings = {
      # General settings
      General = {
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        InputMethod = ""; # Can be set to "qtvirtualkeyboard" if needed
      };

      # Wayland specific settings
      Wayland = {
        CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --no-lockscreen --inputmethod maliit-keyboard";
        EnableHiDPI = true;
        SessionDir = "${hyprland-session}/share/wayland-sessions";
      };

      # User settings
      Users = {
        DefaultPath = "/run/current-system/sw/bin";
        HideShells = "";
        HideUsers = "";
        MaximumUid = 60513;
        MinimumUid = 1000;
        RememberLastSession = true;
        RememberLastUser = true;
        ReuseSession = false;
      };
    };
  };

  # Ensure SDDM theme and dependencies are installed
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qtquick3d
    kdePackages.qtvirtualkeyboard
  ];
}

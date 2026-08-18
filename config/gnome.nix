{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.compact-top-bar
    gnomeExtensions.appindicator
    gnomeExtensions.forge
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.color-picker
    gnomeExtensions.emoji-copy
    gnomeExtensions.battery-time-percentage-compact
    gnomeExtensions.gsconnect
    gnomeExtensions.vitals
    gnomeExtensions.claude-code-usage
    gnomeExtensions.spotify-controls
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.power-profiles-daemon.enable = false;
}

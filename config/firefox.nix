{ ... }:
{
  # Deliberately a NixOS module, not a home-manager one: the home-manager
  # firefox module manages profiles.ini, which repoints Firefox at a profile
  # named after the attrset key and orphans the real lrqken6n.default.
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      ExtensionSettings."uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      Preferences."widget.use-xdg-desktop-portal.file-picker" = {
        Value = 1;
        Status = "default";
      };
    };
  };
}

{ ... }:
{
  # Deliberately a NixOS module, not a home-manager one: the home-manager
  # firefox module manages profiles.ini, which repoints Firefox at a profile
  # named after the attrset key and orphans the real lrqken6n.default.
  programs.firefox.enable = true;
}

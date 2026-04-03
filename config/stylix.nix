{ pkgs, ... }:

{
  stylix.enable = true;

  stylix.base16Scheme = {
    base00 = "1b1f23";
    base01 = "1f2428";
    base02 = "0366d6";
    base03 = "595959";
    base04 = "959da5";
    base05 = "fbfbfe";
    base06 = "ffffff";
    base07 = "ffffff";
    base08 = "f87171";
    base09 = "f8836f";
    base0A = "facc15";
    base0B = "183691";
    base0C = "183691";
    base0D = "0088dd";
    base0E = "a71d5d";
    base0F = "333333";
  };

  stylix.polarity = "dark";

  # Disable automatic theming for some apps on which I want to retain my theming
  home-manager.users.breynard = {
    stylix.targets.alacritty.enable = false;
    stylix.targets.fish.enable = false;
    stylix.targets.starship.enable = false;
    stylix.targets.vscode.enable = false;
  };
}
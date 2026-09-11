{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Unsuffixed noto-fonts is the full monthly release: every script Noto
    # covers. noto-fonts-extra was folded into it and no longer exists.
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    liberation_ttf
    dejavu_fonts

    # MS-compatible faces: corefonts is the real Arial/Times/Verdana/Georgia
    # set, carlito and caladea are metric clones of Calibri and Cambria.
    corefonts
    carlito
    caladea

    nerd-fonts.jetbrains-mono
    adwaita-fonts
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Adwaita Sans"
      "Noto Sans"
      "Noto Sans CJK SC"
    ];
    serif = [
      "Noto Serif"
      "Noto Serif CJK SC"
    ];
    monospace = [
      "JetBrainsMono Nerd Font Mono"
      "Noto Sans Mono"
      "Noto Sans Mono CJK SC"
    ];
    emoji = [ "Noto Color Emoji" ];
  };
}

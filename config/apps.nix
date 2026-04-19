{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System app suite
    firefox
    kdePackages.qtsvg
    nemo
    lite-xl
    kdePackages.okular
    qimgv

    # Other apps
    vesktop
    spotify
    rnote
    speedcrunch
    blender
    slack
    gtkwave
    godot
    musescore
    muse-sounds-manager
    thunderbird
    libreoffice
    kicad
    gimp
    localsend
    obsidian
    stm32cubemx
    krita
    prismlauncher
  ];
}

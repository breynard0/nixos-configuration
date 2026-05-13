{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System app suite
    firefox
    tor-browser
    kdePackages.qtsvg
    nemo
    lite-xl
    evince
    qimgv
    pdfarranger
    kdePackages.ark

    # Other apps
    vesktop
    spotify
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
    linux-wifi-hotspot
    ltspice
    kdePackages.filelight
    simulide
  ];
}

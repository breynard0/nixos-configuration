{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System app suite
    firefox
    tor-browser
    lite-xl
    evince
    pdfarranger
    dconf-editor
    gnome-boxes

    # Other apps
    equibop
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
    gnome-network-displays
    mullvad-vpn
    popsicle
    wxformbuilder
  ];
}

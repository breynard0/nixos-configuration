{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # System app suite
    firefox
    chromium # Required by the JetBrains markdown plugin preview
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    affinity-v3
    prismlauncher
    linux-wifi-hotspot
    ltspice
    kdePackages.filelight
    simulide
    gnome-network-displays
    mullvad-vpn
    popsicle
    wxformbuilder
    inkscape
    ckan
    winboat
    wireshark
    quickemu
    obs-studio
    davinci-resolve
    wineWow64Packages.full
    ghidra
    imhex
    dbeaver-bin
    claude-code
  ];
}

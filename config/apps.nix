{ pkgs, inputs, ... }:
let
  # Spotify's Chromium paints its own Wayland decorations and they come out a
  # plain blue. The nixpkgs launcher unsets DISPLAY whenever NIXOS_OZONE_WL=1,
  # so clearing that (and pinning the Ozone backend) puts it back on Xwayland,
  # where mutter draws the normal titlebar.
  spotifyX11 = pkgs.symlinkJoin {
    name = "spotify-xwayland";
    paths = [ pkgs.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --unset NIXOS_OZONE_WL \
        --add-flags "--ozone-platform=x11"
    '';
  };
  emdash = pkgs.callPackage ../pkgs/emdash.nix { };
  nimbalyst = pkgs.callPackage ../pkgs/nimbalyst.nix { };
  antigravity-cli = pkgs.callPackage ../pkgs/antigravity-cli.nix { };
  got-your-back = pkgs.callPackage ../pkgs/got-your-back.nix { };
in
{
  home.packages = with pkgs; [
    # System app suite
    chromium # Required by the JetBrains markdown plugin preview
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    tor-browser
    lite-xl
    evince
    pdfarranger
    dconf-editor
    gnome-boxes

    # Other apps
    opencode
    opencode-desktop
    lsfg-vk-ui
    equibop
    spotifyX11
    speedcrunch
    blender
    gtkwave
    godot
    musescore
    muse-sounds-manager
    thunderbird
    libreoffice
    onlyoffice-desktopeditors
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
    popsicle
    wxformbuilder
    inkscape
    ckan
    quickemu
    obs-studio
    davinci-resolve
    wineWow64Packages.full
    ghidra
    imhex
    dbeaver-bin
    beekeeper-studio
    emdash
    antigravity-cli
    got-your-back
    nimbalyst
    ventoy-full
    audacity
    github-desktop
    inputs.taut.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

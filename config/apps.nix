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
  sheepit-client = pkgs.callPackage ../pkgs/sheepit-client.nix { };
  helium = pkgs.callPackage ../pkgs/helium.nix { };
  paseoDesktop = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.desktop.overrideAttrs (old: {
    # The desktop resolves @getpaseo/server's package export at startup, but
    # Paseo's runtime tracer does not see this dynamic resolution.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace scripts/trace-daemon.mjs \
        --replace-fail '  "packages/cli/dist/index.js",' \
          '  "packages/server/dist/server/server/exports.js",
  "packages/cli/dist/index.js",'
    '';
    postInstall = (old.postInstall or "") + ''
      test -f "$out/share/paseo-desktop/node_modules/@getpaseo/server/dist/server/server/exports.js"
    '';
  });
in
{
  home.packages = with pkgs; [
    # System app suite
    chromium # Required by the JetBrains markdown plugin preview
    helium
    inputs.myreview.packages.${pkgs.stdenv.hostPlatform.system}.default
    tor-browser
    lite-xl
    evince
    pdfarranger
    dconf-editor
    dbus.lib
    zenity
    gnome-boxes

    # Other apps
    opencode
    opencode-desktop
    lsfg-vk-ui
    ffmpeg
    equibop
    spotifyX11
    speedcrunch
    blender
    sheepit-client
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
    figma-linux
    inputs.taut.packages.${pkgs.stdenv.hostPlatform.system}.default
    paseoDesktop
    whisper-ctranslate2

    # TODO: Delete these three packages when they are no longer needed.
    gnumake
    qemu
    nasm
  ];
}

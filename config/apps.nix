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
  custom = import ../pkgs { inherit pkgs inputs; };
  obsidian = pkgs.obsidian.override { electron = pkgs.electron_44; };
  # taut's stdout was 94% of the user journal.
  taut = pkgs.symlinkJoin {
    name = "taut-quiet";
    paths = [ inputs.taut.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/taut --run 'exec >/dev/null 2>&1'
    '';
  };
in
{
  home.packages = with pkgs; [
    # System app suite
    chromium # Required by the JetBrains markdown plugin preview
    custom.helium
    custom.ytubic
    inputs.myreview.packages.${pkgs.stdenv.hostPlatform.system}.default
    tor-browser
    lite-xl
    pdfarranger
    dconf-editor
    dbus.lib
    zenity
    gnome-boxes

    # Other apps
    opencode
    lsfg-vk-ui
    ffmpeg
    equibop
    spotifyX11
    speedcrunch
    blender
    custom.sheepit-client
    custom.tilp
    cemu-ti
    gtkwave
    godot
    musescore
    muse-sounds-manager
    thunderbird
    zoom-us
    libreoffice
    kicad
    gimp
    localsend
    obsidian
    stm32cubemx
    krita
    mtpaint
    libresprite
    prismlauncher
    r2modman
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
    custom.antigravity-cli
    custom.got-your-back
    ventoy-full
    audacity
    github-desktop
    figma-linux
    taut
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    (pkgs.lib.lowPrio inputs.ableton-linux.packages.${pkgs.stdenv.hostPlatform.system}.default)
    whisper-ctranslate2

    # Capture and notes
    xournalpp
    gnome-frog
    gradia

    # Audio
    pwvucontrol
    qpwgraph
    easyeffects

    # System
    nvtopPackages.intel
    qalculate-gtk
    file-roller
    restic-browser

    # Media and compatibility
    handbrake
    foliate
    fragments
    bottles

    android-tools

    # TODO: Delete these three packages when they are no longer needed.
    gnumake
    qemu
    nasm
  ];
}

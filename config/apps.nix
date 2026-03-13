{ pkgs, pkgs-unstable, ... }:
{
  home.packages =
    with pkgs;
    [
      # System app suite
      firefox
      kdePackages.dolphin
      lite-xl
      kdePackages.okular
      qimgv

      # Other apps
      vesktop
      spotify
      steam
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
    ]
    # Jetbrains apps
    ++ (with jetbrains; [
      webstorm
      rust-rover
      rider
      pycharm
      jdk
      idea
      clion
    ]);
}

{ pkgs, lib, ... }:
let
  ides = [
    "webstorm"
    "rust-rover"
    "rider"
    "pycharm"
    "idea"
    "clion"
    "goland"
    "datagrip"
  ];

  # Shadows the real package (hence lowPrio below) so the IDE launches detached from the terminal.
  detached =
    name:
    pkgs.writeShellScriptBin name ''
      ${lib.getExe pkgs.jetbrains.${name}} "$@" >/dev/null 2>&1 &
    '';
in
{
  home.packages =
    map detached ides
    ++ map (name: lib.lowPrio pkgs.jetbrains.${name}) ides
    ++ [
      pkgs.jetbrains.jdk
      pkgs.jetbrains-toolbox
    ];
}

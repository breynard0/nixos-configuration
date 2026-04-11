{ pkgs, ... }:
{
  home.packages =
    [
      # This custom syntax adds the ability to launch these editors detached from the terminal
      (pkgs.writeShellScriptBin "webstorm" ''
        ${pkgs.jetbrains.webstorm}/bin/webstorm "$@" >/dev/null 2>&1 &
      '')

      (pkgs.writeShellScriptBin "rust-rover" ''
        ${pkgs.jetbrains.rust-rover}/bin/rust-rover "$@" >/dev/null 2>&1 &
      '')

      (pkgs.writeShellScriptBin "rider" ''
        ${pkgs.jetbrains.rider}/bin/rider "$@" >/dev/null 2>&1 &
      '')

      (pkgs.writeShellScriptBin "pycharm" ''
        ${pkgs.jetbrains.pycharm}/bin/pycharm "$@" >/dev/null 2>&1 &
      '')

      (pkgs.writeShellScriptBin "idea" ''
        ${pkgs.jetbrains.idea}/bin/idea "$@" >/dev/null 2>&1 &
      '')

      (pkgs.writeShellScriptBin "clion" ''
        ${pkgs.jetbrains.clion}/bin/clion "$@" >/dev/null 2>&1 &
      '')

      pkgs.jetbrains.jdk
    ];
}

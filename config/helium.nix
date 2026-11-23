{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  custom = import ../pkgs { inherit pkgs inputs; };

  # A second launch only hands off to the running browser and exits, so wait
  # out an instance started by hand rather than restarting in a loop.
  heliumBackground = pkgs.writeShellScript "helium-background" ''
    lock="''${XDG_CONFIG_HOME:-$HOME/.config}/net.imput.helium/SingletonLock"
    if target=$(${pkgs.coreutils}/bin/readlink "$lock" 2>/dev/null); then
      pid=''${target##*-}
      if [ "$(${pkgs.coreutils}/bin/cat "/proc/$pid/comm" 2>/dev/null)" = helium ]; then
        ${pkgs.coreutils}/bin/tail --pid="$pid" -f /dev/null
      fi
    fi
    exec ${lib.getExe custom.helium} --no-startup-window --keep-alive-for-test
  '';
in
{
  # Without background mode Helium exits as soon as it has no window.
  environment.etc."chromium/policies/managed/background-mode.json".text = builtins.toJSON {
    BackgroundModeEnabled = true;
  };

  systemd.user.services.helium-background = {
    description = "Helium kept running so new windows open quickly";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = heliumBackground;
      Restart = "always";
      RestartSec = 1;
    };
  };
}

{ pkgs, ... }:
let
  pyenv = pkgs.python3.withPackages (ps: [ ps.openvino ]);

  # The OpenVINO NPU plugin dlopens libze_loader at runtime, but its RUNPATH
  # covers only OpenVINO, oneTBB and gcc. Without both the level-zero loader
  # (sw/lib) and the NPU driver (opengl-driver/lib) on the library path the
  # plugin fails to load silently and Core() reports just CPU and GPU.
  npuLibs = "/run/opengl-driver/lib:/run/current-system/sw/lib";
in
{
  environment.systemPackages = [
    pyenv

    (pkgs.writeShellScriptBin "openvino-python" ''
      export LD_LIBRARY_PATH=${npuLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
      exec ${pyenv}/bin/python3 "$@"
    '')
  ];
}

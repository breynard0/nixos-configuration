{ pkgs, inputs }:
{
  antigravity-cli = pkgs.callPackage ./antigravity-cli.nix { };
  comfyui = pkgs.callPackage ./comfyui.nix { inherit (inputs) comfyui-nix; };
  dinosaur-lockscreen = pkgs.callPackage ./dinosaur-lockscreen { };
  helium = pkgs.callPackage ./helium.nix { };
  sheepit-client = pkgs.callPackage ./sheepit-client.nix { };
  tilp = pkgs.callPackage ./tilp.nix { };
  ytubic = pkgs.callPackage ./ytubic.nix { };

  # gyb keeps its OAuth state beside the executable unless told otherwise.
  got-your-back = pkgs.writeShellScriptBin "gyb" ''
    config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/gyb"
    mkdir -p "$config_dir"
    exec ${pkgs.lib.getExe pkgs.gyb} --config-folder "$config_dir" "$@"
  '';
}

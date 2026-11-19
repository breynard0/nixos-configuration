{
  stdenv,
  symlinkJoin,
  makeWrapper,
  comfyui-nix,
}:
let
  # timm's bf16 backward tests need AVX512_BF16/AMX, which Lunar Lake lacks, and
  # the flake has no override hook, so its package set is rebuilt here.
  cpkgs = import comfyui-nix.inputs.nixpkgs {
    inherit (stdenv.hostPlatform) system;
    config = {
      allowUnfree = true;
      allowBrokenPredicate = pkg: (pkg.pname or "") == "open-clip-torch";
    };
  };
  versions = import "${comfyui-nix}/nix/versions.nix";
  upstreamOverrides = import "${comfyui-nix}/nix/python-overrides.nix" {
    pkgs = cpkgs;
    inherit versions;
    gpuSupport = "xpu";
    rocmChannel = "rocm71";
  };
  comfyuiXpu =
    (import "${comfyui-nix}/nix/packages.nix" {
      pkgs = cpkgs;
      inherit (cpkgs) lib;
      inherit versions;
      gpuSupport = "xpu";
      pythonOverrides = cpkgs.lib.composeExtensions upstreamOverrides (
        _: pyPrev: {
          timm = pyPrev.timm.overridePythonAttrs (old: {
            disabledTests = (old.disabledTests or [ ]) ++ [ "test_naflex_rope_aug_configuration" ];
          });
        }
      );
    }).default;
in
symlinkJoin {
  name = "comfyui-xpu";
  paths = [ comfyuiXpu ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/comfy-ui \
      --run 'export COMFY_USER_DIR="''${COMFY_USER_DIR:-$HOME/.local/share/comfyui}"'
  '';
}

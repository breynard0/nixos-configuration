{ pkgs-unstable, ... }:

{
  home.packages = [
    # nixpkgs' cargo hook forces AWS_LC_SYS_USE_SYSTEM=1, but codex doesn't provide aws-lc.
    (pkgs-unstable.codex.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ pkgs-unstable.aws-lc ];
    }))
  ];
}

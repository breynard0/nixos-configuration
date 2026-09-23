{ inputs, pkgs, ... }:

{
  home.packages = [ inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}

{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
  };
}

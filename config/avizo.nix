{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  services.avizo = {
    enable = true;
  };
}

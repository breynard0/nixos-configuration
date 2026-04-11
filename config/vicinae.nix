{
  inputs,
  pkgs,
  ...
}:
{
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      favicon_service = "twenty";
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      #bluetooth
      nix
      pulseaudio
      wifi-commander
    ];
  };
}

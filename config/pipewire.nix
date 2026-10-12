{ ... }:

{
  security.rtkit.enable = true;
  security.pam.loginLimits = [
    { domain = "@audio"; type = "-"; item = "rtprio"; value = "95"; }
    { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "@audio"; type = "-"; item = "nice"; value = "-19"; }
  ];
  users.users.breynard.extraGroups = [ "audio" ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
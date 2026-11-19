{ ... }:
{
  # Caps Lock: tap for Escape, hold for Control, on every keyboard.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "overload(control, esc)";
    };
  };

  # Without this libinput treats keyd's keyboard as external and stops
  # disabling the touchpad while typing.
  environment.etc."libinput/local-overrides.quirks".text = ''
    [keyd virtual keyboard]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}

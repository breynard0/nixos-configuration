{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = "fish";
      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };
      window.opacity = 0.95;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting " "
      starship init fish | source
    '';
  };
}

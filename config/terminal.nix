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
      font.size = 10.0;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      starship init fish | source

      export LS_COLORS='no=00;97:rs=00;97:fi=00;94:di=01;34:ln=00;37:pi=00;95:do=00;35:bd=00;93:cd=01;93:or=00;31:so=01;33:su=00;34:sg=00;34:tw=00;34:ow=00;94:st=01;94:ex=00;32:mi=00;31:*rs=00;91:*c=00;34:*h=00;36'
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}

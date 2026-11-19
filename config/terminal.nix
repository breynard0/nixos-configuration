{
  lib,
  pkgs,
  ...
}:
let
  pythonWheelLibs = map (p: "${lib.getLib p}/lib") (
    with pkgs;
    [
      stdenv.cc.cc
      zlib
      zstd
    ]
  );
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = "fish";
      terminal.osc52 = "CopyPaste";
      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };
      window.opacity = 0.95;
      font.size = 10.0;
      font.normal.family = "JetBrainsMono Nerd Font Mono";

      # Claude Code reads ESC+CR as "insert a newline".
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = builtins.fromJSON ''"\u001b\r"'';
        }
      ];

      # islands-dark, matching the Neovim and VS Code themes.
      colors = {
        primary = {
          background = "#191a1c";
          foreground = "#bcbec4";
        };
        selection = {
          background = "#214283";
          text = "CellForeground";
        };
        normal = {
          black = "#000000";
          red = "#f27481";
          green = "#6bcc62";
          yellow = "#e0ce70";
          blue = "#5594fa";
          magenta = "#c092fa";
          cyan = "#47ccbd";
          white = "#ced0d6";
        };
        bright = {
          black = "#4e5157";
          red = "#ff6b7a";
          green = "#67ff59";
          yellow = "#ffec1a";
          blue = "#3399ff";
          magenta = "#d970ff";
          cyan = "#40ffe9";
          white = "#ffffff";
        };
      };
    };
  };

  programs.fish = {
    enable = true;
    generateCompletions = false;
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
      gsw = "git switch";
    };
    interactiveShellInit = ''
      set fish_greeting

      # pip wheels in Nix-Python venvs need these. Interactive shells only, so
      # the desktop session does not inherit it.
      for p in ${lib.concatStringsSep " " pythonWheelLibs}
        contains -- $p $LD_LIBRARY_PATH; or set -gxa LD_LIBRARY_PATH $p
      end

      function __notify_long_command --on-event fish_postexec
        set -l last $status
        test "$CMD_DURATION" -gt 60000; or return
        string match -qr '^\s*(sudo\s+)?(nvim|vim|ssh|man|less|bat|htop|btop|claude|nd|fg|lazygit|tio|nix (develop|shell))\b' -- $argv[1]; and return
        set -l title "Command finished"
        test $last -ne 0; and set title "Command failed ($last)"
        ${pkgs.libnotify}/bin/notify-send -a Terminal -- $title \
          (string shorten -m 120 -- $argv[1])" ("(math -s0 "$CMD_DURATION / 1000")" s)"
      end

      export LS_COLORS='no=00;97:rs=00;97:fi=00;94:di=01;34:ln=00;37:pi=00;95:do=00;35:bd=00;93:cd=01;93:or=00;31:so=01;33:su=00;34:sg=00;34:tw=00;34:ow=00;94:st=01;94:ex=00;32:mi=00;31:*rs=00;91:*c=00;34:*h=00;36'
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf.enable = true;
  programs.eza.enable = true;
  programs.nix-your-shell.enable = true;
}

{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', monospace";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono', monospace";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "github.copilot.enable.*" = false;
      "git.confirmSync" = false;
      "explorer.confirmDragAndDrop" = false;
      "workbench.colorTheme" = "JetBrains Islands Dark GoLand Tuned";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
    ];
  };
}

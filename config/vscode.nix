{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "github.copilot.enable.*"= false;
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
    ];
  };
}

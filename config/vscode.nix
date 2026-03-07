{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
    ];
  };
}

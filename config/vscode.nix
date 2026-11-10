{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # 1.144 moved its bundled ripgrep; nixpkgs still patches the old path.
    package = pkgs.vscode.overrideAttrs (old: {
      postPatch =
        builtins.replaceStrings
          [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
          [ "resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
          old.postPatch;
    });
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

{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
      basedpyright
      ruff
      gopls
      clang-tools
      typescript-language-server
      tinymist
    ];
  };
}

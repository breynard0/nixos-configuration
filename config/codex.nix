{ pkgs, ... }:

{
  home.packages = [ pkgs.codex ];

  home.file.".codex/config.toml".text = ''
    approvals_reviewer = "auto_review"
  '';
}

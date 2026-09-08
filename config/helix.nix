{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
  };

  home.packages = with pkgs; [
    lldb # provides lldb-dap for debugging
  ];
}

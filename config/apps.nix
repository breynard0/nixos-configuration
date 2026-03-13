{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    # System app suite
    kdePackages.dolphin
    lite-xl
    kdePackages.okular
    qimgv

    # Other apps
    vesktop
    spotify
    steam
  ]; 
}
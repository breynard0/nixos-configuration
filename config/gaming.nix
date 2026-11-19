{ inputs, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    extraCompatPackages = [
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.proton-ge-bin
    ];
  };

  programs.gamemode = {
    enable = true;
    settings.general = {
      renice = 10;
      inhibit_screensaver = 1;
    };
  };

  users.users.breynard.extraGroups = [ "gamemode" ];
}

{
  inputs,
  pkgs,
  ...
}:
{
  # Electron/Chromium apps render blurry under XWayland on the 3840x2160 panel
  # at 1.25 fractional scale; this makes them native Wayland clients.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    CLAUDE_USE_WAYLAND = "1";
  };

  services.fwupd.enable = true;

  programs.gamemode.enable = true;

  programs.nix-index.package =
    inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-stable-db;

  # Defaults are already what we want: plocate, 02:15 daily, /nix/store pruned.
  services.locate.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  environment.systemPackages = [ pkgs.protontricks ];
}

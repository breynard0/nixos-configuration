{
  config,
  pkgs,
  ...
}:
{
  # Electron/Chromium apps render blurry under XWayland on the 3840x2160 panel
  # at 1.25 fractional scale; this makes them native Wayland clients.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.fwupd.enable = true;

  programs.gamemode.enable = true;

  programs.nix-index.enable = true;

  systemd.user.services.nix-index = {
    description = "Update the nix-index database";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${config.programs.nix-index.package}/bin/nix-index -f ${pkgs.path}";
    };
  };

  systemd.user.timers.nix-index = {
    description = "Weekly nix-index database update";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };

  # Defaults are already what we want: plocate, 02:15 daily, /nix/store pruned.
  services.locate.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  hardware.cpu.intel.npu.enable = true;

  environment.systemPackages = with pkgs; [
    protontricks

    # pkgs.openvino ships no executables and installs its libraries under
    # runtime/lib/intel64, which environment.pathsToLink never links, so the
    # Python bindings are the only usable entry point to the runtime.
    (python3.withPackages (ps: [ ps.openvino ]))
  ];
}

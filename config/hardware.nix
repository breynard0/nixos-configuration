{ pkgs, ... }:

{
  boot.supportedFilesystems.ntfs = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # The NixOS pam module registers pam_fprintd "sufficient" ahead of pam_unix
  # for every service, so sudo/polkit/GNOME unlock get fingerprint OR password.
  # gdm.nix force-disables it on the `login` stack and runs a separate
  # gdm-fingerprint stack instead, so tty login stays password-only.
  services.fprintd.enable = true;

  hardware.i2c.enable = true;

  services.usbmuxd.enable = true;

  # probe-rs and openocd each ship a maintained rule set; between them they
  # cover probe-rs, J-Link, CMSIS-DAP and FTDI adapters. stlink is already in
  # services.udev.packages in configuration.nix.
  services.udev.packages = [
    pkgs.probe-rs-tools
    pkgs.openocd
  ];

  users.users.breynard.extraGroups = [ "i2c" ];

  environment.systemPackages = [
    pkgs.ddcutil
    pkgs.libimobiledevice
    pkgs.ifuse
  ];
}

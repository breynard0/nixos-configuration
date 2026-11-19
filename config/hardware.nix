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

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2207", ATTR{idProduct}=="0019", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e001|e003|e004|e008|e012", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b|374e|374f|3752|3753|3754", SYMLINK+="stlink"
  '';

  users.users.breynard.extraGroups = [ "i2c" ];

  environment.systemPackages = [
    pkgs.ddcutil
    pkgs.libimobiledevice
    pkgs.ifuse
  ];
}

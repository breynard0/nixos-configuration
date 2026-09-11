{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  # Short, not zero: the menu is the only way into the Windows install.
  boot.loader.timeout = 2;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "vhci-hcd" ];

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=false"
  ];

  # Hibernation image target. The 8.8 GiB swap partition declared in
  # hardware-configuration.nix cannot hold 30 GiB of RAM, so a larger file on
  # the ext4 root takes priority over it.
  # INCOMPLETE UNTIL a matching `resume_offset=` is added to boot.kernelParams:
  # suspend-then-hibernate will hibernate but NOT resume without it.
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
      priority = 1;
    }
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/b6730135-4f10-48ee-825e-eb9a288e6473";

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
  };

  systemd.sleep.settings.Sleep.HibernateDelaySec = "90min";
}

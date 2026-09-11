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

  # Hibernation image target: the 8.8 GiB swap partition in
  # hardware-configuration.nix cannot hold 30 GiB of RAM. Higher priority than
  # the partition, lower than zram, so this is only touched under real pressure.
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
      priority = 1;
    }
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/b6730135-4f10-48ee-825e-eb9a288e6473";

  systemd.sleep.settings.Sleep.HibernateDelaySec = "90min";

  # No resume_offset= is needed for the swapfile: systemd writes the offset to
  # the HibernateLocation EFI variable at hibernate time and the initrd reads it
  # back. Both systemd-hibernate-resume and its generator are in the systemd
  # initrd, and efivarfs is rw on this machine.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
  };

  # Nothing needs the network up before login, and this unit routinely costs
  # several seconds of boot waiting on DHCP.
  systemd.services.NetworkManager-wait-online.enable = false;
}

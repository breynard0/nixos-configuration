{ pkgs, ... }:
let
  restartIntoWindows = pkgs.writeShellApplication {
    name = "restart-into-windows";
    runtimeInputs = [
      pkgs.efibootmgr
      pkgs.gnused
      pkgs.libnotify
    ];
    text = ''
      entry=$(efibootmgr | sed -n 's/^Boot\([0-9A-Fa-f]\{4\}\)\*\? Windows Boot Manager.*/\1/p' | head -n1)
      if [ -z "$entry" ]; then
        notify-send "Restart into Windows" "No Windows Boot Manager entry in the firmware boot list."
        exit 1
      fi
      pkexec ${pkgs.efibootmgr}/bin/efibootmgr --bootnext "$entry"
      systemctl reboot
    '';
  };

  restartIntoWindowsEntry = pkgs.makeDesktopItem {
    name = "restart-into-windows";
    desktopName = "Restart into Windows";
    exec = "restart-into-windows";
    icon = "system-reboot";
    categories = [ "System" ];
  };
in
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    # Hidden, not zero: Esc within the timeout still reaches older generations.
    timeoutStyle = "hidden";
    extraEntries = ''
      menuentry "Windows" {
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 85D7-2F9D
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  environment.systemPackages = [
    restartIntoWindows
    restartIntoWindowsEntry
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "vhci-hcd"
    "ntsync"
  ];

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = false;
  boot.initrd.services.lvm.enable = false;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.plymouth.enable = true;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=false"
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
      priority = 1;
    }
  ];

  systemd.sleep.settings.Sleep = {
    AllowHibernation = false;
    AllowSuspendThenHibernate = false;
    AllowHybridSleep = false;
  };

  # Nothing needs the network up before login, and this unit routinely costs
  # several seconds of boot waiting on DHCP.
  systemd.services.NetworkManager-wait-online.enable = false;
}

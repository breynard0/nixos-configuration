# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configure graphics drivers
    ./config/graphics.nix

    # Set up GDM and GNOME
    ./config/gnome.nix

    # Configure pipewire
    ./config/pipewire.nix

    # Battery stuff
    ./config/battery.nix

    # Backups
    ./config/backup.nix

    # Configure Ollama
    ./config/ollama.nix

    # 1Password desktop
    ./config/1password.nix

    # Declarative Flatpak apps
    ./config/flatpak.nix

    # Desktop integration bits
    ./config/desktop.nix

    # Caps Lock remap
    ./config/input.nix

    # Steam, gamemode
    ./config/gaming.nix

    # OBS, instant replay, captions
    ./config/capture.nix

    # AirPlay receiver
    ./config/airplay.nix

    # System fonts
    ./config/fonts.nix

    # Peripherals, filesystems, dev-board rules
    ./config/hardware.nix

    # Firewall, Wi-Fi privacy, Tailscale
    ./config/firewall.nix
    ./config/network.nix

    # Gap year stats dashboard
    ./config/gappie-dashboard.nix

    # Opt-in local Tor proxy
    ./config/tor.nix

    # Store cleanup, SMART monitoring
    ./config/maintenance.nix

    # Swap, memory pressure, scheduler, build limits
    ./config/performance.nix

    # Health alerts and history graphs
    ./config/health.nix
    ./config/monitoring.nix

    # Docker, podman
    ./config/containers.nix

    ./config/overlays.nix

    # Set up Postgres for development
    ./config/postgres.nix

    # Intel NPU / OpenVINO
    ./config/npu.nix

    # Printing and scanning
    ./config/printing.nix

    # Bootloader, boot speed, swap
    ./config/boot.nix

    # Firefox
    ./config/firefox.nix

    # Helium kept warm in the background
    ./config/helium.nix
  ];

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "breynard"
  ];

  networking.hostName = "breynard-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  nix.channel.enable = false;

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    zstd
    systemdLibs
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Bluetooth stuff
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Configure appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.breynard = {
    isNormalUser = true;
    description = "breynard";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
      "libvirtd"
      "wireshark"
    ];
  };
  services.udev.packages = [ pkgs.stlink ];

  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  };
  programs.virt-manager.enable = true;

  # Link portal definitions
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget

    alacritty

    restic

    proton-vpn

    config.boot.kernelPackages.usbip

  ];

  programs.fish = {
    enable = true;
    generateCompletions = false;
    useBabelfish = true;
  };
  documentation.man.cache.enable = false;

  programs.ydotool.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
}

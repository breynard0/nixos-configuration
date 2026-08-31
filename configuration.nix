# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  options,
  config,
  inputs,
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

    # Set up Postgres for development
    ./config/postgres.nix

    # iPhone integration
    ./config/tether.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable cache
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.forall.systems"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };
  nix.settings.trusted-users = [
    "root"
    "breynard"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "vhci-hcd" ];

  networking.hostName = "breynard-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  nix.settings.download-buffer-size = 4294967296; # 4 GB

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  # NTP
  networking.timeServers = options.networking.timeServers.default;

  networking.firewall.enable = false;

  # LocalSend
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];

  # Needed for Bitwarden desktop
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "electron-40.10.5"
    "ventoy-1.1.12"
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Bluetooth stuff
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.breynard = {
    isNormalUser = true;
    description = "breynard";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
      "plugdev"
      "kvm"
      "libvirt"
      "input"
    ];
  };
  services.udev.packages = [ pkgs.stlink ];

  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Make use of said allowed unfree packages
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

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

    kitty
    alacritty
    bash

    hplip
    ydotool

    restic

    ventoy

    protonvpn-gui

    config.boot.kernelPackages.usbip

    mfcl8690cdwlpr
    mfcl8690cdwcupswrapper
  ];

  # Docker!
  virtualisation.docker.enable = true;

  programs.ydotool.enable = true;

  # Enable printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable Tor
  # services.tor = {
  #   enable = true;
  #   openFirewall = true;
  #   relay = {
  #     enable = true;
  #     role = "relay";
  #   };
  #   settings = {
  #     ContactInfo = "dev@breynard.net";
  #     Nickname = "breynard";
  #     ORPort = 9001;
  #     ControlPort = 9051;
  #     BandWidthRate = "1 MBytes";
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  environment.variables.EDITOR = "vim";
}

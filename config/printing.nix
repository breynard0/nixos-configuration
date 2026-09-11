{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    # CUPS only sees PPDs from this list; packages in systemPackages are invisible
    # to it, which is why the Brother never offered its own driver.
    drivers = with pkgs; [
      hplip
      mfcl8690cdwlpr
      mfcl8690cdwcupswrapper
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # QZ Tray sends ZPL straight to the label printer, so this stays a raw queue.
  hardware.printers.ensurePrinters = [
    {
      name = "Zebra_wireless";
      deviceUri = "ipp://10.40.77.236:631/printers/Zebra__but_wireless_";
      model = "raw";
    }
  ];

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };

  users.users.breynard.extraGroups = [
    "scanner"
    "lp"
  ];

  environment.systemPackages = [ pkgs.simple-scan ];
}

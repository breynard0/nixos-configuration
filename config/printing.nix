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
    browsed.enable = false;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };

  users.users.breynard.extraGroups = [ "scanner" ];

  environment.systemPackages = [ pkgs.simple-scan ];
}

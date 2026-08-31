{ pkgs, ... }:
let
  tether = pkgs.callPackage ../pkgs/tether.nix { };
in
{
  environment.systemPackages = [ tether ];

  # Exposes Bearer.LE1, which ANCS notification mirroring runs over. Must be
  # active before pairing: a bond made without it has no LE half.
  hardware.bluetooth.settings.General.Experimental = true;

  # iOS only offers the message and contact permissions to a device presenting
  # class A/V Hands-Free, and bluetoothd resets the class on every restart.
  systemd.packages = [ tether ];
  systemd.services."tether-btclass@hci0" = {
    overrideStrategy = "asDropin";
    wantedBy = [ "bluetooth.service" ];
    path = [ pkgs.bluez ];
  };
}

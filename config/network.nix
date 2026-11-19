{ ... }:
{
  # A different, stable MAC per network instead of the hardware address.
  networking.networkmanager.wifi.macAddress = "stable-ssid";
  networking.modemmanager.enable = false;

  services.tailscale.enable = true;
  # For `tailscale serve`, reachable from the tailnet only.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];
}

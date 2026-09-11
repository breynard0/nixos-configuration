{ ... }:

{
  networking.firewall = {
    enable = true;

    # Container/VM bridges and the transient links GNOME Network Displays and
    # create_ap bring up. Trailing "+" is an iptables interface wildcard: docker
    # names compose networks br-<id>, wpa_supplicant names P2P groups p2p-<dev>-N.
    trustedInterfaces = [
      "docker0"
      "br-+"
      "virbr0"
      "p2p-+"
      "ap0"
    ];

    allowedTCPPorts = [
      53317 # LocalSend
      7236 # gnome-network-displays WFD RTSP server
      7250 # gnome-network-displays Miracast-over-Infrastructure listener
    ];

    allowedUDPPorts = [
      53317 # LocalSend
    ];

    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}

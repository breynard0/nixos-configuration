{ ... }:

{
  # Run Tor as an opt-in local proxy. Normal system traffic is not redirected,
  # so applications only pay Tor's latency when explicitly using torsocks or
  # the SOCKS5 proxy at 127.0.0.1:9050.
  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;

    # Keep the proxy private to this machine. Relay mode, transparent proxying,
    # and firewall changes remain disabled by default.
    client.socksListenAddress = {
      addr = "127.0.0.1";
      port = 9050;
      IsolateDestAddr = true;
      IsolateSOCKSAuth = true;
    };
  };
}

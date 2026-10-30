{ ... }:
{
  services.gappie-dashboard = {
    enable = true;
    authorEmail = "brendan@hackclub.com";
  };

  networking.hosts."127.0.0.1" = [ "dash.bd" ];

  services.nginx = {
    enable = true;
    defaultListen = [ { addr = "127.0.0.1"; port = 80; } ];
    virtualHosts."dash.bd".locations."/" = {
      proxyPass = "http://127.0.0.1:8787";
      proxyWebsockets = true;
    };
  };
}

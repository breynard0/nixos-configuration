{ pkgs, ... }:
{
  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "devbase" ];
    enableTCPIP = true;
    settings.password_encryption = "scram-sha-256";
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  address        auth-method
      local all       all                    trust
      host  all       all     127.0.0.1/32   scram-sha-256
      host  all       all     ::1/128        scram-sha-256
    '';
    package = pkgs.postgresql_16;
  };
}

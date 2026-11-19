{ pkgs, ... }:
{
  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "devbase" ];
    # Peer auth maps the login user to a role of the same name.
    ensureUsers = [
      {
        name = "breynard";
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
    ];
    enableTCPIP = false;
    settings.password_encryption = "scram-sha-256";
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  address        auth-method
      local all       all                    peer
      host  all       all     127.0.0.1/32   scram-sha-256
      host  all       all     ::1/128        scram-sha-256
    '';
    package = pkgs.postgresql_16;
  };
}

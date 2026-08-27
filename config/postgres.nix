{pkgs}:
{
  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "devbase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    package = pkgs.postgresql.pg_config;
  };
}
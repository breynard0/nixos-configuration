{ pkgs, ... }:
{
  # The unnamed server is the conventional one: 127.0.0.1:6379, no password.
  # It also puts redis-cli on the system path.
  services.redis.servers."".enable = true;

  # Otherwise the module sets vm.overcommit_memory=1 for the whole machine.
  services.redis.vmOverCommit = false;

  environment.systemPackages = [ pkgs.tiny-rdm ];
}

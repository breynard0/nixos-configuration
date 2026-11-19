{ ... }:
let
  agentEnv = "/var/lib/beszel-agent.env";
in
{
  # History graphs at http://127.0.0.1:8090
  services.beszel.hub.enable = true;

  services.beszel.agent = {
    enable = true;
    environmentFile = agentEnv;
    # The agent would otherwise open docker.sock at boot and socket-activate Docker.
    environment.DOCKER_HOST = "unix:///run/beszel-no-docker.sock";
  };
  # The hub issues the agent's key during first-run setup; idle until it is saved.
  systemd.services.beszel-agent.unitConfig.ConditionPathExists = agentEnv;
}

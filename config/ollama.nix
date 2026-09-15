{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };

  systemd.services.ollama.environment.OLLAMA_IGPU_ENABLE = "1";
}

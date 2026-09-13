{ ... }:
{
  programs.cursor = {
    enable = true;
    profiles = {
      main = {
        enableExtensionUpdateCheck = true;
      };
    };
  };
}

{ ... }:
{
  programs.cursor = {
    enable = true;
    profiles = {
      default = {
        enableExtensionUpdateCheck = true;
      };
      main = { };
    };
  };
}

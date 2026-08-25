{ ... }:

{
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "orion-beta";
        location = "https://flatpak.orionbrowser.com/orion-beta.flatpakrepo";
      }
    ];

    packages = [
      {
        appId = "com.kagi.Orion";
        origin = "orion-beta";
      }
    ];

    update.onActivation = true;
  };
}

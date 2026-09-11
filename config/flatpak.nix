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

    # ~/.themes and ~/.icons are symlinks into the store, which the sandbox
    # cannot follow without the store itself mounted.
    overrides.settings.global = {
      Context.filesystems = [
        "/nix/store:ro"
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
        "xdg-config/Kvantum:ro"
        "xdg-config/qt5ct:ro"
        "xdg-config/qt6ct:ro"
      ];
      Environment = {
        GTK_THEME = "WhiteSur-Dark-blue";
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };
    };

    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}

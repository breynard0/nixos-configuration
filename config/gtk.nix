{ pkgs, ... }:

{
  gtk = {
    enable = true;

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    theme = {
      package = pkgs.fluent-gtk-theme;
      name = "Fluent-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Adwaita Sans";
      size = 11;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "font-name" = "Adwaita Sans 11";
      "document-font-name" = "Adwaita Sans 11";
      "monospace-font-name" = "JetBrainsMono Nerd Font Mono 10";
    };
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Adwaita Sans Bold 11";
    };
  };
}

{ pkgs, ... }:

let
  gtkTheme = pkgs.qogir-theme;
  gtkThemeName = "Qogir-Dark";

  iconTheme = pkgs.qogir-icon-theme;
  iconThemeName = "Qogir-Dark";

  # The GTK theme has no Qt half; vinceliuice ships that as a separate repo.
  kvantumTheme = pkgs.qogir-kde;
  kvantumThemeName = "Qogir-dark";

  cursorSize = 24;
in
{
  home.packages = [
    gtkTheme
    iconTheme
    kvantumTheme
  ];

  gtk = {
    enable = true;

    theme = {
      package = gtkTheme;
      name = gtkThemeName;
    };

    # GTK 4 ignores gtk-theme-name, so home-manager imports the theme's CSS
    # from gtk.css instead. That only happens when gtk4.theme is set explicitly.
    gtk4.theme = {
      package = gtkTheme;
      name = gtkThemeName;
    };

    iconTheme = {
      package = iconTheme;
      name = iconThemeName;
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

    # libadwaita uses different selectors than the GTK 3 rules in dconf.nix.
    gtk4.extraCss = ''
      headerbar {
        min-height: 0;
        padding-top: 4px;
        padding-bottom: 4px;
      }
      headerbar button.titlebutton,
      windowcontrols button {
        min-height: 0;
        min-width: 0;
        padding: 0;
      }
    '';

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    package = iconTheme;
    name = iconThemeName;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  # gsd-xsettings serves these to GTK apps; settings.ini is ignored under GNOME.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = gtkThemeName;
      icon-theme = iconThemeName;
      cursor-theme = iconThemeName;
      cursor-size = cursorSize;
      font-name = "Adwaita Sans 11";
      document-font-name = "Adwaita Sans 11";
      monospace-font-name = "JetBrainsMono Nerd Font Mono 10";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Adwaita Sans Bold 11";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = gtkThemeName;
    };
  };

  # Flatpaks bind ~/.themes and ~/.icons into the sandbox, but the home-manager
  # profile lives outside both, so link the theme in by hand.
  home.file = {
    ".themes/${gtkThemeName}".source = "${gtkTheme}/share/themes/${gtkThemeName}";
    ".icons/${iconThemeName}".source = "${iconTheme}/share/icons/${iconThemeName}";
  };

  # Kvantum resolves themes from ~/.config/Kvantum before XDG_DATA_DIRS.
  xdg.configFile = {
    "Kvantum/${kvantumThemeName}".source = "${kvantumTheme}/share/Kvantum/${kvantumThemeName}";

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=${kvantumThemeName}
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=${iconThemeName}
      standard_dialogs=xdgdesktopportal

      [Fonts]
      general="Adwaita Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      fixed="JetBrainsMono Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    '';

    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=${iconThemeName}

      [Fonts]
      general="Adwaita Sans,11,-1,5,50,0,0,0,0,0"
      fixed="JetBrainsMono Nerd Font Mono,10,-1,5,50,0,0,0,0,0"
    '';
  };
}

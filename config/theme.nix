{ pkgs, ... }:

let
  gtkThemeName = "WhiteSur-Dark-blue";

  whitesurGtk = pkgs.whitesur-gtk-theme.override {
    themeVariants = [ "blue" ];
    colorVariants = [ "dark" ];
  };

  # WhiteSur draws a drop shadow behind the top bar labels. Its value carries
  # four lengths, which text-shadow does not take (there is no spread), so St
  # renders it as a smear rather than a shadow. Neutralised here.
  gtkTheme = pkgs.runCommand "whitesur-gtk-theme-panel-tweaks" { } ''
    mkdir -p $out/share/themes
    cp -r ${whitesurGtk}/share/themes/${gtkThemeName} $out/share/themes/
    chmod -R u+w $out/share/themes/${gtkThemeName}

    css=$out/share/themes/${gtkThemeName}/gnome-shell/gnome-shell.css

    substituteInPlace $css \
      --replace-fail \
        'text-shadow: 0 1px 3px 3px rgba(0, 0, 0, 0.15);' \
        'text-shadow: none;'

    # Scoped to the #panel rule: 'font-weight: 500' also styles unrelated widgets.
    sed -i '/^#panel {$/,/^}$/ s/font-weight: 500;/font-weight: normal;/' $css
    grep -A4 '^#panel {$' $css | grep -q 'font-weight: normal;' \
      || { echo "the #panel font-weight rule moved; theme layout changed" >&2; exit 1; }
  '';

  iconThemeName = "WhiteSur-apps-dark";

  # Keeps WhiteSur's application icons for their squircle crop and nothing
  # else. GNOME's own apps are dropped so they resolve to the real GNOME icons
  # that each app ships into hicolor, and every other context (places, mimes,
  # devices, status, actions, symbolic) falls through to Adwaita.
  iconIndexTheme = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=${iconThemeName}
    Comment=WhiteSur application icons over Adwaita
    Inherits=Adwaita,hicolor
    Example=folder

    Directories=apps/16,apps/22,apps/32,apps/scalable

    [apps/16]
    Size=16
    Context=Applications
    Type=Fixed

    [apps/22]
    Size=22
    Context=Applications
    Type=Fixed

    [apps/32]
    Size=32
    Context=Applications
    Type=Fixed

    [apps/scalable]
    Size=64
    Context=Applications
    MinSize=16
    MaxSize=512
    Type=Scalable
  '';

  iconTheme = pkgs.runCommand "whitesur-apps-icon-theme" { } ''
    src=${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark
    dst=$out/share/icons/${iconThemeName}
    mkdir -p $dst/apps

    # -L because the size directories are symlinks into the shared WhiteSur
    # tree rather than real directories.
    for d in 16 22 32 scalable; do
      cp -rL "$src/apps/$d" "$dst/apps/$d"
    done
    chmod -R u+w $dst

    # @2x is omitted: the icons that matter here are scalable SVGs.
    find $dst -name 'org.gnome.*' -delete

    cp ${iconIndexTheme} $dst/index.theme
  '';

  # Cursors stay stock GNOME; Adwaita's are in the icon theme package.
  cursorTheme = pkgs.adwaita-icon-theme;
  cursorThemeName = "Adwaita";

  # The GTK theme has no Qt half; vinceliuice ships that as a separate repo.
  # Its directory is WhiteSur but the dark config inside is WhiteSurDark, and
  # Kvantum resolves <theme>/<theme>.kvconfig, so the link is renamed below.
  kvantumTheme = pkgs.whitesur-kde;
  kvantumThemeName = "WhiteSurDark";
  kvantumSrcDir = "WhiteSur";

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
    package = cursorTheme;
    name = cursorThemeName;
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
      cursor-theme = cursorThemeName;
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
    "Kvantum/${kvantumThemeName}".source = "${kvantumTheme}/share/Kvantum/${kvantumSrcDir}";

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

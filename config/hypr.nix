{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}:
{
  imports = [ ];

  home.packages = with pkgs; [
    hyprcursor
    hyprshot
    hyprlock
    hyprprop
    adwaita-icon-theme
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;

    settings = {
      monitor = ",1920x1200@60,auto,1";

      env = [
        "GTK_THEME,Adwaita:dark"
        "QT_STYLE_OVERRIDE,Adwaita-dark"
        "COLOR_SCHEME,prefer-dark"
        "GTK_APPLICATION_PREFER_DARK_THEME,1"
        "XCURSOR_SIZE,16"
        "XCURSOR_THEME,Adwaita"
        "HYPRCURSOR_SIZE,16"
        "HYPRCURSOR_THEME,Adwaita"
      ];

      exec-once = [
        "hyprctl setcursor Adwaita 16"
        "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
      ];

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, RETURN, exec, alacritty"
        "$mainMod, P, exec, vicinae open"
        "$mainMod, S, exec, hyprshot -m region"
        "$mainMod, F, exec, firefox"
        "$mainMod, L, exec, hyprlock"

        "$mainMod SHIFT, Q, killactive"
        "$mainMod SHIFT, V, togglefloating"
        "$mainMod SHIFT, J, togglesplit"

        "$mainMod, C, exec, vesktop"
        "$mainMod, M, exec, spotify"
        "$mainMod, E, exec, dolphin"
        "$mainMod, F, exec, firefox"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod SHIFT, T, fullscreen"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, volumectl +"
        ",XF86AudioLowerVolume, exec, volumectl -"
        ",XF86AudioMute, exec, volumectl %"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, lightctl +"
        ",XF86MonBrightnessDown, exec, lightctl -"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 4;

        border_size = 2;
        "col.active_border" = "rgba(0088ddee)";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };
      };

      device = {
        name = "wacom-hid-5285-pen";
        output = "eDP-1";
      };

      gesture = [
        "3, horizontal, workspace"
        "3, vertical, resize"
        "4, down, close"
        "4, up, fullscreen"
      ];

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        enable_anr_dialog = false;
      };
    };
  };

  # Cursor stuff
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  home.file."Pictures/wallpaper.png".source = ../resources/wallpaper.png;
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = "~/Pictures/wallpaper.png";
      wallpaper = ",~/Pictures/wallpaper.png";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs-unstable; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}

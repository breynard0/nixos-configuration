{ pkgs, pkgs-unstable, config, inputs, ... }:
{
    imports = [ ];

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
	];

	exec-once = [
	  "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
	  "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
	];

	"$mainMod" = "SUPER";

	general = {
	  gaps_in = 2;
	  gaps_out = 4;

	  border_size = 2;

	  col.active_border = "rgba(0088ddee)";
	  col.inactive_border = "rgba(595959aa)";

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

	misc = {
	  disable_splash_rendering = true;
	  disable_hyprland_logo = true;
	  enable_anr_dialog = false;
	};
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

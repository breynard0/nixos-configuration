{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  custom = import ../pkgs { inherit pkgs inputs; };

  # Forge never reads its *-border-color gschema keys: at runtime it only
  # applies CSS class names, and its prefs UI writes colours straight into this
  # stylesheet. So the border colours have to be set in the sheet itself.
  # Recolours the whole Forge palette (tiled, split, stacked, tabbed, floated
  # and the drag previews) to #3584e4, keeping each rule's alpha. The drop
  # shadows and the tabbed background are left alone.
  forgeStylesheet = pkgs.runCommand "forge-blue-borders.css" { } ''
    sed -E 's/rgba\((236, 94, 94|255, 246, 108|247, 162, 43|1[78], 199, 224|180, 167, 214|162, 247, 43), ?([0-9.]+)\)/rgba(53, 132, 228, \2)/g' \
      ${pkgs.gnomeExtensions.forge}/share/gnome-shell/extensions/forge@jmmaranan.com/stylesheet.css > $out
  '';
in
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.forge.extensionUuid
          pkgs.gnomeExtensions.all-in-one-clipboard.extensionUuid
          pkgs.gnomeExtensions.color-picker.extensionUuid
          pkgs.gnomeExtensions.battery-time-percentage-compact.extensionUuid
          pkgs.gnomeExtensions.vitals.extensionUuid
          pkgs.gnomeExtensions.spotify-controls.extensionUuid
          pkgs.gnomeExtensions.user-themes.extensionUuid
          pkgs.gnomeExtensions.brightness-control-using-ddcutil.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.quick-settings-audio-devices-hider.extensionUuid
          pkgs.gnomeExtensions.audio-switch-shortcuts.extensionUuid
          custom.dinosaur-lockscreen.extensionUuid
        ];
      };
      "org/gnome/shell" = {
        disable-extension-version-validation = true;
      };
      "org/gnome/shell/keybindings" = {
        open-new-window-application-1 = [ ];
        open-new-window-application-2 = [ ];
        open-new-window-application-3 = [ ];
        open-new-window-application-4 = [ ];
        open-new-window-application-5 = [ ];
        open-new-window-application-6 = [ ];
        open-new-window-application-7 = [ ];
        open-new-window-application-8 = [ ];
        open-new-window-application-9 = [ ];
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];
        toggle-message-tray = [ "<Super>v" ];
        # <Super>s launches taut.
        toggle-quick-settings = [ ];
      };
      # <Super>period belongs to all-in-one-clipboard's emoji tab.
      "desktop/ibus/panel/emoji".hotkey = lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;
      "org/gnome/shell/extensions/all-in-one-clipboard".shortcut-open-clipboard = [ "<Super><Shift>v" ];
      "org/gnome/shell/extensions/audio-switch-shortcuts".cycle-output-hotkey = [ "<Super><Shift>a" ];
      "org/gnome/shell/extensions/quicksettings-audio-devices-hider".excluded-output-names = [
        "HDMI / DisplayPort 1 Output – Core Ultra 200V Series Processors HD Audio"
        "HDMI / DisplayPort 2 Output – Core Ultra 200V Series Processors HD Audio"
        "HDMI / DisplayPort 3 Output – Core Ultra 200V Series Processors HD Audio"
      ];
      "org/gnome/desktop/search-providers".disabled = [
        "org.gnome.Boxes.desktop"
        "org.gnome.Epiphany.desktop"
        "org.gnome.Characters.desktop"
      ];
      "org/gnome/desktop/interface".enable-hot-corners = false;
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/mutter/keybindings" = {
        switch-monitor = [ "XF86Display" ];
      };
      # Let Forge place large new windows instead of Mutter maximizing them.
      "org/gnome/mutter" = {
        auto-maximize = false;
        experimental-features = [ ];
        dynamic-workspaces = false;
        edge-tiling = false;
        workspaces-only-on-primary = false;
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super><Shift>q" ];
        # <Super>h is Forge's focus-left.
        minimize = [ ];
        move-to-workspace-1 = [ "<Super><Shift>1" ];
        move-to-workspace-2 = [ "<Super><Shift>2" ];
        move-to-workspace-3 = [ "<Super><Shift>3" ];
        move-to-workspace-4 = [ "<Super><Shift>4" ];
        move-to-workspace-5 = [ "<Super><Shift>5" ];
        move-to-workspace-6 = [ "<Super><Shift>6" ];
        move-to-workspace-7 = [ "<Super><Shift>7" ];
        move-to-workspace-8 = [ "<Super><Shift>8" ];
        move-to-workspace-9 = [ "<Super><Shift>9" ];
        move-to-workspace-10 = [ "<Super><Shift>0" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
        switch-to-workspace-9 = [ "<Super>9" ];
        switch-to-workspace-10 = [ "<Super>0" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
        name = "save replay";
        command = "systemctl --user kill -s SIGUSR1 replay-buffer.service";
        binding = "<Super><Shift>r";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "alacritty";
        command = "alacritty";
        binding = "<Super>Return";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "helium";
        command = "helium";
        binding = "<Super>f";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "spotify";
        command = "spotify";
        binding = "<Super>m";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "taut";
        command = "taut";
        binding = "<Super>s";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        name = "equibop";
        command = "equibop";
        binding = "<Super>c";
      };
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
      };
      "org/gnome/shell" = {
        always-show-log-out = true;
      };
      "org/gnome/shell/extensions/forge" = {
        focus-on-hover-enabled = true;
        stacked-tiling-mode-enabled = false;
        tabbed-tiling-mode-enabled = false;
        dnd-center-layout = "swap";
        focus-border-toggle = true;
        window-gap-size = lib.hm.gvariant.mkUint32 4;
      };
      # Blanked because these collide with bindings already claimed elsewhere.
      "org/gnome/shell/extensions/forge/keybindings" = {
        window-swap-last-active = [ ];
        window-toggle-float = [ ];
        window-snap-center = [ ];
        window-focus-right = [ ];
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file://${../resources/train_wallpaper.jpg}";
        picture-uri-dark = "file://${../resources/train_wallpaper.jpg}";
        picture-options = "zoom";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../resources/train_wallpaper.jpg}";
        picture-options = "zoom";
      };
    };
  };

  # Shrink and clear titlebars
  home.file.".config/gtk-3.0/gtk.css".text = ''
    window.ssd headerbar.titlebar {
      padding-top: 4px;
      padding-bottom: 4px;
      min-height: 0;
    }
    window.ssd headerbar.titlebar button.titlebutton {
        padding: 0px;
        min-height: 0;
        min-width: 0;
    }
  '';
  dconf.settings."org/gnome/desktop/wm/preferences" = {
    button-layout = "appmenu:";
  };

  home.file.".config/forge/stylesheet/forge/stylesheet.css".source = forgeStylesheet;
}

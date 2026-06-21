{ pkgs, ... }:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.compact-top-bar.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.forge.extensionUuid
          pkgs.gnomeExtensions.all-in-one-clipboard.extensionUuid
          pkgs.gnomeExtensions.color-picker.extensionUuid
          pkgs.gnomeExtensions.emoji-copy.extensionUuid
          pkgs.gnomeExtensions.battery-time-percentage-compact.extensionUuid
          pkgs.gnomeExtensions.gsconnect.extensionUuid
          pkgs.gnomeExtensions.vitals.extensionUuid
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
      };
      "org/gnome/mutter/keybindings" = {
        switch-monitor = [ "XF86Display" ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super><Shift>q" ];
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
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "alacritty";
        command = "alacritty";
        binding = "<Super>Return";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "firefox";
        command = "firefox";
        binding = "<Super>f";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "spotify";
        command = "spotify";
        binding = "<Super>m";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "vicinae";
        command = "vicinae open";
        binding = "<Super>p";
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
        focus-border-toggle = false;
      };
      "org/gnome/shell/extensions/forge/keybindings" = {
        window-swap-last-active = [ ];
        window-toggle-float = [ ];
        window-snap-center = [ ];
        window-focus-right = [ ];
      };
    };
  };
}

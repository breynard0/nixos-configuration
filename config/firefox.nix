{ ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      settings = {
        # Built-in Dark theme. Firefox draws its own chrome and ignores GTK
        # themes, so this is the closest match available without pinning a
        # third-party add-on id.
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
      };
    };
  };
}

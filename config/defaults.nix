{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = "nvim.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/discord" = "equibop.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "image/*" = "org.gnome.Loupe.desktop";
    };
  };

  # text/* needs a desktop entry that opens nvim in a terminal.
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "alacritty -e nvim %F";
    icon = "nvim";
    terminal = false;
    categories = [
      "Utility"
      "TextEditor"
    ];
    mimeType = [
      "text/plain"
      "text/markdown"
    ];
  };
}

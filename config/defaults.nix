{ ... }:
{
  home.sessionVariables.BROWSER = "helium";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = "nvim.desktop";
      "text/html" = "helium.desktop";
      "text/xml" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "application/xhtml_xml" = "helium.desktop";
      "application/xml" = "helium.desktop";
      "application/rss+xml" = "helium.desktop";
      "application/rdf+xml" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/discord" = "equibop.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
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

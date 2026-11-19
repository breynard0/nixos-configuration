{ lib, ... }:
let
  textTypes = [
    "text/plain"
    "text/markdown"
    "text/x-log"
    "text/csv"
    "text/css"
    "text/javascript"
    "text/x-python"
    "text/x-csrc"
    "text/x-chdr"
    "text/x-c++src"
    "text/x-c++hdr"
    "text/x-rust"
    "text/rust"
    "text/x-go"
    "text/x-lua"
    "text/x-nix"
    "text/x-makefile"
    "text/x-cmake"
    "text/x-tex"
    "application/json"
    "application/toml"
    "application/yaml"
    "application/x-yaml"
    "application/x-shellscript"
  ];

  imageTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/heic"
    "image/bmp"
    "image/tiff"
    "image/svg+xml"
    "image/vnd.microsoft.icon"
  ];
in
{
  home.sessionVariables.BROWSER = "helium";

  # MIME defaults are matched exactly; "text/*" style wildcards are ignored.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
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
      "application/pdf" = "org.gnome.Papers.desktop";
    }
    // lib.genAttrs textTypes (_: "nvim.desktop")
    // lib.genAttrs imageTypes (_: "org.gnome.Loupe.desktop");
  };

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
    mimeType = textTypes;
  };
}

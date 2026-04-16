{
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
  glib,
  gobject-introspection,
  cairo,
  gdk-pixbuf,
  pango,
  graphene,
  gtk4,
  gtk4-layer-shell
}:

rustPlatform.buildRustPackage {
  pname = "sound-control-popup";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "r-namiki";
    repo = "sound-control-popup";
    rev = "main";
    hash = "sha256-S4olS6EnTNibscl4KIL+Bz+nid+CBqjtE/qMj8zomnY=";
  };

  cargoHash = "sha256-yfL6iVP5U4dZMqKIEUboqWC624hdHamT/thfRDxXBb0=";

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];
  buildInputs = [
    glib
    cairo
    gdk-pixbuf
    pango
    graphene
    gtk4
    gtk4-layer-shell
  ];
}

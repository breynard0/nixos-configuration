{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  pkg-config,
  intltool,
  gettext,
  wrapGAppsHook3,
  glib,
  gtk2,
  libticonv,
  libtifiles2,
  libticables2,
  libticalcs2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilp2";
  version = "1.18";

  src = fetchurl {
    url = "mirror://sourceforge/tilp/tilp2-linux/tilp2-${finalAttrs.version}/tilp2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ezqzY+61JQTW71gRxdJk+AFgYLt71Ce+WgZMLtc4Tkc=";
  };

  postPatch = ''
    substituteInPlace configure.ac --replace-fail "AC_PATH_KDE" ""
    substituteInPlace src/Makefile.am \
      --replace-fail "@KDE_INCLUDES@ @QT_INCLUDES@" "" \
      --replace-fail "@LIB_KDECORE@ @LIB_KDEUI@ @LIB_KIO@ @LIB_QT@ @KDE_LDFLAGS@" "" \
      --replace-fail "@QT_LDFLAGS@ @X_LDFLAGS@ @LIBZ@" "@LIBZ@"
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk2
    libticonv
    libtifiles2
    libticables2
    libticalcs2
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu17 -Wno-error=incompatible-pointer-types";

  meta = {
    description = "Linux transfer program for TI graphing calculators";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tilp";
    platforms = lib.platforms.linux;
  };
})

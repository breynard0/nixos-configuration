{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  openssl,
  dbus,
  gtk3,
  gdk-pixbuf,
  cairo,
  glib,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytubic";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/NUber-dev/YTubic/releases/download/v${finalAttrs.version}/YTubic_${finalAttrs.version}_Linux_x86_64.deb";
    hash = "sha256-a1AguyAFfkPFVA9DoQIRJ8VJyCY6UfU47mEci2NJxmg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    dbus
    gtk3
    gdk-pixbuf
    cairo
    glib
    webkitgtk_4_1
    libsoup_3
    glib-networking
    stdenv.cc.cc.lib
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ]);

  unpackPhase = "dpkg-deb -x $src .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/bin usr/share $out/
    runHook postInstall
  '';

  # The tray library is dlopen'd, so it is invisible to autoPatchelf
  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]})
  '';

  meta = {
    description = "YouTube Music desktop client";
    homepage = "https://github.com/NUber-dev/YTubic";
    license = lib.licenses.gpl3Only;
    mainProgram = "ytubic";
    platforms = [ "x86_64-linux" ];
  };
})

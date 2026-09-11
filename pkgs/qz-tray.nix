{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  jdk17,
  alsa-lib,
  cairo,
  cups,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libusb1,
  nss,
  pango,
  procps,
  systemd,
  libx11,
  libxtst,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "qz-tray";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/qzind/tray/releases/download/v${finalAttrs.version}/qz-tray-${finalAttrs.version}-x86_64.run";
    hash = "sha256-JIKKVU4UR8jByXEqhJD95Bqzcd69BjIrIe7bOPV0htk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    cairo
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libusb1
    pango
    systemd
    libx11
    libxtst
  ];

  # Makeself archive; --noexec extracts without running the /opt installer
  unpackPhase = ''
    runHook preUnpack
    cp $src qz-tray.run
    chmod +x qz-tray.run
    ./qz-tray.run --noexec --target dist
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/qz-tray.jar -t $out/share/qz-tray
    install -Dm644 dist/LICENSE.txt -t $out/share/qz-tray
    install -Dm644 dist/qz-tray.svg $out/share/icons/hicolor/scalable/apps/qz-tray.svg
    cp -r dist/libs $out/share/qz-tray/libs

    # The bundled JRE 11 is dropped in favour of jdk17 from nixpkgs
    makeWrapper ${jdk17}/bin/java $out/bin/qz-tray \
      --add-flags "-Xms512m" \
      --add-flags "-Djna.nosys=true" \
      --add-flags "-Djava.library.path=$out/share/qz-tray/libs" \
      --add-flags "--add-exports java.desktop/sun.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt=ALL-UNNAMED" \
      --add-flags "-jar $out/share/qz-tray/qz-tray.jar" \
      --prefix PATH : "${
        lib.makeBinPath [
          cups
          nss.tools
          procps
        ]
      }"

    runHook postInstall
  '';

  # JavaFX media plugins want ffmpeg 57/58/59 and the gtk2 variant of
  # glass; QZ only uses the gtk3 backend and does not play media
  autoPatchelfIgnoreMissingDeps = [
    "libavcodec.so.57"
    "libavcodec.so.58"
    "libavcodec.so.59"
    "libavformat.so.57"
    "libavformat.so.58"
    "libavformat.so.59"
    "libgtk-x11-2.0.so.0"
    "libgdk-x11-2.0.so.0"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "qz-tray";
      icon = "qz-tray";
      desktopName = "QZ Tray";
      comment = "Print, scan and serial connector for browser-based applications";
      exec = "qz-tray";
      categories = [ "Utility" ];
      startupNotify = false;
      mimeTypes = [ "x-scheme-handler/qz" ];
    })
  ];

  meta = {
    description = "Print, scan and serial connector for browser-based applications";
    longDescription = ''
      QZ Tray runs a local WebSocket server that lets web pages talk to
      printers, scanners, and serial/HID devices. State (SSL keypair and
      qz-tray.properties) is written to ~/.qz on first run.
    '';
    homepage = "https://qz.io";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "qz-tray";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})

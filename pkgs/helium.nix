{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libva,
  libxkbcommon,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  vulkan-loader,
  wayland,
  libxscrnsaver,
  libuuid,
  libkrb5,
}:

let
  pname = "helium";
  version = "0.18.3.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-xDrhTCq3FVWz/kC9Al3wBPcLxHlalhoaOlaXn6G4uYA=";
  };

  contents = appimageTools.extract { inherit pname version src; };

  runtimeLibs = [
    libGL
    libva
    pipewire
    systemd
    vulkan-loader
    wayland
    libxkbcommon
    libkrb5
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = contents;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxscrnsaver
    libxtst
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ]
  ++ runtimeLibs;

  runtimeDependencies = runtimeLibs;

  # The Qt platform-theme shims are optional plugins
  autoPatchelfIgnoreMissingDeps = [ "libQt*" ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin
    cp -r opt/helium $out/opt/helium

    makeWrapper $out/opt/helium/helium $out/bin/helium \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --set CHROME_WRAPPER helium

    install -Dm444 helium.desktop -t $out/share/applications
    cp -r usr/share/icons $out/share

    runHook postInstall
  '';

  meta = {
    description = "Helium browser";
    homepage = "https://github.com/imputnet/helium";
    license = lib.licenses.gpl3Only;
    mainProgram = "helium";
    platforms = [ "x86_64-linux" ];
  };
}

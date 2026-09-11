{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "emdash";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/generalaction/emdash/releases/download/v${version}/emdash-x86_64.AppImage";
    hash = "sha256-8+UhbYn6OE7R+6hyR0mx0h6n5H+3i+TWyIsEsbNa4Fs=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/Emdash.desktop -t $out/share/applications
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/Emdash.png \
      -t $out/share/icons/hicolor/1024x1024/apps

    # Upstream points Exec at the in-AppImage AppRun; --no-sandbox stays because
    # chrome-sandbox cannot be setuid in the store.
    substituteInPlace $out/share/applications/Emdash.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Agentic development environment that runs multiple coding agents in parallel";
    homepage = "https://emdash.sh";
    license = lib.licenses.asl20;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}

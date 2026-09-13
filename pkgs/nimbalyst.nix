{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "nimbalyst";
  version = "0.77.5";

  src = fetchurl {
    url = "https://github.com/nimbalyst/nimbalyst/releases/download/v${version}/Nimbalyst-Linux.AppImage";
    hash = "sha256-k3Ulfa5BEOBtJpLGPc3GIbKo6jJlRvYG+uJ/Ub4TpdA=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/icons

    # Upstream points Exec at the in-AppImage AppRun; --no-sandbox stays because
    # chrome-sandbox cannot be setuid in the store.
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Visual workspace for running Claude Code, Codex, and OpenCode agents in parallel";
    homepage = "https://nimbalyst.com";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}

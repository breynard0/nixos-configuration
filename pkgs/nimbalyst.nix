{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
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

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/icons

    # Upstream points Exec at the in-AppImage AppRun; --no-sandbox stays because
    # chrome-sandbox cannot be setuid in the store.
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    # Keep all mutable application state out of the Nix store and in directories
    # owned by the user that launches Nimbalyst.  This also avoids inheriting a
    # system-level XDG directory when the desktop launcher starts the AppImage.
    wrapProgram $out/bin/${pname} \
      --run '
        export XDG_CONFIG_HOME="$HOME/.config/${pname}"
        export XDG_DATA_HOME="$HOME/.local/share/${pname}"
        export XDG_CACHE_HOME="$HOME/.cache/${pname}"
        export XDG_STATE_HOME="$HOME/.local/state/${pname}"
        export TMPDIR="$XDG_CACHE_HOME/tmp"
        mkdir -p -m 700 "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME" "$TMPDIR"
      '
  '';

  meta = {
    description = "Visual workspace for running Claude Code, Codex, and OpenCode agents in parallel";
    homepage = "https://nimbalyst.com";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}

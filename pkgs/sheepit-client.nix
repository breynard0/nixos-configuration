{
  curl,
  jre,
  lib,
  makeDesktopItem,
  symlinkJoin,
  systemdLibs,
  writeShellApplication,
}:
let
  launcher = writeShellApplication {
    name = "sheepit-client";
    runtimeInputs = [
      curl
      jre
    ];
    text = ''
      export LD_LIBRARY_PATH="${
        lib.makeLibraryPath [ systemdLibs ]
      }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/sheepit"
      jar="$cache_dir/client.jar"

      if [[ ! -s "$jar" || "''${1:-}" == "--update-client" ]]; then
        if [[ "''${1:-}" == "--update-client" ]]; then
          shift
        fi
        mkdir -p "$cache_dir"
        tmp=$(mktemp "$cache_dir/client.XXXXXX")
        trap 'rm -f "$tmp"' EXIT
        curl --fail --location --retry 3 --output "$tmp" \
          https://www.sheepit-renderfarm.com/media/applet/client-latest.php
        mv "$tmp" "$jar"
        trap - EXIT
      fi

      exec java -jar "$jar" "$@"
    '';
  };

  desktop = makeDesktopItem {
    name = "sheepit-client";
    desktopName = "SheepIt Render Farm Client";
    comment = "Render Blender projects for the SheepIt community";
    exec = "sheepit-client";
    categories = [ "Graphics" ];
  };
in
symlinkJoin {
  name = "sheepit-client";
  paths = [
    launcher
    desktop
  ];
}

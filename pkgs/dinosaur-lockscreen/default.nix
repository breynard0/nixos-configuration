{
  stdenvNoCC,
  fetchurl,
  ffmpeg,
  pipewire,
}:
let
  uuid = "dinosaur-lockscreen@breynard";

  asset =
    name: hash:
    fetchurl {
      url = "https://dinosaurbbq.org/${name}";
      inherit hash;
    };
  dance = asset "dance.gif" "sha256-tdgDatIFVdoRawq6xP3xHic4Ms+yM01atZ8KNMRSbRQ=";
  static = asset "static.gif" "sha256-BdcHDOYAy44Gmrjkpu1SeQPKRj/I2V3JKcE0oURMX8E=";
  music = asset "music.mp3" "sha256-nAFl8Lx0fQ7bLJ0HY3NZoxL6YQpQzwlaZ1jhyoHt7dw=";
in
stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-dinosaur-lockscreen";
  version = "1";

  dontUnpack = true;
  nativeBuildInputs = [ ffmpeg ];

  # The shell cannot decode GIFs frame by frame, so each one is unpacked into
  # numbered PNGs that the extension flips through.
  installPhase = ''
    runHook preInstall

    dir=$out/share/gnome-shell/extensions/${uuid}
    mkdir -p $dir/assets
    cp ${./metadata.json} $dir/metadata.json
    substitute ${./extension.js} $dir/extension.js \
      --replace-fail @pwPlay@ ${pipewire}/bin/pw-play

    ffmpeg -v error -i ${dance} -vf scale=800:-1:flags=lanczos -start_number 0 $dir/assets/dance-%02d.png
    ffmpeg -v error -i ${static} -start_number 0 $dir/assets/static-%02d.png
    ffmpeg -v error -i ${music} -vn -c:a libvorbis -q:a 5 $dir/assets/music.ogg

    runHook postInstall
  '';

  passthru.extensionUuid = uuid;
}

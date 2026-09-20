{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "got-your-back";
  version = "1.95";

  src = fetchurl {
    url = "https://github.com/GAM-team/got-your-back/releases/download/v${finalAttrs.version}/gyb-${finalAttrs.version}-linux-x86_64-glibc2.35.tar.xz";
    hash = "sha256-441vv4ddZ3XkM12+amB0Ts/+DByXoExZwxxfUrUur/Q=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 gyb $out/libexec/gyb
    touch $out/libexec/noupdatecheck.txt
    install -Dm644 LICENSE -t $out/share/licenses/${finalAttrs.pname}

    mkdir -p $out/bin
    substitute ${./got-your-back-wrapper.sh} $out/bin/gyb \
      --replace-fail '@libexec@' "$out/libexec/gyb"
    chmod +x $out/bin/gyb

    runHook postInstall
  '';

  meta = {
    description = "Command-line tool for backing up and restoring Gmail messages";
    homepage = "https://github.com/GAM-team/got-your-back";
    license = lib.licenses.asl20;
    mainProgram = "gyb";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

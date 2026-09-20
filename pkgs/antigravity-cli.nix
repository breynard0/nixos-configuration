{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antigravity-cli";
  version = "1.2.5";

  src = fetchurl {
    url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${finalAttrs.version}/agy_cli_linux_x64.tar.gz";
    hash = "sha256-5FDKq1aCrMkgchsEzw9oYMMT0fUpa8bknXnNOEOALmU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    # Upstream ships the binary as `antigravity`; `agy` is the documented
    # command and leaves the name free for the Antigravity IDE package.
    install -Dm755 antigravity $out/bin/agy

    runHook postInstall
  '';

  meta = {
    description = "Terminal agent harness for Google Antigravity";
    homepage = "https://antigravity.google/product/antigravity-cli";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "agy";
    platforms = [ "x86_64-linux" ];
  };
})

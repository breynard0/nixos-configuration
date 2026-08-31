{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  gettext,
  wrapGAppsHook3,
  avahi,
  glib,
  gtk3,
  gtk-layer-shell,
  libnotify,
  openssl,
  wayland,
  gtest,
  nlohmann_json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tether";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "zackb";
    repo = "tether";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YG5Siv1/MZILtc6/tyydYq9t1bEjTbgC3N1+s0Ni0+A=";
  };

  # No git in the sandbox, so the version would fall back to "-unknown"
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(TETHER_VERSION "''${PROJECT_VERSION}-unknown")' \
                     'set(TETHER_VERSION "''${PROJECT_VERSION}")'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    glib
    gtk3
    gtk-layer-shell
    libnotify
    openssl
    wayland
  ];

  cmakeFlags = [
    # The extensions are published to addons.mozilla.org; building them needs npm and network
    (lib.cmakeBool "TETHER_BUILD_EXTENSIONS" false)

    # Both are pulled in with FetchContent upstream
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")

    # Absolute by default, which would escape $out
    (lib.cmakeFeature "CHROME_MESSAGING_DIR" "etc/chromium/native-messaging-hosts")
    (lib.cmakeFeature "GOOGLE_CHROME_MESSAGING_DIR" "etc/opt/chrome/native-messaging-hosts")
  ];

  doCheck = true;

  # The crypto tests all share a hardcoded /tmp directory, so they race each other
  preCheck = ''
    export CTEST_PARALLEL_LEVEL=1
  '';

  meta = {
    description = "Bridge an iPhone to the Linux desktop: clipboard, files, messages, and notifications";
    homepage = "https://github.com/zackb/tether";
    license = lib.licenses.mit;
    mainProgram = "tether";
    platforms = lib.platforms.linux;
  };
})

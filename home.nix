{
  pkgs,
  ...
}:

{
  imports = [
    ./config/vscode.nix
    ./config/theme.nix
    ./config/terminal.nix
    ./config/apps.nix
    ./config/defaults.nix
    ./config/jetbrains.nix
    ./config/zed.nix
    ./config/nixvim.nix
    ./config/dconf.nix
    ./config/pi.nix
    ./config/claude.nix
  ];

  home.username = "breynard";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fastfetch

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fd
    bat
    btop
    dust
    duf
    tealdeer
    hyperfine
    just
    uv
    tio # serial console
    wl-clipboard # wl-copy / wl-paste for the Wayland clipboard
    gcc
    rustup
    gh # GitHub CLI
    surge-cli # CLI for the surge.sh CDN

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
    ngrok # secure tunnels to localhost

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    dconf

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    htop
    iotop # io monitoring
    iftop # network monitoring
    mission-center

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # nix dev tools
    nixd
    nixfmt
    nix-tree

    pavucontrol
    paprefs

  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
  };

  programs.git.ignores = [
    "**/.claude/settings.local.json"
    ".direnv/"
    "result"
    "result-*"
    ".DS_Store"
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git.settings = {
    init.defaultBranch = "main";
    pull.rebase = true;
    rebase.autoStash = true;
    push.autoSetupRemote = true;
    fetch.prune = true;
    rerere.enabled = true;
    merge.conflictStyle = "zdiff3";
    user.name = "breynard";
    user.email = "dev@breynard.net";
    credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
  };

  home.shellAliases = {
    nd = "nix develop --command fish";
    snrs = "nh os switch";
    ns = "tv nix-search-tv";
    z = "cd";
    zi = "cdi";
  };

  programs.fish.functions = {
    projectinit = ''
      if test -d ~/nixos-configuration/templates/$argv[1]
        nix flake init -t ~/nixos-configuration#$argv[1]
      else
        nix flake init -t github:the-nix-way/dev-templates#$argv[1]
      end
    '';
    # A second GNOME Shell in a window, for testing extensions without logging out.
    gnome-nested = "dbus-run-session -- gnome-shell --devkit $argv";
    lsapps = "ls /etc/profiles/per-user/$(id -n -u)/share/applications";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.television.enable = true;
  programs.nix-search-tv.enable = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}

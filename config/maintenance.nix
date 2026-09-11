{ pkgs, ... }:
let
  # Auto GC roots (mostly direnv's .direnv profiles) are symlinks to the
  # indirect root outside the store. Nix keeps the whole closure alive for
  # each one, so a deleted project can pin gigabytes forever. Only roots
  # whose target is gone in every form are removed.
  pruneAutoGcRoots = pkgs.writeShellScript "prune-auto-gcroots" ''
    for link in /nix/var/nix/gcroots/auto/*; do
      [ -L "$link" ] || continue
      target=$(${pkgs.coreutils}/bin/readlink "$link") || continue
      case "$target" in
        /*) ;;
        *) continue ;;
      esac
      if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        echo "removing dangling GC root $link -> $target"
        ${pkgs.coreutils}/bin/rm -f -- "$link"
      fi
    done
    # Never let a pruning hiccup abort the GC run itself.
    exit 0
  '';

  # smartd exports SMARTD_DEVICESTRING and SMARTD_MESSAGE to -M exec.
  smartdNotify = pkgs.writeShellScript "smartd-notify" ''
    ${pkgs.sudo}/bin/sudo -u breynard \
      DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send --urgency=critical \
      "SMART failure: $SMARTD_DEVICESTRING" \
      "$SMARTD_MESSAGE"
  '';
in
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  systemd.services.nix-gc.serviceConfig.ExecStartPre = "${pruneAutoGcRoots}";

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    # Disk swap sits at priority -1, so zram absorbs pressure first and
    # nvme0n1p6 stays free for hibernation.
    priority = 5;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
  };

  services.smartd = {
    enable = true;

    # There is no MTA, so mail notification would silently go nowhere.
    # The built-in notifiers are all off and the desktop notification is
    # attached directly, because the module only emits "-M exec" for its own
    # generated script when mail, wall or x11 is enabled.
    notifications = {
      mail.enable = false;
      wall.enable = false;
      x11.enable = false;
    };

    defaults.monitored = "-a -m <nomailer> -M exec ${smartdNotify}";
  };
}

{ pkgs, ... }:
let
  # Run through pkexec: opens the AirPlay ports for one uxplay process and
  # closes them again when that process exits.
  firewall = pkgs.writeShellScript "airplay-firewall" ''
    PATH=${
      pkgs.lib.makeBinPath [
        pkgs.iptables
        pkgs.coreutils
        pkgs.systemd
      ]
    }
    pid=$2
    case "$pid" in
      "" | *[!0-9]*) exit 1 ;;
    esac

    rules() {
      for ipt in iptables ip6tables; do
        $ipt -w "$1" nixos-fw -p tcp -m multiport --dports 7000,7001,7100 -j nixos-fw-accept
        $ipt -w "$1" nixos-fw -p udp -m multiport --dports 6000,6001,7011 -j nixos-fw-accept
      done
    }

    case "$1" in
      open)
        case "$(readlink "/proc/$pid/exe")" in
          ${pkgs.uxplay}/*) ;;
          *) exit 1 ;;
        esac
        rules -I
        systemd-run --quiet --collect --unit="airplay-firewall-$pid" "$0" close "$pid"
        ;;
      close)
        tail --pid="$pid" -f /dev/null
        rules -D
        ;;
    esac
  '';

  receiver = pkgs.writeShellApplication {
    name = "airplay-receiver";
    runtimeInputs = [ pkgs.uxplay ];
    text = ''
      uxplay -p &
      pid=$!
      if ! pkexec ${firewall} open "$pid"; then
        kill "$pid"
        exit 1
      fi
      wait "$pid"
    '';
  };

  entry = pkgs.makeDesktopItem {
    name = "airplay-receiver";
    desktopName = "AirPlay Receiver";
    comment = "Mirror an iPhone or iPad screen to this laptop";
    exec = "airplay-receiver";
    icon = "video-display";
    categories = [ "AudioVideo" ];
  };
in
{
  environment.systemPackages = [
    receiver
    entry
  ];

  # uxplay announces itself through avahi.
  services.avahi.publish = {
    enable = true;
    userServices = true;
  };
}

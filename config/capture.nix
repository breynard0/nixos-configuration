{ config, pkgs, ... }:
let
  replaySaved = pkgs.writeShellScript "replay-saved" ''
    ${pkgs.libnotify}/bin/notify-send -a "Instant replay" "Replay saved" "$1"
  '';

  convert =
    {
      name,
      suffix,
      args,
    }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.ffmpeg
        pkgs.libnotify
      ];
      text = ''
        done=0
        while IFS= read -r file; do
          [ -f "$file" ] || continue
          if ffmpeg -nostdin -n -i "$file" ${args} "''${file%.*}${suffix}"; then
            done=$((done + 1))
          fi
        done <<< "''${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS:-}"
        notify-send -a Files "${name}" "$done file(s) converted"
      '';
    };

  toResolve = convert {
    name = "convert-for-resolve";
    suffix = "-dnxhr.mov";
    args = "-c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le";
  };
  toUpload = convert {
    name = "convert-for-upload";
    suffix = "-h264.mp4";
    args = "-c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart";
  };
in
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      obs-backgroundremoval
    ];
  };

  environment.systemPackages = [ pkgs.livecaptions ];

  # Instant replay: <Super><Shift>r (config/dconf.nix) saves the last 60 seconds.
  programs.gpu-screen-recorder.enable = true;

  systemd.user.services.replay-buffer = {
    description = "Instant replay buffer";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    unitConfig.ConditionACPower = true;
    path = [ "/run/wrappers" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Videos/Replays";
      ExecStart = "${config.programs.gpu-screen-recorder.package}/bin/gpu-screen-recorder -w screen -f 60 -a default_output -c mp4 -r 60 -o %h/Videos/Replays -sc ${replaySaved}";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  # ConditionACPower is only checked at start, so follow the charger.
  systemd.services.replay-buffer-power = {
    description = "Start or stop the replay buffer when AC power changes";
    serviceConfig.Type = "oneshot";
    script = ''
      user() {
        ${pkgs.util-linux}/bin/runuser -u breynard -- ${pkgs.coreutils}/bin/env \
          XDG_RUNTIME_DIR=/run/user/1000 systemctl --user "$@"
      }
      user is-active --quiet graphical-session.target || exit 0
      if ${pkgs.systemd}/bin/systemd-ac-power; then
        user start --no-block replay-buffer.service
      else
        user stop --no-block replay-buffer.service
      fi
    '';
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="AC", ACTION=="change", RUN+="${pkgs.systemd}/bin/systemctl start --no-block replay-buffer-power.service"
  '';

  home-manager.users.breynard.home.file = {
    ".local/share/nautilus/scripts/Convert for Resolve (DNxHR)".source = pkgs.lib.getExe toResolve;
    ".local/share/nautilus/scripts/Convert for upload (H.264)".source = pkgs.lib.getExe toUpload;
  };
}

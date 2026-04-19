{
  ...
}:
{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      modules = {
        center = [
          "WindowTitle"
        ];
        left = [
          "Workspaces"
        ];
        right = [
          # "MediaPlayer"
          "SystemInfo"
          [
            "Clock"
            "Settings"
          ]
        ];
      };
      appearance = {
        style = "Solid";
        scale_factor = 0.8;
        opacity = 0.9;
        primary_color = "#24a0f3ff";
        success_color = "#9ece6a";
        text_color = "#fefefe";
        background_color.base = "#27272e";
        background_color.strong = "#414868";
        background_color.weak = "#24273a";
        workspace_colors = [ "#37373dff" ];
      };
      media_player = {
        max_title_length = 50;
        indicator_format = "IconAndTitle";
      };
      window_title = {
        mode = "Title";
        truncate_title_after_length = 60;
      };
    };
  };
}

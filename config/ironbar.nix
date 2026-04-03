{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  # Set styling
  home.file.".config/ironbar/style.css".source = ./ironbar.css;

  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      position = "top";
      anchor_to_edges = true;
      height = 12;
      popup_autohide = true;
      start = [
        { type = "workspaces"; }
      ];
      center = [
        {
          type = "focused";
          icon_size = 10;
        }
      ];
      end = [
        {
          type = "music";
          icon_size = 10;
        }
        {
          type = "volume";
          icon_size = 10;
        }
        {
          type = "clipboard";
          icon_size = 10;
        }
        {
          type = "network_manager";
          icon_size = 10;
        }
        {
          type = "bluetooth";
          icon_size = 10;
        }
        {
          type = "battery";
          icon_size = 10;
        }
        {
          type = "sys_info";
          format = [
            "  {cpu_percent}%"
            "  {memory_percent}%"
          ];
          interval.cpu = 1;
        }
        {
          type = "clock";
        }
      ];
    };
  };
}

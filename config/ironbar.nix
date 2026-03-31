{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      position = "top";
      anchor_to_edges = true;
      height = 14;
      popup_autohide = true;
      start = [
        { type = "workspaces"; }
      ];
      center = [
        {
          type = "focused";
          icon_size = 12;
        }
      ];
      end = [
        {
          type = "music";
          icon_size = 12;
        }
        {
          type = "volume";
          icon_size = 12;
        }
        {
          type = "clipboard";
          icon_size = 12;
        }
        {
          type = "network_manager";
          icon_size = 12;
        }
        {
          type = "bluetooth";
          icon_size = 12;
        }
        {
          type = "battery";
          icon_size = 12;
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
    style = ''
      * {
        font-family: Noto Sans Nerd Font, sans-serif;
        font-size: 10px;
        border: none;
        border-radius: 0;
        background: #303031e4;
        min-height: 0;
      }
      .workspaces .item.focused {
        background-color: #3060a266;
      }

      .workspaces .item.urgent {
        background-color: #a63040dd;
      }
    '';
  };
}

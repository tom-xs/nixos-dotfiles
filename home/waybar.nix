{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "battery"
          "pulseaudio"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";

          show-special = true;
          special-visible-only = true;
        };
        clock = {
          format = "{:%H:%M - %d/%m/%Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        battery = {
          format = "{capacity}%";
          format-charging = "{capacity}% ";
          format-low = "{capacity}% ";
        };
        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "VOL MUTE";
        };
      };
    };

    style = ''
            * {
      border: none;
              border-radius: 0;
              font-family: monospace;
              font-size: 13px;
              min-height: 0;
            }
          window#waybar {
      background: #000000;
      color: #ffffff;
             border-bottom: 1px solid #333333;
          }
      #workspaces button {
      padding: 0 5px;
      background: transparent;
      color: #888888;
      }
      #workspaces button.active {
      color: #ffffff;
      background: #333333;
      }
      #clock, #battery, #pulseaudio, #tray {
      padding: 0 10px;
      color: #ffffff;
      }
      tooltip {
      background: #000000;
      color: #ffffff;
      border: 1px solid #333333;
      }
      tooltip label {
      color: #ffffff;
      font-family: monospace;
      font-size: 14px;
      }
    '';
  };
}

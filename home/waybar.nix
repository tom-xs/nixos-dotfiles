{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26; # Very Compact Height
        spacing = 0;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" "group/music" ];
        modules-right = [ 
          "group/audio" 
          "network" 
          "group/hardware" 
          "battery" 
          "tray" 
        ];

        # --- Groups ---

        "group/music" = {
          orientation = "horizontal";
          modules = [ "custom/prev" "mpris" "custom/next" ];
        };

        "group/audio" = {
          orientation = "horizontal";
          modules = [ "pulseaudio" "pulseaudio#microphone" ];
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [ "cpu" "memory" "custom/gpu" ];
        };

        # --- Modules ---

	"hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          
          # Use {icon} instead of {name}
          format = "{icon}";
          
          # Map workspace numbers to icons
          format-icons = {
            "1" = "";  # Network/Web
            "2" = "";  # Terminal
            "3" = "";  # Chat
            "4" = "󰎚";  # Chat
          };

          # Make them always visible
          persistent-workspaces = {
             "1" = [];
             "2" = [];
             "3" = [];
          };
        };

        "clock" = {
          # Text only, no icon
          format = "{:%H:%M | %d/%m/%y}";
          tooltip-format = "{calendar}";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "{}";
              days = "{}";
              weeks = "W{}";
              today = "{}";
            };
          };
        };

        "mpris" = {
          format = "{status_icon}";
          format-paused = "{status_icon}";
          status-icons = { playing = "⏸"; paused = "▶"; stopped = "■"; };
          max-length = 10;
          on-click-right = "noop"; 
        };

        "custom/prev" = {
          format = "⏮";
          on-click = "playerctl previous";
          tooltip = false;
        };

        "custom/next" = {
          format = "⏭";
          on-click = "playerctl next";
          tooltip = false;
        };

        "pulseaudio" = {
          # Icons Restored, Removed "Vol" text for compactness
          format = "{icon} {volume}%";
          format-bluetooth = " {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        "pulseaudio#microphone" = {
          # Icon Restored, Removed "Mic" text
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "pavucontrol";
        };

        "network" = {
          # Icons Restored
          format-wifi = " {essid}";
          format-ethernet = " Eth";
          format-linked = " (No IP)";
          format-disconnected = "⚠ Off";
          on-click = "nm-connection-editor"; 
        };

        "cpu" = { 
          format = " {usage}%"; 
          tooltip = false; 
        };

        "memory" = { 
          format = " {}%"; 
        };

        "custom/gpu" = {
          exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format = " {}%";
          interval = 5;
        };

        "battery" = {
          states = { good = 95; warning = 30; critical = 15; };
          format = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = { spacing = 10; };
      };
    };

    # --- CSS Styles ---
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 11px;
        font-weight: bold;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #5c5f77;
      }

      /* Spacing */
      #workspaces, #clock, #group-music, #group-audio, #network, #group-hardware, #battery, #tray {
        margin: 0 4px;
      }

      /* 
       * STYLE:
       * Background: White
       * Border: 2px Solid Dark Grey (#5c5f77)
       * Padding: Reduced to 6px horizontal
       */

      #workspaces,
      #clock,
      #mpris, #custom-prev, #custom-next,
      #pulseaudio, #pulseaudio.microphone,
      #network,
      #cpu, #memory, #custom-gpu,
      #battery,
      #tray {
        background-color: #ffffff;
        color: #5c5f77;
        padding: 0 6px; /* Tighter padding for compactness */
        border-radius: 6px;
        border: 2px solid #5c5f77;
      }

      /* Workspaces Specifics */
      #workspaces {
        padding: 0; /* Remove container padding */
      }
      #workspaces button {
        padding: 0 5px; /* Very tight button padding */
        background: transparent;
        color: #5c5f77;
      }
      #workspaces button.active {
        background-color: #f9e2af; 
        color: #5c5f77;
        border-radius: 4px;
      }
      #workspaces button:hover {
        background: rgba(249, 226, 175, 0.5);
        border-radius: 4px;
      }

      /* Fix Group Borders */
      
      /* Music Group */
      #custom-prev { border-right: none; border-radius: 6px 0 0 6px; }
      #mpris { border-left: none; border-right: none; border-radius: 0; }
      #custom-next { border-left: none; border-radius: 0 6px 6px 0; }

      /* Audio Group */
      #pulseaudio { border-right: none; border-radius: 6px 0 0 6px; }
      #pulseaudio.microphone { border-left: none; border-radius: 0 6px 6px 0; }

      /* Hardware Group */
      #cpu { border-right: none; border-radius: 6px 0 0 6px; }
      #memory { border-left: none; border-right: none; border-radius: 0; }
      #custom-gpu { border-left: none; border-radius: 0 6px 6px 0; }

      /* Battery States */
      #battery.charging {
        background-color: #f9e2af;
      }
      #battery.critical:not(.charging) {
        background-color: #ffcccc;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to { background-color: #ffffff; }
      }
    '';
  };
}

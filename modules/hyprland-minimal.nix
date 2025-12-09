{ pkgs, ... }:

let
  # --- 1. Minimal Waybar Config ---
  waybarConfig = pkgs.writeText "waybar-minimal.jsonc" ''
    {
      "layer": "top",
      "position": "top",
      "height": 26, 
      "modules-left": ["hyprland/workspaces"],
      "modules-center": ["clock"],
      "modules-right": ["battery", "pulseaudio", "tray"],
      "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
      },
      "clock": {
        "format": "{:%H:%M - %d/%m/%Y}"
      },
      "battery": {
        "format": "{capacity}%"
      },
      "pulseaudio": {
        "format": "VOL {volume}%"
      }
    }
  '';

  # Added 'border-bottom' for the outline
  waybarStyle = pkgs.writeText "waybar-minimal.css" ''
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
      border-bottom: 1px solid #333333; /* Thin outline */
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
  '';

  # --- 2. Minimal Hyprland Config ---
  minimalHyprlandConfig = ''
    # --- General ---
    monitor=,preferred,auto,1

    # --- Input ---
    input {
        kb_layout = br
        kb_options = ctrl:nocaps
        follow_mouse = 1
        touchpad {
            natural_scroll = true
        }
    }

    # --- Look and Feel (Monochrome & Square) ---
    general {
        gaps_in = 2
        gaps_out = 0
        border_size = 1
        
        # White active border, Gray inactive
        col.active_border = rgba(ffffffaa)
        col.inactive_border = rgba(333333aa)
        
        layout = dwindle
    }

    decoration {
        rounding = 0
        active_opacity = 1.0
        inactive_opacity = 1.0
        
        # Minimal drop shadow
        shadow {
            enabled = true
            range = 4
            render_power = 3
            color = rgba(000000ee)
        }

        blur {
            enabled = false
        }
    }

    # --- Animations (REMOVED) ---
    animations {
        enabled = false
    }

    # --- Keybinds ---
    $mod = SUPER
    $term = kitty
    $menu = wofi --show drun
    $fileManager = dolphin

    bind = $mod, RETURN, exec, $term
    bind = $mod, W, killactive
    bind = $mod, J, togglesplit
    bind = $mod, E, exec, $fileManager
    bind = $mod, L, exec, hyprlock
    bind = $mod, D, exec, $menu
    bind = $mod, P, pseudo
    bind = $mod, F, fullscreen
    bind = $mod, SPACE, togglefloating
    bind = $mod ALT, E, exit

    # Move focus
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    # Move windows
    bind = $mod SHIFT, left, movewindow, l
    bind = $mod SHIFT, right, movewindow, r
    bind = $mod SHIFT, up, movewindow, u
    bind = $mod SHIFT, down, movewindow, d

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Special Workspaces
    bind = $mod, S, togglespecialworkspace, magic
    bind = $mod SHIFT, S, movetoworkspace, special:magic

    # Mouse
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up, workspace, e-1
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    # Media & Brightness
    bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
    bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-
    bindl = ,XF86AudioNext, exec, playerctl next
    bindl = ,XF86AudioPause, exec, playerctl play-pause
    bindl = ,XF86AudioPlay, exec, playerctl play-pause
    bindl = ,XF86AudioPrev, exec, playerctl previous

    # --- Startup ---
    # 1. Wallpaper (Using swaybg for simplicity)
    exec-once = swaybg -i /home/tomasxs/.local/share/wallpaper/dark1.jpg -m fill

    # 2. Topbar
    exec-once = waybar -c ${waybarConfig} -s ${waybarStyle}

    # 3. Notifications
    exec-once = mako &
  '';

  # --- 3. Session Package ---
  minimalSession =
    pkgs.runCommand "hyprland-minimal-session"
      {
        passthru.providedSessions = [ "hyprland-minimal" ];
      }
      ''
        mkdir -p $out/share/wayland-sessions
        cat <<EOF > $out/share/wayland-sessions/hyprland-minimal.desktop
        [Desktop Entry]
        Name=Hyprland Minimal
        Comment=Monochrome, No Animations
        Exec=Hyprland --config /etc/hypr/minimal.conf
        Type=Application
        EOF
      '';

in
{
  environment.etc."hypr/minimal.conf".text = minimalHyprlandConfig;

  services.displayManager.sessionPackages = [ minimalSession ];

  environment.systemPackages = with pkgs; [
    mako
    waybar
    swaybg # Added for wallpaper support
    adwaita-icon-theme
  ];
}

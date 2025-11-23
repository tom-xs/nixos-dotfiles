{ pkgs, ... }:

{
  # Window Manager
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs;[ hyprpaper wofi kdePackages.dolphin playerctl ];
}

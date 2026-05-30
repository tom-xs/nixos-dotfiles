{ pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  programs.waybar.enable = true;

  home.packages = with pkgs; [
    hyprpaper
    wofi
    kdePackages.dolphin
    playerctl
    brightnessctl
  ];
}

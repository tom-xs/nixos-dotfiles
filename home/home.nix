{ config, pkgs, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";

  # User Packages
  home.packages = with pkgs; [
    neovim
    kitty
    btop
    tldr
    vesktop
    zed-editor
    swww
  ];

  # 1. Set Breeze Cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
  };

  # Git Configuration
  programs.git = {
    enable = true;
    settings.user = {
      Name = "Tomas Xavier Santos";
      Email = "tom.xaviersantos@gmail.com";
    };
  };

  # 2. Kitty with Earl Grey Theme
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings.font_family = "SauceCodePro Nerd Font";
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}

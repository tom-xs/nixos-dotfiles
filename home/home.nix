{ pkgs, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";

  # Hyprland Configuration
  imports = [ ./hyprland.nix ];

  # User Packages
  home.packages = with pkgs; [
    neovim
    btop
    tldr
    vesktop
    zed-editor
    nixd
    nil
  ];

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 18;
  };

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      Name = "Tomas Xavier Santos";
      Email = "tom.xaviersantos@gmail.com";
    };
  };

  # Kitty
  programs.kitty = {
    enable = true;
    themeFile = "everforest_light_hard";
    extraConfig = ''confirm_os_window_close 0'';
    font = {
      name = "JetBrains Mono NerdFont";
      size = 12;
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}

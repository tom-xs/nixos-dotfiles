{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";

  # Hyprland Configuration
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./neovim.nix
    ./shell.nix
    ./kitty.nix
    ./tmux.nix
  ];

  # User Packages
  home.packages =
    let
      stremioPkgs = import inputs.nixpkgs-for-stremio {
        inherit (pkgs) system;
      };
    in
    with pkgs;
    [
      (stremioPkgs.stremio)
      btop
      tldr
      feh
      vesktop
      telegram-desktop
      zed-editor
      httpie-desktop
      httpie
      obsidian
      zotero
      calibre
      gimp
    ];

  systemd.user.services.waybar.Install.WantedBy = lib.mkForce [ ];
  systemd.user.services.hyprpaper.Install.WantedBy = lib.mkForce [ ];
  systemd.user.services.hypridle.Install.WantedBy = lib.mkForce [ ];

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

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}

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
    # ./tmux.nix
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

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}


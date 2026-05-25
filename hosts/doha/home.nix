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
    ../../home/tmux.nix
    ../../home/shell.nix
    ../../home/kitty.nix
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
      inputs.helium.packages.${system}.default
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
      thunderbird
      gh
      vscode
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


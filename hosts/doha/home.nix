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
    ../../home/neovim.nix
  ];
  # User Packages
  home.packages =
    let
      system = pkgs.stdenv.hostPlatform.system;
      stremioPkgs = import inputs.nixpkgs-for-stremio {
        inherit system;
      };
    in
    with pkgs;
    [
      inputs.helium.packages.${system}.default
      (stremioPkgs.stremio)
      github-copilot-cli
      tldr
      vesktop
      telegram-desktop
      zed-editor
      libreoffice-still
      obsidian
      zotero
      calibre
      gimp
      thunderbird
      gh
      vscode
      xclip
      spotify
      irpf # :(
    ];

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };
  programs.fish.shellAliases = {
    update = lib.mkForce "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#doha";
  };

  home.stateVersion = "26.11";
  programs.home-manager.enable = true;
}

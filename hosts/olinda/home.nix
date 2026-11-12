{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "26.11";

  # Fedora's nix (dnf) client otherwise tries the store directly and fails
  # with "opening lock file ... Permission denied"; route it via the daemon.
  home.sessionVariables.NIX_REMOTE = "daemon";

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
  ];

  targets.genericLinux.enable = true;

  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/herdr.nix
    ../../home/tmux.nix
    ../../home/konsole.nix
    ../../home/emacs.nix
    ../../home/agent-skills.nix
    ../../home/fonts.nix
    ../../home/orca.nix
    ../../home/alacritty.nix
    ../../home/helix.nix
    ../../home/pi-harness.nix
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };

  home.packages = with pkgs; [
    # Fun
    inputs.helium.packages.${system}.default
    spotify
    vesktop
    telegram-desktop

    # Programming
    gh
    tldr
    zed-editor
    opencode
    go
    nil
    nixd
    postman

    # Utils
    libreoffice-still
    obsidian
    kdePackages.okular
    calibre
    gimp
    thunderbird
  ];

  programs.home-manager.enable = true;

  programs.fish.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@olinda";
  };
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@olinda";
  };
}

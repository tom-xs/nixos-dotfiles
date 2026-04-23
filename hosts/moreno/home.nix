{ pkgs, lib, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "26.05";

  targets.genericLinux.enable = true;

  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
    ../../home/konsole.nix
    ../../home/emacs.nix
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@moreno";
  };
}

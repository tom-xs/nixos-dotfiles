{ pkgs, lib, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "25.11";

  home.sessionPath = [ "/home/tomasxs/.local/bin" ];

  targets.genericLinux.enable = true;

  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
    ../../home/kitty.nix
    ../../home/emacs.nix
  ];

  programs.git = {
    enable = true;
    settings.user = {
      Name = "Tomas Xavier Santos";
      Email = "tom.xaviersantos@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@recife";
  };
}

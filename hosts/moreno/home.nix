{ pkgs, lib, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "25.11";

  # 1. Enable Non-NixOS Compatibility
  targets.genericLinux.enable = true;

  # 2. Import configs
  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
    ../../home/konsole.nix
  ];

  # 3. Git Config
  programs.git = {
    enable = true;
    settings.user = {
      Name = "Tomas Xavier Santos";
      Email = "tom.xaviersantos@gmail.com";
    };
  };

  # 4. Enable Home Manager
  programs.home-manager.enable = true;

  # 5. Overrides
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@moreno";
  };
}

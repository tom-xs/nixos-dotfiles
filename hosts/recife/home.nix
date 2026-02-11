{ pkgs, lib, ... }:

{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "25.11";

  home.sessionPath = [ "/home/tomasxs/.local/bin" ];

  home.packages = with pkgs; [
    beam.packages.erlang.elixir
    inotify-tools

    go
    nil
    nixd
    zed-editor
    github-copilot-cli
  ];

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
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@recife --impure";
  };

  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    userSettings = {
      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };
  };
}

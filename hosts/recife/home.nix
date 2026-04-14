{ pkgs, lib, ... }:

let
  nixpkgs-local = fetchGit {
    url = "/home/tomasxs/Projects/nixpkgs/";
    ref = "appium-update";
  };
  pkgs-local = import nixpkgs-local {
    system = builtins.currentSystem;
    config.allowUnfree = true;
  };
in
{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    ANDROID_HOME = "/usr/lib/android-sdk";
  };

  home.sessionPath = [
    "/home/tomasxs/.local/bin"
    "/opt/android-studio/bin"
    "/usr/lib/android-sdk/platform-tools"
    "/usr/lib/android-sdk/tools/bin"
  ];

  home.packages = with pkgs; [
    nodejs_22
    beam.packages.erlang.elixir
    inotify-tools

    go
    nil
    nixd
    zed-editor
    github-copilot-cli
    chromium
    pkgs-local.appium
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

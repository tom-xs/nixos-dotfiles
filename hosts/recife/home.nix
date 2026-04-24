{
  config,
  pkgs,
  lib,
  ...
}:

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
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "/opt/android-studio/bin"
    "${config.home.homeDirectory}/Android/Sdk/platform-tools"
    "${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin"
  ];

  home.packages = with pkgs; [
    nordic
    utterly-nord-plasma

    nodejs_22
    beam.packages.erlang.elixir
    inotify-tools

    go
    nil
    nixd
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
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  programs.fish.shellAliases = {
    # Needed while pkgs-local.appium comes from a local fetchGit source.
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@recife --impure";
  };
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

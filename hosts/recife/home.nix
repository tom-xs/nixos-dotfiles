{
  config,
  pkgs,
  lib,
  ...
}:

let

  #nixpkgs-local = fetchGit {
  #  url = "/home/tomasxs/Projects/nixpkgs/";
  #  ref = "appium-update";
  #};
  pkgs-local =
    # nixpkgs-local \
    import {
      system = builtins.currentSystem;
      config.allowUnfree = true;
    };
in
{
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";
  home.stateVersion = "26.11";

  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
    "/opt/android-studio/bin"
    "${config.home.homeDirectory}/Android/Sdk/platform-tools"
    "${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin"
  ];

  home.packages = with pkgs; [
    # Fun
    telegram-desktop
    vesktop
    steam

    # Programming
    beam.packages.erlang.elixir
    inotify-tools
    go
    nil
    nixd
    opencode
    chromium
    bootdev-cli
    gh

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only

    #pkgs-local.appium
  ];

  targets.genericLinux.enable = true;

  imports = [
    ../../home/hyprland-minimal.nix
    ../../home/hyprland.nix
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
    ../../home/herdr.nix
    ../../home/kitty.nix
  ];

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tomas Xavier Santos";
      email = "tom.xaviersantos@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  programs.fish.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@recife --impure";
  };
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@recife --impure";
  };

}

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

  # Android development environment: expose SDK vars and tool paths
  # (platform-tools, cmdline-tools, Android Studio) on PATH.
  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/pi-node/node-v22.23.2-linux-x64/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
    "/opt/android-studio/bin"
    "${config.home.homeDirectory}/Android/Sdk/platform-tools"
    "${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin"
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
    ../../home/llama.nix
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
    zotero
    calibre
    gimp
    thunderbird
    # lokus
  ];

  programs.home-manager.enable = true;

  # `update` aliases per-shell. `--impure` is required for the fish
  # flake eval, and bash additionally re-links the GPU driver after a
  # non-NixOS switch.
  programs.fish.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@moreno --impure";
  };
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch -b backup --flake ~/nixos-dotfiles#tomasxs@moreno && sudo /usr/local/bin/opengl-driver-link.sh";
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Change this if your WSL username is different
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";

  home.stateVersion = "26.05";

  # 1. Enable Non-NixOS Compatibility (Required for WSL)
  targets.genericLinux.enable = true;

  # 2. Import your shared modules
  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
  ];
  _module.args.neovimNodeTooling = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
    "/opt/android-studio/bin"
  ];

  home.packages = with pkgs; [
    # wslu # WSL Utilities (wslview, wslact, etc.)
    wget
    curl

    go
    gh
  ];

  # 4. Git Config
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Tomas Xavier Santos";
        email = "tom.xaviersantos@gmail.com";
      };
      init.defaultBranch = "master";
      # Optional: Use Windows Credential Manager
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe";
    };
  };

  # 5. Enable Home Manager
  programs.home-manager.enable = true;

  # 6. Update Alias
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch --flake ~/nixos-dotfiles#tomasxs@wsl";
  };
}

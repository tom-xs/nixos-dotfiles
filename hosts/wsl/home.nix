{ pkgs, lib, ... }:

{
  # Change this if your WSL username is different
  home.username = "tomasxs";
  home.homeDirectory = "/home/tomasxs";

  home.stateVersion = "25.11";

  # 1. Enable Non-NixOS Compatibility (Required for WSL)
  targets.genericLinux.enable = true;

  # 2. Import your shared modules
  imports = [
    ../../home/neovim.nix
    ../../home/shell.nix
    ../../home/tmux.nix
  ];

  # 3. WSL Specific Packages (Optional)
  home.packages = with pkgs; [
    wslu # WSL Utilities (wslview, wslact, etc.)
    wget
    curl
  ];

  # 4. Git Config
  programs.git = {
    enable = true;
    settings.user = {
      Name = "Tomas Xavier Santos";
      Email = "tom.xaviersantos@gmail.com";
    };
    # Optional: Use Windows Credential Manager
    extraConfig.credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe";
  };

  # 5. Enable Home Manager
  programs.home-manager.enable = true;

  # 6. Update Alias
  programs.bash.shellAliases = {
    update = lib.mkForce "home-manager switch --flake ~/nixos-dotfiles#tomasxs@wsl";
  };
}

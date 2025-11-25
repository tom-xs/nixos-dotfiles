{ pkgs, ... }:

{
  # --- Starship Prompt ---
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # --- Bash Configuration ---
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Aliases
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .#camaragibe";
      gc = "nix-collect-garbage --delete-old";
    };
  };

  # --- Modern Tools ---

  # Eza (Better ls)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
  };

  # Zoxide (Better cd)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ]; # Replace cd with zoxide
  };

  # Bat (Better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  # FZF (Fuzzy Finder - Optional but recommended)
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}

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

  # --- Fish Shell Configuration ---
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      gc = "nix-collect-garbage --delete-old";
    };

    interactiveShellInit = ''
      set fish_greeting # Disable the default fish greeting
    '';
  };

  # --- Bash Configuration (Kept for compatibility) ---
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Eza (Better ls)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    icons = "auto";
  };

  # Zoxide (Better cd)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  # Bat (Better cat)
  programs.bat = {
    enable = true;
  };

  # FZF (Fuzzy Finder)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}

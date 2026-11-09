{ themeVariant, ... }:
let
  colors = import ../lib/everforest.nix { inherit themeVariant; };
in
{
  # On non-NixOS hosts, GPU drivers for Nix apps come from the
  # `non-nixos-gpu-setup` step (printed by home-manager switch), so no nixGL
  # wrapper is needed here.
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        size = 14;
      };

      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 1.0;
      };

      scrolling.history = 10000;

      cursor.style = {
        shape = "Block";
        blinking = "Off";
      };

      selection.save_to_clipboard = true;

      colors = {
        primary = {
          background = colors.bg0;
          foreground = colors.fg;
        };
        normal = {
          black = colors.bg1;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.mauve;
          cyan = colors.teal;
          white = colors.fg1;
        };
        bright = {
          black = colors.bg4;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.mauve;
          cyan = colors.teal;
          white = colors.fg;
        };
      };
    };
  };

  # Make alacritty the default terminal for $TERMINAL and xdg-terminal-exec.
  home.sessionVariables.TERMINAL = "alacritty";
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "Alacritty.desktop" ];
  };
}

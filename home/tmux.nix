{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # 1. Core Settings
    shell = "${pkgs.bash}/bin/bash";
    terminal = "screen-256color";
    historyLimit = 100000;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;

    # 2. Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];

    # 3. Extra Config
    extraConfig = ''
      # --- Core Bindings ---
      # Better Splitting (Keep current path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Navigation (Alt + Keys) ---
      # 1. Arrow Keys
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # 2. Vim Keys
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # --- THEME & LAYOUT (Everforest Light) ---
      # 1. Bar Position: Top (Separates bar from prompt)
      set -g status-position bottom
      set -g status-justify left

      # 2. Bar Style: Distinct background for separation
      # bg=#efebd4 is a soft cream color from the theme
      set -g status-style 'bg=#efebd4 fg=#5c6a72'

      # 3. Window Tabs
      set -g window-status-format ' #I:#W '
      set -g window-status-current-format ' #I:#W '
      # Active window gets the Green accent
      set -g window-status-current-style 'bg=#a7c080 fg=#2d353b bold'

      # 4. Pane Borders (The lines between panels)
      set -g pane-border-style 'fg=#d3c6aa'        # Inactive borders (Grey)
      set -g pane-active-border-style 'fg=#a7c080' # Active border (Green)

      # 5. Right Side Info (Date/Time)
      set -g status-right '#[fg=#5c6a72] %Y-%m-%d %H:%M '
      set -g status-left ' '
    '';
  };
}

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
      yank
    ];

    # 3. Extra Config
    extraConfig = ''
      # --- Split bindings ---
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Smart Pane Switching (Alt+h/j/k/l) ---
      # This allows seamless navigation between Vim and Tmux using Alt

      # Logic to check if the current pane is running Vim
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      # Bind Alt+h/j/k/l
      bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
      bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
      bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
      bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

      # Bind Alt+Arrows
      bind-key -n 'M-Left'  if-shell "$is_vim" 'send-keys M-Left'  'select-pane -L'
      bind-key -n 'M-Down'  if-shell "$is_vim" 'send-keys M-Down'  'select-pane -D'
      bind-key -n 'M-Up'    if-shell "$is_vim" 'send-keys M-Up'    'select-pane -U'
      bind-key -n 'M-Right' if-shell "$is_vim" 'send-keys M-Right' 'select-pane -R'

      # --- Theme & Layout ---
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=#efebd4 fg=#5c6a72'
      set -g window-status-format ' #I:#W '
      set -g window-status-current-format ' #I:#W '
      set -g window-status-current-style 'bg=#a7c080 fg=#2d353b bold'
      set -g pane-border-style 'fg=#d3c6aa'
      set -g pane-active-border-style 'fg=#a7c080'
      set -g status-right '#[fg=#5c6a72] %Y-%m-%d %H:%M '
      set -g status-left ' '
    '';
  };
}

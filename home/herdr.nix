{ pkgs, themeVariant, herdr, ... }:

let
  # Define Color Palettes (Everforest)
  colors =
    if themeVariant == "dark" then
      {
        # Dark Hard
        panel_bg = "#2d353b";
        accent = "#a7c080";
        green = "#a7c080";
        blue = "#7fbbb3";
        red = "#e67e80";
        yellow = "#dbbc7f";
        text = "#d3c6aa";
        surface0 = "#272e33";
      }
    else
      {
        # Light Hard
        panel_bg = "#efebd4";
        accent = "#a7c080";
        green = "#a7c080";
        blue = "#7fbbb3";
        red = "#e67e80";
        yellow = "#dbbc7f";
        text = "#5c6a72";
        surface0 = "#fffbef";
      };

  # Generate TOML config
  configToml = ''
    onboarding = false

    [terminal]
    # Default to user's login shell
    shell_mode = "auto"

    [keys]
    # Match tmux prefix (C-a)
    prefix = "ctrl+a"

    # Pane navigation (matching tmux习惯)
    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"

    # Tab navigation
    new_tab = "prefix+c"
    next_tab = "prefix+n"
    previous_tab = "prefix+p"
    close_tab = "prefix+shift+x"
    rename_tab = "prefix+shift+t"

    # Workspace navigation
    new_workspace = "prefix+shift+n"
    close_workspace = "prefix+shift+d"
    rename_workspace = "prefix+shift+w"
    workspace_picker = "prefix+w"

    # Split panes (matching tmux习惯)
    split_vertical = "prefix+pipe"
    split_horizontal = "prefix+minus"

    # Pane management
    close_pane = "prefix+x"
    zoom = "prefix+z"
    edit_scrollback = "prefix+e"
    copy_mode = "prefix+["

    # Reload config
    reload_config = "prefix+shift+r"

    # Sidebar
    toggle_sidebar = "prefix+b"

    # Resize mode
    resize_mode = "prefix+r"

    [theme]
    name = "terminal"

    [theme.custom]
    panel_bg = "${colors.panel_bg}"
    accent = "${colors.accent}"
    green = "${colors.green}"
    blue = "${colors.blue}"
    red = "${colors.red}"
    yellow = "${colors.yellow}"
    text = "${colors.text}"
    surface0 = "${colors.surface0}"

    [ui]
    pane_borders = true
    pane_gaps = true
    copy_on_select = true
    confirm_close = true

    [ui.toast]
    delivery = "herdr"
    delay_seconds = 1

    [ui.toast.herdr]
    position = "bottom-right"

    [worktrees]
    directory = "~/.herdr/worktrees"

    [remote]
    manage_ssh_config = true
  '';
in
{
  # Install herdr package
  home.packages = [ herdr ];

  # Create config directory and config file
  xdg.configFile."herdr/config.toml".text = configToml;
}

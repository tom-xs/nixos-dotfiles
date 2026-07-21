{
  pkgs,
  themeVariant,
  herdr,
  ...
}:

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
        subtext0 = "#a6acae";
        surface1 = "#343f44";
        surface_dim = "#232a2e";
        overlay0 = "#56635f";
        overlay1 = "#6d7f8b";
        mauve = "#d699b6";
        teal = "#7fbbb3";
        peach = "#ed9366";
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
        subtext0 = "#708089";
        surface1 = "#e3e0d1";
        surface_dim = "#e8e4d9";
        overlay0 = "#9aa9a0";
        overlay1 = "#8c9fa0";
        mauve = "#b57edb";
        teal = "#3da5a0";
        peach = "#e67e80";
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

    # Pane navigation
    focus_pane_left = ["prefix+h", "alt+h", "alt+left"]
    focus_pane_down = ["prefix+j", "alt+j", "alt+down"]
    focus_pane_up = ["prefix+k", "alt+k", "alt+up"]
    focus_pane_right = ["prefix+l", "alt+l", "alt+right"]

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
    previous_workspace = "prefix+shift+tab"
    next_workspace = "prefix+tab"

    # Agent navigation
    previous_agent = "prefix+shift+p"
    next_agent = "prefix+shift+o"
    focus_agent = "prefix+alt+1..9"

    # Split panes 
    split_vertical = "prefix+v"
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
    subtext0 = "${colors.subtext0}"
    surface1 = "${colors.surface1}"
    surface_dim = "${colors.surface_dim}"
    overlay0 = "${colors.overlay0}"
    overlay1 = "${colors.overlay1}"
    mauve = "${colors.mauve}"
    teal = "${colors.teal}"
    peach = "${colors.peach}"

    [ui]
    pane_borders = true
    pane_gaps = true
    copy_on_select = true
    confirm_close = true
    sidebar_width = 35
    sidebar_max_width = 42

    [ui.sidebar.agents]
    rows = [["state_icon", "workspace", "tab"]]

    [ui.sidebar.spaces]
    rows = [["state_icon", "workspace", "branch"]]

    [ui.toast]
    delivery = "herdr"
    delay_seconds = 1

    [ui.toast.herdr]
    position = "bottom-right"

    [worktrees]
    directory = "~/.herdr/worktrees"

    [remote]
    manage_ssh_config = true

    [experimental]
    pane_history = true
  '';
in
{
  # Install herdr package
  home.packages = [ herdr ];

  # Create config directory and config file
  xdg.configFile."herdr/config.toml".text = configToml;
}

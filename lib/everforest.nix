# Shared Everforest color palette used by home-manager modules.
{ themeVariant }:

if themeVariant == "dark" then
  {
    # Base
    bg0 = "#2d353b";
    bg1 = "#343f44";
    bg2 = "#3d484d";
    bg3 = "#475258";
    bg4 = "#56635f";
    fg = "#d3c6aa";
    fg0 = "#d3c6aa";
    fg1 = "#a6acae";

    # Accents
    green = "#a7c080";
    blue = "#7fbbb3";
    red = "#e67e80";
    yellow = "#dbbc7f";
    mauve = "#d699b6";
    teal = "#7fbbb3";
    peach = "#ed9366";

    # tmux aliases
    status_bg = "#2d353b";
    status_fg = "#d3c6aa";
    window_bg = "#272e33";
    active_bg = "#a7c080";
    active_fg = "#272e33";
    border_inactive = "#475258";
    border_active = "#a7c080";

    # herdr aliases
    panel_bg = "#2d353b";
    text = "#d3c6aa";
    surface0 = "#272e33";
    subtext0 = "#a6acae";
    surface1 = "#343f44";
    surface_dim = "#232a2e";
    overlay0 = "#56635f";
    overlay1 = "#6d7f8b";
  }
else
  {
    # Base
    bg0 = "#efebd4";
    bg1 = "#e3e0d1";
    bg2 = "#d8d5c7";
    bg3 = "#d3c6aa";
    bg4 = "#9aa9a0";
    fg = "#5c6a72";
    fg0 = "#5c6a72";
    fg1 = "#708089";

    # Accents
    green = "#a7c080";
    blue = "#7fbbb3";
    red = "#e67e80";
    yellow = "#dbbc7f";
    mauve = "#b57edb";
    teal = "#3da5a0";
    peach = "#e67e80";

    # tmux aliases
    status_bg = "#efebd4";
    status_fg = "#5c6a72";
    window_bg = "#fffbef";
    active_bg = "#a7c080";
    active_fg = "#2d353b";
    border_inactive = "#d3c6aa";
    border_active = "#a7c080";

    # herdr aliases
    panel_bg = "#efebd4";
    text = "#5c6a72";
    surface0 = "#fffbef";
    subtext0 = "#708089";
    surface1 = "#e3e0d1";
    surface_dim = "#e8e4d9";
    overlay0 = "#9aa9a0";
    overlay1 = "#8c9fa0";
  }

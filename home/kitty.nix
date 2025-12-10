{ themeVariant, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = if themeVariant == "light" then "everforest_light_hard" else "everforest_dark_hard";
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
      disable_ligatures = "always";
    };
    font = {
      name = "JetBrains Mono NerdFont";
      size = 12;
    };
  };
}

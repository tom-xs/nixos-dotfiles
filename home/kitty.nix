{ ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "everforest_light_hard";
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
    };
    font = {
      name = "JetBrains Mono NerdFont";
      size = 12;
    };
  };
}

{
  pkgs,
  themeVariant,
  config,
  ...
}:
let
  isGeneric = config.targets.genericLinux.enable;

  kittyWrapped = pkgs.writeShellScriptBin "kitty" ''
    exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
  '';
in
{
  programs.kitty = {
    enable = true;
    # Conditionally use the wrapper
    package = if isGeneric then kittyWrapped else pkgs.kitty;
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

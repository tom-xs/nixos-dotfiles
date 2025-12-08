{ pkgs, ... }:

{
  programs.konsole = {
    enable = true;
    defaultProfile = "MyProfile";

    profiles = {
      "MyProfile" = {
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 12;
        };
        # Using a built-in standard or valid name.
        # If you need a custom colorscheme file, you'd use 'extraConfig' or 'customColorSchemes'.
        colorScheme = "Breeze";
      };
    };
  };
}

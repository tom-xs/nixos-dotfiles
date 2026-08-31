{
  pkgs,
  lib,
  themeVariant,
  ...
}:

let
  # Reusable hex->RGB helper and the shared Everforest palettes.
  # Colorschemes are generated from these so they stay in sync with
  # the rest of the theme instead of duplicating hardcoded values.
  hex = import ../lib/hex.nix { inherit lib; };
  darkColors = import ../lib/everforest.nix { themeVariant = "dark"; };
  lightColors = import ../lib/everforest.nix { themeVariant = "light"; };

  # Render a Konsole .colorscheme from a palette. black/white map the
  # ANSI Color0/Color7 slots (dim black + bright foreground) since these
  # are not part of the Everforest base palette.
  mkColorscheme =
    {
      name,
      colors,
      black,
      white,
    }:
    ''
      [General]
      Description=${name}
      Opacity=1

      [Background]
      Color=${hex.hexToRgb colors.bg0}
      [BackgroundIntense]
      Color=${hex.hexToRgb colors.bg0}

      [Foreground]
      Color=${hex.hexToRgb colors.fg}
      [ForegroundIntense]
      Color=${hex.hexToRgb colors.fg}

      [Color0]
      Color=${hex.hexToRgb black}
      [Color0Intense]
      Color=${hex.hexToRgb black}

      [Color1]
      Color=${hex.hexToRgb colors.red}
      [Color1Intense]
      Color=${hex.hexToRgb colors.red}

      [Color2]
      Color=${hex.hexToRgb colors.green}
      [Color2Intense]
      Color=${hex.hexToRgb colors.green}

      [Color3]
      Color=${hex.hexToRgb colors.yellow}
      [Color3Intense]
      Color=${hex.hexToRgb colors.yellow}

      [Color4]
      Color=${hex.hexToRgb colors.blue}
      [Color4Intense]
      Color=${hex.hexToRgb colors.blue}

      [Color5]
      Color=${hex.hexToRgb colors.mauve}
      [Color5Intense]
      Color=${hex.hexToRgb colors.mauve}

      [Color6]
      Color=${hex.hexToRgb colors.teal}
      [Color6Intense]
      Color=${hex.hexToRgb colors.teal}

      [Color7]
      Color=${hex.hexToRgb white}
      [Color7Intense]
      Color=${hex.hexToRgb white}
    '';
in
{
  home.packages = [ pkgs.kdePackages.konsole ];

  xdg.dataFile."konsole/MyProfile.profile".text = ''
    [General]
    Name=MyProfile
    Parent=FALLBACK/

    [Appearance]
    ColorScheme=Everforest${if themeVariant == "dark" then "Dark" else "Light"}
    Font=JetBrainsMono Nerd Font,12,-1,5,50,0,0,0,0,0

    [Scrolling]
    HistoryMode=2
    ScrollBarPosition=1
  '';

  xdg.dataFile."konsole/EverforestDark.colorscheme".text = mkColorscheme {
    name = "Everforest Dark Hard";
    colors = darkColors;
    black = darkColors.bg3;
    white = darkColors.fg;
  };

  xdg.dataFile."konsole/EverforestLight.colorscheme".text = mkColorscheme {
    name = "Everforest Light Hard";
    colors = lightColors;
    black = lightColors.fg;
    white = lightColors.bg0;
  };
}

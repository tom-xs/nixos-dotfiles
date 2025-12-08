{ pkgs, themeVariant, ... }:

{
  # 1. Ensure Konsole is installed
  home.packages = [ pkgs.kdePackages.konsole ];

  # 2. Set the default profile in konsolerc
  xdg.configFile."konsolerc".text = ''
    [Desktop Entry]
    DefaultProfile=MyProfile.profile

    [TabBar]
    ShowTabBar=true
  '';

  # 3. Create the actual profile file
  # Selects EverforestDark or EverforestLight based on themeVariant
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

  # 4. Everforest Dark Hard (Pastel/Warm)
  xdg.dataFile."konsole/EverforestDark.colorscheme".text = ''
    [General]
    Description=Everforest Dark Hard
    Opacity=1

    [Background]
    Color=39,46,51

    [BackgroundIntense]
    Color=39,46,51

    [Foreground]
    Color=211,198,170

    [ForegroundIntense]
    Color=211,198,170

    # --- Pastel ANSI Colors ---
    [Color0] # Black
    Color=75,86,92
    [Color0Intense]
    Color=75,86,92

    [Color1] # Red (Pastel)
    Color=230,126,128
    [Color1Intense]
    Color=230,126,128

    [Color2] # Green (Pastel)
    Color=167,192,128
    [Color2Intense]
    Color=167,192,128

    [Color3] # Yellow (Pastel)
    Color=219,188,127
    [Color3Intense]
    Color=219,188,127

    [Color4] # Blue (Pastel)
    Color=127,187,179
    [Color4Intense]
    Color=127,187,179

    [Color5] # Magenta (Pastel)
    Color=214,153,182
    [Color5Intense]
    Color=214,153,182

    [Color6] # Cyan (Pastel)
    Color=131,192,146
    [Color6Intense]
    Color=131,192,146

    [Color7] # White
    Color=211,198,170
    [Color7Intense]
    Color=211,198,170
  '';

  # 5. Everforest Light Hard (Pastel/Warm)
  xdg.dataFile."konsole/EverforestLight.colorscheme".text = ''
    [General]
    Description=Everforest Light Hard
    Opacity=1

    # Warm off-white background (Not pure white)
    [Background]
    Color=255,251,239
    [BackgroundIntense]
    Color=255,251,239

    # Soft dark grey foreground
    [Foreground]
    Color=92,106,114
    [ForegroundIntense]
    Color=92,106,114

    # --- Pastel ANSI Colors ---
    [Color0] # Black
    Color=92,106,114
    [Color0Intense]
    Color=76,79,105

    [Color1] # Red
    Color=248,85,82
    [Color1Intense]
    Color=248,85,82

    [Color2] # Green
    Color=141,161,1,
    [Color2Intense]
    Color=141,161,1

    [Color3] # Yellow
    Color=223,160,0
    [Color3Intense]
    Color=223,160,0

    [Color4] # Blue
    Color=58,148,197
    [Color4Intense]
    Color=58,148,197

    [Color5] # Magenta
    Color=223,105,186
    [Color5Intense]
    Color=223,105,186

    [Color6] # Cyan
    Color=53,167,124
    [Color6Intense]
    Color=53,167,124

    [Color7] # White
    Color=223,221,194
    [Color7Intense]
    Color=223,221,194
  '';
}

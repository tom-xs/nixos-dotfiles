{ pkgs, ... }:

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
  # Konsole looks for profiles in ~/.local/share/konsole/
  xdg.dataFile."konsole/MyProfile.profile".text = ''
    [General]
    Name=MyProfile
    Parent=FALLBACK/

    [Appearance]
    # You can change this to "BlackOnWhite", "Dracula", etc. if installed
    ColorScheme=Breeze 
    Font=JetBrainsMono Nerd Font,12,-1,5,50,0,0,0,0,0

    [Scrolling]
    HistoryMode=2
    ScrollBarPosition=1
  '';
}

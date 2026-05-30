{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.sauce-code-pro
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.departure-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans"
      "Noto Sans CJK JP"
      "Noto Sans CJK SC"
      "Noto Sans CJK TC"
      "Noto Sans CJK KR"
    ];
    serif = [
      "Noto Serif"
      "Noto Serif CJK JP"
      "Noto Serif CJK SC"
      "Noto Serif CJK TC"
      "Noto Serif CJK KR"
    ];
    monospace = [
      "JetBrains Mono Nerd Font"
      "Noto Sans Mono CJK JP"
      "Noto Sans Mono CJK SC"
      "Noto Sans Mono CJK TC"
      "Noto Sans Mono CJK KR"
    ];
    emoji = [ "Noto Color Emoji" ];
  };
}

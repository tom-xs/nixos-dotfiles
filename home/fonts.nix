{ pkgs, ... }:

# Central font configuration: installs a curated set of families
# (Nerd Fonts for icons, Noto for CJK/emoji coverage) and sets the
# default sans/serif/monospace/emoji via fontconfig aliases.
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
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

  xdg.configFile."fontconfig/conf.d/99-default-fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans</family>
          <family>Noto Sans CJK JP</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Sans CJK TC</family>
          <family>Noto Sans CJK KR</family>
        </prefer>
      </alias>
      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif</family>
          <family>Noto Serif CJK JP</family>
          <family>Noto Serif CJK SC</family>
          <family>Noto Serif CJK TC</family>
          <family>Noto Serif CJK KR</family>
        </prefer>
      </alias>
      <alias>
        <family>monospace</family>
        <prefer>
          <family>JetBrains Mono Nerd Font</family>
          <family>Noto Sans Mono CJK JP</family>
          <family>Noto Sans Mono CJK SC</family>
          <family>Noto Sans Mono CJK TC</family>
          <family>Noto Sans Mono CJK KR</family>
        </prefer>
      </alias>
      <alias>
        <family>emoji</family>
        <prefer>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
    </fontconfig>
  '';
}

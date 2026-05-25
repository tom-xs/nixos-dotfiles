
{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.sauce-code-pro
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.departure-mono
  ];
}

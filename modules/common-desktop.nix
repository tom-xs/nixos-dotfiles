{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;[ firefox wofi kitty pavucontrol networkmanagerapplet];

  # Sound (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.sauce-code-pro
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
  ];
}

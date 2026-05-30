{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables = {
    MESA_SHADER_CACHE_DIR = "$HOME/.cache/mesa";
    MESA_SHADER_CACHE_MAX_SIZE = "10G";
    DXVK_STATE_CACHE = "1";
    DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.cache/nv-shaders";
  };

  environment.systemPackages = with pkgs; [
    # lutris
    prismlauncher
    mangohud
  ];

  # Disable PS5 controller touchpad from behaving like a mouse
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}

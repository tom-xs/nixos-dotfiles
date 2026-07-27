{
  config,
  lib,
  ...
}:
{
  # Bootloader cleanup: keep at most 5 generations
  boot.loader.systemd-boot.configurationLimit = lib.mkIf config.boot.loader.systemd-boot.enable 5;
  boot.loader.grub.configurationLimit = lib.mkIf config.boot.loader.grub.enable 5;

  # Storage Optimization
  nix.settings.auto-optimise-store = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

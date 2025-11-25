{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 1. Bootloader Cleanup (Requested)
  # Limit valid boot entries to 10 to keep the menu clean
  boot.loader.systemd-boot.configurationLimit = 5;

  # 2. Storage Optimization
  nix.settings.auto-optimise-store = true;

  # 3. Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

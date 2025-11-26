{ pkgs, ... }:

{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # System modules
    ../../modules/nvidia.nix
    ../../modules/maintenance.nix
    ../../modules/gaming.nix
    ../../modules/common-desktop.nix

    # Windows Manager
    ../../modules/hyprland.nix
  ];

  # Bootloader
  boot.loader = {
    grub.enable = true;
    grub.device = "nodev";
    grub.efiSupport = true;
    grub.extraEntries = ''
        menuentry "Nobara" --class fedora --class os {
      		insmod part_gpt
      		insmod ext2
      		insmod fat
      		search --no-floppy --fs-uuid --set=root 2FED-459B
      		chainloader /EFI/fedora/grubx64.efi
        }
    '';
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "camaragibe";

  # Set your time zone.
  time.timeZone = "America/Recife";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account.
  users.users.tomasxs = {
    isNormalUser = true;
    description = "Tomas Xavier Santos";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Adds "backup" and save current dotfiles, see:https://nix-community.github.io/home-manager/nixos-options.xhtml
  home-manager.backupFileExtension = "backup";

  # System
  system.stateVersion = "25.05";
}

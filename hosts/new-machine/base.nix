{ pkgs, ... }:

{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # Shared system modules
    ../../modules/maintenance.nix
    ../../modules/common-desktop.nix
  ];

  # Bootloader
  boot.loader = {
    grub.enable = true;
    grub.device = "nodev";
    grub.efiSupport = true;
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
  };

  # Display Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };

  # Network
  networking.networkmanager.enable = true;
  networking.hostName = "new-machine";

  # Locale and time
  time.timeZone = "America/Recife";
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

  # Keyboard
  services.xserver.xkb = {
    layout = "br";
    variant = "";
    options = "ctrl:nocaps";
  };
  console.keyMap = "br-abnt2";

  # User
  users.users.tomasxs = {
    isNormalUser = true;
    description = "Tomas Xavier Santos";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Nix
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Extras
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.05";
}

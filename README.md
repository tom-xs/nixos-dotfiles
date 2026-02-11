# NixOS Dotfiles

A declarative configuration management system for Linux environments using Nix and Home Manager.

## Overview

This repository manages system and user configurations across multiple machines using Nix, a declarative package manager. It provides reproducible, version-controlled configurations for desktop and server environments.

## Machines

- **camaragibe**: Full NixOS desktop system with Hyprland wayland compositor, NVIDIA GPU support, gaming tools, and desktop applications
- **moreno**: Home Manager configuration for non-NixOS Linux systems, focused on development tools
- **recife**: Standalone Home Manager configuration for a secondary Linux machine
- **wsl**: Windows Subsystem for Linux configuration with minimal development tools

## Structure

```
.
├── flake.nix              # Flake configuration and inputs
├── flake.lock             # Locked versions of all dependencies
├── hosts/                 # Machine-specific configurations
│   ├── camaragibe/        # Full NixOS system configuration
│   ├── moreno/            # Home Manager only
│   ├── recife/            # Home Manager only
│   └── wsl/               # WSL Home Manager configuration
├── home/                  # User-level configurations (imported by hosts)
│   ├── home.nix           # Main home configuration (camaragibe)
│   ├── hyprland.nix       # Hyprland compositor settings
│   ├── waybar.nix         # System bar configuration
│   ├── neovim.nix         # Neovim editor configuration
│   ├── shell.nix          # Shell configuration
│   ├── kitty.nix          # Kitty terminal configuration
│   ├── tmux.nix           # Tmux multiplexer configuration
│   ├── konsole.nix        # KDE Konsole configuration
│   └── emacs.nix          # Emacs configuration
└── modules/               # System-level modules (camaragibe only)
    ├── common-desktop.nix # Base desktop packages and audio setup
    ├── hyprland.nix       # Hyprland system packages
    ├── hyprland-minimal.nix
    ├── nvidia.nix         # NVIDIA GPU drivers and configuration
    ├── gaming.nix         # Gaming tools and launchers
    └── maintenance.nix    # System maintenance tools
```

## Key Technologies

**System Management**
- Nix: Declarative package manager
- NixOS: Linux distribution built on Nix
- Flakes: Modern Nix dependency management
- Home Manager: User environment configuration

**Desktop Environment (camaragibe)**
- Hyprland: Wayland compositor
- Waybar: System information bar
- SDDM: Display manager
- Dolphin: File manager
- Hyprpaper: Wallpaper management
- Hypridle: Idle session management

**Audio & Networking**
- Pipewire: Audio server
- ALSA: Audio subsystem
- NetworkManager: Network management

**Development Tools**
- Neovim: Text editor
- Zed Editor: Code editor
- Tmux: Terminal multiplexer
- Kitty: Terminal emulator
- Git: Version control

**Applications**
- Firefox: Web browser
- Obsidian: Note-taking
- Zotero: Research management
- GIMP: Image editor
- Vesktop: Discord client
- Telegram Desktop: Messaging

## Usage

### Camaragibe (Full NixOS)

Rebuild the system:
```bash
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#camaragibe
```

### Moreno (Home Manager only)

Switch to configuration:
```bash
home-manager switch --flake ~/nixos-dotfiles#tomasxs@moreno
```

Update and switch:
```bash
update
```

### Recife (Home Manager only)

Switch to configuration:
```bash
home-manager switch --flake ~/nixos-dotfiles#tomasxs@recife
```

### WSL (Home Manager only)

Switch to configuration:
```bash
home-manager switch --flake ~/nixos-dotfiles#tomasxs@wsl
```

## Hardware

- **Monitor 1**: HDMI-A-1, 1920x1080@74.97Hz
- **Monitor 2**: Panda FPD, 1920x1080@120.03Hz
- **GPU**: NVIDIA (with dedicated driver support)
- **Audio**: Pipewire with ALSA support

## Notes

- Bootloader: GRUB with EFI support and Fedora chainload entry
- Timezone: America/Recife
- All configurations use unstable nixpkgs with unfree packages enabled
- NixGL overlay is included for GPU-accelerated OpenGL support

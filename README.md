# NixOS Dotfiles

A declarative configuration management system for Linux environments using Nix and Home Manager.

## Overview

This repository manages system and user configurations across multiple machines using Nix, a declarative package manager. It provides reproducible, version-controlled configurations for desktop and server environments.

## Machines

- **camaragibe**: Full NixOS desktop (Hyprland, NVIDIA, desktop apps)
- **doha**: Full NixOS desktop (GNOME, NVIDIA, testing tools, Android Studio)
- **moreno**: Home Manager only, non-NixOS Linux, development tools
- **recife**: Standalone Home Manager, secondary Linux (Android dev, Elixir/Go)
- **wsl**: WSL Home Manager (Node.js, Go, Appium)

## Structure

```
.
├── flake.nix              # Flake entry point
├── hosts/                 # Machine-specific configurations
│   ├── camaragibe/        # Full NixOS (Hyprland + NVIDIA + gaming)
│   ├── doha/              # Full NixOS (GNOME + NVIDIA + testing)
│   ├── moreno/            # Home Manager only
│   ├── recife/            # Home Manager only (Android dev)
│   └── wsl/               # WSL Home Manager
├── home/                  # Shared Home Manager modules (imported by hosts)
│   ├── neovim.nix         # Neovim with LSP, Treesitter, conform
│   ├── shell.nix          # fish, starship, eza, zoxide, bat, fzf
│   ├── tmux.nix           # Tmux with Everforest theme
│   ├── kitty.nix          # Kitty terminal (nixGL on non-NixOS)
│   ├── konsole.nix        # KDE Konsole with Everforest themes
│   ├── hyprland.nix       # Hyprland user config
│   ├── waybar.nix         # Waybar status bar
│   └── emacs.nix          # Doom Emacs
└── modules/               # NixOS system modules (NixOS hosts only)
    ├── common-hyper-desktop.nix
    ├── hyprland.nix
    ├── hyprland-minimal.nix
    ├── nvidia.nix
    ├── gaming.nix
    ├── android.nix
    ├── fonts.nix
    ├── testing.nix
    └── maintenance.nix
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

### NixOS hosts (camaragibe, doha)

```bash
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<host>
```

### Home Manager only (moreno, recife, wsl)

```bash
home-manager switch --flake ~/nixos-dotfiles#tomasxs@<host>
```

Note: currently recife and wsl need `--impure` (local `fetchGit` source) to load appium package.

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

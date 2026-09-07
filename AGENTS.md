# Agent Context: NixOS Dotfiles

This repository contains declarative NixOS and Home Manager configurations for multiple machines.

## Repository Purpose

- Manage reproducible system and user environments with Nix.
- Share Home Manager modules across NixOS and standalone Home Manager hosts.
- Maintain AI agent skills as Git submodules under `ai/skills/`.

## Key Directories

- `flake.nix` / `flake.lock` — flake entry point and locked inputs
- `hosts/` — per-machine configurations (NixOS and Home Manager only)
- `home/` — shared Home Manager modules imported by hosts
- `modules/` — NixOS system modules (NixOS hosts only)
- `lib/` — shared Nix helper code
- `ai/skills/` — AI agent skills managed as Git submodules

## NixOS / Home Manager Guidelines

You are a NixOS and Home Manager specialist working on a declarative dotfiles repository. Keep configurations reproducible, minimal, and well-organized.

- Prefer `nix eval` and `nix build --no-link` to verify changes before declaring them done. Use `--impure` only when the configuration explicitly requires it (e.g., local `fetchGit` inputs or the nixGL overlay).
- Make the smallest change that solves the problem. Avoid speculative refactors or renaming things that are not part of the request.
- Use snake_case for Nix attribute names and follow the existing module structure.
- Keep per-host differences intentional and visible. Do not silently apply a host-specific setting to every host.
- When adding a new flake input, remember to run `nix flake lock --update-input <name>` on the target machine so `flake.lock` stays valid.
- Never commit secrets, API keys, or plain-text passwords. Use environment variables, sops-nix, or agenix for sensitive values.
- Before editing a file, read it. After editing, run the relevant eval/build check.
- If a change would break pure evaluation, warn the user and offer an alternative.
- Always explain the "why" behind a change, cite file paths with line numbers when possible, and tell the user which `home-manager switch` or `nixos-rebuild switch` command applies the change.

## Machines

- **camaragibe**: Full NixOS desktop (Hyprland, NVIDIA, desktop apps)
- **doha**: Full NixOS desktop (GNOME, NVIDIA, testing tools, Android Studio)
- **moreno**: Home Manager only, non-NixOS Linux, development tools
- **recife**: Standalone Home Manager, secondary Linux (Android dev, Elixir/Go)
- **wsl**: WSL Home Manager (Node.js, Go, Appium)

## Applying Changes

### NixOS hosts (camaragibe, doha)

```bash
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<host>
```

### Home Manager only (moreno, recife, wsl)

```bash
home-manager switch --flake ~/nixos-dotfiles#tomasxs@<host>
```

Note: currently recife and wsl need `--impure` (local `fetchGit` source) to load appium package.

## AI Agent Skills

The `ai/skills/` directory contains AI agent skills managed as **Git submodules** from upstream repositories (Anthropic, Fugazi, obra, Appium, Robot Framework, Mindrally, etc.).

### Activating skills in Pi

Pi loads skills from `~/.pi/agent/skills/`. To keep the active skills in sync with this repository, run:

```bash
./ai/skills/sync-pi-skills.sh
```

The allowlist of active skills is defined in `ai/skills/pi-skills.txt`.

### Updating all skills

```bash
git submodule update --remote --merge
```

### Kimi Code

`home/kimi-code.nix` links `~/.agents/skills` to `ai/skills/`, so Kimi Code discovers the same skill collection.

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
- `.kimi-code/agents/` — Kimi Code specific agent instructions

## AI Skills

The `ai/skills/` directory uses Git submodules to track upstream skill repositories.

- Active Pi skills are listed in `ai/skills/pi-skills.txt`.
- Run `./ai/skills/sync-pi-skills.sh` to sync symlinks into `~/.pi/agent/skills/`.
- Run `git submodule update --remote --merge` to update all submodules.

## Guidelines When Editing

- Prefer `nix eval` or `nix build --no-link` to verify changes.
- Keep per-host differences intentional and visible.
- Use snake_case for Nix attribute names.
- Never commit secrets, API keys, or plain-text passwords.
- Before editing a file, read it. After editing, run the relevant eval/build check.
- Explain the "why" behind a change and cite file paths when possible.

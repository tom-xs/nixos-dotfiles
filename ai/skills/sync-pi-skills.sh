#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_DIR="$REPO_DIR/ai/skills"
PI_SKILLS_DIR="${PI_SKILLS_DIR:-$HOME/.pi/agent/skills}"
CONFIG_FILE="${1:-$SKILLS_DIR/pi-skills.txt}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

mkdir -p "$PI_SKILLS_DIR"

# Backup existing symlinks
BACKUP_DIR="$PI_SKILLS_DIR/.backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
for link in "$PI_SKILLS_DIR"/*; do
  [ -e "$link" ] || continue
  if [ -L "$link" ]; then
    mv "$link" "$BACKUP_DIR/"
  fi
done

# Create new symlinks
while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  skill_path="$SKILLS_DIR/$line"
  skill_name=$(basename "$line")
  if [ -e "$skill_path" ]; then
    ln -s "$skill_path" "$PI_SKILLS_DIR/$skill_name"
    echo "Linked: $skill_name"
  else
    echo "Warning: not found - $skill_path" >&2
  fi
done < "$CONFIG_FILE"

echo "Synced skills to $PI_SKILLS_DIR"

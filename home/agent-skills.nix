{ ... }:

{
  # Links ~/.agents/skills to the shared AI skills directory.
  # This path is recognized by multiple AI agent harnesses (Kimi Code, Codex,
  # Claude Code, etc.) so they all discover the same skill collection.
  # The ai/skills/ directory contains Git submodules; run
  # ./ai/skills/sync-pi-skills.sh to update Pi's active skill symlinks.
  home.file.".agents/skills".source = ../ai/skills;
}

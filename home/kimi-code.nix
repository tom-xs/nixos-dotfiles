{
  kimi-code,
  ...
}:

{
  home.packages = [ kimi-code ];
  # Links ~/.agents/skills to the shared AI skills directory.
  # Note: ai/skills/ contains Git submodules with many skills;
  # Kimi Code will discover all SKILL.md files recursively.
  home.file.".agents/skills".source = ../ai/skills;
}

{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = false;

    extraPackages = with pkgs; [
      jdt-language-server
      jdk21
      nil
      gopls
      rust-analyzer
      lua-language-server
      bash-language-server
    ];

    settings = {
      theme = "everforest_dark";

      editor = {
        line-number = "relative";
      };
    };
  };
}

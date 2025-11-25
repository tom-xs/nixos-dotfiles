{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Plugins
    plugins = with pkgs.vimPlugins; [
      # Syntax Highlighting
      nvim-treesitter.withAllGrammars

      # UI
      lualine-nvim
      telescope-nvim

      # Theme
      catppuccin-nvim

      # Utilities
      nvim-web-devicons
      which-key-nvim
    ];

    # Basic Configuration (Lua)
    extraConfig = ''
      set number relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set clipboard=unnamedplus

      " Load Theme
      colorscheme catppuccin

      " Lualine Setup
      lua require('lualine').setup { options = { theme = 'catppuccin' } }

      " Telescope Binds
      nnoremap ff Telescope find_files
      nnoremap fg Telescope live_grep
    '';
  };
}

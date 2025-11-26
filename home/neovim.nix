{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. Essential tools & External Binaries
    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
      lazygit

      # -- Language Servers --
      lua-language-server
      nil
      nixd
      rust-analyzer
      python313Packages.python-lsp-server

      # -- Formatters --
      nixfmt
      stylua
      prettierd
      shfmt
      black
      rustfmt
    ];

    # 2. Plugins
    plugins = with pkgs.vimPlugins; [
      # -- Theme --
      everforest

      # -- UI Improvements --
      (pkgs.vimUtils.buildVimPlugin {
        name = "lualine-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "nvim-lualine";
          repo = "lualine.nvim";
          rev = "master";
          hash = "sha256-OpLZH+sL5cj2rcP5/T+jDOnuxd1QWLHCt2RzloffZOA=";
        };
      })
      indent-blankline-nvim
      nvim-web-devicons

      # -- Navigation & Tools --
      telescope-nvim
      plenary-nvim
      neo-tree-nvim
      nui-nvim
      which-key-nvim
      gitsigns-nvim
      todo-comments-nvim
      lazygit-nvim
      nvim-treesitter.withAllGrammars

      # -- QOL Plugins --
      nvim-autopairs
      nvim-surround
      vim-sleuth

      # -- LSP, Formatting & Completion --
      conform-nvim
      nvim-lspconfig

      # Completion Plugins
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets

      # New Additions for visuals/help
      lspkind-nvim # Icons in menu
      cmp-nvim-lsp-signature-help # Function arg popups
    ];

    # 3. Lua Configuration
    extraLuaConfig = ''
      -- ====================
      -- General Settings
      -- ====================
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
      vim.opt.clipboard = "unnamedplus"
      vim.opt.termguicolors = true
      vim.g.mapleader = " "

      -- Vertical Line & Scrolloff
      vim.opt.colorcolumn = "100"
      vim.opt.scrolloff = 10

      -- ====================
      -- Theme: Everforest
      -- ====================
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_better_performance = 1
      vim.g.everforest_ui_contrast = 'high'

      vim.o.background = 'light'
      vim.cmd('colorscheme everforest')

      -- ====================
      -- Plugin: Conform (Formatting)
      -- ====================
      require("conform").setup({
          formatters_by_ft = {
              lua = { "stylua" },
              nix = { "nixfmt" },
              javascript = { "prettierd" },
              typescript = { "prettierd" },
              css = { "prettierd" },
              html = { "prettierd" },
              json = { "prettierd" },
              sh = { "shfmt" },
              rust = { "rustfmt" },
              python = { "black" },
          },
          format_on_save = {
              timeout_ms = 500,
              lsp_fallback = true,
          },
      })

      -- ====================
      -- QOL Plugins Setup
      -- ====================
      require("nvim-autopairs").setup()
      require("nvim-surround").setup()
      require("gitsigns").setup()
      require("todo-comments").setup()
      require("ibl").setup()

      require('lualine').setup({
          options = { 
              theme = 'everforest',
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' }
          }
      })

      require("neo-tree").setup({
          close_if_last_window = true,
      })

      -- ====================
      -- Plugin: WhichKey & Keybindings
      -- ====================
      local wk = require("which-key")
      local builtin = require('telescope.builtin')

      wk.setup({
          preset = "modern",
      })

      wk.add({
          -- File Group
          { "<leader>f", group = "Find/Files" }, 
          { "<leader>ff", builtin.find_files, desc = "Find File" },
          { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
          { "<leader>fb", builtin.buffers, desc = "Find Buffer" },
          { "<leader>ft", ":TodoTelescope<CR>", desc = "Find Todos" },
          { "<leader>fn", ":enew<CR>", desc = "New File" },

          -- Code Group
          { "<leader>c", group = "Code" },
          { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format File" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Variable" },
          { "<leader>cd", vim.lsp.buf.definition, desc = "Go to Definition" },
          
          -- Git Group
          { "<leader>g", group = "Git" },
          { "<leader>gg", ":LazyGit<CR>", desc = "Open LazyGit" },
          { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "View Diff" },
          
          -- Explorer Group
          { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
          
          -- System Group
          { "<leader>q", ":q<CR>", desc = "Quit" },
          { "<leader>w", ":w<CR>", desc = "Save" },
      })

      -- Standard LSP Bindings (No Leader)
      -- K for Hover info, gd for Go to Definition
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover Info" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })

      -- ====================
      -- LSP Setup
      -- ====================
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Added 'pylsp' and removed typo 'nixl'
      local servers = { "lua_ls", "nil_ls", "nixd", "rust_analyzer", "pylsp" }

      for _, lsp in ipairs(servers) do
          if vim.lsp.config then
              vim.lsp.config(lsp, { capabilities = capabilities })
              vim.lsp.enable(lsp)
          else
              require('lspconfig')[lsp].setup({ capabilities = capabilities })
          end
      end

      -- ====================
      -- Completion (CMP) with Icons
      -- ====================
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind') -- Icon provider

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
          snippet = {
              expand = function(args) luasnip.lsp_expand(args.body) end,
          },
          -- Add Icons to the menu
          formatting = {
              format = lspkind.cmp_format({
                  mode = 'symbol_text',
                  maxwidth = 50,
                  ellipsis_char = '...',
              })
          },
          mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                  else fallback()
                  end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then cmp.select_prev_item()
                  elseif luasnip.expand_or_jumpable() then luasnip.jump(-1)
                  else fallback()
                  end
              end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' }, -- Function arg hints
              { name = 'luasnip' },
          }, {
              { name = 'buffer' },
          })
      })
    '';
  };
}

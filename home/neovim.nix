{
  config,
  pkgs,
  themeVariant,
  ...
}:

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
      elixir-ls

      # -- Formatters --
      nixfmt
      stylua
      prettierd
      shfmt
      black
      rustfmt
      elixir
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

      # -- Project Management --
      (pkgs.vimUtils.buildVimPlugin {
        name = "project-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "ahmedkhalf";
          repo = "project.nvim";
          rev = "main";
          hash = "sha256-avV3wMiDbraxW4mqlEsKy0oeewaRj9Q33K8NzWoaptU=";
        };
      })

      # -- QOL Plugins --
      trouble-nvim
      vim-illuminate
      leap-nvim

      # -- Navigation & Tools --
      vim-tmux-navigator
      telescope-nvim
      telescope-ui-select-nvim
      plenary-nvim
      neo-tree-nvim
      nui-nvim
      which-key-nvim
      gitsigns-nvim
      todo-comments-nvim
      lazygit-nvim

      # Install ALL grammars
      nvim-treesitter.withAllGrammars

      # -- QOL Editor --
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
      lspkind-nvim
      cmp-nvim-lsp-signature-help
      cmp-treesitter
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
      vim.opt.colorcolumn = "100"
      vim.opt.scrolloff = 10

      -- ====================
      -- Theme
      -- ====================
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_ui_contrast = 'high'
      vim.o.background = 'light'
      vim.cmd('colorscheme everforest')

      -- DYNAMIC THEME SELECTION
      vim.o.background = '${themeVariant}' -- This becomes 'light' or 'dark'
      vim.cmd('colorscheme everforest')

      -- ====================
      -- Diagnostics Config
      -- ====================
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- ====================
      -- Treesitter Configuration
      -- ====================
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        ensure_installed = {}, 
        auto_install = false,
      })

      -- ====================
      -- Project Config
      -- ====================
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "flake.nix", "mix.exs" },
      })

      -- Load Telescope Extensions
      require('telescope').load_extension('projects')
      require('telescope').load_extension('ui-select')

      -- ====================
      -- Leap (Motion) Setup
      -- ====================
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

      -- ====================
      -- Formatting
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
              elixir = { "mix" },
          },
          format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })

      require("nvim-autopairs").setup()
      require("nvim-surround").setup()
      require("todo-comments").setup()
      require("ibl").setup()
      require("trouble").setup()

      -- ====================
      -- Gitsigns
      -- ====================
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,
        numhl      = false,
        linehl     = false,
        word_diff  = false,
        watch_gitdir = { follow_files = true },
        auto_attach = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
        },
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      })

      require('lualine').setup({
          options = { 
              theme = 'everforest',
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' }
          }
      })

      require("neo-tree").setup({
          close_if_last_window = true,
          window = { width = 25 },
          filesystem = { hijack_netrw_behavior = "disabled" },
      })

      -- ====================
      -- Keybindings
      -- ====================
      local wk = require("which-key")
      local builtin = require('telescope.builtin')

      wk.setup({ preset = "modern" })

      wk.add({
          { "<leader>f", group = "Find/Files" }, 
          { "<leader>ff", builtin.find_files, desc = "Find File" },
          { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
          { "<leader>fb", builtin.buffers, desc = "Find Buffer" },
          { "<leader>fp", ":Telescope projects<CR>", desc = "Switch Project" },
          { "<leader>ft", ":TodoTelescope<CR>", desc = "Find Todos" },
          
          { "<leader>c", group = "Code" },
          { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format File" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Variable" },
          { "<leader>cd", vim.lsp.buf.definition, desc = "Go to Definition" },
          
          { "<leader>x", group = "Diagnostics" },
          { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project Diagnostics" },
          { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
          { "<leader>xt", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, desc = "Toggle Diagnostics" },

          { "<leader>g", group = "Git" },
          { "<leader>gg", ":LazyGit<CR>", desc = "Open LazyGit" },
          { "<leader>gj", ":Gitsigns next_hunk<CR>", desc = "Next Hunk" },
          { "<leader>gk", ":Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
          { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
          { "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
          { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
          { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Blame Line (Popup)" },
          { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "Diff This" },
          { "<leader>gtb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Blame" },
          
          { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
          { "<leader>q", ":q<CR>", desc = "Quit" },
          { "<leader>w", ":w<CR>", desc = "Save" },
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover Info" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })

      -- ====================
      -- Ergonomic Remaps
      -- ====================
      vim.keymap.set({'n', 'i', 'c'}, '<M-m>', '<CR>', { desc = "Alt-Enter" })
      vim.keymap.set('i', 'jj', '<Esc>', { desc = "Quick Escape" })
      vim.keymap.set('i', 'jk', '<Esc>', { desc = "Quick Escape" })
      vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<cmd>w<cr><esc>', { desc = "Save File" })

      -- ====================
      -- Tmux Navigation (Alt Keys)
      -- ====================
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set({'n', 't'}, '<M-h>', '<cmd>TmuxNavigateLeft<cr>')
      vim.keymap.set({'n', 't'}, '<M-j>', '<cmd>TmuxNavigateDown<cr>')
      vim.keymap.set({'n', 't'}, '<M-k>', '<cmd>TmuxNavigateUp<cr>')
      vim.keymap.set({'n', 't'}, '<M-l>', '<cmd>TmuxNavigateRight<cr>')

      -- ====================
      -- LSP & Completion
      -- ====================
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local servers = { "lua_ls", "nil_ls", "nixd", "rust_analyzer", "pylsp", "elixirls" }

      for _, lsp in ipairs(servers) do
          if vim.lsp.config then
              vim.lsp.config(lsp, { capabilities = capabilities })
              vim.lsp.enable(lsp)
          else
              require('lspconfig')[lsp].setup({ capabilities = capabilities })
          end
      end

      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind') 

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          formatting = {
              format = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })
          },
          sorting = {
            comparators = {
              cmp.config.compare.offset,
              cmp.config.compare.exact,
              cmp.config.compare.score,
              cmp.config.compare.recently_used,
              cmp.config.compare.locality,
              cmp.config.compare.kind,
              cmp.config.compare.sort_text,
              cmp.config.compare.length,
              cmp.config.compare.order,
            },
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
              { name = 'nvim_lsp_signature_help' },
              { name = 'treesitter' },
              { name = 'luasnip' },
              { name = 'path' },
          }, {
              { name = 'buffer' },
          })
      })
    '';
  };
}

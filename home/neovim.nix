{
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

    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
      lazygit
      lua-language-server
      nil
      nixd
      rust-analyzer
      python313Packages.python-lsp-server
      elixir-ls
      gopls
      nixfmt
      stylua
      prettierd
      shfmt
      black
      rustfmt
      elixir
      go
      delve
      gofumpt
      gotools
    ];

    plugins = with pkgs.vimPlugins; [
      everforest
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
      (pkgs.vimUtils.buildVimPlugin {
        name = "project-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "ahmedkhalf";
          repo = "project.nvim";
          rev = "main";
          hash = "sha256-avV3wMiDbraxW4mqlEsKy0oeewaRj9Q33K8NzWoaptU=";
        };
      })
      trouble-nvim
      vim-illuminate
      leap-nvim
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
      nvim-treesitter.withAllGrammars
      nvim-autopairs
      nvim-surround
      vim-sleuth
      conform-nvim
      nvim-lspconfig
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

      # Ai Completion
      codeium-nvim
    ];

    # 3. Lua Configuration
    initLua = ''
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

      -- Go Indentation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = false
        end,
      })

      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_ui_contrast = 'high'
      vim.o.background = '${themeVariant}'
      vim.cmd('colorscheme everforest')

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = { prefix = '●', source = "if_many" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Treesitter
      vim.api.nvim_create_autocmd("FileType", {
        callback = function() pcall(vim.treesitter.start) end,
      })

      -- Project
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "flake.nix", "mix.exs" },
      })
      require('telescope').load_extension('projects')
      require('telescope').load_extension('ui-select')

      -- Leap
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

      -- Smart gx
      vim.keymap.set("n", "gx", function()
        local path = vim.fn.expand("<cfile>")
        if path:match("https?://") or path:match("www%.") then
          vim.ui.open(path)
        else
          if vim.fn.filereadable(path) == 1 then vim.cmd("edit " .. path)
          else vim.notify("File not found: " .. path, vim.log.levels.WARN) end
        end
      end, { desc = "Smart gx" })

      -- Formatting
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
              go = { "gofumpt", "goimports" },
          },
          format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })

      require("nvim-autopairs").setup()
      require("nvim-surround").setup()
      require("todo-comments").setup()
      require("ibl").setup()
      require("trouble").setup()

      -- Gitsigns
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
        watch_gitdir = { follow_files = true },
        auto_attach = true,
      })

      require('lualine').setup({
          options = { theme = 'everforest' }
      })

      require("neo-tree").setup({
          close_if_last_window = true,
          window = { width = 25 },
          filesystem = { hijack_netrw_behavior = "disabled" },
      })

      -- Keybindings
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
          { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
          { "<leader>q", ":q<CR>", desc = "Quit" },
          { "<leader>w", ":w<CR>", desc = "Save" },
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover Info" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set({'n', 'i', 'c'}, '<M-m>', '<CR>', { desc = "Alt-Enter" })
      vim.keymap.set('i', 'jj', '<Esc>', { desc = "Quick Escape" })
      vim.keymap.set('i', 'jk', '<Esc>', { desc = "Quick Escape" })
      vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<cmd>w<cr><esc>', { desc = "Save File" })

      -- Tmux Navigation
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set({'n', 't'}, '<M-h>', '<cmd>TmuxNavigateLeft<cr>')
      vim.keymap.set({'n', 't'}, '<M-j>', '<cmd>TmuxNavigateDown<cr>')
      vim.keymap.set({'n', 't'}, '<M-k>', '<cmd>TmuxNavigateUp<cr>')
      vim.keymap.set({'n', 't'}, '<M-l>', '<cmd>TmuxNavigateRight<cr>')

      -- ====================
      -- Codeium Setup (Virtual Text Mode)
      -- ====================
      require("codeium").setup({
        enable_chat = true,
        -- Enable virtual text (Ghost Text) just like Copilot
        virtual_text = {
          enabled = true,
          -- This maps <Tab> to accept the suggestion
          map_keys = true, 
          key_bindings = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            clear = false,
            next = "<M-]>",
            prev = "<M-[>",
          }
        }
      })

      -- ====================
      -- LSP & CMP
      -- ====================
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local servers = { "lua_ls", "nil_ls", "nixd", "rust_analyzer", "pylsp", "elixirls", "gopls" }

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
          -- Mappings
          mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              
              ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then 
                      cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then 
                      luasnip.expand_or_jump()
                  else
                      fallback()
                  end
              end, { 'i', 's' }),
              
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then cmp.select_prev_item()
                  elseif luasnip.expand_or_jumpable() then luasnip.jump(-1)
                  else fallback()
                  end
              end, { 'i', 's' }),
          }),
          
          -- SOURCES: Codeium removed from here to prevent duplicate menu items
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

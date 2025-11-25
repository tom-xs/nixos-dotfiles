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
      lazygit # Required for lazygit plugin

      # -- Language Servers --
      lua-language-server
      nil # Nix LSP

      # -- Formatters (for conform.nvim) --
      nixfmt # Nix
      stylua # Lua
      prettierd # Web (JS/TS/CSS/HTML)
      shfmt # Shell
      black # Python (Enable if you use Python)
    ];

    # 2. Plugins
    plugins = with pkgs.vimPlugins; [
      # -- Theme --
      everforest # Official Vimscript version (Stable)

      # -- GUI / UI Improvements --
      lualine-nvim # Status bar
      indent-blankline-nvim # Indent guides
      nvim-web-devicons # Icons

      # -- Navigation & Tools --
      telescope-nvim
      plenary-nvim
      neo-tree-nvim
      nui-nvim
      which-key-nvim # Key popup helper
      gitsigns-nvim # Git integration
      todo-comments-nvim # Todo highlighting
      lazygit-nvim # Git TUI integration
      nvim-treesitter.withAllGrammars

      # -- QOL Plugins --
      nvim-autopairs # Auto close brackets () [] {}
      nvim-surround # Change surroundings cs"'
      vim-sleuth # Auto-detect indent (tabs vs spaces)

      # -- LSP, Formatting & Completion --
      conform-nvim # Formatting (Modern replacement for null-ls)
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
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

        -- 1. Vertical Line at 100 characters
        vim.opt.colorcolumn = "100"

        -- 2. Scrolloff (Keep cursor away from edges)
        -- Keeps 10 lines visible above/below the cursor when scrolling
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
        -- To add new languages:
        -- 1. Add the formatter binary to 'extraPackages' in nix config
        -- 2. Add the filetype to this list below
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
            },
            format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
            },
            })

      -- ====================
        -- QOL Plugins Setup
        -- ====================

        -- nvim-autopairs: Automatically closes brackets like (), [], {}
      require("nvim-autopairs").setup()

        -- nvim-surround: Manipulate surroundings
        -- Usage:
        -- cs"'  -> Change surrounding " to '
        -- ds"   -> Delete surrounding "
        -- ysw"  -> Add surrounding " to word
        require("nvim-surround").setup()

        -- lazygit: Git integration
        -- Press <leader>gg to open the git UI
        vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })

        -- ====================
        -- Plugin: WhichKey
        -- ====================
        require("which-key").setup()

        -- ====================
        -- Plugin: Gitsigns
        -- ====================
        require('gitsigns').setup()

        -- ====================
        -- Plugin: Lualine
        -- ====================
        require('lualine').setup({
            options = { 
            theme = 'everforest',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' }
            }
            })

      -- ====================
        -- Plugin: Indent Blankline
        -- ====================
        require("ibl").setup()

        -- ====================
        -- Plugin: Telescope
        -- ====================
        local builtin = require('telescope.builtin')
        local wk = require("which-key")

        wk.add({
            { "<leader>f", group = "Find" }, 
            { "<leader>ff", builtin.find_files, desc = "Find File" },
            { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
            { "<leader>fb", builtin.buffers, desc = "Find Buffer" },
            { "<leader>ft", ":TodoTelescope<CR>", desc = "Find Todos" },
            })

      -- ====================
        -- Plugin: Neo-tree
        -- ====================
        require("neo-tree").setup({
            close_if_last_window = true,
            })
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Toggle Explorer" })

        -- ====================
        -- Plugin: Todo-comments
        -- ====================
        require("todo-comments").setup()

        -- ====================
        -- LSP Setup
        -- ====================
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local servers = { "lua_ls", "nil_ls" }

      for _, lsp in ipairs(servers) do
        if vim.lsp.config then
          vim.lsp.config(lsp, { capabilities = capabilities })
            vim.lsp.enable(lsp)
        else
          require('lspconfig')[lsp].setup({ capabilities = capabilities })
            end
            end

            -- ====================
            -- Completion (CMP)
            -- ====================
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
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
                    }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    }, {
                    { name = 'buffer' },
                    })
            })
    '';
  };
}

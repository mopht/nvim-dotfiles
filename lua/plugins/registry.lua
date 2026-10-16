-- Plugin registry for vim.pack.
local M = {}

M.plugins = {

    -- ══════════════════════════════════════════════
    -- start/  — always loaded
    -- ══════════════════════════════════════════════

    -- Dependencies (must load before dependent plugins)
    { name = "_blink.lib",              src = "saghen/blink.lib",                    pack = "start" },
    { name = "plenary.nvim",            src = "nvim-lua/plenary.nvim",               pack = "start" },
    { name = "nvim-web-devicons",       src = "nvim-tree/nvim-web-devicons",         pack = "start" },
    { name = "nui.nvim",                src = "MunifTanjim/nui.nvim",                pack = "start" },
    { name = "mini.icons",              src = "echasnovski/mini.icons",              pack = "start" },
    { name = "nvim-navic",              src = "SmiteshP/nvim-navic",                 pack = "start" },
    { name = "mason.nvim",              src = "mason-org/mason.nvim",                pack = "start" },
    { name = "mason-lspconfig.nvim",    src = "mason-org/mason-lspconfig.nvim",      pack = "start" },

    { name = "which-key.nvim",          src = "folke/which-key.nvim",                pack = "start",
    config = function()
        require("which-key").setup({})
    end},
    -- Core
    { name = "nvim-lspconfig",          src = "neovim/nvim-lspconfig",               pack = "start",
    config = function()
        local spec = require("plugins.specs.nvim-lspconfig")
        if spec.config then spec.config() end
    end },
    { name = "blink.cmp",               src = "saghen/blink.cmp",                    pack = "start",
    config = function()
        -- v2: build/download native fuzzy matcher (one-time, caches after)
        local ok, _ = pcall(function() require("blink.cmp").build():pwait() end)
        if not ok then
            vim.notify("blink.cmp: native build failed, using Lua fallback", vim.log.levels.WARN)
        end
        local spec = require("plugins.specs.blink-cmp")
        require("blink.cmp").setup(spec.opts or {})
    end },
    { name = "nvim-treesitter",         src = "nvim-treesitter/nvim-treesitter",     pack = "start",
    version = "main",
    config = function()
        local spec = require("plugins.specs.nvim-treesitter")
        require("nvim-treesitter.config").setup(spec.opts or {})
    end },
    {
        name = "tree-sitter-manager.nvim", src = "romus204/tree-sitter-manager.nvim", pack = "start",
        config = function()
            require('tree-sitter-manager').setup({
                ensure_installed = {
                    'haskell',
                },
                auto_install = true,
                languages = { haskell = { install_info = {
                    revision = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395",
                    url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell",
                }, }, },
            })
        end,
    },

    -- Colorschemes
    { name = "everforest-nvim",         src = "neanias/everforest-nvim",             pack = "start" },

    -- UI
    { name = "lualine.nvim",            src = "nvim-lualine/lualine.nvim",           pack = "start",
    config = function()
        local spec = require("plugins.specs.lualine")
        require("lualine").setup(spec.opts or {})
    end },
    { name = "barbecue",                src = "utilyre/barbecue.nvim",               pack = "start",
    config = function()
        local spec = require("plugins.specs.barbecue")
        require("barbecue").setup(spec.opts or {})
    end },
    -- { name = "bufferline.nvim",         src = "akinsho/bufferline.nvim",             pack = "start",
    -- config = function()
    --     local spec = require("plugins.specs.bufferline")
    --     require("bufferline").setup(spec.opts or {})
    -- end },
    { name = "hlchunk.nvim",            src = "shellRaining/hlchunk.nvim",           pack = "start",
    config = function()
        local spec = require("plugins.specs.hlchunk")
        require("hlchunk").setup(spec.opts or {})
    end },
    { name = "noice.nvim",              src = "folke/noice.nvim",                    pack = "start",
    config = function()
        local spec = require("plugins.specs.noice")
        require("noice").setup(spec.opts or {})
    end },
    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim",     pack = "start" },
    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", pack = "start",
    config = function()
        local spec = require("plugins.specs.nvim-treesitter-context")
        require("treesitter-context").setup(spec.opts or {})
    end },

    -- { name = "oil.nvim",                src = "stevearc/oil.nvim", pack = "start",
    -- config = function() require("oil").setup() end},

    -- ══════════════════════════════════════════════
    -- opt/  — lazy-loaded on demand
    -- ══════════════════════════════════════════════

    -- ── cmd-based ────────────────────────────────
    { name = "neo-tree.nvim",           src = "nvim-neo-tree/neo-tree.nvim",         pack = "opt", cmd = { "Neotree" },
    config = function()
        require("plugins.specs.neo-tree")
        require("plugins.specs.nui")
    end },
    { name = "snacks.nvim",             src = "folke/snacks.nvim",                   pack = "opt",
    keys = {
        { "<leader>ff", action = function() require("snacks").picker.files() end,   desc = "Find Files" },
        { "<leader>fg", action = function() require("snacks").picker.grep() end,    desc = "Live Grep" },
        { "<leader>fb", action = function() require("snacks").picker.buffers() end, desc = "Find Buffers" },
        { "<leader>fh", action = function() require("snacks").picker.help() end,    desc = "Help Tags" },
        { "<F8>",       action = function() require("snacks").terminal.toggle(nil, { win = { position = "bottom", height = 9 } }) end, desc = "Toggle terminal" },
        { "<leader>fn", action = function() require("snacks").terminal.toggle("nu", { win = { position = "float", width = 0.8, height = 0.8 } }) end, desc = "Nushell" },
        { "<leader>fm", action = function() require("snacks").terminal.toggle("lazygit", { win = { position = "float", width = 0.9, height = 0.9 } }) end, desc = "Lazygit" },
    },
    config = function()
        local spec = require("plugins.specs.snacks")
        require("snacks").setup(spec.opts or {})
    end },
    { name = "trouble.nvim",            src = "folke/trouble.nvim",                  pack = "opt", cmd = { "Trouble" },
    config = function()
        local spec = require("plugins.specs.trouble")
        require("trouble").setup(spec.opts or {})
    end },
    -- { name = "symbols-outline.nvim",    src = "simrat39/symbols-outline.nvim",       pack = "opt", cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    -- config = function()
    --     local spec = require("plugins.specs.symbols-outline")
    --     require("symbols-outline").setup(spec.opts or {})
    -- end },
    { name = "code_runner.nvim",        src = "CRAG666/code_runner.nvim",            pack = "opt", cmd = { "RunCode" },
    config = function()
        require("code_runner").setup(require("plugins.specs.code_runner").opts or {})
    end },
    { name = "guess-indent.nvim",       src = "NMAC427/guess-indent.nvim",           pack = "opt", cmd = { "GuessIndent" },
    config = function() require('guess-indent').setup {} end },
    { name = "twilight.nvim",           src = "folke/twilight.nvim",                 pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function()
        require("twilight").setup({})
    end },
    { name = "zen-mode.nvim",           src = "folke/zen-mode.nvim",                 pack = "opt", cmd = { "ZenMode" },
    config = function()
        require("zen-mode").setup({})
    end },

    -- ── key-based ────────────────────────────────
    { name = "flash.nvim",              src = "folke/flash.nvim",                    pack = "opt",
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,                    desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,              desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,                  desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end,       desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,                  desc = "Toggle Flash Search" },
    },
    config = function() require("flash").setup({}) end },
    { name = "Comment.nvim",            src = "numToStr/Comment.nvim",               pack = "opt",
    keys = {
        { "gc",  mode = { "n", "v" } },
        { "gcc", mode = "n" },
    },
    config = function() require("Comment").setup({}) end },
    { name = "goto-preview",            src = "rmagatti/goto-preview",               pack = "opt",
    keys = {
        { "gpd", mode = "n", action = function() require("goto-preview").goto_preview_definition() end,        desc = "Preview Definition" },
        { "gpt", mode = "n", action = function() require("goto-preview").goto_preview_type_definition() end,   desc = "Preview Type Def" },
        { "gpi", mode = "n", action = function() require("goto-preview").goto_preview_implementation() end,    desc = "Preview Impl" },
        { "gpD", mode = "n", action = function() require("goto-preview").goto_preview_declaration() end,       desc = "Preview Declaration" },
        { "gP",  mode = "n", action = function() require("goto-preview").close_all_win() end,                  desc = "Close All Previews" },
    },
    config = function()
        require("goto-preview").setup(require("plugins.specs.goto-preview").opts or {})
    end },
    { name = "neoscroll.nvim",          src = "karb94/neoscroll.nvim",               pack = "opt",
    keys = {
        { "<C-u>" }, { "<C-d>" }, { "<C-b>" }, { "<C-f>" },
        { "<C-y>" }, { "<C-e>" }, { "zz" }, { "zt" }, { "zb" },
    },
    config = function() require("neoscroll").setup({}) end },
    { name = "vim-tmux-navigator",      src = "christoomey/vim-tmux-navigator",      pack = "opt",
    keys = {
        { "<C-h>" }, { "<C-j>" }, { "<C-k>" }, { "<C-l>" },
    },
    config = nil },

    -- ── event-based ──────────────────────────────
    { name = "auto-save.nvim",          src = "okuuva/auto-save.nvim",               pack = "opt", event = { "InsertEnter" },
    config = function() require("auto-save").setup({}) end },
    { name = "better-escape.nvim",      src = "max397574/better-escape.nvim",        pack = "opt", event = { "InsertEnter" },
    config = function()
        require("better_escape").setup(require("plugins.specs.better-escape").opts)
    end },
    { name = "nvim-autopairs",          src = "windwp/nvim-autopairs",               pack = "opt", event = { "InsertEnter" },
    config = function()
        local spec = require("plugins.specs.autopairs")
        if spec.config then spec.config() end
    end },
    { name = "tabout.nvim",             src = "abecodes/tabout.nvim",                pack = "opt", event = { "InsertEnter" },
    config = function() require("tabout").setup(require("plugins.specs.tabout").opts) end },
    { name = "lsp_signature.nvim",      src = "ray-x/lsp_signature.nvim",            pack = "opt", event = { "InsertEnter" },
    config = function() require("lsp_signature").setup(require("plugins.specs.lsp_signature").opts) end },
    { name = "friendly-snippets",       src = "rafamadriz/friendly-snippets",        pack = "opt", event = { "InsertEnter" } },
    -- { name = "inlay-hints.nvim",        src = "MysticalDevil/inlay-hints.nvim", pack = "opt", event = { "LspAttach" },
    --     config = function() require("inlay-hints").setup({}) end },
    { name = "none-ls.nvim",            src = "nvimtools/none-ls.nvim",              pack = "opt", event = { "LspAttach" },
    config = function()
        vim.cmd("packadd none-ls-extras.nvim")
        local spec = require("plugins.specs.none-ls")
        if spec.config then spec.config() end
    end },
    { name = "vim-better-whitespace",   src = "ntpeters/vim-better-whitespace",      pack = "opt", event = { "BufEnter" },
    config = nil },
    { name = "todo-comments.nvim",      src = "folke/todo-comments.nvim",            pack = "opt", event = { "BufEnter" },
    config = function()
        local spec = require("plugins.specs.todo-comments")
        require("todo-comments").setup(spec.opts or {})
    end },

    -- ── filetype-based ───────────────────────────
    { name = "moonbit.nvim",            src = "moonbit-community/moonbit.nvim",      pack = "opt", ft = "moonbit",
    config = function() require("moonbit").setup({
        mooncakes = {
            virtual_text = true,   -- virtual text showing suggestions
            use_local = true,      -- recommended, use index under ~/.moon
        },
        -- optionally disable the treesitter integration
        treesitter =  {
            enabled = true,
            -- Set false to disable automatic installation and updating of parsers.
            auto_install = true
        },
        -- configure the language server integration
        -- set `lsp = false` to disable the language server integration
        lsp = {
            -- set to false to use the legacy language server
            native = true,
            -- provide an `on_attach` function to run when the language server starts
            on_attach = function(client, bufnr) end,
            -- provide client capabilities to pass to the language server
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        },
        -- configure jsonls schema integration (enabled by default)
        -- set `jsonls = false` to disable
        jsonls = {
            -- optional extra jsonls settings to merge
            settings = {},
        },
    }) end },
    { name = "idris2-nvim",             src = "ShinKage/idris2-nvim",                pack = "opt", ft = "idris",
    config = function() require("idris2-nvim").setup() end},
    { name = "koka.nvim",               src = "syaiful6/koka.nvim",                  pack = "opt", ft = "koka" },
    { name = "haskell-tools.nvim",      src = "mrcjkb/haskell-tools.nvim",           pack = "start",--[[  ft = { "haskell" }, ]]
    config = nil }, -- already lazyed
    { name = "lazydev.nvim",            src = "folke/lazydev.nvim",                  pack = "opt", ft = { "lua" },
    config = function() require("lazydev").setup(require("plugins.specs.lazydev").opts) end },
    -- { name = "zig-lamp",                src = "...", pack = "opt", ft = { "zig", "zon" },
    -- pre = function()
    --     vim.g.zig_lamp_zls_auto_install = nil
    --     vim.g.zig_lamp_fall_back_sys_zls = nil
    --     vim.g.zig_lamp_zls_lsp_opt = {}
    --     vim.g.zig_lamp_zls_settings = {}
    --     vim.g.zig_lamp_pkg_help_fg = "#CF5C00"
    --     vim.g.zig_lamp_zig_fetch_timeout = 5000
    -- end },
    { name = "rustaceanvim",            src = "mrcjkb/rustaceanvim",                 pack = "start" },
    -- { name = "c3.nvim",                 src = "...", pack = "opt", ft = { "c3", "c3i" },
    -- config = function()
    --     require("c3")
    -- end },

    -- ── unused / backup ──────────────────────────
    { name = "none-ls-extras.nvim",     src = "nvimtools/none-ls-extras.nvim",       pack = "opt" },
    { name = "catppuccin",              src = "catppuccin/nvim",                     pack = "opt" },
    { name = "tokyonight.nvim",         src = "folke/tokyonight.nvim",               pack = "opt" },
}

return M

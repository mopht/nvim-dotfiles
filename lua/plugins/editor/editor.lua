local M = {
    { name = "code_runner.nvim", src = "CRAG666/code_runner.nvim", pack = "opt", cmd = { "RunCode" },
    config = function()
        require("code_runner").setup(require("plugins.specs.code_runner").opts or {})
    end },

    { name = "guess-indent.nvim", src = "NMAC427/guess-indent.nvim", pack = "opt", cmd = { "GuessIndent" },
    config = function() require("guess-indent").setup({}) end },

    { name = "twilight.nvim", src = "folke/twilight.nvim", pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function() require("twilight").setup({}) end },

    { name = "zen-mode.nvim", src = "folke/zen-mode.nvim", pack = "opt", cmd = { "ZenMode" },
    config = function() require("zen-mode").setup({}) end },

    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt",
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function() require("flash").setup({}) end },

    { name = "Comment.nvim", src = "numToStr/Comment.nvim", pack = "opt",
    keys = {
        { "gc",  mode = { "n", "v" }, desc = "Comment operator" },
        { "gcc", mode = "n",          desc = "Comment line" },
    },
    config = function() require("Comment").setup({}) end },

    { name = "goto-preview", src = "rmagatti/goto-preview", pack = "opt",
    keys = {
        { "gpd", mode = "n", action = function() require("goto-preview").goto_preview_definition() end,      desc = "Preview Definition" },
        { "gpt", mode = "n", action = function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Def" },
        { "gpi", mode = "n", action = function() require("goto-preview").goto_preview_implementation() end,  desc = "Preview Impl" },
        { "gpD", mode = "n", action = function() require("goto-preview").goto_preview_declaration() end,     desc = "Preview Declaration" },
        { "gP",  mode = "n", action = function() require("goto-preview").close_all_win() end,                desc = "Close All Previews" },
    },
    config = function()
        require("goto-preview").setup(require("plugins.specs.goto-preview").opts or {})
    end },

    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", pack = "opt",
    keys = {
        { "<C-u>", desc = "Scroll up half page" },
        { "<C-d>", desc = "Scroll down half page" },
        { "<C-b>", desc = "Scroll up page" },
        { "<C-f>", desc = "Scroll down page" },
        { "<C-y>", desc = "Scroll line up" },
        { "<C-e>", desc = "Scroll line down" },
        { "zz",    desc = "Center cursor line" },
        { "zt",    desc = "Cursor line to top" },
        { "zb",    desc = "Cursor line to bottom" },
    },
    config = function() require("neoscroll").setup({}) end },

    { name = "auto-save.nvim", src = "okuuva/auto-save.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("auto-save").setup({}) end },

    { name = "better-escape.nvim", src = "max397574/better-escape.nvim", pack = "opt", event = { "InsertEnter" },
    config = function()
        require("better_escape").setup(require("plugins.specs.better-escape").opts)
    end },

    { name = "nvim-autopairs", src = "windwp/nvim-autopairs", pack = "opt", event = { "InsertEnter" },
    config = function()
        local spec = require("plugins.specs.autopairs")
        if spec.config then spec.config() end
    end },

    { name = "tabout.nvim", src = "abecodes/tabout.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("tabout").setup(require("plugins.specs.tabout").opts) end },

    { name = "vim-better-whitespace", src = "ntpeters/vim-better-whitespace", pack = "opt", event = { "BufEnter" },
    config = nil },

    { name = "todo-comments.nvim", src = "folke/todo-comments.nvim", pack = "opt", event = { "BufEnter" },
    config = function()
        local spec = require("plugins.specs.todo-comments")
        require("todo-comments").setup(spec.opts or {})
    end },
}

return M

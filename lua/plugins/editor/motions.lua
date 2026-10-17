local M = {
    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt",
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function() require("flash").setup({})
    end },
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
}

return M

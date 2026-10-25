local goto_preview_opts = { default_mappings = true }

return {
    { "folke/flash.nvim", lazy = true,
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    opts = {} },

    { "rmagatti/goto-preview", lazy = true,
    keys = {
        { "gpd", mode = "n", action = function() require("goto-preview").goto_preview_definition() end,      desc = "Preview Definition" },
        { "gpt", mode = "n", action = function() require("goto-preview").goto_preview_type_definition({}) end, desc = "Preview Type Def" },
        { "gpi", mode = "n", action = function() require("goto-preview").goto_preview_implementation({}) end,  desc = "Preview Impl" },
        { "gpD", mode = "n", action = function() require("goto-preview").goto_preview_declaration({}) end,     desc = "Preview Declaration" },
        { "gP",  mode = "n", action = function() require("goto-preview").close_all_win() end,                desc = "Close All Previews" },
    },
    opts = goto_preview_opts },
}

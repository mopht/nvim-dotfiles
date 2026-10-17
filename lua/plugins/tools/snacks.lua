local snacks_opts = {
    -- explorer = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    image = { enabled = true },
    lazygit = {enabled = true },
    indent = {
        enabled = true,
        scope = { enabled = true, },
        chunk = {
            enabled = true,
            char = {
                corner_top = "╭",
                corner_bottom = "╰",
            }
        },
    },
    picker = {
        enabled = true,
        layout = {
            preset = "default",
            layout = {
                width = 0.85,
                min_width = 70,
            },
        },
    },
    terminal = {
        win = {
            style = "terminal",
        },
    },
}

local M = {
    { name = "snacks.nvim", src = "folke/snacks.nvim", pack = "opt",
    event = { "BufReadPre" };
    keys = {
        { "<leader><space>", action = function() require("snacks").picker.smart() end,   desc = "Smart Find Files" },
        { "<leader>f",       action = function() require("snacks").picker.files() end,   desc = "Find Files" },
        { "<leader>g",       action = function() require("snacks").picker.grep() end,    desc = "Live Grep" },
        { "<leader>b",       action = function() require("snacks").picker.buffers() end, desc = "Find Buffers" },
        { "<leader>hh",      action = function() require("snacks").picker.help() end,    desc = "Help Tags" },
        { "<F8>",            action = function() require("snacks").terminal.toggle(nil, { win = { position = "bottom", height = 9 } }) end, desc = "Toggle terminal" },
        { "<leader>tn",      action = function() require("snacks").terminal.toggle("nu", { win = { position = "float", width = 0.8, height = 0.8 } }) end, desc = "Nushell" },
        { "<leader>tm",      action = function() require("snacks").lazygit() end, desc = "Lazygit" },
    },
    config = function() require("snacks").setup(snacks_opts) end },
}

return M

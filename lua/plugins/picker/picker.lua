local M = {
    { name = "snacks.nvim", src = "folke/snacks.nvim", pack = "opt",
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
    config = function()
        local spec = require("plugins.specs.snacks")
        require("snacks").setup(spec.opts or {})
    end },

    { name = "trouble.nvim", src = "folke/trouble.nvim", pack = "opt", cmd = { "Trouble" },
    config = function()
        local spec = require("plugins.specs.trouble")
        require("trouble").setup(spec.opts or {})
    end },
}

return M

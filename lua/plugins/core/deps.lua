local M = {
    { name = "lz.n",              src = "nvim-neorocks/lz.n",           pack = "start" },
    { name = "_blink.lib",        src = "saghen/blink.lib",             pack = "start" },
    -- { name = "plenary.nvim",      src = "nvim-lua/plenary.nvim",        pack = "start" },
    { name = "nui.nvim",          src = "MunifTanjim/nui.nvim",         pack = "start" },
    { name = "nvim-navic",        src = "SmiteshP/nvim-navic",          pack = "start" },
    { name = "mini.icons",        src = "echasnovski/mini.icons",       pack = "start",
    config = function ()
        local icons = require("mini.icons")
        icons.setup()
        icons.mock_nvim_web_devicons()
    end},
}

return M

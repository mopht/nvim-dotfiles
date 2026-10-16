local M = {
    -- Dependencies (must load before dependent plugins)
    { name = "_blink.lib",        src = "saghen/blink.lib",             pack = "start" },
    { name = "plenary.nvim",      src = "nvim-lua/plenary.nvim",        pack = "start" },
    { name = "nvim-web-devicons", src = "nvim-tree/nvim-web-devicons",  pack = "start" },
    { name = "nui.nvim",          src = "MunifTanjim/nui.nvim",         pack = "start" },
    { name = "mini.icons",        src = "echasnovski/mini.icons",       pack = "start" },
    { name = "nvim-navic",        src = "SmiteshP/nvim-navic",          pack = "start" },

    { name = "which-key.nvim",    src = "folke/which-key.nvim",         pack = "start",
    config = function()
        require("which-key").setup(require("plugins.specs.which-key").opts or {})
    end },
}

return M

local M = {
    { name = "everforest-nvim", src = "neanias/everforest-nvim", pack = "start",
    colorscheme = "everforest" },
    { name = "catppuccin",      src = "catppuccin/nvim",         pack = "opt" },
    { name = "tokyonight.nvim", src = "folke/tokyonight.nvim",   pack = "opt",
    colorscheme = "tokyonight",
    config = function () require("tokyonight").setup({
        transparent = true,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
            -- lualine = "transparent"
        }
    })
    end, },
}

return M

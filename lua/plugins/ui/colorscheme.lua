-- To switch theme, edit the colorscheme field here; lua/config/colorscheme.lua applies it

local tokyonight_opts = {
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    },
}

return {
    { name = "everforest-nvim", src = "neanias/everforest-nvim", pack = "start",
    colorscheme = "everforest",
    config = function() require("everforest").setup({ transparent_background_level = 2 }) end },
    { name = "catppuccin",      src = "catppuccin/nvim",         pack = "opt" },
    { name = "tokyonight.nvim", src = "folke/tokyonight.nvim",   pack = "opt",
    config = function() require("tokyonight").setup({tokyonight_opts}) end },
}

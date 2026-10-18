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
    { name = "catppuccin",      src = "catppuccin/nvim",         pack = "opt",
    colorscheme = "catppuccin", },
    { name = "tokyonight.nvim", src = "folke/tokyonight.nvim",   pack = "opt",
    -- without this field lz.n has no trigger for the plugin and loads it on
    -- every startup, so :colorscheme tokyonight only worked by accident
    colorscheme = "tokyonight",
    config = function() require("tokyonight").setup(tokyonight_opts) end },
}

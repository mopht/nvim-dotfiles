-- To switch theme, edit the colorscheme field here; lua/config/colorscheme.lua applies it
return {
    { name = "everforest-nvim", src = "neanias/everforest-nvim", pack = "start",
    colorscheme = "everforest",
    config = function() require("everforest").setup({ transparent_background_level = 2 }) end },
    { name = "catppuccin",      src = "catppuccin/nvim",         pack = "opt" },
    { name = "tokyonight.nvim", src = "folke/tokyonight.nvim",   pack = "opt",
    colorscheme = "tokyonight", config = function() require("tokyonight").setup() end },
}

-- To switch theme, edit the colorscheme field here; lua/config/colorscheme.lua applies it

local tokyonight_opts = {
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    },
}

return {
    -- everforest's module is `everforest`, not `everforest-nvim`
    { name = "everforest-nvim", src = "neanias/everforest-nvim", lazy = false,
    colorscheme = "everforest",
    main = "everforest",
    opts = { transparent_background_level = 2 } },
    { name = "catppuccin",      src = "catppuccin/nvim",         lazy = true,
    colorscheme = "catppuccin" },
    { name = "tokyonight.nvim", src = "folke/tokyonight.nvim",   lazy = true,
    -- without this field lz.n has no trigger for the plugin and loads it on
    -- every startup, so :colorscheme tokyonight only worked by accident
    colorscheme = "tokyonight",
    opts = tokyonight_opts },
}

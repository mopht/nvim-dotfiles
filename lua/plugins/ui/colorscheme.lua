-- Theme: edit the colorscheme field; lua/load/init.lua applies it

local tokyonight_opts = {
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    },
}

local catppuccin_opts = {
    float = { solid = true },
}

return {
    -- everforest's module is `everforest`, not `everforest-nvim`
    { name = "everforest-nvim", src = "neanias/everforest-nvim", lazy = false,
    colorscheme = "everforest", main = "everforest",
    opts = { transparent_background_level = 2 } },

    { name = "catppuccin",      src = "catppuccin/nvim",         lazy = true,
    colorscheme = "catppuccin", opts = catppuccin_opts },

    { name = "tokyonight",      src = "folke/tokyonight.nvim",   lazy = true,
    colorscheme = "tokyonight", opts = tokyonight_opts },

    { name = "onedark",         src = "navarasu/onedark.nvim",   lazy = true,
    colorscheme = "onedark", opts = { transparent = true } },
}

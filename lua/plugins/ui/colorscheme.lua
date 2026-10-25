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
    { "neanias/everforest-nvim", lazy = false,
    colorscheme = "everforest", main = "everforest",
    opts = { transparent_background_level = 2 } },

    { "catppuccin/nvim", name = "catppuccin", lazy = true,
    colorscheme = "catppuccin", opts = catppuccin_opts },

    { "folke/tokyonight.nvim", name = "tokyonight", lazy = true,
    colorscheme = "tokyonight", opts = tokyonight_opts },

    { "navarasu/onedark.nvim", name = "onedark", lazy = true,
    colorscheme = "onedark", opts = { transparent = true } },
}

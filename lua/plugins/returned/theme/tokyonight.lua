return {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
    config = function()
        require("plugins.tokyonight")
    end,
}

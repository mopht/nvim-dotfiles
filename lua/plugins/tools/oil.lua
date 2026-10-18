return {
    { name = "oil.nvim", src = "stevearc/oil.nvim", lazy = false,
    config = function() require("oil").setup() end },
}

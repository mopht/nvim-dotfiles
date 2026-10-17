local M = {
    { name = "oil.nvim", src = "stevearc/oil.nvim", pack = "start",
    config = function() require("oil").setup() end },
}

return M

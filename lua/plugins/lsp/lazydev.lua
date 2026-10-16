local M = {
    { name = "lazydev.nvim", src = "folke/lazydev.nvim", pack = "start",  ft = { "lua" },
    config = function() require("lazydev").setup(require("plugins.specs.lazydev").opts) end },
}

return M

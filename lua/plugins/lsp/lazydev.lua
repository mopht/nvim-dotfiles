local M = {
    { name = "lazydev.nvim", src = "folke/lazydev.nvim", pack = "opt", ft = { "lua" },
    config = function() require("lazydev").setup({
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    }) end },
}

return M

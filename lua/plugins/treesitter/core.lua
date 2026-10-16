local M = {
    { name = "nvim-treesitter", src = "nvim-treesitter/nvim-treesitter", pack = "start",
    version = "main",
    config = function()
        local spec = require("plugins.specs.nvim-treesitter")
        require("nvim-treesitter.config").setup(spec.opts or {})
    end },
    { name = "tree-sitter-manager.nvim", src = "romus204/tree-sitter-manager.nvim", pack = "start",
    config = function()
        require("tree-sitter-manager").setup({
            ensure_installed = {
                "haskell",
            },
            auto_install = true,
            languages = {
                haskell = {
                    install_info = {
                        revision = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395",
                        url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell",
                    },
                },
            },
        })
    end },
}

return M

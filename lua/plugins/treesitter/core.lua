local nvim_treesitter_opts = {
    ensure_installed = {
        "c",
        "lua",
        "zig",
        "vim",
        "vimdoc",
        "kotlin",
        "query",
        "rust",
        "cpp",
        "javascript",
        "python",
        "haskell",
        "typescript",
    },

    highlight = { enable = true },
    indent = { enable = true },

    rainbow = {
        enable = true,
        extended_more = true,
        max_file_lines = nil,
    },

}

return {
    { name = "nvim-treesitter", src = "nvim-treesitter/nvim-treesitter", pack = "start",
    config = function() require("nvim-treesitter.config").setup(nvim_treesitter_opts) end },
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

return {
    "nvim-treesitter/nvim-treesitter",

    event = { "VeryLazy" },
    opts = {
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
}

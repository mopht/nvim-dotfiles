return {
    "nvim-treesitter/nvim-treesitter",

    event = { "VeryLazy" },
    opts = {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
            "c",
            "lua",
            "zig",
            "vim",
            "vimdoc",
            "kotlin",
            -- "coffeescript",
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

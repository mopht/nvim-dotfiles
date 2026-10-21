-- nvim-treesitter (main branch), no setup() call needed.
-- Parsers: :TSInstall c lua zig vim vimdoc kotlin query rust cpp javascript python haskell typescript
-- Highlight, indent and folds: lua/config/treesitter.lua.
local context_opts = {
    enable = true,
    throttle = true,
    max_lines = 0,
    patterns = {
        default = {
            "class",
            "function",
            "method",
        },
    },
    show_brackets = false,
}

return {
    { name = "nvim-treesitter", src = "nvim-treesitter/nvim-treesitter", lazy = false },

    { name = "tree-sitter-manager.nvim", src = "romus204/tree-sitter-manager.nvim", lazy = true,
    ft = "haskell",
    opts = {
        ensure_installed = {
            "haskell",
        },
        auto_install = true,
        languages = { haskell = { install_info = {
            revision = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395",
            url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell",
        }, }, },
    } },

    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", lazy = false,
    main = "treesitter-context", opts = context_opts },

    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim", lazy = false },
}

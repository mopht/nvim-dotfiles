-- nvim-treesitter (main branch), no setup() call needed.
-- Highlight, indent and folds: lua/config/treesitter.lua.
return {
    { "nvim-treesitter/nvim-treesitter", lazy = true,
    event = "BufReadPost",
    cmd = { "TSInstall", "TSInstallFromGrammar", "TSUpdate", "TSUninstall", "TSLog" } },

    { "romus204/tree-sitter-manager.nvim", lazy = true,
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

    { "nvim-treesitter/nvim-treesitter-context", lazy = false,
    main = "treesitter-context", opts = {} },

    { "HiPhish/rainbow-delimiters.nvim", lazy = false },
}

-- nvim-treesitter (main branch).
--
-- No setup() call is needed: the old keys (ensure_installed, highlight, indent,
-- rainbow) were dropped upstream and were silently ignored here. Parsers are
-- installed with :TSInstall, e.g.
--   :TSInstall c lua zig vim vimdoc kotlin query rust cpp javascript python haskell typescript
-- Highlighting, indent and folding are enabled per buffer in lua/config/treesitter.lua.
return {
    { name = "nvim-treesitter", src = "nvim-treesitter/nvim-treesitter", pack = "start" },
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

-- ============================================================================
-- init.lua — Entry point for native Vim packages (pack/*/start/ + opt/)
-- Migrated from lazy.nvim to Neovim's built-in :h packages
-- ============================================================================

-- Leader keys (must be set before any mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Auto cmd
require("autocmd.italicize")

-- General options (no plugin dependencies)
require("core.options")

-- Plugin loader: adds start/ plugins to rtp, runs configs, sets up lazy-loading
require("core.pack-loader").setup()

-- Keymaps (cmd-based mappings work through pack-loader's command shadowing)
require("core.keymap")

-- Neovide GUI settings
require("core.neovide")

vim.filetype.add({
    extension = {
        c3 = "c3",
        c3i = "c3"
    },
})

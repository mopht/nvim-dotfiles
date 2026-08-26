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
    kk = "koka",
    pl = 'prolog',
    idr = "idris2",
    mbt = "moonbit"
  },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "koka",
    callback = function() pcall(vim.treesitter.start) end,
})

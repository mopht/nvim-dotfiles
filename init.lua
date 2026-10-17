-- ============================================================================
-- init.lua — Entry point for native Vim packages (pack/*/start/ + opt/)
-- Migrated from lazy.nvim to Neovim's built-in :h vim.pack
-- ============================================================================

vim.loader.enable()

-- Leader keys (must be set before any mappings)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.autocmds")
require("config.options")
require("plugins.loader").setup()
require("config.keymaps")
require("config.neovide")

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

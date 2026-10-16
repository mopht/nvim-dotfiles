-- ============================================================================
-- init.lua — Entry point for native Vim packages (pack/*/start/ + opt/)
-- Migrated from lazy.nvim to Neovim's built-in :h packages
-- ============================================================================

-- Leader keys (must be set before any mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- One-time migration to the new layout. After it succeeds, the sentinel file
-- exists and this block becomes a no-op.
local nvim_config_root = vim.fn.stdpath("config") .. "/lua"
local migrated = nvim_config_root .. "/config/.migrated"
if vim.fn.filereadable(migrated) == 0 then
    pcall(require, "bootstrap")
end

if vim.fn.filereadable(migrated) == 1 then
    require("config.autocmds")
    require("config.options")
    require("plugins.loader").setup()
    require("config.keymaps")
    require("config.neovide")
else
    -- Fallback for a failed migration.
    require("autocmd.italicize")
    require("core.options")
    require("core.pack-loader").setup()
    require("core.keymap")
    require("core.neovide")
end



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

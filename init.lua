-- ============================================================================
-- init.lua — Entry point
-- Migrated from lazy.nvim to Neovim's built-in :h vim.pack
-- ============================================================================

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("pack").setup()

require("config.highlights")
require("config.keymaps")
require("config.neovide")

-- tabstop / shiftwidth / expandtab come from lua/config/options.lua.
-- softtabstop is not set globally, and it is what makes <BS> in insert mode
-- step back a whole indent, so keep it here for Haskell.
vim.bo.softtabstop = 4

-- Winbar breadcrumbs from LSP / treesitter. Replaces barbecue + nvim-navic.
--
-- No config function: the plugin ships plugin/dropbar.lua, which calls
-- setup() on the first FileType, so it is already lazy and needs no opts.
return {
    { name = "dropbar.nvim", src = "Bekaboo/dropbar.nvim", lazy = false },
}

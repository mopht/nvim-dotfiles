-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true

-- anti warp
vim.opt.wrap = false
-- vim.opt.cursorline = true

-- enable mouse
vim.opt.mouse:append("a")

vim.opt.clipboard:append("unnamedplus")

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wildoptions = "pum"
vim.opt.winblend = 30
vim.opt.pumblend = 23
vim.opt.pumheight = 12
vim.opt.background = "dark"
-- The theme is applied centrally in lua/config/colorscheme.lua (after VimEnter,
-- when plugins are already on the rtp). To change it, edit the colorscheme field
-- in lua/plugins/ui/colorscheme.lua

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovim is always UTF-8; only the file encoding is worth setting
vim.opt.fileencoding = "utf-8"

vim.opt.backup = false

vim.opt.laststatus = 2
vim.opt.fillchars = { vert = " ", eob = " " }

-- Fold settings live in lua/config/treesitter.lua (window-local, so they are set
-- together with foldexpr)

vim.g.everforest_enable_italic = true

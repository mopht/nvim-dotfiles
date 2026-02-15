-- local opt = vim.opt

-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.ai = true
vim.opt.si = true

-- anti warp
vim.opt.wrap = false
vim.opt.cursorline = true

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
-- vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[colorscheme catppuccin]])
-- vim.cmd[[noicedisable]]
-- vim.cmd.colorscheme "catppuccin"
-- vim.cmd[[colorscheme embark]]
vim.cmd.colorscheme "everforest"
-- require('onedark').load()
-- opt.guifont = {"Operator Mono Lig", ":h25" }

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.cmd('autocmd!')

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.backup = false

vim.opt.laststatus = 2

vim.opt.fillchars = { vert = " ", eob = " " }

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

vim.g.everforest_enable_italic = true

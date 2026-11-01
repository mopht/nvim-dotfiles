-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- no wrap
vim.opt.wrap = false

-- enable mouse
vim.opt.mouse = "a"

vim.opt.clipboard:append "unnamedplus"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 4
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.wildoptions = "pum"
vim.opt.winblend = 30
vim.opt.pumblend = 23
vim.opt.pumheight = 12
-- Theme: lua/plugins/ui/colorscheme.lua, applied by lua/load/init.lua

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- moonbit.nvim is lazy, so its ftdetect is not on the runtimepath yet
vim.filetype.add {
    extension = { mbt = "moonbit", mbti = "moonbit" },
    filename = {
        ["moon.mod"] = "moonbit",
        ["moon.pkg"] = "moonbit",
        ["moon.work"] = "moonbit",
    },
}

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.undofile = true

vim.opt.laststatus = 2
vim.opt.fillchars = { vert = " ", eob = " " }

-- Folds: lua/config/treesitter.lua

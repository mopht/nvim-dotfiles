-- local opt = vim.opt

-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- 缩进
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
-- 自动缩进
vim.opt.ai = true
-- 智能缩进
vim.opt.si = true

-- 防止包裹
vim.opt.wrap = false

-- 光标行
vim.opt.cursorline = true

-- 启用鼠标
vim.opt.mouse:append("a")

-- 系统剪板
vim.opt.clipboard:append("unnamedplus")

-- 默认新窗口右和下
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 外
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

-- 到时候插件要安装文件管理器 nvim-tree，所以需要在文件的开头禁用 netrw
-- = 1 是告诉Neovim netrw 已经载入了，不需要再载入
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 清除所有之前定义的 autocmd 并从干净的状态开始
-- vim.cmd('autocmd!')

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 禁止Neovim自动生成备份文件
vim.opt.backup = false

vim.opt.laststatus = 2

-- 把填充缓冲区空行的"~"换成空格
vim.opt.fillchars = { vert = " ", eob = " " }

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99
vim.g.everforest_enable_italic = true

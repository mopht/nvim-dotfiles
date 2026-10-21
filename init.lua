vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("load.init").setup()
require("config.highlights")
require("config.keymaps")
require("config.neovide")

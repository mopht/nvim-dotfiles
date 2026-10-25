vim.loader.enable()

vim.g.mapleader = " "

require("config.options")
require("load.init").setup()
require("config.highlights")
require("config.keymaps")
require("config.neovide")

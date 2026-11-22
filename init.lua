vim.loader.enable()

require("vim._core.ui2").enable()

vim.o.cmdheight = 0
vim.g.mapleader = " "

require "config.options"
require "load.init" .setup()
require "config.highlights"
require "config.keymaps"
require "config.neovide"

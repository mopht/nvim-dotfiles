if not vim.g.neovide then return end

local blur = 0.45

vim.o.guifont = "Operator Mono Lig, Maple Mono NF:h20:#e-subpixelantialias"
vim.opt.linespace = 10

vim.g.neovide_opacity = blur
vim.g.neovide_normal_opacity = blur
vim.g.neovide_window_blurred = true

vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_fullscreen = false
vim.g.neovide_floating_shadow = true

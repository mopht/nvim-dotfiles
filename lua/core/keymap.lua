-- local keymap = vim.keymap

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>=", ":lua vim.lsp.buf.format { async = true }<CR>")

vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<C-o>", "<cmd>lua vim.diagnostic.open_float()<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")

vim.keymap.set("n", "tl", "<cmd>TodoLocList toggle<cr>")

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")
vim.keymap.set("n", "sl", ":bnext<CR>")
vim.keymap.set("n", "sh", ":bprevious<CR>")

vim.keymap.set("n", "nl", ":nohl<CR>")
vim.keymap.set("n", "<leader>bp", ":BufferLinePickClose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<F7>", ":FloatermNew --height=0.8 --width=0.8 --wintype=float <CR>")
vim.keymap.set("n", "<F8>", ":ToggleTerm size=10 <CR>")

vim.keymap.set("n", "<F11>", ":RunCode<CR>")

vim.keymap.set("n", "xx", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
vim.keymap.set("n", "cs", "<cmd>Trouble symbols toggle focus=false<cr>")
vim.keymap.set("n", "cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")
vim.keymap.set("n", "xL", "<cmd>Trouble loclist toggle<cr>")
vim.keymap.set("n", "xQ", "<cmd>Trouble qflist toggle<cr>")

vim.keymap.set("n", "<leader>oo", "<cmd>SymbolsOutline<cr>")

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>")

-- vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>")
-- vim.keymap.set("n", "<leader>fd", "<cmd>TodoTelescope<cr>")

-- vim.keymap.set("n", "<leader>fm", "<cmd>FloatermNew --height=0.8 --width=0.8 --wintype=float<cr>")
-- vim.keymap.set("n", "<leader>fn", "<cmd>ToggleTerm direction=float<cr>")
vim.keymap.set("n", "<leader>fn", "<cmd>lua _NUSHELL_TOGGLE()<cr>")
vim.keymap.set("n", "<leader>fm", "<cmd>lua _LAZYGIT_TOGGLE()<cr>");

vim.keymap.set("n", "<leader>he", "<cmd>Haskell hls evalAll<cr>")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.g.mapleader = " "

-- Formatting
vim.keymap.set("n", "<leader>=", ":lua vim.lsp.buf.format { async = true }<CR>", { desc = "Format buffer" })

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<C-o>", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostics float" })

-- Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })

-- Buffers / search
vim.keymap.set("n", "sl", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "sh", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "nl", ":nohl<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>bp", ":BufferLinePickClose<CR>", { noremap = true, silent = true, desc = "Close buffer pick" })

-- Explorer
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle explorer" })

-- Todo
vim.keymap.set("n", "tl", "<cmd>TodoLocList toggle<cr>", { desc = "Todo location list" })

-- Trouble
vim.keymap.set("n", "xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
vim.keymap.set("n", "xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble buffer diagnostics" })
vim.keymap.set("n", "cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble symbols" })
vim.keymap.set("n", "cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble LSP" })
vim.keymap.set("n", "xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble location list" })
vim.keymap.set("n", "xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble quickfix" })

-- Runner / tools
vim.keymap.set("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true, desc = "Toggle compiler results" })
vim.keymap.set("n", "<F11>", ":RunCode<CR>", { desc = "Run code" })
vim.keymap.set("n", "<leader>he", "<cmd>Haskell hls evalAll<cr>", { desc = "Haskell evaluate all" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Fuzzy finder and terminal keymaps are lazily registered by plugins/registry.lua (snacks.nvim)

-- leader is set in init.lua

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>o", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostics float" })

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

-- Tools. Plugin keys live in their specs; `-` opens Oil.
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

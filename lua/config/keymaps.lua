-- leader is set in init.lua

-- -- -- LSP
-- -- K stays native outside LSP buffers, so help/man keyword lookup still works
vim.keymap.set('n', 'K', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        vim.lsp.buf.hover()
    else
        vim.cmd('normal! K')
    end
end, { desc = "LSP hover or keyword prg" })

vim.keymap.set("n", "<leader>o", vim.diagnostic.open_float, { desc = "Diagnostics float" })

-- Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })

-- Buffers / search
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>n", ":nohl<CR>", { desc = "Clear search highlight" })

-- Tools. Plugin keys live in their specs; `-` opens Oil.
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

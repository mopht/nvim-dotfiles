return {
    { "folke/trouble.nvim", lazy = true, cmd = { "Trouble" },
    keys = {
        { "<leader>xx", mode = "n", desc = "Trouble diagnostics",
            action = function() vim.cmd("Trouble diagnostics toggle") end },
        { "<leader>xX", mode = "n", desc = "Trouble buffer diagnostics",
            action = function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end },
        { "<leader>xs", mode = "n", desc = "Trouble symbols",
            action = function() vim.cmd("Trouble symbols toggle focus=false") end },
        { "<leader>xL", mode = "n", desc = "Trouble LSP",
            action = function() vim.cmd("Trouble lsp toggle focus=false win.position=right") end },
        { "<leader>xl", mode = "n", desc = "Trouble location list",
            action = function() vim.cmd("Trouble loclist toggle") end },
        { "<leader>xq", mode = "n", desc = "Trouble quickfix",
            action = function() vim.cmd("Trouble qflist toggle") end },
    },
    opts = {} },
}

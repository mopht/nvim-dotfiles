return {
    { name = "trouble.nvim", src = "folke/trouble.nvim", lazy = true, cmd = { "Trouble" },
    keys = {
        { "xx", mode = "n", action = function() vim.cmd("Trouble diagnostics toggle") end, desc = "Trouble diagnostics" },
        { "xX", mode = "n", action = function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end, desc = "Trouble buffer diagnostics" },
        { "cs", mode = "n", action = function() vim.cmd("Trouble symbols toggle focus=false") end, desc = "Trouble symbols" },
        { "cl", mode = "n", action = function() vim.cmd("Trouble lsp toggle focus=false win.position=right") end, desc = "Trouble LSP" },
        { "xL", mode = "n", action = function() vim.cmd("Trouble loclist toggle") end, desc = "Trouble location list" },
        { "xQ", mode = "n", action = function() vim.cmd("Trouble qflist toggle") end, desc = "Trouble quickfix" },
    },
    opts = {} },
}

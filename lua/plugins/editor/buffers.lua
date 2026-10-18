return {
    { name = "vim-better-whitespace", src = "ntpeters/vim-better-whitespace", lazy = true, event = { "BufEnter" } },
    { name = "todo-comments.nvim",    src = "folke/todo-comments.nvim",       lazy = true, event = { "BufEnter" },
      keys = { {"tl", mode = "n", action = function() vim.cmd("TodoLocList toggle<cr>") end, desc = "Todo location list" } },
    config = function() require("todo-comments").setup({}) end },
    { name = "auto-save.nvim",        src = "okuuva/auto-save.nvim",          lazy = true, event = { "InsertEnter" },
    config = function()
        require("auto-save").setup({ condition = function(buf)
            if vim.fn.getbufvar(buf, "&buftype") == "acwrite" then return false end
            return true
        end, })
    end },
}

return {
    { name = "vim-better-whitespace", src = "ntpeters/vim-better-whitespace", lazy = true, event = { "BufEnter" } },
    { name = "todo-comments.nvim",    src = "folke/todo-comments.nvim",       lazy = true, event = { "BufEnter" },
      keys = {
          { "tl", mode = "n", action = function() vim.cmd("TodoLocList toggle<cr>") end, desc = "Todo location list" },
      },
      opts = {} },
    { name = "auto-save.nvim",        src = "okuuva/auto-save.nvim",          lazy = true, event = { "InsertEnter" },
    opts = {
        condition = function(buf)
            return vim.fn.getbufvar(buf, "&buftype") ~= "acwrite"
        end,
    } },
}

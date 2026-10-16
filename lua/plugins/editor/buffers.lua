local M = {
    { name = "auto-save.nvim", src = "okuuva/auto-save.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("auto-save").setup({}) end },
    { name = "vim-better-whitespace", src = "ntpeters/vim-better-whitespace", pack = "opt", event = { "BufEnter" },
    config = nil },
    { name = "todo-comments.nvim", src = "folke/todo-comments.nvim", pack = "opt", event = { "BufEnter" },
    config = function()
        local spec = require("plugins.specs.todo-comments")
        require("todo-comments").setup(spec.opts or {})
    end },
}

return M

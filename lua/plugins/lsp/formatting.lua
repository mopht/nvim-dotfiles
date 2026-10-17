local M = {
    { name = "none-ls.nvim", src = "nvimtools/none-ls.nvim", pack = "opt", event = { "LspAttach" },
    config = function()
        vim.cmd("packadd none-ls-extras.nvim")
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- null_ls.builtins.formatting.stylua,
                -- null_ls.builtins.completion.spell,
                require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
            },
        })
    end },
    { name = "none-ls-extras.nvim", src = "nvimtools/none-ls-extras.nvim", pack = "opt" },
}

return M

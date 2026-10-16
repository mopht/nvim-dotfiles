local M = {
    { name = "moonbit.nvim", src = "moonbit-community/moonbit.nvim", pack = "opt", ft = "moonbit",
    config = function()
        require("moonbit").setup({
            mooncakes = {
                virtual_text = true,
                use_local = true,
            },
            treesitter = {
                enabled = true,
                auto_install = true,
            },
            lsp = {
                native = true,
                on_attach = function(client, bufnr) end,
                capabilities = vim.lsp.protocol.make_client_capabilities(),
            },
            jsonls = {
                settings = {},
            },
        })
    end },
}

return M

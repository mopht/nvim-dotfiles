return {
    { name = "moonbit.nvim", src = "moonbit-community/moonbit.nvim", lazy = true, ft = "moonbit",
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
                on_attach = function() end,
                capabilities = vim.lsp.protocol.make_client_capabilities(),
            },
            jsonls = {
                settings = {},
            },
        })
    end },
}

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

    { name = "idris2-nvim", src = "ShinKage/idris2-nvim", pack = "opt", ft = "idris",
    config = function() require("idris2-nvim").setup() end },

    { name = "koka.nvim", src = "syaiful6/koka.nvim", pack = "opt", ft = "koka" },

    { name = "haskell-tools.nvim", src = "mrcjkb/haskell-tools.nvim", pack = "start",
    config = nil },

    { name = "rustaceanvim", src = "mrcjkb/rustaceanvim", pack = "start" },
}

return M

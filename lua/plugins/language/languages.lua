return {
    -- The module is `idris2`, not `idris2-nvim`
    { name = "idris2-nvim", src = "ShinKage/idris2-nvim", lazy = true, ft = "idris",
    main = "idris2", opts = {} },

    { name = "koka.nvim", src = "syaiful6/koka.nvim", lazy = true, ft = "koka" },

    { name = "haskell-tools.nvim", src = "mrcjkb/haskell-tools.nvim", lazy = false,
    config = function()
        vim.keymap.set("n", "<leader>he", "<cmd>Haskell hls evalAll<cr>", { desc = "Haskell evaluate all" })
    end },

    { name = "rustaceanvim", src = "mrcjkb/rustaceanvim", lazy = false },

    { name = "moonbit.nvim", src = "moonbit-community/moonbit.nvim", lazy = true,
    ft = "moonbit",
    opts = {
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
    } },
}

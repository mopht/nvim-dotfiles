return {
    -- The module is `idris2`, not `idris2-nvim`
    { "ShinKage/idris2-nvim", lazy = true, ft = { "idris2", "lidris2" },
    main = "idris2", opts = {} },

    { "syaiful6/koka.nvim", lazy = true, ft = "koka" },

    { "mrcjkb/haskell-tools.nvim", lazy = false,
    config = function()
        vim.keymap.set("n", "<leader>he", "<cmd>Haskell hls evalAll<cr>", { desc = "Haskell evaluate all" })
    end },

    { "mrcjkb/rustaceanvim", lazy = false },

    { "moonbit-community/moonbit.nvim", lazy = true,
    ft = "moonbit",
    -- also load for the json manifests, so mooncakes and the schema apply there
    event = { "BufRead moon.mod.json", "BufRead moon.pkg.json" },
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
                capabilities = vim.lsp.protocol.make_client_capabilities(),
            },
        })
    end },
}

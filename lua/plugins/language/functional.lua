return {
    -- The module is `idris2`, not `idris2-nvim`
    { name = "idris2-nvim", src = "ShinKage/idris2-nvim", lazy = true, ft = "idris",
    main = "idris2",
    opts = {} },
    { name = "koka.nvim", src = "syaiful6/koka.nvim", lazy = true, ft = "koka" },
    { name = "haskell-tools.nvim", src = "mrcjkb/haskell-tools.nvim", lazy = false,
    config = function()
        vim.keymap.set("n", "<leader>he", "<cmd>Haskell hls evalAll<cr>", { desc = "Haskell evaluate all" })
    end },
}

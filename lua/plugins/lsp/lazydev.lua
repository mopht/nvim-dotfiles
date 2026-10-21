return {
    -- Loaded at startup: blink.cmp resolves the provider module eagerly
    { name = "lazydev.nvim", src = "folke/lazydev.nvim", lazy = false,
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },
}

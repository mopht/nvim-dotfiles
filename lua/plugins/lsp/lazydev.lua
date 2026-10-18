return {
    -- Keep lazydev loaded at startup: blink.cmp resolves the provider module
    -- eagerly, so lazy-loading it on ft=lua can make the module unavailable.
    { name = "lazydev.nvim", src = "folke/lazydev.nvim", lazy = false,
    opts = {
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    } },
}

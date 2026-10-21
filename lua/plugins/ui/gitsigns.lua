-- Git signs, loaded on the first buffer read.
return {
    { name = "gitsigns.nvim", src = "lewis6991/gitsigns.nvim", lazy = true,
    event = { "BufReadPre", "BufNewFile" }, opts = {} },
}

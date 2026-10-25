-- Git signs, loaded on the first buffer read.
return {
    { "lewis6991/gitsigns.nvim", lazy = true,
    event = { "BufReadPre", "BufNewFile" }, cmd = { "Gitsigns" }, opts = {} },
}

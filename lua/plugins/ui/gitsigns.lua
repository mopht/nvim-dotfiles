-- Git signs in the sign column. Loaded on the first buffer read (the trigger
-- gitsigns recommends); the git work itself is async and does not block.
-- If even that ~3ms matters, switch the event to "CursorHold" to load it only
-- once the editor is idle.
return {
    { name = "gitsigns.nvim", src = "lewis6991/gitsigns.nvim", lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {} },
}

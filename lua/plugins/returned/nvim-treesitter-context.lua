return {
    "romgrk/nvim-treesitter-context",
    -- lazy = true,
    -- event = { "User FileOpened" },
    opts = {
        enable = true,
        throttle = true,
        max_lines = 0,
        patterns = {
            default = {
                "class",
                "function",
                "method",
            },
        },
        show_brackets = false,
    }

}

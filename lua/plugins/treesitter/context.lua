local nvim_treesitter_context_opts = {
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

return {
    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", lazy = false,
    main = "treesitter-context", opts = nvim_treesitter_context_opts },

    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim", lazy = false },
}

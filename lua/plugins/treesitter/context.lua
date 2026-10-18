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
    config = function() require("treesitter-context").setup(nvim_treesitter_context_opts) end },
    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim", lazy = false },
}

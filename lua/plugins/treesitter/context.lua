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

local M = {
    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", pack = "start",
    config = function() require("treesitter-context").setup(nvim_treesitter_context_opts) end },
    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim", pack = "start" },
}

return M

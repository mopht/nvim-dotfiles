local M = {
    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", pack = "start",
    config = function()
        local spec = require("plugins.specs.nvim-treesitter-context")
        require("treesitter-context").setup(spec.opts or {})
    end },
    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim", pack = "start" },
}

return M

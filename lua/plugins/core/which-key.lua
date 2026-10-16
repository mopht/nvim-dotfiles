local M = {
    { name = "which-key.nvim",    src = "folke/which-key.nvim",         pack = "start",
    config = function()
        require("which-key").setup(require("plugins.specs.which-key").opts or {})
    end },
}

return M

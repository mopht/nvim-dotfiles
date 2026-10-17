local M = {
    { name = "nvim-lspconfig", src = "neovim/nvim-lspconfig", pack = "start",
    config = function()
        local spec = require("plugins.specs.nvim-lspconfig")
        if spec.config then spec.config() end
    end },
}

return M

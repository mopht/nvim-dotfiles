local M = {
    { name = "none-ls.nvim", src = "nvimtools/none-ls.nvim", pack = "opt", event = { "LspAttach" },
    config = function()
        vim.cmd("packadd none-ls-extras.nvim")
        local spec = require("plugins.specs.none-ls")
        if spec.config then spec.config() end
    end },
    { name = "none-ls-extras.nvim", src = "nvimtools/none-ls-extras.nvim", pack = "opt" },
}

return M

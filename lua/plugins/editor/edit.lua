local M = {
    { name = "better-escape.nvim", src = "max397574/better-escape.nvim", pack = "opt", event = { "InsertEnter" },
    config = function()
        require("better_escape").setup(require("plugins.specs.better-escape").opts)
    end },
    { name = "nvim-autopairs", src = "windwp/nvim-autopairs", pack = "opt", event = { "InsertEnter" },
    config = function()
        local spec = require("plugins.specs.autopairs")
        if spec.config then spec.config() end
    end },
    { name = "tabout.nvim", src = "abecodes/tabout.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("tabout").setup(require("plugins.specs.tabout").opts) end },
}

return M

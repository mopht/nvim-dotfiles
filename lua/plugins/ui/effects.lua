local M = {
    { name = "noice.nvim", src = "folke/noice.nvim", pack = "start",
    config = function()
        local spec = require("plugins.specs.noice")
        require("noice").setup(spec.opts or {})
    end },
}

return M

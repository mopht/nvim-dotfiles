local M = {
    { name = "trouble.nvim", src = "folke/trouble.nvim", pack = "opt", cmd = { "Trouble" },
    config = function()
        local spec = require("plugins.specs.trouble")
        require("trouble").setup(spec.opts or {})
    end },
}

return M

local M = {
    { name = "lualine.nvim", src = "nvim-lualine/lualine.nvim", pack = "start",
    config = function()
        local spec = require("plugins.specs.lualine")
        require("lualine").setup(spec.opts or {})
    end },

    { name = "barbecue", src = "utilyre/barbecue.nvim", pack = "start",
    config = function()
        local spec = require("plugins.specs.barbecue")
        require("barbecue").setup(spec.opts or {})
    end },

    { name = "hlchunk.nvim", src = "shellRaining/hlchunk.nvim", pack = "start",
    config = function()
        local spec = require("plugins.specs.hlchunk")
        require("hlchunk").setup(spec.opts or {})
    end },

    { name = "noice.nvim", src = "folke/noice.nvim", pack = "start",
    config = function()
        local spec = require("plugins.specs.noice")
        require("noice").setup(spec.opts or {})
    end },
}

return M

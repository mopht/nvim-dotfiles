local M = {
    { name = "neo-tree.nvim", src = "nvim-neo-tree/neo-tree.nvim", pack = "opt", cmd = { "Neotree" },
    config = function()
        require("plugins.specs.neo-tree")
        require("plugins.specs.nui")
    end },
}

return M

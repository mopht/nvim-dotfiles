local M = {
    { name = "neo-tree.nvim", src = "nvim-neo-tree/neo-tree.nvim", pack = "opt", cmd = { "Neotree" },
    config = function()
        require("plugins.specs.neo-tree")
        require("plugins.specs.nui")
    end },

    { name = "vim-tmux-navigator", src = "christoomey/vim-tmux-navigator", pack = "opt",
    keys = {
        { "<C-h>", desc = "Window left" },
        { "<C-j>", desc = "Window down" },
        { "<C-k>", desc = "Window up" },
        { "<C-l>", desc = "Window right" },
    },
    config = nil },
}

return M

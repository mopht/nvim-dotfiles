local which_key_opts = {
    preset = "helix",
    delay = 120,
    layout = {
        spacing = 2,
    },
    icons = {
        mappings = true,
        colors = true,
    },
    show_help = false,
    show_keys = false,
}

-- Group labels for leader prefixes that are not mapped themselves
local groups = {
    { "<leader>r", group = "run" },
}

return {
    { name = "which-key.nvim",    src = "folke/which-key.nvim",         lazy = false,
    opts = which_key_opts,
    config = function() require("which-key").add(groups) end },
}

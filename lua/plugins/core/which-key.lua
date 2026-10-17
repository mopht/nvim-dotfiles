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

return {
    { name = "which-key.nvim",    src = "folke/which-key.nvim",         pack = "start",
    config = function() require("which-key").setup(which_key_opts) end },
}

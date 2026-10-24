local which_key_opts = {
    preset = "helix",
    delay = 280,
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
    { name = "which-key.nvim",    src = "folke/which-key.nvim",         lazy = false,
    opts = which_key_opts },
}

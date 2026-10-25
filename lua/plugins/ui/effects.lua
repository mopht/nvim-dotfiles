local noice_opts = {
    cmdline = { view = "cmdline" },
    lsp = { signature = { enabled = false } },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
    },
}

-- noice must be ready before the first message
return {
    { "folke/noice.nvim", lazy = false, opts = noice_opts },
}

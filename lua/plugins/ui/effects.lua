local noice_opts = {
    cmdline = {
        enabled = true,
        view = "cmdline",
    },
    lsp = {
        progress = {
            enabled = true,
        },
        signature = {
            enabled = false,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
    messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
    },
    health = {
        -- checker = true,
    },
    -- vim.cmd [[NoiceDisable]]
}

-- noice has no natural trigger (it has to be ready before the first message),
-- so `lazy = false` even though lz.n would currently treat a trigger-less spec
-- as eager anyway
return {
    { name = "noice.nvim", src = "folke/noice.nvim", lazy = false,
    opts = noice_opts },
}

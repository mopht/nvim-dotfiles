return {
    "folke/noice.nvim",
    -- lazy = true,
    -- cmd = "NoiceDisable",

    opts = {
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
    },

    event = "VeryLazy",
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
    },
}

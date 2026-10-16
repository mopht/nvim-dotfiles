return {
    "max397574/better-escape.nvim",
    event = "InsertEnter",

    opts = {
        default_mappings = false,
        mappings = {
            i = {
                j = {
                    -- These can all also be functions
                    k = "<Esc>",
                    j = "<Esc>"
                },
            },
        },
    }
}

return {
    opts = {
        -- explorer = { enabled = true },
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        image = { enabled = true },
        lazygit = {enabled = true },
        indent = {
            enabled = true,
            scope = { enabled = true, },
            chunk = {
                enabled = true,
                char = {
                    corner_top = "╭",
                    corner_bottom = "╰",
                }
            },
        },
        picker = {
            enabled = true,
            layout = {
                preset = "default",
                layout = {
                    width = 0.85,
                    min_width = 70,
                },
            },
        },
        terminal = {
            win = {
                style = "terminal",
            },
        },
    },
}

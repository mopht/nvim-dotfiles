return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        line_num = {
            enable = true
        },
        indent = {
            enable = true
        },
        chunk = {
            enable = true,
        },
    }
}

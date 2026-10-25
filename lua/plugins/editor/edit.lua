local better_escape_opts = {
    mappings = {
        i = { j = { j = "<Esc>", k = "<Esc>" } },
    },
}

return {
    { "max397574/better-escape.nvim", lazy = true,
    event = { "InsertEnter" }, main = "better_escape", opts = better_escape_opts },

    { "abecodes/tabout.nvim", lazy = true,
    event = { "InsertEnter" }, opts = {} },

    { "windwp/nvim-autopairs", lazy = true,
    event = { "InsertEnter" },
    opts = {
        check_ts = true,
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
        },
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = [=[[%'%"%)%>%]%)%}%,]]=],
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "Search",
            highlight_grey = "Comment",
        },
    } },

    { "NMAC427/guess-indent.nvim", lazy = true,
    cmd = { "GuessIndent" }, opts = {} },
}

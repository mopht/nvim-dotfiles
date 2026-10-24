local better_escape_opts = {
    mappings = {
        i = { j = { j = "<Esc>", k = "<Esc>" } },
    },
}

return {
    { name = "better-escape.nvim", src = "max397574/better-escape.nvim", lazy = true,
    event = { "InsertEnter" }, main = "better_escape", opts = better_escape_opts },

    { name = "tabout.nvim",        src = "abecodes/tabout.nvim",  lazy = true,
    event = { "InsertEnter" }, opts = {} },

    { name = "nvim-autopairs",     src = "windwp/nvim-autopairs", lazy = true,
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

    { name = "guess-indent.nvim", src = "NMAC427/guess-indent.nvim", lazy = true,
    cmd = { "GuessIndent" }, opts = {} },

    { name = "twilight.nvim",     src = "folke/twilight.nvim",       lazy = true,
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" }, opts = {} },

    { name = "zen-mode.nvim",     src = "folke/zen-mode.nvim",       lazy = true,
    cmd = { "ZenMode" },     opts = {} },
}

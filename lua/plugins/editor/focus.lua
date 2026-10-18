return {
    { name = "guess-indent.nvim", src = "NMAC427/guess-indent.nvim", lazy = true, cmd = { "GuessIndent" },
    config = function() require("guess-indent").setup({}) end },
    { name = "twilight.nvim", src = "folke/twilight.nvim", lazy = true, cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function() require("twilight").setup({}) end },
    { name = "zen-mode.nvim", src = "folke/zen-mode.nvim", lazy = true, cmd = { "ZenMode" },
    config = function() require("zen-mode").setup({}) end },
}

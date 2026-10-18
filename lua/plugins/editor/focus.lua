return {
    { name = "guess-indent.nvim", src = "NMAC427/guess-indent.nvim", pack = "opt", cmd = { "GuessIndent" },
    config = function() require("guess-indent").setup({}) end },
    { name = "twilight.nvim", src = "folke/twilight.nvim", pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function() require("twilight").setup({}) end },
    { name = "zen-mode.nvim", src = "folke/zen-mode.nvim", pack = "opt", cmd = { "ZenMode" },
    config = function() require("zen-mode").setup({}) end },
}

return {
    { name = "idris2-nvim", src = "ShinKage/idris2-nvim", pack = "opt", ft = "idris",
    config = function() require("idris2-nvim").setup() end },
    { name = "koka.nvim", src = "syaiful6/koka.nvim", pack = "opt", ft = "koka" },
    { name = "haskell-tools.nvim", src = "mrcjkb/haskell-tools.nvim", pack = "start",
    config = nil },
}

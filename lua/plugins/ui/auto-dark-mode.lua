-- Follow the system dark/light appearance (XDG desktop portal on Linux; falls
-- back to "dark" when detection fails). The default hooks only set
-- 'background'; everforest reloads from there.
return {
    { "f-person/auto-dark-mode.nvim", lazy = false, opts = {} },
}

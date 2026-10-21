-- Force italics on the groups below, whatever colorscheme is active.
--
-- Colorschemes redefine highlight groups, so this cannot run only once: it has
-- to be reapplied on ColorScheme, otherwise everything except the theme's own
-- italic groups (keywords/comments) loses italics after :colorscheme <theme>.
-- UIEnter covers the startup path: the theme is applied during init, before
-- this file registers its ColorScheme listener, so the first application is
-- missed and UIEnter catches up once the UI is attached.

local GROUPS = {
    "@keyword", "@keyword.function", "@keyword.return", "@keyword.repeat",
    "@keyword.operator", "@keyword.import", "@keyword.conditional",
    "@conditional", "@repeat", "@keyword.exception",
    "Keyword", "Conditional", "Repeat",
    "@string", "@number", "@type", "Type",
    "@variable.member", "@module", "@boolean",
    "@constructor", "@constant",
}

local function apply_italics()
    for _, group in ipairs(GROUPS) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok then
            hl.italic = true
            vim.api.nvim_set_hl(0, group, hl --[[@as vim.api.keyset.highlight]])
        end
    end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, {
    callback = apply_italics,
    desc = "keep the custom italic groups across colorscheme switches",
})

-- the theme is already applied when this file loads, so apply once immediately
-- instead of waiting for the first ColorScheme/UIEnter
apply_italics()

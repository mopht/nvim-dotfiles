-- Italics for the groups below. Reapplied on ColorScheme, plus once at load.

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

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = apply_italics,
    desc = "keep the custom italic groups across colorscheme switches",
})

-- the theme is already applied when this file loads, so apply once immediately
-- instead of waiting for the first ColorScheme
apply_italics()

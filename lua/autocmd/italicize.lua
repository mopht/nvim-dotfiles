vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        local groups = {
            "@keyword", "@keyword.function", "@keyword.return", "@keyword.repeat",
            "@keyword.operator", "@keyword.import", "@keyword.conditional",
            "@conditional", "@repeat", "@keyword.exception",
            "Keyword", "Conditional", "Repeat",
            "@string", "@number", "@type", "Type",
            "@variable.member", "@module", "@boolean"
        }
        for _, group in ipairs(groups) do
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
            if ok then
                hl.italic = true
                vim.api.nvim_set_hl(0, group, hl)
            end
        end
    end,
})

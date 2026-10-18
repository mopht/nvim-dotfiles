-- Keep the statusline background transparent, but leave mode groups alone so
-- NORMAL / INSERT / VISUAL keep their colored badge.
local function apply_transparency()
    local groups = {
        "StatusLine",
        "StatusLineNC",
        "MiniStatuslineDevinfo",
        "MiniStatuslineFilename",
        "MiniStatuslineFileinfo",
        "MiniStatuslineInactive",
    }

    for _, name in ipairs(groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if ok then
            hl.bg = nil
            hl.ctermbg = nil
            vim.api.nvim_set_hl(0, name, hl)
        end
    end
end

local function file_info()
    local ft = vim.bo.filetype
    local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.bo.encoding
    local icon = ""

    if _G.MiniIcons ~= nil and ft ~= "" then
        icon = MiniIcons.get("filetype", ft) .. " "
    end

    local parts = {}
    if ft ~= "" then
        table.insert(parts, icon .. ft)
    end
    if enc ~= "" then
        table.insert(parts, enc)
    end

    return table.concat(parts, " ")
end

local function progress()
    local line = vim.fn.line(".")
    local total = math.max(vim.fn.line("$"), 1)
    return math.floor(line / total * 100) .. "%%"
end

local statusline_opts = {
    use_icons = true,
    content = {
        active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
                "%<",
                { hl = "MiniStatuslineFilename", strings = { filename } },
                '%=',
                { hl = "MiniStatuslineFileinfo", strings = { file_info() } },
                { hl = "MiniStatuslineFileinfo", strings = { progress() } },
                { hl = mode_hl, strings = { location } },
            })
        end,
    },
}

return {
    { name = "mini.statusline", src = "nvim-mini/mini.statusline", lazy = false,
    config = function()
        require("mini.statusline").setup(statusline_opts)
        apply_transparency()

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("MiniStatuslineTransparent", { clear = true }),
            callback = apply_transparency,
        })
    end },
}

-- Transparent statusline background; mode groups keep their colors.
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
    local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
    local icon = ""

    local mini_icons = rawget(_G, "MiniIcons")
    if mini_icons ~= nil and ft ~= "" then
        icon = mini_icons.get("filetype", ft) .. " "
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
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local total = math.max(vim.api.nvim_buf_line_count(0), 1)
    return math.floor(line / total * 100) .. "%%"
end

local statusline_opts = {
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
    -- default is 32 ms, which rebuilds the breadcrumbs on nearly every cursor
    -- move while scrolling; 100 ms only delays updates during held-down keys
    { "Bekaboo/dropbar.nvim", lazy = false,
    opts = { bar = { update_debounce = 100 } } },

    { "nvim-mini/mini.statusline", lazy = false,
    opts = statusline_opts,
    config = function()
        apply_transparency()

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("MiniStatuslineTransparent", { clear = true }),
            callback = apply_transparency,
        })
    end },
}

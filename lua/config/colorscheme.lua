-- ============================================================================
-- colorscheme.lua — single entry point for the theme
-- The theme name lives in a plugin spec's colorscheme field,
-- see lua/plugins/colorschemes/
-- ============================================================================

local M = {}

-- Called after all start plugin configs have run, i.e. the theme plugin is set up
function M.apply(specs)
    for _, p in ipairs(specs) do
        if p.pack == "start" and p.colorscheme then
            pcall(vim.cmd.colorscheme, p.colorscheme)
        end
    end
end

return M

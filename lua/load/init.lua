-- ============================================================================
-- load/init.lua — assembly entry point
-- registry specs → vim.pack install → colorscheme → lz.n (eager + lazy)
-- ============================================================================

local M = {}

local registry   = require("load.registry")
local install    = require("load.install")
local spec       = require("load.spec")
local treesitter = require("config.treesitter")

M.plugins = registry.plugins

-- Find the eager colorscheme plugin (lazy = false + colorscheme field).
-- Returns nil if none is found (graceful degradation).
local function find_current_theme(specs)
    for _, p in ipairs(specs) do
        if not p.lazy and p.colorscheme then return p end
    end
end

-- Apply the current theme before lz.n.load() so that:
--   1. No first-frame flash (colorscheme active before any buffer is drawn)
--   2. lazy = false plugins' after() see the correct palette immediately
local function apply_theme(specs)
    local theme = find_current_theme(specs)
    if not theme then return end
    spec.apply_config(theme)

    local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
    if not ok then
        vim.notify(("load: cannot apply theme %q: %s"):format(theme.colorscheme, err), vim.log.levels.ERROR)
    end
end

-- Build lz.n specs for ALL plugins:
--   lazy = false  → lz.n loads them immediately (after theme is applied)
--   lazy = true   → lz.n registers trigger-based deferred loading
-- The theme plugin is skipped: apply_theme() already set it up and applied it.
local function build_lz_specs(specs)
    local result = {}
    for _, p in ipairs(specs) do
        if p.lazy then
            result[#result + 1] = spec.to_lazy(p)
        elseif not p.colorscheme then
            result[#result + 1] = spec.to_eager(p)
        end
    end
    return result
end

function M.setup()
    -- Phase 0: install / register plugins with vim.pack
    install.setup(M.plugins)

    -- Phase 1: apply the current theme immediately (before lz.n.load)
    apply_theme(M.plugins)

    -- Phase 2: load all plugins via lz.n
    -- eager plugins run their after() right now (palette already set)
    -- lazy plugins register their trigger rules
    require("lz.n").load(build_lz_specs(M.plugins))

    -- Phase 3: treesitter folds + highlight auto-start
    treesitter.setup_folds()
    treesitter.auto_highlight()
end

return M

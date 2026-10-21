-- registry -> vim.pack -> theme -> lz.n

local M = {}

local registry   = require("load.registry")
local install    = require("load.install")
local spec       = require("load.spec")
local treesitter = require("config.treesitter")

M.plugins = registry.plugins

-- First eager spec that declares a colorscheme.
local function find_current_theme(specs)
    for _, p in ipairs(specs) do
        if not p.lazy and p.colorscheme then return p end
    end
end

-- Set up and apply the theme before lz.n loads the plugins.
local function apply_theme(specs)
    local theme = find_current_theme(specs)
    if not theme then return end
    spec.apply_config(theme)

    local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
    if not ok then
        vim.notify(("load: cannot apply theme %q: %s"):format(theme.colorscheme, err), vim.log.levels.ERROR)
    end
end

-- Eager specs run their config right away, lazy specs register their triggers.
-- The theme plugin is skipped: apply_theme() already handled it.
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
    -- install / register
    install.setup(M.plugins)

    -- theme
    apply_theme(M.plugins)

    -- load
    require("lz.n").load(build_lz_specs(M.plugins))

    -- treesitter
    treesitter.setup_folds()
    treesitter.auto_highlight()
end

return M

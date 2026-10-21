-- registry -> vim.pack -> theme -> lz.n

local M = {}

local registry   = require("load.registry")
local install    = require("load.install")
local spec       = require("load.spec")
local treesitter = require("config.treesitter")

M.plugins = registry.plugins

-- Build the lz.n specs in registry order and return the eager theme spec.
-- The theme plugin is not passed to lz.n: it is set up separately below.
local function collect(specs)
    local result, theme = {}, nil
    for _, p in ipairs(specs) do
        if p.lazy then
            result[#result + 1] = spec.to_lazy(p)
        elseif p.colorscheme then
            theme = theme or p
        else
            result[#result + 1] = spec.to_eager(p)
        end
    end
    return result, theme
end

-- Set up and apply the theme before lz.n loads the plugins.
local function apply_theme(theme)
    spec.apply_config(theme)

    local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
    if not ok then
        vim.notify(("load: cannot apply theme %q: %s"):format(theme.colorscheme, err), vim.log.levels.ERROR)
    end
end

function M.setup()
    -- install / register
    install.setup(M.plugins)

    local specs, theme = collect(M.plugins)

    -- theme
    if theme then apply_theme(theme) end

    -- load
    require("lz.n").load(specs)

    -- treesitter
    treesitter.setup_folds()
    treesitter.auto_highlight()
end

return M

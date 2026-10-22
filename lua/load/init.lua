-- registry -> vim.pack (install only) -> theme -> lz.n (loads everything)

-- vim.pack no longer loads plugins, so lz.n has to be on the runtimepath
-- before it can load the rest.
vim.pack.add({ "https://github.com/lumen-oss/lz.n" })

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
        if p.colorscheme and not p.lazy then
            theme = theme or p
        else
            result[#result + 1] = spec.to_lz(p)
        end
    end
    return result, theme
end

-- Load, set up and apply the theme before lz.n loads the other plugins.
local function apply_theme(theme)
    vim.cmd.packadd(theme.name)
    spec.apply_config(theme)

    local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
    if not ok then
        vim.notify(("load: cannot apply theme %q: %s"):format(theme.colorscheme, err), vim.log.levels.ERROR)
    end
end

function M.setup()
    -- install / register
    -- lz.n is added above, outside the registry; tell PackClean it is managed
    install.setup(M.plugins, { "lz.n" })

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

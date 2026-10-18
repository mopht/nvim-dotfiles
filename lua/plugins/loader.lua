-- ============================================================================
-- loader.lua — assembly entry point
-- registry specs → vim.pack install → start configs + colorscheme → lz.n lazy
-- ============================================================================

local M = {}
local api = vim.api

local registry = require("plugins.registry")
local pack = require("plugins.pack")
local colorscheme = require("config.colorscheme")
local treesitter = require("config.treesitter")

M.plugins = registry.plugins

-- Turn a registry spec into an lz.n lazy-loading rule
local function to_lazy_spec(p)
    local spec = { p.name }
    if p.event then spec.event = p.event end
    if p.ft then spec.ft = p.ft end
    if p.cmd then spec.cmd = p.cmd end
    if p.pre then spec.before = p.pre end
    -- opt colorscheme plugins load on demand via :colorscheme
    if p.colorscheme then spec.colorscheme = p.colorscheme end

    -- keys: lz.n only takes lhs/mode/desc; mappings with an action are bound in after
    if p.keys then
        local lzn_keys = {}
        for _, k in ipairs(p.keys) do
            table.insert(lzn_keys, { k[1], mode = k.mode, desc = k.desc })
        end
        spec.keys = lzn_keys
    end

    -- after: run config first, then bind the mappings that carry an action
    spec.after = function()
        if p.config then pcall(p.config) end
        if not p.keys then return end

        for _, k in ipairs(p.keys) do
            if k.action then
                vim.keymap.set(k.mode or "n", k[1], k.action, { desc = k.desc })
            end
        end
    end

    return spec
end

-- After VimEnter: theme plugin config → apply theme → other start configs → folds
--
-- The order matters. When :colorscheme runs inside a VimEnter callback, the
-- ColorScheme event does NOT fire non-nested autocommands, so plugins that
-- recompute highlights on ColorScheme (mini.statusline transparency, barbecue
-- winbar colors) must be set up *after* the theme is applied. Otherwise they
-- capture the fallback background.
local function on_vim_enter()
    -- 1) the theme plugin's own config (e.g. everforest.setup) runs before the theme
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and p.colorscheme and p.config then pcall(p.config) end
    end

    -- 2) apply the theme
    colorscheme.apply(M.plugins)

    -- 3) configs of the remaining start plugins; highlights are final by now
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and not p.colorscheme and p.config then pcall(p.config) end
    end

    treesitter.setup_folds()
end

function M.setup()
    -- Phase 0: pre-init hooks of start plugins (plugins are not on the rtp yet)
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and p.pre then pcall(p.pre) end
    end

    -- Phase 1: install / register plugins
    pack.setup(M.plugins)

    -- Phase 2: start plugin configs + colorscheme (runs after VimEnter)
    api.nvim_create_autocmd("VimEnter", { once = true, callback = on_vim_enter })

    -- Phase 3: lazy-loading rules for opt plugins
    local lazy_specs = {}
    for _, p in ipairs(M.plugins) do
        if p.pack == "opt" then table.insert(lazy_specs, to_lazy_spec(p)) end
    end
    require("lz.n").load(lazy_specs)

    -- Phase 4: treesitter highlight auto-start
    treesitter.auto_highlight()
end

return M

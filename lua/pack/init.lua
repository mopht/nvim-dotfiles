-- ============================================================================
-- pack/init.lua — assembly entry point
-- registry specs → vim.pack install → start configs + colorscheme → lz.n lazy
-- ============================================================================

local M = {}
local api = vim.api

local registry    = require("pack.registry")
local install     = require("pack.install")
local colorscheme = require("config.colorscheme")
local treesitter  = require("config.treesitter")

M.plugins = registry.plugins

-- Spec fields lz.n understands as-is
local LAZY_FIELDS = { "event", "ft", "cmd", "colorscheme" }

-- lz.n only takes lhs/mode/desc, so that is all it gets
local function to_lz_keys(keys)
    local lz_keys = {}
    for _, k in ipairs(keys) do
        lz_keys[#lz_keys + 1] = { k[1], mode = k.mode, desc = k.desc }
    end
    return lz_keys
end

-- Bind the mappings that carry their own action, once the plugin has loaded
local function bind_actions(keys)
    for _, k in ipairs(keys) do
        if k.action then
            vim.keymap.set(k.mode or "n", k[1], k.action, { desc = k.desc })
        end
    end
end

-- Turn a registry spec into an lz.n lazy-loading rule
local function to_lazy_spec(p)
    local spec = {
        p.name,
        before = p.pre,
        keys   = p.keys and to_lz_keys(p.keys) or nil,
    }

    for _, field in ipairs(LAZY_FIELDS) do
        spec[field] = p[field]
    end

    -- config first, then the mappings that carry an action
    spec.after = function()
        if p.config then pcall(p.config) end
        if p.keys then bind_actions(p.keys) end
    end

    return spec
end

-- Run the configs of the eager plugins: either the theme ones (set up before
-- the theme is applied) or the rest (set up against the final palette).
--
-- The order matters. When :colorscheme runs inside a VimEnter callback, the
-- ColorScheme event does NOT fire non-nested autocommands, so plugins that
-- recompute highlights on ColorScheme (mini.statusline transparency, dropbar
-- winbar colors) must be set up *after* the theme is applied. Otherwise they
-- capture the fallback background.
local function run_eager_configs(specs, theme_pass)
    for _, p in ipairs(specs) do
        local is_theme = p.colorscheme ~= nil
        if not p.lazy and p.config and is_theme == theme_pass then
            pcall(p.config)
        end
    end
end

local function on_vim_enter()
    run_eager_configs(M.plugins, true)  -- theme plugins: set up before the theme
    colorscheme.apply(M.plugins)        -- the theme itself
    run_eager_configs(M.plugins, false) -- everything else sees final highlights
    treesitter.setup_folds()
end

function M.setup()
    -- Phase 0: pre-init hooks of eager plugins (not on the rtp yet)
    for _, p in ipairs(M.plugins) do
        if not p.lazy and p.pre then pcall(p.pre) end
    end

    -- Phase 1: install / register plugins
    install.setup(M.plugins)

    -- Phase 2: eager plugin configs + colorscheme (runs after VimEnter)
    api.nvim_create_autocmd("VimEnter", { once = true, callback = on_vim_enter })

    -- Phase 3: lazy-loading rules
    local lazy_specs = {}
    for _, p in ipairs(M.plugins) do
        if p.lazy then lazy_specs[#lazy_specs + 1] = to_lazy_spec(p) end
    end
    require("lz.n").load(lazy_specs)

    -- Phase 4: treesitter highlight auto-start
    treesitter.auto_highlight()
end

return M

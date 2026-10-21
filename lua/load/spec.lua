-- ============================================================================
-- pack/spec.lua — turn registry specs into lz.n specs and run their config
-- ============================================================================

local M = {}

-- Fields lz.n understands as-is
local LAZY_FIELDS = { "event", "ft", "cmd", "colorscheme", "priority" }

-- Module that owns a spec's setup(): the plugin name without the .nvim suffix,
-- unless the spec sets `main` (better_escape, everforest, idris2, ...)
function M.module_of(p)
    return p.main or p.name:gsub("%.nvim$", "")
end

local function notify(p, msg)
    vim.notify(("pack: %s %s"):format(p.name, msg), vim.log.levels.ERROR)
end

-- opts = {...} is shorthand for require(main).setup(opts)
local function apply_opts(p)
    local module = M.module_of(p)
    local ok, plugin = pcall(require, module)
    if not ok then
        notify(p, ("cannot require %q"):format(module))
        return
    end
    if type(plugin.setup) ~= "function" then
        notify(p, ("%q has no setup()"):format(module))
        return
    end

    local setup_ok, err = pcall(plugin.setup, p.opts)
    if not setup_ok then
        notify(p, ("setup failed: %s"):format(err))
    end
end

-- Run a spec's config: opts first, then the explicit config function
function M.apply_config(p)
    if p.opts then apply_opts(p) end

    if p.config then
        local ok, err = pcall(p.config, p, p.opts)
        if not ok then
            notify(p, ("config failed: %s"):format(err))
        end
    end
end

-- lz.n only takes lhs/mode/desc, so that is all it gets
local function to_lz_keys(keys)
    local lz_keys = {}
    for _, k in ipairs(keys) do
        lz_keys[#lz_keys + 1] = { k[1], mode = k.mode, desc = k.desc }
    end
    return lz_keys
end

-- Bind the mappings that carry their own action once the plugin has loaded
local function bind_actions(keys)
    for _, k in ipairs(keys) do
        if k.action then
            vim.keymap.set(k.mode or "n", k[1], k.action, { desc = k.desc })
        end
    end
end

-- Turn a registry spec into an lz.n lazy-loading rule
function M.to_lazy(p)
    local spec = {
        p.name,
        before = p.pre,
        keys   = p.keys and to_lz_keys(p.keys) or nil,
    }

    for _, field in ipairs(LAZY_FIELDS) do
        spec[field] = p[field]
    end

    spec.after = function()
        M.apply_config(p)
        if p.keys then bind_actions(p.keys) end
    end

    return spec
end

return M

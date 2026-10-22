-- Build lz.n specs and run their config.

local M = {}

-- Fields lz.n understands as triggers
local TRIGGER_FIELDS = { "event", "ft", "cmd", "colorscheme" }

-- Module that owns a spec's setup(): the plugin name without the .nvim suffix,
-- unless the spec sets `main` (better_escape, everforest, idris2, ...)
function M.module_of(p)
    return p.main or p.name:gsub("%.nvim$", "")
end

local function notify(p, msg, level)
    vim.notify(("pack: %s %s"):format(p.name, msg), level or vim.log.levels.ERROR)
end

-- opts = {...} is shorthand for require(main).setup(opts)
local function apply_opts(p)
    local module = M.module_of(p)
    local ok, plugin = pcall(require, module)
    if not ok then
        notify(p, ("cannot require %q: %s"):format(module, plugin))
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

-- opts first, then config
function M.apply_config(p)
    if p.opts then apply_opts(p) end

    if p.config then
        local ok, err = pcall(p.config, p, p.opts)
        if not ok then
            notify(p, ("config failed: %s"):format(err))
        end
    end
end

-- lz.n takes lhs/mode/desc only
local function to_lz_keys(keys)
    local lz_keys = {}
    for _, k in ipairs(keys) do
        lz_keys[#lz_keys + 1] = { k[1], mode = k.mode, desc = k.desc }
    end
    return lz_keys
end

-- Bind mappings that carry an action
local function bind_actions(keys)
    for _, k in ipairs(keys) do
        if k.action then
            vim.keymap.set(k.mode or "n", k[1], k.action, { desc = k.desc })
        end
    end
end

-- Whether a lazy spec declares anything that can load it
function M.has_trigger(p)
    if p.keys and #p.keys > 0 then return true end
    for _, field in ipairs(TRIGGER_FIELDS) do
        if p[field] then return true end
    end
    return false
end

-- Run the config and bind the key actions once the plugin has loaded
local function after(p)
    return function()
        M.apply_config(p)
        if p.keys then bind_actions(p.keys) end
    end
end

-- lz.n spec: lazy specs carry their triggers and load on demand, eager
-- specs carry none and are loaded by lz.n.load() right away
function M.to_lz(p)
    local s = { p.name }

    if p.lazy then
        s.keys = p.keys and to_lz_keys(p.keys) or nil
        for _, field in ipairs(TRIGGER_FIELDS) do
            s[field] = p[field]
        end
        if not M.has_trigger(p) then
            notify(p, "is lazy but has no trigger, so it loads at startup", vim.log.levels.WARN)
        end
    end

    -- eager load order, higher first
    s.priority = p.priority
    s.after    = after(p)
    return s
end

return M

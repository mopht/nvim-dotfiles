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

-- Eager spec: run the config at startup
function M.to_eager(p)
    return {
        p.name,
        -- vim.pack already loaded it; :packadd would source plugin/ again
        load     = function() end,
        priority = p.priority,
        after = function()
            M.apply_config(p)
            if p.keys then bind_actions(p.keys) end
        end,
    }
end

-- Lazy spec: load on trigger
function M.to_lazy(p)
    local spec = {
        p.name,
        keys = p.keys and to_lz_keys(p.keys) or nil,
    }

    for _, field in ipairs(TRIGGER_FIELDS) do
        spec[field] = p[field]
    end

    if not M.has_trigger(p) then
        notify(p, "is lazy but has no trigger, so it loads at startup", vim.log.levels.WARN)
    end

    spec.after = function()
        M.apply_config(p)
        if p.keys then bind_actions(p.keys) end
    end

    return spec
end

return M

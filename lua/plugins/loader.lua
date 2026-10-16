-- ============================================================================
-- loader.lua - vim.pack loader + lazy-loading hooks
-- Plugin specs live in lua/plugins/registry.lua
-- ============================================================================

local M = {}
local api = vim.api
local registry = require("plugins.registry")

M.plugins = registry.plugins


-- ============================================================================
-- Lazy-Loading Helpers
-- ============================================================================

--- Shadow a plugin command: on first invocation, packadd + config, then re-dispatch.
-- CRITICAL: delete our shadow BEFORE packadd—otherwise the plugin's own
-- nvim_create_user_command() will fail due to a name conflict.
local function hook_cmd(plugin_name, cmd_name, config_fn, pre_fn)
    api.nvim_create_user_command(cmd_name, function(opts)
        local args = opts.args
        local bang = opts.bang
        pcall(api.nvim_del_user_command, cmd_name)
        if pre_fn then pcall(pre_fn) end
        vim.cmd("packadd " .. plugin_name)
        if config_fn then config_fn() end
        local line = cmd_name
        if bang then line = line .. "!" end
        if args and #args > 0 then
            line = line .. " " .. args
        end
        vim.cmd(line)
    end, { nargs = "*", bang = true, desc = "lazy-load " .. plugin_name })
end

--- Intercept keypress: on first press, packadd + config, then re-feed key or call action
local function hook_key(plugin_name, config_fn, key_specs, pre_fn)
    for _, ks in ipairs(key_specs) do
        local lhs   = ks[1]
        local mode  = ks.mode  or "n"
        local action = ks.action
        local desc  = ks.desc  or ("lazy-load " .. plugin_name)
        local opts  = vim.tbl_extend("keep", ks.opts or {}, { desc = desc })

        vim.keymap.set(mode, lhs, function()
            if pre_fn then pcall(pre_fn) end
            vim.cmd("packadd " .. plugin_name)
            if config_fn then config_fn() end
            if action then
                action()
            else
                local termcodes = api.nvim_replace_termcodes(lhs, true, false, true)
                api.nvim_feedkeys(termcodes, "m", false)
            end
        end, opts)
    end
end

--- Fire once on an autocmd event
local function hook_event(plugin_name, config_fn, events, pre_fn)
    api.nvim_create_autocmd(events, {
        once = true,
        callback = function()
            if pre_fn then pcall(pre_fn) end
            vim.cmd("packadd " .. plugin_name)
            if config_fn then config_fn() end
        end,
        desc = "lazy-load " .. plugin_name,
    })
end

--- Fire once on filetype
local function hook_ft(plugin_name, config_fn, filetypes, pre_fn)
    api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        once = true,
        callback = function()
            if pre_fn then pcall(pre_fn) end
            vim.cmd("packadd " .. plugin_name)
            if config_fn then config_fn() end
        end,
        desc = "lazy-load " .. plugin_name,
    })
end

-- ============================================================================
-- vim.pack helpers
-- ============================================================================

--- 把注册表条目转成 vim.pack.Spec
local function to_spec(p)
    local src = p.src
    if not src:find("://", 1, true) then
        src = "https://github.com/" .. src
    end
    local spec = { src = src, name = p.name }
    if p.version then spec.version = p.version end
    return spec
end

-- ============================================================================
-- Setup
-- ============================================================================

--- Main entry point. Call from init.lua.
---
--- Strategy:
---   - start 插件：vim.pack.add() 默认行为（启动期等价于 :packadd!，
---     plugin/ 在 init 之后自动 source）。config 延迟到 VimEnter。
---   - opt 插件：vim.pack.add(..., { load = noop })，只确保已安装，
---     不加入 rtp；首次使用时由各 hook 调用 :packadd + config。
function M.setup()
    -- PackChanged：插件安装/更新后的构建步骤（须在 vim.pack.add 之前注册）
    api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            local d = ev.data
            if d.spec.name == "nvim-treesitter" and (d.kind == "install" or d.kind == "update") then
                if not d.active then vim.cmd.packadd("nvim-treesitter") end
                pcall(vim.cmd, "TSUpdate")
            end
        end,
    })

    -- Phase 0: pre-init hooks（设置 vim.g 等，需在插件 source 之前）
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and p.pre then
            pcall(p.pre)
        end
    end

    -- Phase 1: 安装 / 注册插件
    local eager, lazy = {}, {}
    for _, p in ipairs(M.plugins) do
        table.insert(p.pack == "start" and eager or lazy, to_spec(p))
    end
    -- 首次运行会弹出确认并 clone；之后只读锁文件
    vim.pack.add(eager)
    vim.pack.add(lazy, { load = function() end }) -- 只安装，不加载

    -- Phase 2: 延迟 start 插件的 config + colorscheme 到 VimEnter
    api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            -- 2a. Apply colorscheme FIRST (must be before italicize)
            require("everforest").setup({ transparent_background_level = 2})
            pcall(vim.cmd.colorscheme, "everforest")
            -- 2b. Treesitter-dependent fold options
            pcall(function()
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            end)
            -- 2c. Call config functions for start plugins (AFTER colorscheme)
            for _, p in ipairs(M.plugins) do
                if p.pack == "start" and p.config then
                    pcall(p.config)
                end
            end
        end,
    })

    -- Phase 3: 注册 opt 插件的懒加载 hook
    for _, p in ipairs(M.plugins) do
        if p.pack == "opt" then
            if p.cmd then
                for _, c in ipairs(p.cmd) do
                    hook_cmd(p.name, c, p.config, p.pre)
                end
            end
            if p.keys then
                hook_key(p.name, p.config, p.keys, p.pre)
            end
            if p.event then
                hook_event(p.name, p.config, p.event, p.pre)
            end
            if p.ft then
                hook_ft(p.name, p.config, p.ft, p.pre)
            end
        end
    end

    -- Phase 4: treesitter auto-start (Neovim 0.12 requires explicit call)
    api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        callback = function(ev)
            if vim.treesitter.highlighter.active[ev.buf] then return end
            local ft = vim.bo[ev.buf].filetype
            if ft and ft ~= "" then
                local lang = vim.treesitter.language.get_lang(ft)
                if lang then
                    pcall(vim.treesitter.start, ev.buf, lang)
                end
            end
        end,
        desc = "auto-start treesitter highlighting",
    })

    -- User commands
    -- :PackUpdate 会打开确认缓冲区，:write 确认更新，:quit 取消
    api.nvim_create_user_command("PackUpdate", function(opts)
        local names = #opts.fargs > 0 and opts.fargs or nil
        vim.pack.update(names)
    end, { nargs = "*", desc = "Update plugins via vim.pack (:write to confirm)" })

    -- :PackClean 删除已安装但不在注册表里的插件
    api.nvim_create_user_command("PackClean", function()
        local known = {}
        for _, p in ipairs(M.plugins) do known[p.name] = true end
        local stale = {}
        for _, p in ipairs(vim.pack.get()) do
            if not known[p.spec.name] then table.insert(stale, p.spec.name) end
        end
        if #stale == 0 then
            vim.notify("pack-loader: nothing to clean", vim.log.levels.INFO)
            return
        end
        vim.pack.del(stale)
        vim.notify("pack-loader: removed " .. table.concat(stale, ", "), vim.log.levels.INFO)
    end, { desc = "Remove plugins not listed in the registry" })
end

return M

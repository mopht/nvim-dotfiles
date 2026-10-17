-- ============================================================================
-- loader.lua - vim.pack loader + lz.n lazy-loading
-- Plugin specs live in lua/plugins/<category>/*.lua
-- ============================================================================

local M = {}
local api = vim.api
local registry = require("plugins.registry")

M.plugins = registry.plugins

-- ============================================================================
-- vim.pack helpers
-- ============================================================================

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

function M.setup()
    -- PackChanged: 插件安装/更新后的构建步骤
    api.nvim_create_autocmd("PackChanged", { callback = function(ev)
        local d = ev.data
        if not (d.spec.name == "nvim-treesitter"
            and (d.kind == "install" or d.kind == "update")) then return end

        if not d.active then vim.cmd.packadd("nvim-treesitter") end
        pcall(vim.cmd.fun, "TSUpdate")
    end,})

    -- Phase 0: pre-init hooks
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and p.pre then pcall(p.pre) end
    end

    -- Phase 1: 安装 / 注册插件
    local eager, lazy = {}, {}
    for _, p in ipairs(M.plugins) do
        table.insert(p.pack == "start" and eager or lazy, to_spec(p))
    end
    vim.pack.add(eager)
    vim.pack.add(lazy, { load = function() end })

    -- Phase 2: colorscheme + start 插件 config（VimEnter 后执行）
    api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            require("everforest").setup({ transparent_background_level = 2 })
            pcall(vim.cmd.colorscheme, "everforest")

            -- treesitter fold options
            pcall(function()
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr   = "nvim_treesitter#foldexpr()"
            end)

            -- start 插件的 config（colorscheme 之后）
            for _, p in ipairs(M.plugins) do
                if p.pack == "start" and p.config then
                    pcall(p.config)
                end
            end
        end,
    })

    local lazy_specs = {}
    for _, p in ipairs(M.plugins) do
        if p.pack ~= "opt" then goto continue end

        local spec = { p.name }
        if p.event then spec.event = p.event end
        if p.ft    then spec.ft    = p.ft    end
        if p.cmd   then spec.cmd   = p.cmd   end
        if p.pre   then spec.before = p.pre  end
        if p.colorscheme then spec.colorscheme = p.colorscheme end

        -- keys：过滤掉 action，只传 lhs/mode/desc 给 lz.n
        if p.keys then
            local lzn_keys = {}
            for _, k in ipairs(p.keys) do
                table.insert(lzn_keys, {k[1], mode = k.mode, desc = k.desc,})
            end
            spec.keys = lzn_keys
        end

        -- after：先执行原 config，再绑定有 action 的按键
        spec.after = function()
            if p.config then pcall(p.config) end
            if not p.keys then return end
            for _, k in ipairs(p.keys) do
                if not k.action then goto continue end
                vim.keymap.set(k.mode or "n", k[1], k.action, { desc = k.desc } )
                ::continue::
            end
        end
        table.insert(lazy_specs, spec)

        ::continue::
    end
    require("lz.n").load(lazy_specs)

    -- Phase 4: treesitter auto-start
    api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        callback = function(ev)
            if vim.treesitter.highlighter.active[ev.buf] then return end
            local ft = vim.bo[ev.buf].filetype
            if not (ft and ft ~= "") then return end

            local lang = vim.treesitter.language.get_lang(ft)
            if lang then pcall(vim.treesitter.start, ev.buf, lang) end
        end,
        desc = "auto-start treesitter highlighting",
    })

    -- Pack 命令
    api.nvim_create_user_command("PackUpdate", function(opts)
        local names = #opts.fargs > 0 and opts.fargs or nil
        vim.pack.update(names)
    end, { nargs = "*", desc = "Update plugins via vim.pack" })

    api.nvim_create_user_command("PackClean", function()
        local known = {}
        for _, p in ipairs(M.plugins) do known[p.name] = true end
        local stale = {}
        for _, p in ipairs(vim.pack.get()) do
            if not known[p.spec.name] then
                table.insert(stale, p.spec.name)
            end
        end
        if #stale == 0 then
            vim.notify("pack-loader: nothing to clean", vim.log.levels.INFO)
            return
        end
        vim.pack.del(stale)
        vim.notify("pack-loader: removed " .. table.concat(stale, ", "),
                   vim.log.levels.INFO)
    end, { desc = "Remove plugins not listed in the registry" })
end

return M

-- ============================================================================
-- pack-loader.lua - vim.pack (Neovim 0.12+) loader with Lazy Loading
--   pack = "start" → vim.pack.add() 默认加载；config 延迟到 VimEnter
--   pack = "opt"   → vim.pack.add(..., { load = noop }) 只安装不加载，
--                    之后通过 cmd-shadow / key-intercept / autocmd / filetype
--                    触发 :packadd 实现懒加载
-- 插件由 vim.pack 管理：
--   安装位置  stdpath("data")/site/pack/core/opt/<name>
--   锁文件    stdpath("config")/nvim-pack-lock.json （建议纳入版本控制）
-- ============================================================================

local M = {}

local api = vim.api

-- ============================================================================
-- Plugin Registry
-- ============================================================================

-- Each entry:
--   name     : 目录名（vim.pack 的 spec.name，也是 :packadd 的参数）
--   src      : "owner/repo"（自动展开为 GitHub URL）或完整 URL
--   pack     : "start"（启动时加载）或 "opt"（懒加载）
--   version? : 分支 / tag / commit / vim.version.range()
--   config?  : 插件加载后调用的函数
--   pre?     : 加载前调用（设置 vim.g 等）
--   cmd?     : 需要拦截的命令名（opt）
--   keys?    : { lhs, mode?, action?, desc? }（opt）
--   event?   : autocmd 事件（opt）
--   ft?      : filetype（opt）

M.plugins = {

    -- ══════════════════════════════════════════════
    -- start/  — always loaded
    -- ══════════════════════════════════════════════

    -- Dependencies (must load before dependent plugins)
    { name = "_blink.lib",              src = "saghen/blink.lib",                    pack = "start" },
    { name = "plenary.nvim",            src = "nvim-lua/plenary.nvim",               pack = "start" },
    { name = "nvim-web-devicons",       src = "nvim-tree/nvim-web-devicons",         pack = "start" },
    { name = "nui.nvim",                src = "MunifTanjim/nui.nvim",                pack = "start" },
    { name = "mini.icons",              src = "echasnovski/mini.icons",              pack = "start" },
    { name = "nvim-navic",              src = "SmiteshP/nvim-navic",                 pack = "start" },
    { name = "mason.nvim",              src = "mason-org/mason.nvim",                pack = "start" },
    { name = "mason-lspconfig.nvim",    src = "mason-org/mason-lspconfig.nvim",      pack = "start" },

    { name = "which-key.nvim",          src = "folke/which-key.nvim",                pack = "start",
    config = function()
        require("which-key").setup({})
    end},
    -- Core
    { name = "nvim-lspconfig",          src = "neovim/nvim-lspconfig",               pack = "start",
    config = function()
        local spec = require("plugins.returned.nvim-lspconfig")
        if spec.config then spec.config() end
    end },
    { name = "blink.cmp",               src = "saghen/blink.cmp",                    pack = "start",
    config = function()
        -- v2: build/download native fuzzy matcher (one-time, caches after)
        local ok, _ = pcall(function() require("blink.cmp").build():pwait() end)
        if not ok then
            vim.notify("blink.cmp: native build failed, using Lua fallback", vim.log.levels.WARN)
        end
        local spec = require("plugins.returned.blink-cmp")
        require("blink.cmp").setup(spec.opts or {})
    end },
    { name = "nvim-treesitter",         src = "nvim-treesitter/nvim-treesitter",     pack = "start",
    version = "main",
    config = function()
        local spec = require("plugins.returned.nvim-treesitter")
        require("nvim-treesitter.config").setup(spec.opts or {})
    end },
    {
        name = "tree-sitter-manager.nvim", src = "romus204/tree-sitter-manager.nvim", pack = "start",
        config = function()
            require('tree-sitter-manager').setup({
                ensure_installed = {
                    'haskell',
                },
                auto_install = true,
                languages = { haskell = { install_info = {
                    revision = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395",
                    url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell",
                }, }, },
            })
        end,
    },

    -- Colorschemes
    { name = "everforest-nvim",         src = "neanias/everforest-nvim",             pack = "start" },

    -- UI
    { name = "lualine.nvim",            src = "nvim-lualine/lualine.nvim",           pack = "start",
    config = function()
        local spec = require("plugins.returned.lualine")
        require("lualine").setup(spec.opts or {})
    end },
    { name = "barbecue",                src = "utilyre/barbecue.nvim",               pack = "start",
    config = function()
        local spec = require("plugins.returned.barbecue")
        require("barbecue").setup(spec.opts or {})
    end },
    { name = "bufferline.nvim",         src = "akinsho/bufferline.nvim",             pack = "start",
    config = function()
        local spec = require("plugins.returned.bufferline")
        require("bufferline").setup(spec.opts or {})
    end },
    { name = "hlchunk.nvim",            src = "shellRaining/hlchunk.nvim",           pack = "start",
    config = function()
        local spec = require("plugins.returned.hlchunk")
        require("hlchunk").setup(spec.opts or {})
    end },
    { name = "noice.nvim",              src = "folke/noice.nvim",                    pack = "start",
    config = function()
        local spec = require("plugins.returned.noice")
        require("noice").setup(spec.opts or {})
    end },
    { name = "rainbow-delimiters.nvim", src = "HiPhish/rainbow-delimiters.nvim",     pack = "start" },
    { name = "nvim-treesitter-context", src = "nvim-treesitter/nvim-treesitter-context", pack = "start",
    config = function()
        local spec = require("plugins.returned.nvim-treesitter-context")
        require("treesitter-context").setup(spec.opts or {})
    end },

    -- { name = "oil.nvim",                src = "stevearc/oil.nvim", pack = "start",
    -- config = function() require("oil").setup() end},

    -- ══════════════════════════════════════════════
    -- opt/  — lazy-loaded on demand
    -- ══════════════════════════════════════════════

    -- ── cmd-based ────────────────────────────────
    { name = "neo-tree.nvim",           src = "nvim-neo-tree/neo-tree.nvim",         pack = "opt", cmd = { "Neotree" },
    config = function()
        require("plugins.required.neo-tree")
        require("plugins.required.nui")
    end },
    { name = "fzf-lua",                 src = "ibhagwan/fzf-lua",                    pack = "opt", cmd = { "FzfLua" },
    config = function()
        local spec = require("plugins.returned.fzf-lua")
        require("fzf-lua").setup(spec.opts or {})
    end },
    { name = "trouble.nvim",            src = "folke/trouble.nvim",                  pack = "opt", cmd = { "Trouble" },
    config = function()
        local spec = require("plugins.returned.trouble")
        require("trouble").setup(spec.opts or {})
    end },
    -- { name = "symbols-outline.nvim",    src = "simrat39/symbols-outline.nvim",       pack = "opt", cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    -- config = function()
    --     local spec = require("plugins.returned.symbols-outline")
    --     require("symbols-outline").setup(spec.opts or {})
    -- end },
    { name = "code_runner.nvim",        src = "CRAG666/code_runner.nvim",            pack = "opt", cmd = { "RunCode" },
    config = function()
        require("code_runner").setup(require("plugins.returned.code_runner").opts or {})
    end },
    { name = "guess-indent.nvim",       src = "NMAC427/guess-indent.nvim",           pack = "opt", cmd = { "GuessIndent" },
    config = function() require('guess-indent').setup {} end },
    { name = "twilight.nvim",           src = "folke/twilight.nvim",                 pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function()
        require("twilight").setup({})
    end },
    { name = "zen-mode.nvim",           src = "folke/zen-mode.nvim",                 pack = "opt", cmd = { "ZenMode" },
    config = function()
        require("zen-mode").setup({})
    end },

    -- ── key-based ────────────────────────────────
    { name = "flash.nvim",              src = "folke/flash.nvim",                    pack = "opt",
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,                    desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,              desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,                  desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end,       desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,                  desc = "Toggle Flash Search" },
    },
    config = function() require("flash").setup({}) end },
    { name = "Comment.nvim",            src = "numToStr/Comment.nvim",               pack = "opt",
    keys = {
        { "gc",  mode = { "n", "v" } },
        { "gcc", mode = "n" },
    },
    config = function() require("Comment").setup({}) end },
    { name = "goto-preview",            src = "rmagatti/goto-preview",               pack = "opt",
    keys = {
        { "gpd", mode = "n", action = function() require("goto-preview").goto_preview_definition() end,       desc = "Preview Definition" },
        { "gpt", mode = "n", action = function() require("goto-preview").goto_preview_type_definition() end,   desc = "Preview Type Def" },
        { "gpi", mode = "n", action = function() require("goto-preview").goto_preview_implementation() end,    desc = "Preview Impl" },
        { "gpD", mode = "n", action = function() require("goto-preview").goto_preview_declaration() end,       desc = "Preview Declaration" },
        { "gP",  mode = "n", action = function() require("goto-preview").close_all_win() end,                  desc = "Close All Previews" },
    },
    config = function()
        require("goto-preview").setup(require("plugins.returned.goto-preview").opts or {})
    end },
    { name = "neoscroll.nvim",          src = "karb94/neoscroll.nvim",               pack = "opt",
    keys = {
        { "<C-u>" }, { "<C-d>" }, { "<C-b>" }, { "<C-f>" },
        { "<C-y>" }, { "<C-e>" }, { "zz" }, { "zt" }, { "zb" },
    },
    config = function() require("neoscroll").setup({}) end },
    { name = "vim-tmux-navigator",      src = "christoomey/vim-tmux-navigator",      pack = "opt",
    keys = {
        { "<C-h>" }, { "<C-j>" }, { "<C-k>" }, { "<C-l>" },
    },
    config = nil },

    -- ── event-based ──────────────────────────────
    { name = "auto-save.nvim",          src = "okuuva/auto-save.nvim",               pack = "opt", event = { "InsertEnter" },
    config = function() require("auto-save").setup({}) end },
    { name = "better-escape.nvim",      src = "max397574/better-escape.nvim",        pack = "opt", event = { "InsertEnter" },
    config = function()
        require("better_escape").setup(require("plugins.returned.better-escape").opts)
    end },
    { name = "nvim-autopairs",          src = "windwp/nvim-autopairs",               pack = "opt", event = { "InsertEnter" },
    config = function()
        local spec = require("plugins.returned.autopairs")
        if spec.config then spec.config() end
    end },
    { name = "tabout.nvim",             src = "abecodes/tabout.nvim",                pack = "opt", event = { "InsertEnter" },
    config = function() require("tabout").setup(require("plugins.returned.tabout").opts) end },
    { name = "lsp_signature.nvim",      src = "ray-x/lsp_signature.nvim",            pack = "opt", event = { "InsertEnter" },
    config = function() require("lsp_signature").setup(require("plugins.returned.lsp_signature").opts) end },
    { name = "friendly-snippets",       src = "rafamadriz/friendly-snippets",        pack = "opt", event = { "InsertEnter" } },
    -- { name = "inlay-hints.nvim",        src = "MysticalDevil/inlay-hints.nvim", pack = "opt", event = { "LspAttach" },
    --     config = function() require("inlay-hints").setup({}) end },
    { name = "none-ls.nvim",            src = "nvimtools/none-ls.nvim",              pack = "opt", event = { "LspAttach" },
    config = function()
        vim.cmd("packadd none-ls-extras.nvim")
        local spec = require("plugins.returned.none-ls")
        if spec.config then spec.config() end
    end },
    { name = "vim-better-whitespace",   src = "ntpeters/vim-better-whitespace",      pack = "opt", event = { "BufEnter" },
    config = nil },
    { name = "toggleterm.nvim",         src = "akinsho/toggleterm.nvim",             pack = "opt", event = { "BufEnter" },
    config = function()
        local spec = require("plugins.returned.toggleterm")
        if spec.config then spec.config() end
    end },
    { name = "todo-comments.nvim",      src = "folke/todo-comments.nvim",            pack = "opt", event = { "BufEnter" },
    config = function()
        local spec = require("plugins.returned.todo-comments")
        require("todo-comments").setup(spec.opts or {})
    end },

    -- ── filetype-based ───────────────────────────
    { name = "moonbit.nvim",            src = "moonbit-community/moonbit.nvim",      pack = "opt", ft = "moonbit",
    config = function() require("moonbit").setup({
        mooncakes = {
            virtual_text = true,   -- virtual text showing suggestions
            use_local = true,      -- recommended, use index under ~/.moon
        },
        -- optionally disable the treesitter integration
        treesitter =  {
            enabled = true,
            -- Set false to disable automatic installation and updating of parsers.
            auto_install = true
        },
        -- configure the language server integration
        -- set `lsp = false` to disable the language server integration
        lsp = {
            -- set to false to use the legacy language server
            native = true,
            -- provide an `on_attach` function to run when the language server starts
            on_attach = function(client, bufnr) end,
            -- provide client capabilities to pass to the language server
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        },
        -- configure jsonls schema integration (enabled by default)
        -- set `jsonls = false` to disable
        jsonls = {
            -- optional extra jsonls settings to merge
            settings = {},
        },
    }) end },
    { name = "idris2-nvim",             src = "ShinKage/idris2-nvim",                pack = "opt", ft = "idris",
    config = function() require("idris2-nvim").setup() end},
    { name = "koka.nvim",               src = "syaiful6/koka.nvim",                  pack = "opt", ft = "koka" },
    { name = "haskell-tools.nvim",      src = "mrcjkb/haskell-tools.nvim",           pack = "start",--[[  ft = { "haskell" }, ]]
    config = nil }, -- already lazyed
    { name = "lazydev.nvim",            src = "folke/lazydev.nvim",                  pack = "opt", ft = { "lua" },
    config = function() require("lazydev").setup(require("plugins.returned.lazydev").opts) end },
    -- { name = "zig-lamp",                src = "...", pack = "opt", ft = { "zig", "zon" },
    -- pre = function()
    --     vim.g.zig_lamp_zls_auto_install = nil
    --     vim.g.zig_lamp_fall_back_sys_zls = nil
    --     vim.g.zig_lamp_zls_lsp_opt = {}
    --     vim.g.zig_lamp_zls_settings = {}
    --     vim.g.zig_lamp_pkg_help_fg = "#CF5C00"
    --     vim.g.zig_lamp_zig_fetch_timeout = 5000
    -- end },
    { name = "rustaceanvim",            src = "mrcjkb/rustaceanvim",                 pack = "start" },
    -- { name = "c3.nvim",                 src = "...", pack = "opt", ft = { "c3", "c3i" },
    -- config = function()
    --     require("c3")
    -- end },

    -- ── unused / backup ──────────────────────────
    { name = "none-ls-extras.nvim",     src = "nvimtools/none-ls-extras.nvim",       pack = "opt" },
    { name = "catppuccin",              src = "catppuccin/nvim",                     pack = "opt" },
    { name = "tokyonight.nvim",         src = "folke/tokyonight.nvim",               pack = "opt" },
}

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

-- ============================================================================
-- pack-loader.lua - Neovim Native Package Loader with Lazy Loading
-- Replaces lazy.nvim with Neovim's built-in :h packages (pack/*/start/ + opt/)
--   start/ → Neovim auto-adds to rtp; configs deferred to VimEnter
--   opt/   → lazy-loaded via cmd-shadow, key-intercept, autocmd, or filetype
-- ============================================================================

local M = {}

local fn = vim.fn
local api = vim.api
local uv = vim.uv or vim.loop

local pack_root = fn.stdpath("data") .. "/site/pack/plugins"
local start_dir = pack_root .. "/start"
local opt_dir   = pack_root .. "/opt"

-- ============================================================================
-- Plugin Registry
-- ============================================================================

-- Each entry:
--   name   : directory name in pack/
--   pack   : "start" or "opt"
--   config?: function called after plugin is loaded
--   cmd?   : table of command names to intercept (opt)
--   keys?  : table of {lhs, mode?, action?} to intercept (opt)
--   event? : table of autocmd events (opt)
--   ft?    : table of filetypes (opt)

M.plugins = {

    -- ══════════════════════════════════════════════
    -- start/  — always loaded
    -- ══════════════════════════════════════════════

	-- Dependencies (must load before dependent plugins)
	{ name = "_blink.lib",              pack = "start" },  -- blink.cmp v2 dep; '_' prefix ensures loads first
	{ name = "plenary.nvim",             pack = "start" },
    { name = "nvim-web-devicons",       pack = "start" },
    { name = "nui.nvim",                pack = "start" },
    { name = "mini.icons",              pack = "start" },
    { name = "nvim-navic",              pack = "start" },
    { name = "friendly-snippets",       pack = "start" },
    { name = "mason.nvim",              pack = "start" },
    { name = "mason-lspconfig.nvim",    pack = "start" },
    { name = "none-ls-extras.nvim",     pack = "start" },

    { name = "c3.nvim",                 pack = "start",
        config = function()
            require("c3")
        end },
    { name = "which-key.nvim",          pack = "start",
    config = function()
        require("which-key").setup({})
    end},
    -- Core
    { name = "nvim-lspconfig",          pack = "start",
        config = function()
            local spec = require("plugins.returned.nvim-lspconfig")
            if spec.config then spec.config() end
        end },
	{ name = "blink.cmp",               pack = "start",
	  config = function()
		-- v2: build/download native fuzzy matcher (one-time, caches after)
		local ok, _ = pcall(function() require("blink.cmp").build():pwait() end)
		if not ok then
			vim.notify("blink.cmp: native build failed, using Lua fallback", vim.log.levels.WARN)
		end
		local spec = require("plugins.returned.blink-cmp")
		require("blink.cmp").setup(spec.opts or {})
	  end },
    { name = "nvim-treesitter",         pack = "start",
        config = function()
            local spec = require("plugins.returned.nvim-treesitter")
            require("nvim-treesitter.config").setup(spec.opts or {})
        end },

    -- Colorschemes
    { name = "everforest-nvim",         pack = "start" },
    { name = "catppuccin",              pack = "start" },
    { name = "tokyonight.nvim",         pack = "start" },

    -- UI
    { name = "lualine.nvim",            pack = "start",
        config = function()
            local spec = require("plugins.returned.lualine")
            require("lualine").setup(spec.opts or {})
        end },
    { name = "barbecue",                pack = "start",
        config = function()
            local spec = require("plugins.returned.barbecue")
            require("barbecue").setup(spec.opts or {})
        end },
    { name = "bufferline.nvim",         pack = "start",
        config = function()
            local spec = require("plugins.returned.bufferline")
            require("bufferline").setup(spec.opts or {})
        end },
    { name = "hlchunk.nvim",            pack = "start",
        config = function()
            local spec = require("plugins.returned.hlchunk")
            require("hlchunk").setup(spec.opts or {})
        end },
    { name = "noice.nvim",              pack = "start",
        config = function()
            local spec = require("plugins.returned.noice")
            require("noice").setup(spec.opts or {})
        end },
    { name = "todo-comments.nvim",      pack = "start",
        config = function()
            local spec = require("plugins.returned.todo-comments")
            require("todo-comments").setup(spec.opts or {})
        end },
    { name = "rainbow-delimiters.nvim", pack = "start" },
    { name = "nvim-treesitter-context", pack = "start",
        config = function()
            local spec = require("plugins.returned.nvim-treesitter-context")
            require("treesitter-context").setup(spec.opts or {})
        end },
    { name = "italicize",               pack = "start",
        config = function()
            require("plugins.required.italicize")
        end },
    { name = "toggleterm.nvim",         pack = "start",
        config = function()
            local spec = require("plugins.returned.toggleterm")
            if spec.config then spec.config() end
        end },
    { name = "none-ls.nvim",            pack = "start",
        config = function()
            local spec = require("plugins.returned.none-ls")
            if spec.config then spec.config() end
        end },

    -- Language support
    { name = "rustaceanvim",            pack = "start" },

    -- ══════════════════════════════════════════════
    -- opt/  — lazy-loaded on demand
    -- ══════════════════════════════════════════════

    -- ── cmd-based ────────────────────────────────
    { name = "neo-tree.nvim",           pack = "opt", cmd = { "Neotree" },
        config = function()
            require("plugins.required.neo-tree")
            require("plugins.required.nui")
        end },
    { name = "fzf-lua",                 pack = "opt", cmd = { "FzfLua" },
        config = function()
            local spec = require("plugins.returned.fzf-lua")
            require("fzf-lua").setup(spec.opts or {})
        end },
    { name = "trouble.nvim",            pack = "opt", cmd = { "Trouble" },
        config = function()
            local spec = require("plugins.returned.trouble")
            require("trouble").setup(spec.opts or {})
        end },
    { name = "symbols-outline.nvim",    pack = "opt", cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
        config = function()
            local spec = require("plugins.returned.symbols-outline")
            require("symbols-outline").setup(spec.opts or {})
        end },
    { name = "code_runner.nvim",         pack = "opt", cmd = { "RunCode" },
        config = function()
            require("code_runner").setup(require("plugins.returned.code_runner").opts or {})
        end },
    { name = "guess-indent.nvim",       pack = "opt", cmd = { "GuessIndent" },
        config = function()
            local spec = require("plugins.returned.guess-indent")
            require("guess-indent").setup(spec.opts or {})
        end },
    { name = "twilight.nvim",           pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
        config = function()
            require("twilight").setup({})
        end },
    { name = "zen-mode.nvim",           pack = "opt", cmd = { "ZenMode" },
        config = function()
            require("zen-mode").setup({})
        end },

    -- ── key-based ────────────────────────────────
    { name = "flash.nvim",              pack = "opt",
        keys = {
            { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,                    desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,              desc = "Flash Treesitter" },
            { "r",     mode = "o",               action = function() require("flash").remote() end,                  desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end,       desc = "Treesitter Search" },
            { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,                  desc = "Toggle Flash Search" },
        },
        config = function() require("flash").setup({}) end },
    { name = "Comment.nvim",            pack = "opt",
        keys = {
            { "gc",  mode = { "n", "v" } },
            { "gcc", mode = "n" },
        },
        config = function() require("Comment").setup({}) end },
    { name = "goto-preview",            pack = "opt",
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
    { name = "neoscroll.nvim",          pack = "opt",
        keys = {
            { "<C-u>" }, { "<C-d>" }, { "<C-b>" }, { "<C-f>" },
            { "<C-y>" }, { "<C-e>" }, { "zz" }, { "zt" }, { "zb" },
        },
        config = function() require("neoscroll").setup({}) end },
    { name = "vim-tmux-navigator",      pack = "opt",
        keys = {
            { "<C-h>" }, { "<C-j>" }, { "<C-k>" }, { "<C-l>" },
        },
        config = nil },

    -- ── event-based ──────────────────────────────
    { name = "auto-save.nvim",          pack = "opt", event = { "InsertEnter" },
        config = function() require("auto-save").setup({}) end },
    { name = "better-escape.nvim",      pack = "opt", event = { "InsertEnter" },
        config = function()
            require("better_escape").setup(require("plugins.returned.better-escape").opts)
        end },
    { name = "nvim-autopairs",          pack = "opt", event = { "InsertEnter" },
        config = function()
            local spec = require("plugins.returned.autopairs")
            if spec.config then spec.config() end
        end },
    { name = "tabout.nvim",             pack = "opt", event = { "InsertEnter" },
        config = function() require("tabout").setup(require("plugins.returned.tabout").opts) end },
    { name = "lsp_signature.nvim",      pack = "opt", event = { "InsertEnter" },
        config = function() require("lsp_signature").setup(require("plugins.returned.lsp_signature").opts) end },
    { name = "inlay-hints.nvim",        pack = "opt", event = { "LspAttach" },
        config = function() require("inlay-hints").setup({}) end },
    { name = "vim-better-whitespace",   pack = "opt", event = { "BufEnter" },
        config = nil },

    -- ── filetype-based ───────────────────────────
    { name = "lazydev.nvim",            pack = "opt", ft = { "lua" },
        config = function() require("lazydev").setup(require("plugins.returned.lazydev").opts) end },
    { name = "zig-lamp",                pack = "opt", ft = { "zig", "zon" },
        pre = function()
            vim.g.zig_lamp_zls_auto_install = nil
            vim.g.zig_lamp_fall_back_sys_zls = nil
            vim.g.zig_lamp_zls_lsp_opt = {}
            vim.g.zig_lamp_zls_settings = {}
            vim.g.zig_lamp_pkg_help_fg = "#CF5C00"
            vim.g.zig_lamp_zig_fetch_timeout = 5000
        end },
}

-- ============================================================================
-- Lazy-Loading Helpers
-- ============================================================================

--- Shadow a plugin command: on first invocation, packadd + config, then re-dispatch.
-- CRITICAL: delete our shadow BEFORE packadd—otherwise the plugin's own
-- nvim_create_user_command() will fail due to a name conflict.
local function hook_cmd(plugin_name, cmd_name, config_fn, pre_fn)
    api.nvim_create_user_command(cmd_name, function(opts)
        -- Save arguments so we can re-dispatch after loading
        local args = opts.args
        local bang = opts.bang
        -- Delete shadow command FIRST (plugins cannot register if name is taken)
        pcall(api.nvim_del_user_command, cmd_name)
        -- Now the plugin can safely create its own :Command
        if pre_fn then pcall(pre_fn) end
        vim.cmd("packadd " .. plugin_name)
        if config_fn then config_fn() end
        -- Re-dispatch to the real plugin command
        local line = cmd_name
        if bang then line = line .. "!" end
        if args and #args > 0 then
            line = line .. " " .. args
        end
        vim.cmd(line)
    end, { nargs = "*", bang = true, desc = "lazy-load " .. plugin_name })
end

--- Intercept keypress: on first press, packadd + config, then re-feed key or call action
-- packadd synchronously sources plugin files (which register their own keymaps),
-- so our lazy mapping is replaced immediately. Re-feeding the key causes the
-- plugin's real mapping to fire — no vim.schedule needed (avoids ordering issues).
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
                -- Direct action: plugin is now available, call it
                action()
            else
                -- Re-feed the key: plugin's own mapping now replaces ours
                -- nvim_feedkeys inside a mapping callback queues the key
                -- for processing after this callback returns
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
-- Setup
-- ============================================================================

--- Main entry point. Call from init.lua.
---
--- Strategy:
---   - start/ plugins: let Neovim add them to rtp automatically (after vimrc).
---     Pre-init hooks (vim.g globals) run BEFORE plugins are sourced.
---     Config functions are deferred to VimEnter (by then all start/ plugins
---     are fully in rtp).
---   - opt/ plugins: register lazy-load hooks (cmd shadow, key intercept,
---     autocmd event, filetype). Hooks call packadd + config on first use.
---
--- This avoids manually adding to rtp (which could cause double-sourcing).
function M.setup()
    -- Ensure packpath includes our site dir (so Neovim finds pack/*/start/)
    local site_path = fn.stdpath("data") .. "/site"
    local pp = vim.opt.packpath:get()
    if not vim.tbl_contains(pp, site_path) then
        table.insert(pp, 1, site_path)
        vim.opt.packpath = pp
    end

    -- Phase 0: run pre-init hooks BEFORE Neovim sources start/ plugins
    -- (sets vim.g globals that plugins read during initialization)
    for _, p in ipairs(M.plugins) do
        if p.pack == "start" and p.pre then
            pcall(p.pre)
        end
    end

    -- Phase 1: defer start/ plugin configs + colorscheme to VimEnter
    -- By VimEnter, Neovim has added all pack/*/start/ dirs to rtp
    -- and sourced their plugin/ files — everything is ready.
    api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            -- 1a. Call config functions for start/ plugins
            for _, p in ipairs(M.plugins) do
                if p.pack == "start" and p.config then
                    pcall(p.config)
                end
            end
            -- 1b. Apply colorscheme
            pcall(vim.cmd.colorscheme, "everforest")
            -- 1c. Treesitter-dependent fold options
            pcall(function()
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            end)
        end,
    })

    -- Phase 2: register lazy-load hooks for opt/ plugins
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

    -- Phase 3: register treesitter auto-start (Neovim 0.12 requires explicit call)
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

    -- Register user commands
    api.nvim_create_user_command("PackUpdate", function()
        M.update_all()
    end, { desc = "Update all plugins via git pull" })
end

-- ============================================================================
-- Bootstrap: move plugins from lazy.nvim cache into pack directories
-- ============================================================================

--- Run ONCE to migrate existing plugins from nvim-data/lazy/ to site/pack/plugins/
function M.bootstrap()
    local lazy_dir = fn.stdpath("data") .. "/lazy"

    uv.fs_mkdir(start_dir, 493)
    uv.fs_mkdir(opt_dir, 493)

    for _, p in ipairs(M.plugins) do
        local target = (p.pack == "start" and start_dir or opt_dir) .. "/" .. p.name
        if uv.fs_stat(target) then
            goto continue
        end
        local source = lazy_dir .. "/" .. p.name
        if uv.fs_stat(source) then
            local ok, err = os.rename(source, target)
            if ok then
                vim.notify("pack-loader: moved " .. p.name .. " → " .. p.pack, vim.log.levels.INFO)
            else
                vim.notify("pack-loader: failed to move " .. p.name .. ": " .. (err or "?"), vim.log.levels.ERROR)
            end
        else
            vim.notify("pack-loader: " .. p.name .. " not in lazy cache, skipping", vim.log.levels.WARN)
        end
        ::continue::
    end

    -- Remove lazy directory if empty
    pcall(function()
        local remaining = uv.fs_scandir(lazy_dir)
        if remaining then
            local first = uv.fs_scandir_next(remaining)
            if not first then
                uv.fs_rmdir(lazy_dir)
                vim.notify("pack-loader: removed empty lazy/ directory", vim.log.levels.INFO)
            else
                vim.notify("pack-loader: lazy/ has remaining items (e.g. " .. first .. "), not removing", vim.log.levels.WARN)
            end
        end
    end)

    vim.notify("pack-loader: bootstrap complete! Restart Neovim.", vim.log.levels.INFO)
end

-- ============================================================================
-- Clone: install a single plugin from GitHub
-- ============================================================================

--- Clone a plugin into the correct pack/ directory.
--- @param name   string   Directory name in pack/ (e.g. "gitsigns.nvim")
--- @param repo   string   GitHub repo (e.g. "lewis6991/gitsigns.nvim")
--- @param pack  '"start"'|'"opt"'   Default "start"
--- @param opts?  string   Extra git-clone flags (e.g. "--branch=main")
function M.clone(name, repo, pack, opts)
    pack = pack or "start"
    local target = pack_root .. "/" .. pack .. "/" .. name
    if uv.fs_stat(target) then
        vim.notify("pack-loader: " .. name .. " already exists in " .. pack, vim.log.levels.WARN)
        return
    end
    local url = "https://github.com/" .. repo .. ".git"
    local cmd = { "git", "clone", "--filter=blob:none" }
    if opts then
        for _, o in ipairs(vim.split(opts, "%s+")) do
            table.insert(cmd, o)
        end
    end
    table.insert(cmd, url)
    table.insert(cmd, target)
    vim.notify("pack-loader: cloning " .. repo .. " → " .. pack, vim.log.levels.INFO)
    local out = fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("pack-loader: clone failed\n" .. out, vim.log.levels.ERROR)
    else
        vim.notify("pack-loader: " .. name .. " installed", vim.log.levels.INFO)
    end
end

--- Update a plugin via git pull. Handles detached HEAD left by lazy.nvim.
--- @param name string  Directory name in pack/
--- @param pack '"start"'|'"opt"'  Default "start"
function M.update(name, pack)
    pack = pack or "start"
    local dir = pack_root .. "/" .. pack .. "/" .. name
    if not uv.fs_stat(dir) then
        vim.notify("pack-loader: " .. name .. " not found in " .. pack, vim.log.levels.ERROR)
        return
    end
    -- Check if we're in detached HEAD (lazy.nvim left plugins this way)
    local branch = fn.system({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" }):gsub("%s+", "")
    if branch == "HEAD" then
        -- Detached → find and checkout the default branch
        local remote = fn.system({ "git", "-C", dir, "remote", "show", "origin" })
        local default_branch = remote:match("HEAD branch: (%S+)") or "main"
        vim.notify("pack-loader: detached HEAD → switching " .. name .. " to " .. default_branch, vim.log.levels.INFO)
        fn.system({ "git", "-C", dir, "checkout", default_branch })
    end
    vim.notify("pack-loader: pulling " .. name .. " ...", vim.log.levels.INFO)
    local out = fn.system({ "git", "-C", dir, "pull", "--ff-only" })
    vim.notify(out, vim.log.levels.INFO)
end

--- Update ALL plugins in batch.
function M.update_all()
	local total = #M.plugins
	local done = 0
	for _, p in ipairs(M.plugins) do
		done = done + 1
		vim.notify(string.format("pack-loader: [%d/%d] %s ...", done, total, p.name), vim.log.levels.INFO)
		M.update(p.name, p.pack)
	end
	vim.notify("pack-loader: all " .. total .. " plugins updated", vim.log.levels.INFO)
end

return M

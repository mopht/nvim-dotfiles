-- ============================================================================
-- pack/install.lua — vim.pack wrapper: install, build hooks, maintenance commands
-- Owns "how plugins are installed/updated", not load order
-- ============================================================================

local M = {}
local api = vim.api

-- Convert a registry spec into what vim.pack.add() expects
local function to_pack_spec(p)
    return {
        name    = p.name,
        src     = p.src:find("://", 1, true) and p.src or ("https://github.com/" .. p.src),
        version = p.version,
    }
end

-- Extra build step to run after a plugin is installed or updated
local BUILDERS = {
    ["nvim-treesitter"] = function() vim.cmd("TSUpdate") end,
    ["blink.cmp"] = function()
        -- build() returns a blink.lib.Task; that class does not annotate its
        -- pwait/wait methods, hence the suppression
        ---@diagnostic disable-next-line: undefined-field
        local done, err = require("blink.cmp").build():pwait()
        if not done then error(err, 0) end
    end,
}

local function setup_build_hook()
    api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            local d = ev.data
            local build = BUILDERS[d.spec.name]
            if not build or (d.kind ~= "install" and d.kind ~= "update") then return end

            if not d.active then vim.cmd.packadd(d.spec.name) end

            local ok, err = pcall(build)
            if not ok then
                vim.notify(("pack: build failed for %s: %s"):format(d.spec.name, err), vim.log.levels.ERROR)
            end
        end,
    })
end

-- eager plugins go on the rtp immediately; lazy ones are only registered,
-- loading them is lz.n's job
function M.install(specs)
    local eager, lazy = {}, {}
    for _, p in ipairs(specs) do
         table.insert(p.lazy and lazy or eager, to_pack_spec(p))
    end

    vim.pack.add(eager)
    vim.pack.add(lazy, { load = function() end })
end

function M.commands(specs)
    api.nvim_create_user_command("PackUpdate", function(opts)
        local names = #opts.fargs > 0 and opts.fargs or nil
        vim.pack.update(names)
    end, { nargs = "*", desc = "Update plugins via vim.pack" })

    api.nvim_create_user_command("PackClean", function()
        local known = {}
        for _, p in ipairs(specs) do known[p.name] = true end

        local stale = {}
        for _, p in ipairs(vim.pack.get()) do
            if not known[p.spec.name] then
                stale[#stale + 1] = p.spec.name
            end
        end

        if #stale == 0 then
            vim.notify("pack: nothing to clean", vim.log.levels.INFO)
            return
        end

        vim.pack.del(stale)
        vim.notify("pack: removed " .. table.concat(stale, ", "), vim.log.levels.INFO)
    end, { desc = "Remove plugins not listed in the registry" })
end

function M.setup(specs)
    setup_build_hook()
    M.install(specs)
    M.commands(specs)
end

return M

-- Task templates for overseer: bun and cabal.
local M = {}

-- Run from the project root when the current buffer is inside one
local function project_root(markers)
    return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local function bun_root()
    return project_root { "bun.lockb", "bun.lock", "package.json" }
end

local function cabal_root()
    return project_root{
        "cabal.project",
        "cabal.project.local",
        function(name) return name:match("%.cabal$") ~= nil end,
    }
end

-- Scripts declared in the nearest package.json
local function package_scripts()
    local path = bun_root() .. "/package.json"
    if vim.fn.filereadable(path) == 0 then return {} end

    local ok, data = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
    end)
    if not ok or type(data) ~= "table" or type(data.scripts) ~= "table" then return {} end

    local scripts = vim.tbl_keys(data.scripts)
    table.sort(scripts)
    return scripts
end

local function args_param()
    return {
        desc = "Extra arguments",
        type = "list",
        subtype = { type = "string" },
        optional = true,
    }
end

M.templates = {
    {
        name = "bun run",
        desc = "Run a package.json script with bun",
        tags = { "bun" },
        params = function()
            local scripts = package_scripts()
            if #scripts == 0 then
                return { script = { desc = "Script", type = "string" }, args = args_param() }
            end
            return {
                script = { desc = "Script", type = "enum", choices = scripts },
                args = args_param(),
            }
        end,
        builder = function(params)
            local cmd = { "bun", "run" }
            if params.script and params.script ~= "" then table.insert(cmd, params.script) end
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = bun_root(), components = { "default" } }
        end,
    },
    {
        name = "bun test",
        desc = "Run bun test",
        tags = { "bun" },
        params = { args = args_param() },
        builder = function(params)
            local cmd = { "bun", "test" }
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = bun_root(), components = { "default" } }
        end,
    },
    {
        name = "bun install",
        desc = "Install dependencies with bun",
        tags = { "bun" },
        params = { args = args_param() },
        builder = function(params)
            local cmd = { "bun", "install" }
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = bun_root(), components = { "default" } }
        end,
    },
    {
        name = "cabal build",
        desc = "Build the current cabal project",
        tags = { "cabal" },
        params = { args = args_param() },
        builder = function(params)
            local cmd = { "cabal", "build" }
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = cabal_root(), components = { "default" } }
        end,
    },
    {
        name = "cabal test",
        desc = "Run the test suite of the current cabal project",
        tags = { "cabal" },
        params = { args = args_param() },
        builder = function(params)
            local cmd = { "cabal", "test" }
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = cabal_root(), components = { "default" } }
        end,
    },
    {
        name = "cabal run",
        desc = "Run a cabal executable",
        tags = { "cabal" },
        params = {
            target = { desc = "Executable", type = "string", optional = true },
            args = args_param(),
        },
        builder = function(params)
            local cmd = { "cabal", "run" }
            if params.target and params.target ~= "" then table.insert(cmd, params.target) end
            vim.list_extend(cmd, params.args or {})
            return { cmd = cmd, cwd = cabal_root(), components = { "default" } }
        end,
    },
}

return M

-- Discovers plugin specs from lua/plugins/<category>/*.lua.
-- Each file returns either a single spec table or a list of spec tables.
-- Anything else in lua/plugins/ is a mistake and fails loudly: files placed
-- directly in lua/plugins/ used to be skipped silently.

local M = {}

local root = vim.fn.stdpath("config") .. "/lua/plugins"

local specs = {}

local function load_spec(module)
    local ok, loaded = pcall(require, module)
    if not ok then
        error(("cannot load plugin spec %s: %s"):format(module, loaded), 0)
    end
    if type(loaded) ~= "table" then
        error(("plugin spec %s must return a table, got %s"):format(module, type(loaded)), 1)
    end

    if loaded.name then
        table.insert(specs, loaded)
    else
        vim.list_extend(specs, loaded)
    end
end

for name, type in vim.fs.dir(root) do
    if type == "directory" then
        for file, ftype in vim.fs.dir(root .. "/" .. name) do
            if ftype ~= "file" or (not file:match("%.lua$")) then goto continue end
            local stem = file:gsub("%.lua$", "")
            load_spec("plugins." .. name .. "." .. stem)

            :: continue ::
        end
    elseif type == "file" and name:match("%.lua$") then
        error(("plugin spec %s must live in a category directory, e.g. lua/plugins/editor/%s")
            :format(name, name), 0)
    end
end


M.plugins = specs

return M

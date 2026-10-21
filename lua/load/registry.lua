-- Discovers plugin specs from lua/plugins/<category>/*.lua.
-- Each file returns either a single spec table or a list of spec tables.
-- Anything else in lua/plugins/ is a mistake and fails loudly: files placed
-- directly in lua/plugins/ used to be skipped silently.

local M = {}

local root = vim.fn.stdpath("config") .. "/lua/plugins"

-- vim.fs.dir yields filesystem order; sorting keeps the load order stable
local function sorted_entries(path)
    local entries = {}
    for name, type in vim.fs.dir(path) do
        entries[#entries + 1] = { name = name, type = type }
    end
    table.sort(entries, function(a, b) return a.name < b.name end)
    return entries
end

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

for _, category in ipairs(sorted_entries(root)) do
    if category.type == "directory" then
        for _, file in ipairs(sorted_entries(root .. "/" .. category.name)) do
            if file.type == "file" and file.name:match("%.lua$") then
                load_spec(("plugins.%s.%s"):format(category.name, file.name:gsub("%.lua$", "")))
            end
        end
    elseif category.type == "file" and category.name:match("%.lua$") then
        error(("plugin spec %s must live in a category directory, e.g. lua/plugins/editor/%s")
            :format(category.name, category.name), 0)
    end
end

M.plugins = specs

return M

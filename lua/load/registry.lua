-- Discovers specs in lua/plugins/<category>/*.lua. Each file returns one spec
-- table or a list of specs. A spec's first element is its repository; `name`
-- defaults to the repository name and only needs to be set when it differs.
-- A spec file directly in lua/plugins/ is an error.

local M = {}

local root = vim.fn.stdpath("config") .. "/lua/plugins"

-- sort entries so the load order is stable
local function sorted_entries(path)
    local entries = {}
    for name, type in vim.fs.dir(path) do
        entries[#entries + 1] = { name = name, type = type }
    end
    table.sort(entries, function(a, b) return a.name < b.name end)
    return entries
end

local specs = {}
local seen = {}

-- "folke/flash.nvim" or a full URL -> "flash.nvim"
local function src_name(src)
    local path = src:gsub("%.git$", ""):gsub("/+$", "")
    return path:match("([^/]+)$") or path
end

local function check_spec(entry, module)
    if type(entry) ~= "table" then
        error(("plugin spec %s: expected a table, got %s"):format(module, type(entry)), 0)
    end

    local src = entry[1] or entry.src
    if type(src) ~= "string" then
        error(("plugin spec %s: missing repository"):format(module), 0)
    end

    local name = entry.name or src_name(src)
    if seen[name] then
        error(("plugin spec %s: duplicate plugin %q"):format(module, name), 0)
    end
    seen[name] = true

    -- normalize, the rest of the loader only deals with name and src
    entry.name = name
    entry.src = src
end

local function load_spec(module)
    local ok, loaded = pcall(require, module)
    if not ok then
        error(("cannot load plugin spec %s: %s"):format(module, loaded), 0)
    end
    if type(loaded) ~= "table" then
        error(("plugin spec %s must return a table, got %s"):format(module, type(loaded)), 1)
    end

    -- one spec ({ "owner/repo", ... }) or a list of specs
    if type(loaded[1]) == "string" or loaded.name or loaded.src then
        check_spec(loaded, module)
        table.insert(specs, loaded)
    else
        for _, entry in ipairs(loaded) do check_spec(entry, module) end
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

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
        error(("plugin spec %s must return a table, got %s"):format(module, type(loaded)), 0)
    end

    if loaded.name then
        table.insert(specs, loaded)
    else
        vim.list_extend(specs, loaded)
    end
end

for _, entry in ipairs(vim.fn.glob(root .. "/*", false, true)) do
    if vim.fn.isdirectory(entry) == 1 then
        local category = vim.fn.fnamemodify(entry, ":t")

        for _, file in ipairs(vim.fn.glob(entry .. "/*.lua", false, true)) do
            load_spec("plugins." .. category .. "." .. vim.fn.fnamemodify(file, ":t:r"))
        end
    elseif entry:match("%.lua$") then
        error(("plugin spec %s must live in a category directory, e.g. lua/plugins/editor/%s")
            :format(vim.fn.fnamemodify(entry, ":t"), vim.fn.fnamemodify(entry, ":t")), 0)
    end
end

M.plugins = specs

return M

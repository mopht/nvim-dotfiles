-- Discovers plugin specs from lua/plugins/<category>/*.lua.
-- Each file returns either a single spec table or a list of spec tables.

local M = {}

local root = vim.fn.stdpath("config") .. "/lua/plugins"

local specs = {}

local function add(loaded)
    if loaded.name then
        table.insert(specs, loaded)
    else
        vim.list_extend(specs, loaded)
    end
end

for _, dir in ipairs(vim.fn.glob(root .. "/*", false, true)) do
    if vim.fn.isdirectory(dir) == 1 then
        local category = vim.fn.fnamemodify(dir, ":t")

        for _, file in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
            local name = vim.fn.fnamemodify(file, ":t:r")
            add(require("plugins." .. category .. "." .. name))
        end
    end
end

M.plugins = specs

return M

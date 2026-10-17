-- Plugin registry: auto-loads every .lua file under lua/plugins/<category>/.
-- A category file may return a single spec table or a list of spec tables.
local M = {}

local root = vim.fn.stdpath("config") .. "/lua/plugins"

local function add_specs(specs)
    if specs.name then table.insert(M, specs)
    else vim.list_extend(M, specs) end
end

for _, dir in ipairs(vim.fn.glob(root .. "/*", false, true)) do
    local name = vim.fn.fnamemodify(dir, ":t")
    if not (name ~= "specs" and vim.fn.isdirectory(dir) == 1) then goto continue end

    for _, file in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
        local mod = "plugins." .. name .. "." .. vim.fn.fnamemodify(file, ":t:r")
        add_specs(require(mod))
    end

    ::continue::
end

return { plugins = M }

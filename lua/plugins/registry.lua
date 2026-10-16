-- Plugin registry: assembled from category files.
local M = {}

local modules = {
    "plugins.core.core",
    "plugins.colorschemes.colorschemes",
    "plugins.lsp.lsp",
    "plugins.treesitter.treesitter",
    "plugins.ui.ui",
    "plugins.editor.editor",
    "plugins.navigation.navigation",
    "plugins.picker.picker",
    "plugins.language.language",
}

for _, mod in ipairs(modules) do
    local specs = require(mod)
    if specs.name then
        table.insert(M, specs)
    else
        vim.list_extend(M, specs)
    end
end

return { plugins = M }

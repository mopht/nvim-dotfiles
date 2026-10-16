local M = {
    { name = "blink.cmp", src = "saghen/blink.cmp", pack = "start",
    config = function()
        -- v2: build/download native fuzzy matcher (one-time, caches after)
        local ok, _ = pcall(function() require("blink.cmp").build():pwait() end)
        if not ok then
            vim.notify("blink.cmp: native build failed, using Lua fallback", vim.log.levels.WARN)
        end
        local spec = require("plugins.specs.blink-cmp")
        require("blink.cmp").setup(spec.opts or {})
    end },
    { name = "lsp_signature.nvim", src = "ray-x/lsp_signature.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("lsp_signature").setup(require("plugins.specs.lsp_signature").opts) end },
    { name = "friendly-snippets", src = "rafamadriz/friendly-snippets", pack = "opt", event = { "InsertEnter" } },
}

return M

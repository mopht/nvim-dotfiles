local M = {
    { name = "mason.nvim",           src = "mason-org/mason.nvim",           pack = "start" },
    { name = "mason-lspconfig.nvim", src = "mason-org/mason-lspconfig.nvim", pack = "start" },

    { name = "nvim-lspconfig", src = "neovim/nvim-lspconfig", pack = "start",
    config = function()
        local spec = require("plugins.specs.nvim-lspconfig")
        if spec.config then spec.config() end
    end },

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

    { name = "lazydev.nvim", src = "folke/lazydev.nvim", pack = "opt", ft = { "lua" },
    config = function() require("lazydev").setup(require("plugins.specs.lazydev").opts) end },

    { name = "lsp_signature.nvim", src = "ray-x/lsp_signature.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("lsp_signature").setup(require("plugins.specs.lsp_signature").opts) end },

    { name = "none-ls.nvim", src = "nvimtools/none-ls.nvim", pack = "opt", event = { "LspAttach" },
    config = function()
        vim.cmd("packadd none-ls-extras.nvim")
        local spec = require("plugins.specs.none-ls")
        if spec.config then spec.config() end
    end },

    { name = "none-ls-extras.nvim", src = "nvimtools/none-ls-extras.nvim", pack = "opt" },

    { name = "friendly-snippets", src = "rafamadriz/friendly-snippets", pack = "opt", event = { "InsertEnter" } },
}

return M

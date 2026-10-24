-- LSP servers: name -> vim.lsp.config() overrides. Servers not listed keep
-- nvim-lspconfig's defaults.
--
-- haskell-language-server is started by haskell-tools.nvim (ftplugin). Do not
-- enable it here: the second client starts without --lsp and exits.
local servers = {
    clangd = { cmd = { "clangd" }, filetypes = { "cpp", "c++", "c" } },
    nixd = { cmd = { "nixd" }, filetypes = { "nix" } },
    lua_ls = { cmd = { "lua-language-server" }, filetypes = { "lua" } },
    ["moonbit-lsp"] = { cmd = { "moon lsp" }, filetypes = { "moonbit" } },
    ["scheme-lsp"] = { cmd = { "guile-lsp-server" }, filetypes = { "scheme" } },
    tslsp = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript" },
        root_markers = { "tsconfig.json", "package.json", ".git" },
    },
    idris2_lsp = {
        cmd = { "idris2-lsp" },
        filetypes = { "idris2", "idr" },
        root_markers = { ".ipkg", ".git" },
    },
    prolog_ls = {
        cmd = {
            "swipl", "-g", "use_module(library(lsp_server))",
            "-g", "lsp_server:main", "-t", "halt", "--", "stdio",
        },
        filetypes = { "prolog" },
        root_markers = { ".git" },
    },
}

return {
    { name = "nvim-lspconfig", src = "neovim/nvim-lspconfig", lazy = false,
    config = function()
        -- vim.lsp.config() / vim.lsp.enable()
        vim.diagnostic.config({
            virtual_text = { prefix = "■" },
            severity_sort = true,
            float = { source = true },
        })

        for name, overrides in pairs(servers) do
            vim.lsp.config(name, overrides)
            vim.lsp.enable(name)
        end
    end },

    -- Loaded at startup: blink.cmp requires the provider module when it sets up
    { name = "lazydev.nvim", src = "folke/lazydev.nvim", lazy = false,
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },

    { name = "conform.nvim", src = "stevearc/conform.nvim", lazy = true,
    event = { "BufWritePre" }, cmd = { "ConformInfo" },
    keys = {
        { "<leader>=", mode = "n", action = function()
            require("conform").format({ async = true })
        end, desc = "Format" },
    },
    opts = {
        -- Add formatters per filetype when the binaries are available, e.g.:
        -- lua = { "stylua" },
        -- nix = { "nixfmt" },
        -- typescript = { "prettierd", "prettier", stop_after_first = true },
        formatters_by_ft = {
            lua = { "stylua" },
            nix = { "nixfmt" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    } },
}

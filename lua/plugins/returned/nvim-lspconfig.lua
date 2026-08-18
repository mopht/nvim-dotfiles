return {
    'neovim/nvim-lspconfig',

    dependencies = {
        'saghen/blink.cmp',
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim"
    },

    opts = {
        servers = {
            lua_ls = {},
            clangd = {}
        }
    },
    config = function()
        -- nvim-lspconfig 0.11+ API: use vim.lsp.enable() / vim.lsp.config()
        -- Old require('lspconfig').xxx.setup() is DEPRECATED

        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                -- "lua_ls",
                -- "clangd",
                -- "hls"
            },
            handlers = {
                -- Default: auto-enable all installed servers
                function(server_name)
                    vim.lsp.enable(server_name)
                end,
                -- Custom: clangd uses specific path
                -- ["clangd"] = function()
                --     vim.lsp.config("clangd", {
                --         cmd = {
                --             "E:/apps/apps/mingw-mstorsjo-llvm-ucrt/current/bin/clangd.exe",
                --             "--background-index",
                --             "--query-driver=clang++",
                --         },
                --         filetypes = { "cc", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                --     })
                --     vim.lsp.enable("clangd")
                -- end,
            },
        })

        vim.diagnostic.config({
            virtual_text = {
                prefix = '■',
            },
            severity_sort = true,
            float = {
                source = "always",
            },
        })

        -- haskell-language-server (via ghcup)
        vim.lsp.config("haskell-language-server", {
            cmd = { "haskell-language-server-wrapper" },
            filetypes = { "haskell", "lhaskell" },
        })
        vim.lsp.enable("haskell-language-server")

        vim.lsp.config("clangd", {
            cmd = { "clangd" },
            filetypes = { "cpp", "c++", "c" },
        })
        vim.lsp.enable("clangd")

        vim.lsp.config("idris2_lsp", {
            cmd = { "idris2-lsp" },
            filetypes = { "idris2", "idr" },
            root_markers = { ".ipkg", ".git"},
        })
        vim.lsp.enable("idris2_lsp")

        vim.lsp.config('prolog_ls', {
            cmd = { 'swipl', '-g', 'use_module(library(lsp_server))', '-g', 'lsp_server:main', '-t', 'halt', '--', 'stdio' },
            filetypes = { 'prolog' },
            root_markers = { '.git' },
        })
        vim.lsp.enable('prolog_ls')
        -- vim.lsp.inlay_hint.enable()
    end
}

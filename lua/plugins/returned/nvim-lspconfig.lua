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
        local lspconfig = require("lspconfig")
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
            -- 确保安装，根据需要填写
            ensure_installed = {
                -- "lua_ls",
                -- "clangd",
                "hls"
            },
        })

        -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.diagnostic.config({
            virtual_text = {
                -- source = "always",  -- Or "if_many"
                prefix = '■', -- Could be '■', '▎', 'x'
            },
            severity_sort = true,
            float = {
                source = "always", -- Or "if_many"
            },
        })

        require("mason-lspconfig").setup({
            function(server_name)
                vim.lsp.config(server_name).setup({})
            end,
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    cmd = {
                        "clangd",
                        "--experimental-modules-support"
                    },
                })
            end
        })

        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                -- "--experimental-modules-support",
                "--background-index",
                -- "--format-style=file",
                -- "--query-driver=*arm-none-eabi*",
                -- "-fmodules",
                -- "--std=c++26",
                -- NOTE：在Windows下使用如下绝对路径时反而无效
                -- "--query-driver=${path_to_compiler}\\gcc-arm-none-eabi\\12.2.rel1\\bin\\arm-none-eabi*",
            },
            filetypes = { "cc", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        })
        vim.lsp.config("haskell-language-server", {
            cmd = {
                "haskell-language-server",
                -- "--experimental-modules-support",
                -- "--background-index",
                -- "--format-style=file",
                -- "--query-driver=*arm-none-eabi*",
                -- "-fmodules",
                -- "--std=c++26",
                -- NOTE：在Windows下使用如下绝对路径时反而无效
                -- "--query-driver=${path_to_compiler}\\gcc-arm-none-eabi\\12.2.rel1\\bin\\arm-none-eabi*",
            },
            filetypes = { "hs" },
        })
    end
}

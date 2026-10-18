return {
    { name = "nvim-lspconfig", src = "neovim/nvim-lspconfig", pack = "start",
    config = function()
        -- nvim-lspconfig 0.11+ API: use vim.lsp.enable() / vim.lsp.config()
        -- Old require('lspconfig').xxx.setup() is DEPRECATED

        vim.diagnostic.config({
            virtual_text = {
                prefix = '■',
            },
            severity_sort = true,
            float = {
                source = true,
            },
        })

        -- haskell-language-server is started by haskell-tools.nvim from its
        -- ftplugin (see lua/plugins/language/functional.lua), with --lsp and a
        -- per-session --logfile. Enabling it here as well starts a second
        -- client without --lsp, which exits right away and shows up as
        -- "Client haskell-language-server quit with exit code ..."

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

        vim.lsp.config("nixd", {
            cmd = { "nixd" },
            filetypes = { "nix" },
        })
        vim.lsp.enable("nixd")

        vim.lsp.config("moonbit-lsp", {
            cmd = { "moon-lsp" },
            filetypes = { "moonbit" },
        })
        vim.lsp.enable("moonbit-lsp")

        vim.lsp.config("scheme-lsp", {
            cmd = { "guile-lsp-server" },
            filetypes = { "scheme" },
        })
        vim.lsp.enable("scheme-lsp")

        vim.lsp.config("tslsp", {
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = { "typescript" },
            root_dir = vim.fs.root(0, {'package.json', 'tsconfig.json', '.git'})
        })
        vim.lsp.enable("tslsp")

        vim.lsp.config("lua_ls", {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
        })
        vim.lsp.enable("lua_ls")
    end },
}

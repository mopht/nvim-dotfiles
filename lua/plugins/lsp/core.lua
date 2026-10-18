-- LSP servers: name -> vim.lsp.config() overrides. Anything not listed here
-- still gets nvim-lspconfig's defaults.
--
-- haskell-language-server is intentionally absent: haskell-tools.nvim starts it
-- from its ftplugin (see lua/plugins/language/functional.lua) with --lsp and a
-- per-session --logfile. Enabling it here as well started a second client
-- without --lsp, which exited right away and showed up as "Client
-- haskell-language-server quit with exit code ...".
local servers = {
    clangd = { cmd = { "clangd" }, filetypes = { "cpp", "c++", "c" } },
    nixd = { cmd = { "nixd" }, filetypes = { "nix" } },
    lua_ls = { cmd = { "lua-language-server" }, filetypes = { "lua" } },
    ["moonbit-lsp"] = { cmd = { "moon-lsp" }, filetypes = { "moonbit" } },
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
        -- nvim-lspconfig 0.11+ API: use vim.lsp.enable() / vim.lsp.config()
        -- Old require('lspconfig').xxx.setup() is DEPRECATED
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
}

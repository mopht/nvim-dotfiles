return {
    { name = "conform.nvim", src = "stevearc/conform.nvim", lazy = false,
    config = function()
        require("conform").setup({
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
        })
    end },
}

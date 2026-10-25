local blink_opts = {
    keymap = {
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
        -- 'mono' (default) or 'normal' for 'Nerd Font'
        nerd_font_variant = 'normal',
    },

    completion = {
        documentation = { auto_show = true },
    },

    -- default providers plus lazydev
    sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
        },
    },
}

return {
    { "saghen/blink.cmp", lazy = true,
    event = "InsertEnter", cmd = { "BlinkCmp" },
    -- native matcher: built by the PackChanged hook in lua/load/install.lua
    config = function()
        require("blink.cmp").setup(blink_opts)
    end },

    { "rafamadriz/friendly-snippets", lazy = true,
    event = { "InsertEnter" } },
}

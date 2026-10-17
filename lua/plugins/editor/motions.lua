local goto_preview_opts = {
    width = 120, -- Width of the floating window
    height = 15, -- Height of the floating window
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
    default_mappings = true, -- Bind default mappings
    print(),
    debug = false, -- Print debug information
    opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
    resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
    post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
    post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
    references = { -- Configure the telescope UI for slowing the references cycling window.
        -- telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
    },
    -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
    focus_on_open = true,                                      -- Focus the floating window when opening it.
    dismiss_on_move = false,                                   -- Dismiss the floating window when moving the cursor.
    force_close = true,                                        -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
    bufhidden = "wipe",                                        -- the bufhidden option to set on the floating window. See :h bufhidden
    stack_floating_preview_windows = true,                     -- Whether to nest floating windows
    preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
    zindex = 1,                                                -- Starting zindex for the stack of floating windows
}

return {
    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt",
    keys = {
        { "s",     mode = { "n", "x", "o" }, action = function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, action = function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               action = function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      action = function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = "c",               action = function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function() require("flash").setup({})
    end },
    { name = "goto-preview", src = "rmagatti/goto-preview", pack = "opt",
    keys = {
        { "gpd", mode = "n", action = function() require("goto-preview").goto_preview_definition() end,      desc = "Preview Definition" },
        { "gpt", mode = "n", action = function() require("goto-preview").goto_preview_type_definition({}) end, desc = "Preview Type Def" },
        { "gpi", mode = "n", action = function() require("goto-preview").goto_preview_implementation({}) end,  desc = "Preview Impl" },
        { "gpD", mode = "n", action = function() require("goto-preview").goto_preview_declaration({}) end,     desc = "Preview Declaration" },
        { "gP",  mode = "n", action = function() require("goto-preview").close_all_win() end,                desc = "Close All Previews" },
    },
    config = function()
        require("goto-preview").setup(goto_preview_opts)
    end },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", pack = "opt",
    keys = {
        { "<C-u>", desc = "Scroll up half page" },
        { "<C-d>", desc = "Scroll down half page" },
        { "<C-b>", desc = "Scroll up page" },
        { "<C-f>", desc = "Scroll down page" },
        { "<C-y>", desc = "Scroll line up" },
        { "<C-e>", desc = "Scroll line down" },
        { "zz",    desc = "Center cursor line" },
        { "zt",    desc = "Cursor line to top" },
        { "zb",    desc = "Cursor line to bottom" },
    },
    config = function() require("neoscroll").setup({}) end },
}

-- return M

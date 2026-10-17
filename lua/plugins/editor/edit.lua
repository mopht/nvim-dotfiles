local better_escape_opts = {
    default_mappings = false,
    mappings = {
        i = {
            j = {
                k = "<Esc>",
                j = "<Esc>"
            },
        },
    },
}

local tabout_opts = {
    tabkey = "<Tab>",          -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true,         -- shift content if tab out is not possible
    act_as_shift_tab = false,  -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    default_tab = "<C-t>",     -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
    default_shift_tab = "<C-d>", -- reverse shift default action,
    enable_backwards = true,   -- well ...
    completion = true,         -- if the tabkey is used in a completion pum
    tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
    },
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {}, -- tabout will ignore these filetypes
}

local M = {
    { name = "better-escape.nvim", src = "max397574/better-escape.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("better_escape").setup(better_escape_opts) end },
    { name = "tabout.nvim", src = "abecodes/tabout.nvim", pack = "opt", event = { "InsertEnter" },
    config = function() require("tabout").setup(tabout_opts) end },
    -- nvim-autopairs removed: use Neovim's built-in editing behavior and
    -- blink.cmp completion.accept.auto_brackets instead.
}

return M

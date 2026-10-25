-- Resize the explorer split to fit the widest visible line.
local function explorer_resize_to_widest(picker)
    local snack_win = picker.list and picker.list.win
    if not (snack_win and snack_win.win and vim.api.nvim_win_is_valid(snack_win.win)) then
        return
    end

    local max_width = 0
    for _, line in ipairs(vim.api.nvim_buf_get_lines(snack_win.buf, 0, -1, false)) do
        max_width = math.max(max_width, vim.api.nvim_strwidth(line))
    end

    local width = math.max(max_width + 4, 19)
    width = math.min(width, math.max(vim.o.columns - 10, 19))
    pcall(vim.api.nvim_win_set_width, snack_win.win, width)
end

local snacks_opts = {
    scroll = {
        animate = {
            duration = { step = 10, total = 200 },
            easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
            delay = 100, -- delay in ms before using the repeat animation
            duration = { step = 5, total = 50 },
            easing = "linear",
        },
    },
    explorer = {
        enabled = true,
        replace_netrw = true,
    },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    image = { enabled = true },
    lazygit = { enabled = true },
    indent = {
        enabled = true,
        scope = { enabled = true },
        chunk = {
            enabled = true,
            char = {
                corner_top = "╭",
                corner_bottom = "╰",
            },
        },
    },
    picker = {
        enabled = true,
        layout = {
            preset = "default",
            layout = {
                width = 0.85,
                min_width = 70,
            },
        },
        sources = {
            explorer = {
                layout = {
                    preset = "sidebar",
                    preview = false,
                    cycle = false,
                    layout = {
                        width = 19,
                        min_width = 19,
                        max_width = 999,
                        height = 0,
                        position = "left",
                    },
                },
                actions = {
                    resize_to_widest = explorer_resize_to_widest,
                },
                win = { list = { keys = { e = "resize_to_widest" } } },
            },
        },
    },
    terminal = {
        win = {
            style = "terminal",
        },
    },
    -- replacement for zen-mode.nvim, driven by the commands below
    zen = {
        enabled = true,
        -- zen-mode.nvim used to strip the gutters, keep that look
        win = {
            wo = {
                number = false,
                relativenumber = false,
                signcolumn = "no",
                foldcolumn = "0",
            },
        },
    },
    -- replacement for twilight.nvim, driven by the commands below
    dim = { enabled = true },
}

-- Keep the commands of the plugins these two replaced, so nothing else moves.
local function focus_commands()
    local snacks = require("snacks")

    local function toggle_dim()
        if snacks.dim.enabled then
            snacks.dim.disable()
        else
            snacks.dim.enable()
        end
    end

    vim.api.nvim_create_user_command("ZenMode", function() snacks.zen() end, { desc = "Toggle zen mode" })
    vim.api.nvim_create_user_command("Twilight", toggle_dim, { desc = "Toggle dimming outside the scope" })
    vim.api.nvim_create_user_command("TwilightEnable", function() snacks.dim.enable() end,
        { desc = "Dim outside the scope" })
    vim.api.nvim_create_user_command("TwilightDisable", function() snacks.dim.disable() end,
        { desc = "Stop dimming" })
end

return {
    { name = "snacks.nvim", src = "folke/snacks.nvim", lazy = true,
    event = { "BufReadPre" },
    cmd = { "ZenMode", "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
        { "<leader>e",       action = function() require("snacks").explorer() end,       desc = "Toggle explorer" },
        { "<leader><space>", action = function() require("snacks").picker.smart() end,   desc = "Smart Find Files" },
        { "<leader>f",       action = function() require("snacks").picker.files() end,   desc = "Find Files" },
        { "<leader>g",       action = function() require("snacks").picker.grep() end,    desc = "Live Grep" },
        { "<leader>b",       action = function() require("snacks").picker.buffers() end, desc = "Find Buffers" },
        { "<leader>hh",      action = function() require("snacks").picker.help() end,    desc = "Help Tags" },
        { "<F8>",            action = function() require("snacks").terminal.toggle(nil, { win = { position = "bottom", height = 9 } }) end, desc = "Toggle terminal" },
        { "<leader>tn",      action = function() require("snacks").terminal.toggle("nu", { win = { position = "float", width = 0.8, height = 0.8 } }) end, desc = "Nushell" },
        { "<leader>tm",      action = function() require("snacks").lazygit() end, desc = "Lazygit" },
    },
    opts = snacks_opts,
    config = focus_commands },
}

-- Task runner. Loaded through `cmd` or `keys`; no task-list keymaps beyond
-- the buffer-local ones the plugin ships.
return {
    { name = "overseer.nvim", src = "stevearc/overseer.nvim", lazy = true,
    cmd = {
        "Overseer",
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerRun",
        "OverseerShell",
        "OverseerTaskAction",
    },
    keys = {
        { "<leader>rr", mode = "n", action = function() vim.cmd("OverseerRun") end, desc = "Run task" },
        { "<leader>rt", mode = "n", action = function() vim.cmd("OverseerToggle") end, desc = "Toggle task list" },
        { "<leader>rs", mode = "n", action = function() vim.cmd("OverseerShell") end, desc = "Run shell command" },
        { "<leader>ra", mode = "n", action = function() vim.cmd("OverseerTaskAction") end, desc = "Task action" },
    },
    opts = {} },
}

-- Task runner. Loaded by `cmd` or `keys`.
return {
    { "stevearc/overseer.nvim", lazy = true,
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
    opts = {},
    config = function()
        local overseer = require "overseer"
        for _, template in ipairs(require("plugins.tools.overseer.templates").templates) do
            overseer.register_template(template)
        end
    end },
}

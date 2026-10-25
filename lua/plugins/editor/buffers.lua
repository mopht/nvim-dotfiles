return {
    { "nvim-mini/mini.trailspace", lazy = true,
    event = { "BufEnter" }, opts = {},
    config = function()
        vim.api.nvim_create_user_command("StripWhitespace", function()
            require("mini.trailspace").trim()
        end, { desc = "Trim trailing whitespace" })
    end },

    { "folke/todo-comments.nvim", lazy = true, event = { "BufEnter" },
    keys = {
        { "tl", mode = "n", action = function() vim.cmd("TodoLocList") end, desc = "Todo location list" },
    },
    opts = {} },

    { "okuuva/auto-save.nvim", lazy = true, event = { "InsertEnter" },
    opts = {
        condition = function(buf)
            local bo = vim.bo[buf]
            return bo.buftype == "" and bo.filetype ~= "gitcommit"
        end,
    } },
}

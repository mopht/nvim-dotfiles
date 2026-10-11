return {
    -- 'akinsho/toggleterm.nvim',
    -- version = "*",
    config = function()
        require("toggleterm").setup({
            float_opts = {
                -- The border key is *almost* the same as 'nvim_open_win'
                -- see :h nvim_open_win for details on borders however
                -- the 'curved' border is a custom border type
                -- not natively supported but implemented in this plugin.
                border = 'curved',
                -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
                width = 115,
                height = 22,
                winblend = 3,
                title_pos = 'left'
            },

        })

        local Terminal = require("toggleterm.terminal").Terminal
        local nushell = Terminal:new { cmd = "nu", direction = "float", hidden = true }
        local lazygit = Terminal:new { cmd = "lazygit", direction = "float",  hidden = true }

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        function _NUSHELL_TOGGLE()
            nushell:toggle()
        end
    end
}

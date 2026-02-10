return {
    "akinsho/bufferline.nvim",
    -- after = {"folke/tokyonight.nvim"},
    lazy = true,
    event = "VeryLazy",
    -- cmd = {"colorscheme tokyonight"},
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            offsets = {{
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
            }},

            max_name_length = 10,
            tab_size = 15,
        }
    }
}

-- stdpath("data")
-- macOS/Linux: ~/.local/share/nvim
-- Windows: ~/AppData/Local/nvim-data
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        { import = "plugins.returned.zig-lamp" },
        { import = "plugins.returned.blink-cmp"},
        { import = "plugins.returned.flash" },
        { import = "plugins.returned.lazydev" },
        { import = "plugins.returned.toggleterm" },
        { import = "plugins.returned.which-key" },
        { import = "plugins.returned.vim-better-whitespace" },
        { import = "plugins.returned.lsp_signature" },
        { import = "plugins.returned.italicize" },
        { import = "plugins.returned.none-ls" },
        { import = "plugins.returned.guess-indent" },
        { import = "plugins.returned.goto-preview" },
        { import = "plugins.returned.hlchunk" },
        { import = "plugins.returned.neoscroll" },
        { import = "plugins.returned.barbecue" },
        { import = "plugins.returned.lualine" },
        { import = "plugins.returned.nvim-treesitter" },
        { import = "plugins.returned.neo-tree" },
        { import = "plugins.returned.vim-tmux-navigator" },
        { import = "plugins.returned.autopairs" },
        { import = "plugins.returned.nvim-lspconfig" };
        { import = "plugins.returned.bufferline" },
        { import = "plugins.returned.Comment" },
        { import = "plugins.returned.tabout" },
        { import = "plugins.returned.noice" },
        { import = "plugins.returned.better-escape" },
        { import = "plugins.returned.auto-save" },
        { import = "plugins.returned.ranbow-delimiters" },
        { import = "plugins.returned.nvim-treesitter-context" },
        { import = "plugins.returned.todo-comments" },
        { import = "plugins.returned.code_runner" },
        { import = "plugins.returned.rustaceanvim" },
        { import = "plugins.returned.inlay-hints" },
        { import = "plugins.returned.twilight" },
        { import = "plugins.returned.zen-mode" },
        { import = "plugins.returned.trouble" },
        { import = "plugins.returned.symbols-outline" },
        { import = "plugins.returned.fzf-lua"},

        { import = "plugins.returned.theme.everforest" },
        { import = "plugins.returned.theme.catppuccin" },
        { import = "plugins.returned.theme.tokyonight" },
    },
    install = { colorscheme = { "everforest" } },
    checker = { enabled = true },
})

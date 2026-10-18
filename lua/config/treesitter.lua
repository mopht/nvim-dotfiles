-- ============================================================================
-- treesitter.lua — treesitter highlight auto-start + treesitter-based folding
-- ============================================================================

local M = {}

-- Folding: use Neovim's built-in foldexpr; the old nvim_treesitter#foldexpr()
-- no longer exists upstream
function M.setup_folds()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
end

function M.auto_highlight()
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        callback = function(ev)
            if vim.treesitter.highlighter.active[ev.buf] then return end

            local ft = vim.bo[ev.buf].filetype
            if not (ft and ft ~= "") then return end

            local lang = vim.treesitter.language.get_lang(ft)
            if lang then pcall(vim.treesitter.start, ev.buf, lang) end
        end,
        desc = "auto-start treesitter highlighting",
    })
end

return M

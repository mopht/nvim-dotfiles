-- ============================================================================
-- treesitter.lua — treesitter highlight / indent auto-start + folding
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
            local buf = ev.buf
            local ft = vim.bo[buf].filetype

            if not vim.treesitter.highlighter.active[buf] then
                if not (ft and ft ~= "") then return end

                local lang = vim.treesitter.language.get_lang(ft)
                if not lang or not pcall(vim.treesitter.start, buf, lang) then return end
            end

            -- The main branch no longer enables indent through setup(); it has
            -- to be set per buffer. This runs on every event because the
            -- filetype indent files are sourced on FileType, i.e. after
            -- BufReadPost, and would otherwise override it. Languages without
            -- an indent query are skipped: get_indent() returns 0 for them,
            -- which would flatten the buffer instead of keeping its indent
            local lang = vim.treesitter.language.get_lang(ft)
            if not lang then return end

            local ok, query = pcall(vim.treesitter.query.get, lang, "indents")
            if ok and query then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
        desc = "start treesitter highlighting and indent",
    })
end

return M

-- Treesitter highlight, indent and folds.

local M = {}

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
            if ft == "" then return end

            local lang = vim.treesitter.language.get_lang(ft)
            if not lang then return end

            if not vim.treesitter.highlighter.active[buf] then
                if not pcall(vim.treesitter.start, buf, lang) then return end
            end

            -- indentexpr is per buffer; only languages with an indent query
            -- get it, nvim-treesitter's indentexpr returns 0 otherwise
            local ok, query = pcall(vim.treesitter.query.get, lang, "indents")
            if ok and query then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
        desc = "start treesitter highlighting and indent",
    })
end

return M

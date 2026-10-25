-- Treesitter highlight, indent and folds.

local M = {}

-- Highlighting forces a full parse of the buffer during redraw (~200 ms for
-- 2k lines, ~400 ms for 20k lines), which turns scrolling and typing in a big
-- file into stutter. Above this size highlighting and treesitter indent are
-- off; folds stay on, since they only parse around the viewport.
local MAX_LINES = 10000

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

            if vim.api.nvim_buf_line_count(buf) > MAX_LINES then
                vim.b[buf].ts_large = true

                -- nvim 0.12's own ftplugins (lua, markdown, help, query) start
                -- highlighting before this autocmd runs, so the highlighter has
                -- to be stopped rather than skipped
                local function stop()
                    if vim.api.nvim_buf_is_valid(buf) and vim.treesitter.highlighter.active[buf] then
                        pcall(vim.treesitter.stop, buf)
                    end
                end

                stop()
                -- snacks.quickfile starts highlighting when it loads, which can
                -- happen after this autocmd, so stop again on the next tick
                vim.schedule(stop)

                if vim.bo[buf].indentexpr:find("nvim-treesitter", 1, true) then
                    vim.bo[buf].indentexpr = ""
                end
                return
            end

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

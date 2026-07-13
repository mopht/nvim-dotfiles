#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/plugins"
START_DIR="$PACK_ROOT/start"
OPT_DIR="$PACK_ROOT/opt"

clone() {
    local name="$1" repo="$2" dir="$3"
    local target="$dir/$name"
    if [ -d "$target" ]; then
        echo "  ✔ $name already exists, skipping"
        return 0
    fi
    echo "  → cloning $name ($repo) ..."
    git clone --filter=blob:none "https://github.com/$repo.git" "$target"
}

mkdir -p "$START_DIR" "$OPT_DIR"

echo "=== Installing start/ plugins (always loaded) ==="

clone _blink.lib              saghen/blink.lib               "$START_DIR"
clone plenary.nvim            nvim-lua/plenary.nvim          "$START_DIR"
clone nvim-web-devicons       nvim-tree/nvim-web-devicons    "$START_DIR"
clone nui.nvim                MunifTanjim/nui.nvim           "$START_DIR"
clone mini.icons              echasnovski/mini.icons         "$START_DIR"
clone nvim-navic              SmiteshP/nvim-navic            "$START_DIR"
clone mason.nvim              williamboman/mason.nvim        "$START_DIR"
clone mason-lspconfig.nvim    williamboman/mason-lspconfig.nvim "$START_DIR"
clone which-key.nvim          folke/which-key.nvim           "$START_DIR"
clone nvim-lspconfig          neovim/nvim-lspconfig          "$START_DIR"
clone blink.cmp               saghen/blink.cmp               "$START_DIR"
clone nvim-treesitter         nvim-treesitter/nvim-treesitter "$START_DIR"
clone tree-sitter-manager.nvim romus204/tree-sitter-manager.nvim "$START_DIR"
clone everforest-nvim         neanias/everforest-nvim        "$START_DIR"
clone lualine.nvim            nvim-lualine/lualine.nvim      "$START_DIR"
clone barbecue                utilyre/barbecue.nvim          "$START_DIR"
clone bufferline.nvim         akinsho/bufferline.nvim        "$START_DIR"
clone hlchunk.nvim            shellRaining/hlchunk.nvim      "$START_DIR"
clone noice.nvim              folke/noice.nvim               "$START_DIR"
clone rainbow-delimiters.nvim HiPhish/rainbow-delimiters.nvim "$START_DIR"
clone nvim-treesitter-context romgrk/nvim-treesitter-context "$START_DIR"
clone haskell-tools.nvim      mrcjkb/haskell-tools.nvim      "$START_DIR"

echo ""
echo "=== Installing opt/ plugins (lazy-loaded) ==="

clone neo-tree.nvim           nvim-neo-tree/neo-tree.nvim    "$OPT_DIR"
clone fzf-lua                 ibhagwan/fzf-lua               "$OPT_DIR"
clone trouble.nvim            folke/trouble.nvim             "$OPT_DIR"
clone symbols-outline.nvim    simrat39/symbols-outline.nvim  "$OPT_DIR"
clone code_runner.nvim        CRAG666/code_runner.nvim       "$OPT_DIR"
clone guess-indent.nvim       nmac427/guess-indent.nvim      "$OPT_DIR"
clone twilight.nvim           folke/twilight.nvim            "$OPT_DIR"
clone zen-mode.nvim           folke/zen-mode.nvim            "$OPT_DIR"
clone flash.nvim              folke/flash.nvim               "$OPT_DIR"
clone Comment.nvim            numToStr/Comment.nvim          "$OPT_DIR"
clone goto-preview            rmagatti/goto-preview          "$OPT_DIR"
clone neoscroll.nvim          karb94/neoscroll.nvim          "$OPT_DIR"
clone vim-tmux-navigator      christoomey/vim-tmux-navigator "$OPT_DIR"
clone auto-save.nvim          okuuva/auto-save.nvim          "$OPT_DIR"
clone better-escape.nvim      max397574/better-escape.nvim   "$OPT_DIR"
clone nvim-autopairs          windwp/nvim-autopairs          "$OPT_DIR"
clone tabout.nvim             abecodes/tabout.nvim           "$OPT_DIR"
clone lsp_signature.nvim      ray-x/lsp_signature.nvim       "$OPT_DIR"
clone friendly-snippets       rafamadriz/friendly-snippets   "$OPT_DIR"
clone none-ls.nvim            nvimtools/none-ls.nvim         "$OPT_DIR"
clone vim-better-whitespace   ntpeters/vim-better-whitespace "$OPT_DIR"
clone toggleterm.nvim         akinsho/toggleterm.nvim        "$OPT_DIR"
clone todo-comments.nvim      folke/todo-comments.nvim       "$OPT_DIR"
clone lazydev.nvim            folke/lazydev.nvim             "$OPT_DIR"
clone zig-lamp                jinzhongjia/zig-lamp           "$OPT_DIR"
clone rustaceanvim            mrcjkb/rustaceanvim            "$OPT_DIR"
#clone c3.nvim                 c3-lang/c3.nvim                "$OPT_DIR"
clone none-ls-extras.nvim     nvimtools/none-ls-extras.nvim  "$OPT_DIR"
clone catppuccin              catppuccin/nvim                "$OPT_DIR"
clone tokyonight.nvim         folke/tokyonight.nvim          "$OPT_DIR"

echo ""
echo "=== Installing treesitter parsers ==="
nvim --headless -u "$HOME/.config/nvim/init.lua" \
  -c 'lua require("nvim-treesitter").install({"lua", "vim", "vimdoc", "c", "cpp", "rust", "bash", "javascript", "markdown", "markdown_inline", "yaml", "toml", "json", "haskell", "python", "typescript"}); vim.defer_fn(function() vim.cmd("qa!") end, 60000)' \
  2>&1
echo ""

echo "=== All plugins installed ==="
echo "Start plugins: $(ls -1 "$START_DIR" | wc -l)"
echo "Opt plugins:   $(ls -1 "$OPT_DIR" | wc -l)"

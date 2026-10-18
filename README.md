# nvim-config

English | [简体中文](README-CN.md)

Personal Neovim configuration. Plugins are installed and managed by Neovim's built-in `vim.pack`, with lazy loading powered by `lz.n`.

## ✨ Features

- **Plugin management**: `vim.pack` + `lz.n`
- **LSP**: `nvim-lspconfig` with manual `vim.lsp.config` / `vim.lsp.enable`, plus `lazydev.nvim`
- **Completion**: `blink.cmp` with lazydev source
- **Formatting**: `conform.nvim` (`stylua`, `nixfmt`, and LSP fallback)
- **Treesitter**: `nvim-treesitter`, `tree-sitter-manager.nvim`, `rainbow-delimiters.nvim`
- **Picker / terminal**: `snacks.nvim` (smart/files/grep/buffers/help, terminal, lazygit)
- **UI**: `which-key.nvim` (Helix preset), `mini.statusline`, `barbecue`, `noice.nvim`
- **Explorer / navigation**: `snacks.nvim` explorer, `oil.nvim`, `vim-tmux-navigator`
- **Editing**: `flash.nvim`, `goto-preview`, `neoscroll`, `nvim-autopairs`, `better-escape`, `tabout`, `auto-save`, `vim-better-whitespace`, `todo-comments.nvim`
- **Diagnostics panel**: `trouble.nvim`
- **Code runner**: `code_runner.nvim`
- **Colorschemes**: `everforest` by default, with `tokyonight` and `catppuccin` available
- **GUI**: Neovide font, opacity, and window settings

## ⚙️ Requirements

- **Neovim >= 0.12.4** (for native `vim.pack`)
- `git`
- `ripgrep`, `fd` (Snacks picker)
- A Nerd Font
- Optional: `lazygit`, `nushell`

LSP servers are configured manually in `lua/plugins/lsp/core.lua`; make sure their executables are on `PATH`.

Install language toolchains as needed:

- Haskell: `ghcup` + `haskell-language-server`
- C/C++: `clangd`
- Idris2: `idris2-lsp`
- Prolog: `swipl`
- Nix: `nixd`
- MoonBit: `moon` / `moon-lsp`
- Scheme: `guile-lsp-server`
- TypeScript: `typescript-language-server`
- Lua / lazydev: `lua-language-server`
- Formatting: `stylua`, `nixfmt`
- `code_runner.nvim`: `python3`, `deno`, `gcc`, `clang++`, `rustc`, `javac`, etc.

## 📦 Installation

Back up your existing config:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone this repository:

```bash
git clone git@github.com:MoYu-CL/nvim-dotfiles.git ~/.config/nvim
```

Start Neovim:

```bash
nvim
```

On first launch, `vim.pack` will prompt to install missing plugins. Plugin versions are pinned in `nvim-pack-lock.json`.

Useful commands:

```vim
:PackUpdate          " update all plugins
:PackUpdate <name>   " update a specific plugin
:PackClean           " remove plugins not registered in the registry
```

## 📁 Structure

```text
~/.config/nvim/
├── README.md
├── README-CN.md
├── init.lua
├── nvim-pack-lock.json
├── ftplugin/
│   └── haskell.lua
└── lua/
    ├── config/
    │   ├── colorscheme.lua
    │   ├── highlights.lua
    │   ├── keymaps.lua
    │   ├── neovide.lua
    │   ├── options.lua
    │   └── treesitter.lua
    ├── pack/
    │   ├── init.lua
    │   ├── install.lua
    │   └── registry.lua
    └── plugins/
        ├── lib/
        │   └── deps.lua
        ├── editor/
        │   ├── buffers.lua
        │   ├── edit.lua
        │   ├── focus.lua
        │   └── motions.lua
        ├── language/
        │   ├── functional.lua
        │   ├── moonbit.lua
        │   └── rust.lua
        ├── lsp/
        │   ├── completion.lua
        │   ├── core.lua
        │   ├── formatting.lua
        │   └── lazydev.lua
        ├── navigation/
        │   └── tmux.lua
        ├── tools/
        │   ├── oil.lua
        │   ├── snacks.lua
        │   └── trouble.lua
        ├── treesitter/
        │   ├── context.lua
        │   └── core.lua
        └── ui/
            ├── colorscheme.lua
            ├── effects.lua
            ├── status.lua
            └── which-key.lua
```

## 🧩 Plugin Layout

`lua/pack/registry.lua` automatically discovers every `.lua` file under `lua/plugins/<category>/`. Each file may return a single plugin spec or a list of specs:

```lua
-- A single plugin
return {
    { name = "mini.icons", src = "echasnovski/mini.icons", pack = "start" },
}
```

```lua
-- Multiple plugins in one file
return {
    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt", keys = { ... } },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", pack = "opt", keys = { ... } },
}
```

- `pack = "start"`: load at startup
- `pack = "opt"`: lazy-loaded via `cmd`, `keys`, `event`, or `ft`
- Keymaps with an `action` are bound after the plugin loads

`lua/pack/init.lua` only wires things together: it reads the registry, hands the specs to `vim.pack`, runs the start-plugin configs and the colorscheme on `VimEnter`, then registers lazy-loading rules with `lz.n`.

Supporting modules:

- `lua/pack/install.lua` — install/update via `vim.pack`, the Treesitter build hook, and `:PackUpdate` / `:PackClean`
- `lua/pack/registry.lua` — spec discovery; a spec file placed directly in `lua/plugins/` raises an error instead of being skipped
- `lua/config/colorscheme.lua` — applies the `colorscheme` field declared in the plugin specs
- `lua/config/treesitter.lua` — Treesitter highlight auto-start and `foldexpr`

## ⌨️ Keymaps

Leader is `<Space>`.

### Find / Terminal

| Key | Description |
| --- | --- |
| `<leader><space>` | Smart Find Files |
| `<leader>f` | Find Files |
| `<leader>g` | Live Grep |
| `<leader>b` | Find Buffers |
| `<leader>hh` | Help Tags |
| `<F8>` | Toggle bottom terminal |
| `<leader>tn` | Nushell float |
| `<leader>tm` | Lazygit |

### LSP / Editing

| Key | Description |
| --- | --- |
| `<leader>=` | Format buffer |
| `K` | Hover |
| `<C-o>` | Diagnostics float |
| `<leader>e` | Toggle snacks explorer |
| `-` | Open parent directory with Oil |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |
| `sl` / `sh` | Next / previous buffer |
| `nl` | Clear search highlight |
| `tl` | Todo location list |
| `<leader>he` | Haskell evaluate all |
| `<F11>` | Run code |

### Trouble

| Key | Description |
| --- | --- |
| `xx` | Workspace diagnostics |
| `xX` | Buffer diagnostics |
| `cs` | Symbols |
| `cl` | LSP references/definitions |
| `xL` | Location list |
| `xQ` | Quickfix list |

### Flash / Preview / Scrolling

| Key | Description |
| --- | --- |
| `s` / `S` | Flash jump / Treesitter |
| `r` / `R` | Remote Flash / Treesitter search |
| `gpd` / `gpt` / `gpi` / `gpD` | Goto preview definition/type/implementation/declaration |
| `gP` | Close all previews |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Window / tmux navigation |

## 🛠 Customization

- Core options: `lua/config/options.lua`
- Keymaps: `lua/config/keymaps.lua`
- Autocmds: `lua/config/highlights.lua`
- Neovide settings: `lua/config/neovide.lua`
- LSP servers: `lua/plugins/lsp/core.lua`
- Formatters: `lua/plugins/lsp/formatting.lua`
- Add plugins: create or edit a `.lua` file under `lua/plugins/<category>/` (a file directly in `lua/plugins/` is rejected at startup)
- Change colorscheme: edit the `colorscheme` field in `lua/plugins/colorschemes/colorschemes.lua`

## Notes

- Plugin install location: `stdpath("data")/site/pack/core/opt/`
- Lock file: `nvim-pack-lock.json`
- New plugins are installed by `vim.pack` on the next startup after updating the registry


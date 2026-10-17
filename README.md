# nvim-config

English | [简体中文](README-CN.md)

Personal Neovim configuration. Plugins are installed and managed by Neovim's built-in `vim.pack`, with lazy loading powered by `lz.n`.

## ✨ Features

- **Plugin management**: `vim.pack` + `lz.n`
- **LSP**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `lazydev.nvim`
- **Completion**: `blink.cmp`
- **Formatting**: `conform.nvim`
- **Treesitter**: `nvim-treesitter`, `tree-sitter-manager.nvim`, `rainbow-delimiters.nvim`
- **Picker / terminal**: `snacks.nvim` (smart/files/grep/buffers/help, terminal, lazygit)
- **UI**: `which-key.nvim` (Helix preset), `mini.statusline`, `barbecue`, `noice.nvim`
- **Explorer / navigation**: `snacks.nvim` explorer, `vim-tmux-navigator`
- **Editing**: `flash.nvim`, `goto-preview`, `neoscroll`, `better-escape`, `tabout`, `auto-save`, `todo-comments.nvim`, blink.cmp auto brackets
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

Install language toolchains as needed:

- Haskell: `ghcup` + `haskell-language-server`
- C/C++: `clangd`
- Idris2: `idris2-lsp`
- Prolog: `swipl`
- Nix: `nixd`
- MoonBit: `moon` / `moon-lsp`
- Scheme: `guile-lsp-server`
- TypeScript: `typescript-language-server`
- `code_runner.nvim`: `python3`, `deno`, `gcc`, `clang++`, `rustc`, `javac`, etc.

## 📦 Installation

Back up your existing config:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone this repository:

```bash
git clone git@github.com:MoYu-CL/nvim-config.git ~/.config/nvim
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
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   ├── neovide.lua
    │   └── options.lua
    └── plugins/
        ├── loader.lua
        ├── registry.lua
        ├── colorschemes/
        │   └── colorschemes.lua
        ├── core/
        │   ├── deps.lua
        │   └── which-key.lua
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
        │   ├── neo-tree.lua   # disabled; snacks.explorer is used
        │   └── tmux.lua
        ├── tools/
        │   ├── snacks.lua
        │   └── trouble.lua
        ├── treesitter/
        │   ├── context.lua
        │   └── core.lua
        └── ui/
            ├── effects.lua
            └── status.lua
```

## 🧩 Plugin Layout

`lua/plugins/registry.lua` automatically discovers every `.lua` file under `lua/plugins/<category>/`. Each file may return a single plugin spec or a list of specs:

```lua
-- A single plugin
local M = {
    { name = "mini.icons", src = "echasnovski/mini.icons", pack = "start" },
}
return M
```

```lua
-- Multiple plugins in one file
local M = {
    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt", keys = { ... } },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", pack = "opt", keys = { ... } },
}
return M
```

- `pack = "start"`: load at startup
- `pack = "opt"`: lazy-loaded via `cmd`, `keys`, `event`, or `ft`
- Keymaps with an `action` are bound after the plugin loads

`lua/plugins/loader.lua` is responsible for:

- Installing and updating plugins with `vim.pack`
- Registering lazy-loading rules with `lz.n`
- Applying the colorscheme and start-plugin configs on `VimEnter`
- Auto-starting Treesitter
- Providing `:PackUpdate` / `:PackClean`

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
| `<leader>e` | Toggle snack explorer |
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
- Autocmds: `lua/config/autocmds.lua`
- Neovide settings: `lua/config/neovide.lua`
- Add plugins: create or edit a `.lua` file under `lua/plugins/<category>/`
- Change colorscheme: edit the `everforest` / `colorscheme` setup in `lua/plugins/loader.lua`

## Notes

- Plugin install location: `stdpath("data")/site/pack/core/opt/`
- Lock file: `nvim-pack-lock.json`
- New plugins are installed by `vim.pack` on the next startup after updating the registry


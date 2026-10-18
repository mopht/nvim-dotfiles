# nvim-config

English | [简体中文](README-CN.md)

A personal Neovim configuration built on Neovim's native `vim.pack`, with lazy loading provided by `lz.n`

## 🎯 Design Philosophy

This configuration aims to provide strong development capabilities with minimal configuration complexity

- Prefer Neovim's built-in APIs, and avoid adding abstraction layers on top
- Use plugins only for capabilities that are missing or impractical to implement natively
- Keep plugin specifications explicit and organized by responsibility
- Introduce abstractions only when they meaningfully reduce duplication or maintenance cost

Maintaining a capable development environment at low complexity takes priority, and the plugin count follows from that

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
- **Colorschemes**: `everforest` by default, with `tokyonight` and `catppuccin` available
- **GUI**: Neovide font, opacity, and window settings

## ⚙️ Requirements

- **Neovim >= 0.12.4** (required for native `vim.pack`)
- `git`
- `ripgrep`, `fd` (Snacks picker)
- A Nerd Font
- Optional: `lazygit`, `nushell`

LSP servers are configured manually in `lua/plugins/lsp/core.lua`, and the corresponding executables must be available on `PATH`

The following language toolchains are installed separately:

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

## 📦 Installation

Back up the existing configuration:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone the repository:

```bash
git clone git@github.com:MoYu-CL/nvim-dotfiles.git ~/.config/nvim
```

Start Neovim:

```bash
nvim
```

On first launch `vim.pack` prompts for the installation of missing plugins, and the resolved versions are recorded in `nvim-pack-lock.json`

Maintenance commands:

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
            ├── gitsigns.lua
            ├── status.lua
            └── which-key.lua
```

## 🧩 Plugin Layout

`lua/pack/registry.lua` automatically discovers every `.lua` file under `lua/plugins/<category>/`; each file returns either a single plugin spec or a list of specs:

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

- `pack = "start"`: loaded at startup
- `pack = "opt"`: lazy-loaded via `cmd`, `keys`, `event`, `ft` or `colorscheme`
- Keymaps that carry an `action` are bound after the plugin loads
- Every `opt` spec requires at least one trigger
- Colorscheme plugins declare `colorscheme = "<name>"`, which also makes `:colorscheme <name>` load them on demand

`lua/pack/init.lua` only assembles the pieces: it reads the registry, hands the specs to `vim.pack`, runs the start-plugin configs and the colorscheme on `VimEnter`, and then registers the lazy-loading rules with `lz.n`

Supporting modules:

- `lua/pack/install.lua`: install/update via `vim.pack`, the Treesitter build hook, and `:PackUpdate` / `:PackClean`
- `lua/pack/registry.lua`: spec discovery; a spec file placed directly in `lua/plugins/` raises an error, so a misplaced spec surfaces at startup
- `lua/config/colorscheme.lua`: applies the `colorscheme` field declared in the plugin specs
- `lua/config/treesitter.lua`: Treesitter highlight auto-start and `foldexpr`

## ⌨️ Keymaps

The leader key is `<Space>`

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
| `<C-u>` / `<C-d>` | Scroll half page up / down |
| `<C-b>` / `<C-f>` | Scroll page up / down |
| `<C-y>` / `<C-e>` | Scroll one line up / down |
| `zz` / `zt` / `zb` | Center / top / bottom the cursor line |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Window / tmux navigation |

## 🛠 Customization

- Core options: `lua/config/options.lua`
- Keymaps: `lua/config/keymaps.lua`
- Italics: `lua/config/highlights.lua` (forces italics on a fixed group list and reapplies them on every `ColorScheme`)
- Statusline transparency: `lua/plugins/ui/status.lua`
- Neovide settings: `lua/config/neovide.lua`
- LSP servers: `lua/plugins/lsp/core.lua`
- Formatters: `lua/plugins/lsp/formatting.lua`
- Add plugins: create or edit a `.lua` file under `lua/plugins/<category>/` (a file placed directly in `lua/plugins/` is rejected at startup)
- Change colorscheme: edit the `colorscheme` field in `lua/plugins/ui/colorscheme.lua`

## Notes

- Plugin install location: `stdpath("data")/site/pack/core/opt/`
- Lock file: `nvim-pack-lock.json`
- New plugins are installed by `vim.pack` on the next startup after adding a spec file
- Theme order: the theme is applied before the remaining start-plugin configs, so plugins that recompute highlights on `ColorScheme` (statusline, barbecue) see the final palette (`lua/pack/init.lua`)
- Repo tooling: `.stylua.toml`, `.editorconfig`, `.luarc.json`

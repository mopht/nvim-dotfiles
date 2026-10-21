# nvim-config

English | [简体中文](README-CN.md)

Personal Neovim configuration built on the native `vim.pack` plugin manager, with lazy loading via `lz.n`

## 🎯 Design Philosophy

This configuration aims to provide strong development capabilities with minimal configuration complexity

- Prefer Neovim's built-in APIs, and avoid adding abstraction layers on top
- Use plugins only for capabilities that are missing or impractical to implement natively
- Keep plugin specifications explicit and organized by responsibility
- Introduce abstractions only when they meaningfully reduce duplication or maintenance cost

Maintaining a capable development environment at low complexity takes priority, and the plugin count follows from that

## ✨ Features

- **Plugin management**: `vim.pack` + `lz.n`
- **LSP**: `nvim-lspconfig` with `vim.lsp.config` / `vim.lsp.enable`, `lazydev.nvim`, `haskell-tools.nvim`
- **Completion**: `blink.cmp`, `friendly-snippets`
- **Formatting**: `conform.nvim` with `stylua`, `nixfmt` and LSP fallback
- **Treesitter**: `nvim-treesitter`, `tree-sitter-manager.nvim`, `nvim-treesitter-context`, `rainbow-delimiters.nvim`
- **Picker / terminal**: `snacks.nvim`
- **UI**: `which-key.nvim`, `mini.statusline`, `mini.icons`, `dropbar.nvim`, `noice.nvim`
- **Explorer / navigation**: `snacks.nvim` explorer, `oil.nvim`, `vim-tmux-navigator`
- **Editing**: `flash.nvim`, `goto-preview`, `neoscroll`, `nvim-autopairs`, `better-escape`, `tabout`, `auto-save`, `mini.trailspace`, `todo-comments.nvim`, `guess-indent.nvim`, `twilight.nvim`, `zen-mode.nvim`
- **Language plugins**: `rustaceanvim`, `idris2-nvim`, `koka.nvim`, `moonbit.nvim`
- **Git**: `gitsigns.nvim`
- **Diagnostics**: `trouble.nvim`
- **Debugging**: `nvim-dap`, adapters come from the language plugins
- **Task runner**: `overseer.nvim` with bun and cabal templates
- **Colorschemes**: `everforest` (default), `tokyonight`, `catppuccin`
- **GUI**: Neovide settings

## ⚙️ Requirements

- **Neovim >= 0.12.4** (`vim.pack`)
- `git`
- `ripgrep`, `fd` for the picker
- A Nerd Font
- `cargo` for the `blink.cmp` native matcher
- Optional: `lazygit`, `nushell`, `bun` and `cabal` for the overseer templates

LSP servers are declared in `lua/plugins/lsp/core.lua`; their executables must be on `PATH`:

- Haskell: `ghcup`, `haskell-language-server`
- C/C++: `clangd`
- Idris2: `idris2-lsp`
- Prolog: `swipl`
- Nix: `nixd`
- MoonBit: `moon`, `moon-lsp`
- Scheme: `guile-lsp-server`
- TypeScript: `typescript-language-server`
- Lua: `lua-language-server`
- Formatting: `stylua`, `nixfmt`

## 📦 Installation

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone git@github.com:MoYu-CL/nvim-dotfiles.git ~/.config/nvim
nvim
```

On the first start `vim.pack` installs the missing plugins and records the resolved versions in `nvim-pack-lock.json`. The first start also builds the `blink.cmp` native fuzzy matcher

Commands:

```vim
:PackUpdate          " update all plugins
:PackUpdate <name>   " update one plugin
:PackClean           " remove plugins missing from the registry
```

## 📁 Structure

```text
~/.config/nvim/
├── .editorconfig
├── .gitignore
├── .luarc.json
├── .stylua.toml
├── README.md
├── README-CN.md
├── init.lua
├── nvim-pack-lock.json
├── ftplugin/
│   └── haskell.lua
└── lua/
    ├── config/
    │   ├── highlights.lua
    │   ├── keymaps.lua
    │   ├── neovide.lua
    │   ├── options.lua
    │   └── treesitter.lua
    ├── load/
    │   ├── init.lua
    │   ├── install.lua
    │   ├── registry.lua
    │   └── spec.lua
    └── plugins/
        ├── lib/
        │   └── deps.lua
        ├── editor/
        │   ├── buffers.lua
        │   ├── edit.lua
        │   └── motions.lua
        ├── language/
        │   └── languages.lua
        ├── lsp/
        │   ├── completion.lua
        │   └── core.lua
        ├── navigation/
        │   └── tmux.lua
        ├── tools/
        │   ├── dap.lua
        │   ├── oil.lua
        │   ├── overseer.lua
        │   ├── overseer/
        │   │   └── templates.lua
        │   ├── snacks.lua
        │   └── trouble.lua
        ├── treesitter/
        │   └── core.lua
        └── ui/
            ├── colorscheme.lua
            ├── effects.lua
            ├── gitsigns.lua
            ├── status.lua
            └── which-key.lua
```

## 🧩 Plugin Layout

`lua/load/registry.lua` loads every `.lua` file directly under `lua/plugins/<category>/`. Each file returns one spec table or a list of specs:

```lua
return {
    { name = "flash.nvim", src = "folke/flash.nvim", lazy = true, keys = { ... }, opts = {} },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", lazy = true, keys = { ... }, opts = {} },
}
```

Spec fields:

- `name`, `src`: plugin name and repository
- `lazy = false`: loaded by `vim.pack`
- `lazy = true`: loaded by `cmd`, `keys`, `event`, `ft` or `colorscheme`
- `opts`: `require(main).setup(opts)`
- `main`: module that owns `opts`, defaults to `name` without the `.nvim` suffix
- `config`: setup code that runs after `opts`
- `priority`: load order for eager specs, higher first (default 50)
- `colorscheme`: startup theme and `:colorscheme <name>` trigger
- `keys` with `action`: the mapping is bound after the plugin loads

`lua/load/init.lua` reads the registry, hands the specs to `vim.pack`, applies the theme, then passes every spec to `lz.n`:

- `lua/load/install.lua`: install, update, build hooks, `:PackUpdate`, `:PackClean`
- `lua/load/registry.lua`: spec discovery
- `lua/load/spec.lua`: spec normalization, `opts` and `config` execution
- `lua/config/treesitter.lua`: highlight, indent and folds

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
| `<leader>o` | Diagnostics float |
| `J` / `K` (visual) | Move the selection down / up |
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

### Task runner

| Key | Description |
| --- | --- |
| `<leader>rr` | Run a task |
| `<leader>rt` | Toggle the task list |
| `<leader>rs` | Run a shell command |
| `<leader>ra` | Run an action on a task |

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

- Options: `lua/config/options.lua`
- Keymaps: `lua/config/keymaps.lua`
- Italics: `lua/config/highlights.lua`
- Statusline transparency: `lua/plugins/ui/status.lua`
- Neovide: `lua/config/neovide.lua`
- LSP servers: `lua/plugins/lsp/core.lua`
- Formatters: `lua/plugins/lsp/core.lua`
- Task templates: `lua/plugins/tools/overseer/templates.lua`
- DAP: `lua/plugins/tools/dap.lua`
- Add a plugin: create a file under `lua/plugins/<category>/`
- Colorscheme: `lua/plugins/ui/colorscheme.lua`

## Notes

- Plugins install to `stdpath("data")/site/pack/core/opt/`
- Versions are pinned in `nvim-pack-lock.json`
- New specs are installed on the next start; `:PackUpdate` also runs the build hooks
- The theme is applied after the plugins are loaded and before any plugin config
- `blink.cmp` loads on `InsertEnter`; its native matcher is built on install and after every update
- Shared dependencies: `lua/plugins/lib/deps.lua`
- Repo tooling: `.stylua.toml`, `.editorconfig`, `.luarc.json`

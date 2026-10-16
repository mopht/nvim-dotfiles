# nvim-config

Personal Neovim configuration.

## Features

- Plugin manager: vim.pack
- LSP setup: nvim-lspconfig + mason.nvim
- Completion: blink.cmp
- Syntax highlighting: nvim-treesitter
- Fuzzy finder: snacks.nvim (picker)
- File explorer: neo-tree.nvim
- Statusline: lualine.nvim
- Colorscheme: everforest

## Requirements

- Neovim >= 0.12.4
- [ghcup](https://www.haskell.org/ghcup/) + [HLS](https://github.com/haskell/haskell-language-server) (for Haskell development)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `ripgrep`, `fd` (for fuzzy finding)
- `git`

## Installation

Back up your existing config first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone this repo:

```bash
git clone git@github.com:MoYu-CL/nvim-config.git ~/.config/nvim
```

Before launch, you have to install all the plugins:

```bash
./install-plugins.sh
```

Launch Neovim:

```bash
nvim
```

## Structure

```
~/.config/nvim
├── init.lua
├── nvim-pack-lock.json  # pinned vim.pack versions
└── lua/
    ├── config/          # options, keymaps, autocmds, neovide
    └── plugins/         # loader.lua, registry.lua, <category>/, specs/
```

<!-- ## Key Notes -->

<!-- ## License -->
<!---->
<!-- MIT -->

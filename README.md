# nvim-config

Personal Neovim configuration.

## Features

- Plugin manager: <!-- e.g. lazy.nvim -->
- LSP setup: <!-- e.g. nvim-lspconfig + mason.nvim -->
- Completion: <!-- e.g. nvim-cmp / blink.cmp -->
- Syntax highlighting: <!-- e.g. nvim-treesitter -->
- Fuzzy finder: <!-- e.g. telescope.nvim / fzf-lua -->
- File explorer: <!-- e.g. neo-tree.nvim -->
- Statusline: <!-- e.g. lualine.nvim -->
- Colorscheme: <!-- your theme -->

## Requirements

- Neovim >= <!-- version, e.g. 0.10 -->
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
git clone git@github.com:<your-username>/nvim-config.git ~/.config/nvim
```

Launch Neovim — plugins will install automatically on first run:

```bash
nvim
```

## Structure

```
~/.config/nvim
├── init.lua
├── lua/
│   ├── config/       # core options, keymaps, autocmds
│   └── plugins/      # plugin specs
└── lazy-lock.json    # pinned plugin versions
```

## Key Notes

<!-- Anything worth documenting, e.g. Haskell/Brick TUI dev setup,
     Neovide-specific config, custom keymaps worth remembering -->

## License

MIT

# nvim-config

[English](README.md) | 简体中文

本仓库为个人 Neovim 配置，插件由 Neovim 原生 `vim.pack` 安装与管理，懒加载由 `lz.n` 提供

## 🎯 设计理念

本配置旨在以尽可能低的配置复杂度，提供足够强的开发能力

- 优先使用 Neovim 内置 API，避免叠加额外的抽象层
- 仅在能力缺失或原生实现不划算时使用插件
- 插件 spec 保持显式声明，并按职责归类
- 仅在能显著减少重复或降低维护成本时引入抽象

重点在于以尽可能低的复杂度维持一个可用的开发环境，插件数量随之而定

## ✨ 功能

- **插件管理**：`vim.pack` + `lz.n`
- **LSP**：`nvim-lspconfig` 使用手动 `vim.lsp.config` / `vim.lsp.enable` 配置，搭配 `lazydev.nvim`
- **补全**：`blink.cmp`，带 lazydev source
- **格式化**：`conform.nvim`（`stylua`、`nixfmt`，并回退到 LSP 格式化）
- **Treesitter**：`nvim-treesitter`、`tree-sitter-manager.nvim`、`rainbow-delimiters.nvim`
- **Picker / 终端**：`snacks.nvim`（smart/files/grep/buffers/help、terminal、lazygit）
- **UI**：`which-key.nvim`（Helix 风格）、`mini.statusline`、`dropbar.nvim`、`noice.nvim`
- **文件树 / 窗口导航**：`snacks.nvim` explorer、`oil.nvim`、`vim-tmux-navigator`
- **编辑能力**：`flash.nvim`、`goto-preview`、`neoscroll`、`nvim-autopairs`、`better-escape`、`tabout`、`auto-save`、`vim-better-whitespace`、`todo-comments.nvim`
- **诊断面板**：`trouble.nvim`
- **任务运行器**：`overseer.nvim`，内置 bun 和 cabal 模板
- **主题**：默认 `everforest`，可选 `tokyonight`、`catppuccin`
- **GUI**：附带 Neovide 字体、透明度和窗口设置

## ⚙️ 环境要求

- **Neovim >= 0.12.4**（原生 `vim.pack` 所需）
- `git`
- `ripgrep`、`fd`（Snacks picker）
- 一个 Nerd Font
- 可选：`lazygit`、`nushell`

LSP server 在 `lua/plugins/lsp/core.lua` 中手动配置，对应的可执行文件需位于 `PATH` 中

以下语言工具链需另行安装：

- Haskell：`ghcup` + `haskell-language-server`
- C/C++：`clangd`
- Idris2：`idris2-lsp`
- Prolog：`swipl`
- Nix：`nixd`
- MoonBit：`moon` / `moon-lsp`
- Scheme：`guile-lsp-server`
- TypeScript：`typescript-language-server`
- Lua / lazydev：`lua-language-server`
- 格式化：`stylua`、`nixfmt`

## 📦 安装

备份现有配置：

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

克隆仓库：

```bash
git clone git@github.com:MoYu-CL/nvim-dotfiles.git ~/.config/nvim
```

启动 Neovim：

```bash
nvim
```

首次启动时 `vim.pack` 会提示安装缺失插件，解析后的版本记录在 `nvim-pack-lock.json` 中

维护命令：

```vim
:PackUpdate          " 更新插件
:PackUpdate <name>   " 更新指定插件
:PackClean           " 清理未在 registry 中注册的插件
```

## 📁 目录结构

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
    │   ├── registry.lua
    │   └── spec.lua
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
        │   ├── overseer.lua
        │   ├── overseer/
        │   │   └── templates.lua
        │   ├── snacks.lua
        │   └── trouble.lua
        ├── treesitter/
        │   ├── context.lua
        │   └── core.lua
        └── ui/
            ├── colorscheme.lua
            ├── dropbar.lua
            ├── effects.lua
            ├── gitsigns.lua
            ├── status.lua
            └── which-key.lua
```

## 🧩 插件组织方式

`lua/pack/registry.lua` 会自动扫描 `lua/plugins/<category>/*.lua`，每个文件返回单个 plugin spec 或一个 spec 列表：

```lua
-- 单个插件
return {
    { name = "mini.icons", src = "echasnovski/mini.icons", lazy = false, opts = {} },
}
```

```lua
-- 一个文件里放多个插件
return {
    { name = "flash.nvim", src = "folke/flash.nvim", lazy = true, keys = { ... }, opts = {} },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", lazy = true, keys = { ... }, opts = {} },
}
```

- `lazy = false`：启动时加载
- `lazy = true`：延迟加载，可由 `cmd`、`keys`、`event`、`ft` 或 `colorscheme` 触发
- `opts = { ... }`：等价于 `require(main).setup(opts)`
- `main`：`opts` 对应的 Lua 模块名，默认取插件名去掉 `.nvim` 后缀；两者不一致时必须显式指定（`better_escape`、`everforest`、`idris2`、`treesitter-context`）
- `config`：`opts` 表达不了的额外逻辑，在 `opts` 之后执行
- 带 `action` 的 `keys` 映射在插件加载后绑定
- 每个 `lazy = true` spec 至少需要一个触发器
- 主题插件声明 `colorscheme = "<name>"`，`:colorscheme <name>` 也会据此按需加载

`lua/pack/init.lua` 只负责装配：读取 registry，将 spec 交给 `vim.pack`，在 `VimEnter` 时执行 start 插件的 config 并应用主题，最后把懒加载规则注册给 `lz.n`

配套模块：

- `lua/pack/install.lua`：`vim.pack` 安装 / 更新、Treesitter 构建钩子、`:PackUpdate` / `:PackClean`
- `lua/pack/registry.lua`：spec 发现；直接放在 `lua/plugins/` 下的 spec 文件会直接报错，避免被静默忽略
- `lua/config/colorscheme.lua`：应用插件 spec 里声明的 `colorscheme` 字段
- `lua/config/treesitter.lua`：Treesitter 高亮自启与 `foldexpr`

## ⌨️ 快捷键

Leader 键为 `<Space>`

### 查找 / 终端

| 快捷键 | 功能 |
| --- | --- |
| `<leader><space>` | Smart Find Files |
| `<leader>f` | Find Files |
| `<leader>g` | Live Grep |
| `<leader>b` | Find Buffers |
| `<leader>hh` | Help Tags |
| `<F8>` | 切换底部终端 |
| `<leader>tn` | Nushell 浮窗 |
| `<leader>tm` | Lazygit |

### LSP / 编辑

| 快捷键 | 功能 |
| --- | --- |
| `<leader>=` | 格式化当前 buffer |
| `K` | Hover |
| `<C-o>` | 显示诊断浮窗 |
| `<leader>e` | 切换 snacks explorer |
| `-` | 用 Oil 打开父目录 |
| `<leader>sv` / `<leader>sh` | 垂直 / 水平分屏 |
| `sl` / `sh` | 下一个 / 上一个 buffer |
| `nl` | 清除搜索高亮 |
| `tl` | Todo location list |
| `<leader>he` | Haskell evaluate all |

### Trouble

| 快捷键 | 功能 |
| --- | --- |
| `xx` | 工作区诊断 |
| `xX` | 当前 buffer 诊断 |
| `cs` | Symbols |
| `cl` | LSP references / definitions |
| `xL` | Location list |
| `xQ` | Quickfix list |

### 任务运行

| 快捷键 | 功能 |
| --- | --- |
| `<leader>rr` | 运行任务 |
| `<leader>rt` | 开关任务列表 |
| `<leader>rs` | 运行 shell 命令 |
| `<leader>ra` | 对任务执行操作 |

### Flash / 预览 / 滚动

| 快捷键 | 功能 |
| --- | --- |
| `s` / `S` | Flash jump / Treesitter |
| `r` / `R` | Remote Flash / Treesitter search |
| `gpd` / `gpt` / `gpi` / `gpD` | Goto preview definition / type / implementation / declaration |
| `gP` | 关闭所有 preview |
| `<C-u>` / `<C-d>` | 上 / 下滚动半页 |
| `<C-b>` / `<C-f>` | 上 / 下滚动整页 |
| `<C-y>` / `<C-e>` | 上 / 下滚动一行 |
| `zz` / `zt` / `zb` | 光标行居中 / 置顶 / 置底 |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 窗口 / tmux 导航 |

## 🛠 自定义

- 基础选项：`lua/config/options.lua`
- 快捷键：`lua/config/keymaps.lua`
- 斜体：`lua/config/highlights.lua`（对固定的一组高亮组强制斜体，并在每次 `ColorScheme` 时重新应用）
- 状态栏透明：`lua/plugins/ui/status.lua`
- Neovide 设置：`lua/config/neovide.lua`
- LSP server：`lua/plugins/lsp/core.lua`
- 格式化器：`lua/plugins/lsp/formatting.lua`
- 添加插件：在 `lua/plugins/<category>/` 下新增或修改 `.lua` 文件（直接放在 `lua/plugins/` 下会在启动时报错）
- 切换主题：修改 `lua/plugins/ui/colorscheme.lua` 中的 `colorscheme` 字段

## 备注

- 插件源码安装位置：`stdpath("data")/site/pack/core/opt/`
- 锁文件：`nvim-pack-lock.json`
- 新增 spec 文件后，新插件会在下次启动时由 `vim.pack` 安装
- 主题顺序：主题在其余 start 插件 config 之前应用，因此依赖 `ColorScheme` 重算高亮的插件（statusline、dropbar）拿到的是最终配色（见 `lua/pack/init.lua`）
- 仓库工具配置：`.stylua.toml`、`.editorconfig`、`.luarc.json`

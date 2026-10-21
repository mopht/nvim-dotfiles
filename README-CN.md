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
- **LSP**：`nvim-lspconfig` 配一张 `vim.lsp.config` / `vim.lsp.enable` 覆盖表，搭配 `lazydev.nvim` 与 `haskell-tools.nvim`
- **补全**：`blink.cmp`、`friendly-snippets`
- **格式化**：`conform.nvim`，使用 `stylua`、`nixfmt`，并回退到 LSP 格式化
- **Treesitter**：`nvim-treesitter`、`tree-sitter-manager.nvim`、`nvim-treesitter-context`、`rainbow-delimiters.nvim`
- **Picker / 终端**：`snacks.nvim`
- **UI**：`which-key.nvim`、`mini.statusline`、`mini.icons`、`dropbar.nvim`、`noice.nvim`
- **文件树 / 窗口导航**：`snacks.nvim` explorer、`oil.nvim`、`vim-tmux-navigator`
- **编辑能力**：`flash.nvim`、`goto-preview`、`neoscroll`、`nvim-autopairs`、`better-escape`、`tabout`、`auto-save`、`vim-better-whitespace`、`todo-comments.nvim`、`guess-indent.nvim`、`twilight.nvim`、`zen-mode.nvim`
- **语言插件**：`rustaceanvim`、`idris2-nvim`、`koka.nvim`、`moonbit.nvim`
- **Git**：`gitsigns.nvim`
- **诊断**：`trouble.nvim`
- **任务运行器**：`overseer.nvim`，内置 bun 和 cabal 模板
- **主题**：默认 `everforest`，可选 `tokyonight`、`catppuccin`
- **GUI**：Neovide 设置

## ⚙️ 环境要求

- **Neovim >= 0.12.4**（`vim.pack`）
- `git`
- `ripgrep`、`fd`，供 picker 使用
- 一个 Nerd Font
- `cargo`，用于编译 `blink.cmp` 的原生 matcher
- 可选：`lazygit`、`nushell`，以及供 overseer 模板使用的 `bun`、`cabal`

LSP server 在 `lua/plugins/lsp/core.lua` 中声明；可执行文件需在 `PATH` 中：

- Haskell：`ghcup`、`haskell-language-server`
- C/C++：`clangd`
- Idris2：`idris2-lsp`
- Prolog：`swipl`
- Nix：`nixd`
- MoonBit：`moon`、`moon-lsp`
- Scheme：`guile-lsp-server`
- TypeScript：`typescript-language-server`
- Lua：`lua-language-server`
- 格式化：`stylua`、`nixfmt`

## 📦 安装

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone git@github.com:MoYu-CL/nvim-dotfiles.git ~/.config/nvim
nvim
```

首次启动时 `vim.pack` 会安装缺失插件，解析后的版本记录在 `nvim-pack-lock.json`。首次启动还会编译 `blink.cmp` 的原生 fuzzy matcher

常用命令：

```vim
:PackUpdate          " 更新全部插件
:PackUpdate <name>   " 更新单个插件
:PackClean           " 删除 registry 中没有的插件
```

## 📁 目录结构

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
            ├── effects.lua
            ├── gitsigns.lua
            ├── status.lua
            └── which-key.lua
```

## 🧩 插件组织方式

`lua/load/registry.lua` 加载 `lua/plugins/<category>/` 下直接存在的每个 `.lua` 文件。每个文件返回一个 spec 表或一组 spec：

```lua
return {
    { name = "flash.nvim", src = "folke/flash.nvim", lazy = true, keys = { ... }, opts = {} },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", lazy = true, keys = { ... }, opts = {} },
}
```

spec 字段：

- `name`、`src`：插件名与仓库地址
- `lazy = false`：由 `vim.pack` 加载
- `lazy = true`：由 `cmd`、`keys`、`event`、`ft` 或 `colorscheme` 触发加载
- `opts`：等价于 `require(main).setup(opts)`
- `main`：`opts` 对应的模块名，默认取插件名去掉 `.nvim` 后缀
- `config`：在 `opts` 之后执行的 setup 代码
- `priority`：eager spec 的加载顺序，数值越大越先加载（默认 50）
- `colorscheme`：启动主题，同时作为 `:colorscheme <name>` 的触发器
- 带 `action` 的 `keys`：插件加载后绑定该映射

`lua/load/init.lua` 读取 registry，把 spec 交给 `vim.pack`，应用主题，然后把全部 spec 交给 `lz.n`：

- `lua/load/install.lua`：安装、更新、构建钩子、`:PackUpdate`、`:PackClean`
- `lua/load/registry.lua`：spec 发现
- `lua/load/spec.lua`：spec 转换，执行 `opts` 与 `config`
- `lua/config/treesitter.lua`：高亮、缩进与折叠

## ⌨️ 快捷键

leader 键为 `<Space>`

### 查找 / 终端

| 按键 | 说明 |
| --- | --- |
| `<leader><space>` | 智能查找文件 |
| `<leader>f` | 查找文件 |
| `<leader>g` | 实时 grep |
| `<leader>b` | 切换缓冲区 |
| `<leader>hh` | 帮助标签 |
| `<F8>` | 开关底部终端 |
| `<leader>tn` | Nushell 浮窗 |
| `<leader>tm` | Lazygit |

### LSP / 编辑

| 按键 | 说明 |
| --- | --- |
| `<leader>=` | 格式化当前缓冲区 |
| `K` | 悬浮文档 |
| `<leader>o` | 诊断浮窗 |
| `J` / `K`（可视模式） | 向下 / 向上移动选中行 |
| `<leader>e` | 开关 snacks 文件树 |
| `-` | 用 Oil 打开上级目录 |
| `<leader>sv` / `<leader>sh` | 垂直 / 水平分屏 |
| `sl` / `sh` | 下一个 / 上一个缓冲区 |
| `nl` | 清除搜索高亮 |
| `tl` | Todo 位置列表 |
| `<leader>he` | Haskell 求值全部 |

### Trouble

| 按键 | 说明 |
| --- | --- |
| `xx` | 工作区诊断 |
| `xX` | 当前缓冲区诊断 |
| `cs` | 符号列表 |
| `cl` | LSP 引用 / 定义 |
| `xL` | 位置列表 |
| `xQ` | quickfix 列表 |

### 任务运行器

| 按键 | 说明 |
| --- | --- |
| `<leader>rr` | 运行任务 |
| `<leader>rt` | 开关任务列表 |
| `<leader>rs` | 运行 shell 命令 |
| `<leader>ra` | 对任务执行操作 |

### Flash / 预览 / 滚动

| 按键 | 说明 |
| --- | --- |
| `s` / `S` | Flash 跳转 / Treesitter |
| `r` / `R` | 远程 Flash / Treesitter 搜索 |
| `gpd` / `gpt` / `gpi` / `gpD` | Goto preview 定义/类型/实现/声明 |
| `gP` | 关闭全部预览 |
| `<C-u>` / `<C-d>` | 上下滚动半页 |
| `<C-b>` / `<C-f>` | 上下滚动整页 |
| `<C-y>` / `<C-e>` | 上下滚动一行 |
| `zz` / `zt` / `zb` | 光标行居中 / 置顶 / 置底 |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 窗口 / tmux 导航 |

## 🛠 自定义

- 选项：`lua/config/options.lua`
- 快捷键：`lua/config/keymaps.lua`
- 斜体：`lua/config/highlights.lua`
- 状态栏透明：`lua/plugins/ui/status.lua`
- Neovide：`lua/config/neovide.lua`
- LSP server：`lua/plugins/lsp/core.lua`
- 格式化器：`lua/plugins/lsp/formatting.lua`
- 任务模板：`lua/plugins/tools/overseer/templates.lua`
- 新增插件：在 `lua/plugins/<category>/` 下新建文件
- 主题：`lua/plugins/ui/colorscheme.lua`

## 备注

- 插件安装位置：`stdpath("data")/site/pack/core/opt/`
- 版本锁定在 `nvim-pack-lock.json`
- 新增 spec 后，下次启动会安装对应插件；`:PackUpdate` 也会执行构建钩子
- 主题在插件加载完成后、任何插件 config 之前应用
- `blink.cmp` 在首次启动和每次更新后编译原生 matcher
- 共享依赖：`lua/plugins/lib/deps.lua`
- 仓库工具配置：`.stylua.toml`、`.editorconfig`、`.luarc.json`

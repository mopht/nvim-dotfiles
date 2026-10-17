# nvim-config

[English](README.md) | 简体中文

个人 Neovim 配置。插件由 Neovim 原生 `vim.pack` 安装和管理，使用 `lz.n` 做懒加载。

## ✨ 功能

- **插件管理**：`vim.pack` + `lz.n`
- **LSP**：`nvim-lspconfig`、`mason.nvim`、`mason-lspconfig.nvim`、`lazydev.nvim`
- **补全**：`blink.cmp`
- **格式化 / 诊断**：`none-ls.nvim` + `none-ls-extras`
- **Treesitter**：`nvim-treesitter`、`tree-sitter-manager.nvim`、`rainbow-delimiters.nvim`
- **Picker / 终端**：`snacks.nvim`（smart/files/grep/buffers/help、terminal、lazygit）
- **UI**：`which-key.nvim`（Helix 风格）、`lualine.nvim`、`barbecue`、`noice.nvim`
- **文件树 / 窗口导航**：`neo-tree.nvim`、`vim-tmux-navigator`
- **编辑增强**：`flash.nvim`、`goto-preview`、`neoscroll`、`nvim-autopairs`、`better-escape`、`tabout`、`auto-save`、`todo-comments.nvim`
- **诊断面板**：`trouble.nvim`
- **运行代码**：`code_runner.nvim`
- **主题**：默认 `everforest`，可选 `tokyonight`、`catppuccin`
- **GUI**：附带 Neovide 字体、透明度和窗口设置

## ⚙️ 环境要求

- **Neovim >= 0.12.4**（依赖原生 `vim.pack`）
- `git`
- `ripgrep`、`fd`（Snacks picker）
- 一个 Nerd Font
- 可选：`lazygit`、`nushell`

按需安装语言工具链：

- Haskell：`ghcup` + `haskell-language-server`
- C/C++：`clangd`
- Idris2：`idris2-lsp`
- Prolog：`swipl`
- Nix：`nixd`
- MoonBit：`moon` / `moon-lsp`
- Scheme：`guile-lsp-server`
- TypeScript：`typescript-language-server`
- `code_runner.nvim`：`python3`、`deno`、`gcc`、`clang++`、`rustc`、`javac` 等

## 📦 安装

先备份旧配置：

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

克隆仓库：

```bash
git clone git@github.com:MoYu-CL/nvim-config.git ~/.config/nvim
```

直接启动 Neovim：

```bash
nvim
```

首次启动时 `vim.pack` 会提示安装缺失插件，确认即可。插件版本记录在 `nvim-pack-lock.json`。

常用命令：

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
        │   ├── neo-tree.lua
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

## 🧩 插件组织方式

`lua/plugins/registry.lua` 会自动扫描 `lua/plugins/<category>/*.lua`。每个文件可以返回单个 plugin spec，也可以返回一个 spec 列表：

```lua
-- 单个插件
local M = {
    { name = "mini.icons", src = "echasnovski/mini.icons", pack = "start" },
}
return M
```

```lua
-- 一个文件里放多个插件
local M = {
    { name = "flash.nvim", src = "folke/flash.nvim", pack = "opt", keys = { ... } },
    { name = "neoscroll.nvim", src = "karb94/neoscroll.nvim", pack = "opt", keys = { ... } },
}
return M
```

- `pack = "start"`：启动时加载
- `pack = "opt"`：延迟加载，可通过 `cmd`、`keys`、`event`、`ft` 触发
- `keys` 里带 `action` 的映射会在插件加载后自动绑定

`lua/plugins/loader.lua` 负责：

- `vim.pack` 安装和更新插件
- 使用 `lz.n` 注册懒加载规则
- `VimEnter` 时应用 colorscheme 和 start 插件配置
- Treesitter 自动启动
- `:PackUpdate` / `:PackClean`

## ⌨️ 快捷键

Leader 是 `<Space>`。

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
| `<leader>e` | 切换 Neo-tree |
| `<leader>sv` / `<leader>sh` | 垂直 / 水平分屏 |
| `sl` / `sh` | 下一个 / 上一个 buffer |
| `nl` | 清除搜索高亮 |
| `tl` | Todo location list |
| `<leader>he` | Haskell evaluate all |
| `<F11>` | 运行代码 |

### Trouble

| 快捷键 | 功能 |
| --- | --- |
| `xx` | 工作区诊断 |
| `xX` | 当前 buffer 诊断 |
| `cs` | Symbols |
| `cl` | LSP references / definitions |
| `xL` | Location list |
| `xQ` | Quickfix list |

### Flash / 预览 / 滚动

| 快捷键 | 功能 |
| --- | --- |
| `s` / `S` | Flash jump / Treesitter |
| `r` / `R` | Remote Flash / Treesitter search |
| `gpd` / `gpt` / `gpi` / `gpD` | Goto preview definition / type / implementation / declaration |
| `gP` | 关闭所有 preview |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 窗口 / tmux 导航 |

## 🛠 自定义

- 基础选项：`lua/config/options.lua`
- 快捷键：`lua/config/keymaps.lua`
- 自动命令：`lua/config/autocmds.lua`
- Neovide 设置：`lua/config/neovide.lua`
- 添加插件：在 `lua/plugins/<category>/` 下新增或修改 `.lua` 文件
- 切换主题：修改 `lua/plugins/loader.lua` 里的 `everforest` / `colorscheme` 配置

## 备注

- 插件源码安装位置：`stdpath("data")/site/pack/core/opt/`
- 锁文件：`nvim-pack-lock.json`
- 修改插件 registry 后，新插件会在下次启动时由 `vim.pack` 安装

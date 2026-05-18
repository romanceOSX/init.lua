# 🦄💫 init.lua

International oatmeal smuggler neovim configuration. Plugin management via [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

| Tool | Purpose |
|------|---------|
| `git` | Plugin installation |
| `ripgrep` | Live grep in Telescope |
| `make` / `cmake` | Build telescope-fzf-native |
| `node` / `npm` | Some Mason-managed tools |
| `python3` | Python LSP + debugpy |
| `cargo` | Rust toolchain |
| Nerd Font | Icons (optional but recommended) |

## Installation

```sh
# Unix / macOS
git clone https://github.com/romanceOSX/init.lua ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/romanceOSX/init.lua $env:LOCALAPPDATA\nvim
```

Lazy.nvim bootstraps itself on first launch — all plugins install automatically.

## Plugin List

### LSP & Formatting
| Plugin | Role |
|--------|------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/DAP/linter installer |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Mason ↔ lspconfig bridge |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting on save |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP progress notifications |

**Auto-installed servers:** `lua_ls`, `rust_analyzer`, `pyright`, `clangd`

**Formatters (installed via Mason):** `stylua`, `black`, `isort`, `rustfmt`, `clang-format`

### Autocompletion
| Plugin | Role |
|--------|------|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path source |
| [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) | Command-line source |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | Snippet source |

### Snippets
| Plugin | Role |
|--------|------|
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |

### Debugging (DAP)
| Plugin | Role |
|--------|------|
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | DAP client |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debug UI |
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Inline variable values |
| [telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim) | DAP + Telescope integration |

**Adapters:** `cpptools` (C/C++), `codelldb` (Rust), `debugpy` (Python)

### Search & Navigation
| Plugin | Role |
|--------|------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | Code structure sidebar |

### Syntax
| Plugin | Role |
|--------|------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & parsing |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky scope context |

**Auto-installed parsers:** `c`, `cpp`, `rust`, `python`, `lua`, `vim`, `vimdoc`, `markdown`

### UI
| Plugin | Role |
|--------|------|
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO/FIXME/etc |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto bracket pairs |

### Themes
| Plugin | Scheme(s) |
|--------|-----------|
| [sainnhe/everforest](https://github.com/sainnhe/everforest) | everforest |
| [pinkmare](https://github.com/matsuuu/pinkmare) | pinkmare |
| [nightblossom.nvim](https://github.com/rijulpaul/nightblossom.nvim) | nightblossom-pastel |
| [jellybeans.nvim](https://github.com/wtfox/jellybeans.nvim) | jellybeans |
| [lush.nvim](https://github.com/rktjmp/lush.nvim) | Custom *sakura* theme |

Active scheme: `sakura` (set in `after/plugin/colors.lua`)

### AI
| Plugin | Role |
|--------|------|
| [copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot (run `:Copilot setup`) |

## Key Bindings

`<leader>` = `<Space>`

### LSP
| Key | Action |
|-----|--------|
| `<leader>lR` | Rename symbol |
| `<leader>lr` | References |
| `<leader>lD` | Definition |
| `<leader>ld` | Declaration |
| `<leader>li` | Implementation |
| `<leader>lt` | Type definition |
| `<leader>lc` | Incoming calls |
| `<leader>ll` | Toggle LSP on/off |

### DAP
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>dso` | Step over |
| `<leader>dsi` | Step into |
| `<leader>dsx` | Step out |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

### Terminal
| Key | Action |
|-----|--------|
| `<C-\>` | Toggle shell terminal |
| `<leader>gg` / `<leader>gt` | Toggle lazygit |

### Completion
| Key | Action |
|-----|--------|
| `<C-j>` / `<C-n>` | Next item |
| `<C-k>` / `<C-p>` | Previous item |
| `<C-y>` | Confirm selection |
| `<C-Space>` | Trigger completion |

### Snippets
| Key | Action |
|-----|--------|
| `<C-K>` | Expand snippet |
| `<C-L>` | Jump forward |
| `<C-J>` | Jump backward |



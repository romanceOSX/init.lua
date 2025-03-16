# 🦄💫 init.lua

Personal neovim configuration 🗣️❗️

## Pluggins List
### LSP plugins
- Default lsp configs with [lspconfig](https://github.com/neovim/nvim-lspconfig)
- Lsp/DAP/linters/formatter package [manager](https://github.com/williamboman/mason.nvim)
- Glue adapter between lspconfig and mason through [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)
- LSP configuration by [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)

### Autocompletion plugins
- Autocompletion engine by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) 
#### with the following sources
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)
- [cmp-luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [cmp-path](https://github.com/hrsh7th/cmp-path)

### Snippet plugins
- Snippet engine by [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
#### with the following collections
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)

### searchers plugins
- Fuzzy finder [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- FZF integration for telescope.nvim [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) 

### Utilities
- Bookmarking tool [theprimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- Git-like undo tool [mbbill/undotree](https://github.com/mbbill/undotree)
- Git neovim wrapper [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
- Pop-up terminals [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- Parentheses/square brackets autopair completion [tpope/vim-fugitive](https://github.com/windwp/nvim-autopairs)
- Linter [tpope/vim-fugitive](https://github.com/nvim-treesitter/nvim-treesitter)

### Color themes
- everforest [sainnhe/everforest](https://github.com/neanias/everforest-nvim)
- dracula [Mofiqul/dracula.nvim](https://github.com/Mofiqul/dracula.nvim)
- nightfox [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
- sonokai [sainnhe/sonokai](https://github.com/sainnhe/sonokai)

### Other
- Markdown Preview [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)

## Requirements
### Host's requirements
- git
- npm
- python3 environment
- cargo (rust package manager)

### 3rd party requirements
Tools that need to installed independently from neovim
- [ ] Packer.nvim
- [ ] Ripgrep (for telescope grepping)

## To-Do
- [ ] Optimize cmp engine
- [ ] Add latex support for math notes
- [ ] Integrate debuging facilities for c++ (clangd/gbd)
- [ ] Nerdfonts? and devicons?
- [ ] Create menu for selecting colorscehemes
- [ ] Lua scripts for ensuring the 3rd party dependencies 


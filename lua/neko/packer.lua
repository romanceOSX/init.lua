-- This file can be loaded by calling `lua require(plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]

-- Packer Startup
return require('packer').startup(function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}
    -- Toggleterm 
    use {"akinsho/toggleterm.nvim", tag = '*', config = function() require("toggleterm").setup() end,}
    -- Telescope 
    use {'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = {{'nvim-lua/plenary.nvim'}}}
    -- Telescope-fzf
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'}
    -- Color Themes
    use {'Mofiqul/dracula.nvim'}
    use {"EdenEast/nightfox.nvim"}
    use {"sainnhe/sonokai"}
    use {"sainnhe/everforest"}
    -- Harpoon
    use{'theprimeagen/harpoon'}
    -- Undo Tree
    use{'mbbill/undotree'}
    -- Fugitive
    use{'tpope/vim-fugitive'}
    -- indent-blankline.nvim
    use {"lukas-reineke/indent-blankline.nvim"}
    -- LspConfig
    use {'neovim/nvim-lspconfig'}
    -- mason
    use {"williamboman/mason.nvim"}
    use {"williamboman/mason-lspconfig.nvim"}   -- Closes gaps between mason and lspconfig
    -- nvim-cmp
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lua'}
    use {'saadparwaiz1/cmp_luasnip'}      -- Allows for completion sources provided by luasnip, not just from lsp
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-cmdline'}
    use {'hrsh7th/cmp-path'}
    -- Luasnip
    use {"L3MON4D3/LuaSnip", tag = "v2.*", run = "make install_jsregexp"}
    use {"rafamadriz/friendly-snippets"}  -- Sample snippets
    use {"windwp/nvim-autopairs"}
    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
end)


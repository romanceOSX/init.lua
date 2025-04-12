-- Packer Startup
return require('packer').startup(function(use)
    -- packer
    use {'wbthomason/packer.nvim'}

    -- color themes
    use {'sainnhe/everforest'}
    use {'Mofiqul/dracula.nvim'}
    use {'EdenEast/nightfox.nvim'}
    use {'sainnhe/sonokai'}

    -- lsp
    use {'neovim/nvim-lspconfig'}
    use {'williamboman/mason.nvim'}
    use {'williamboman/mason-lspconfig.nvim'}   -- Closes gaps between mason and lspconfig

    -- autocompletion
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lua'}
    use {'saadparwaiz1/cmp_luasnip'}      -- Allows for completion sources provided by luasnip, not just from lsp
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-cmdline'}
    use {'hrsh7th/cmp-path'}

    -- snippets
    use {'L3MON4D3/LuaSnip', tag = "v2.*", run = "make install_jsregexp"}
    use {'rafamadriz/friendly-snippets'}  -- Sample snippets

    -- searchers
    use {'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = {{'nvim-lua/plenary.nvim'}}}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'}

    -- utilities
    use {'theprimeagen/harpoon'}
    use {'mbbill/undotree'}
    use {'tpope/vim-fugitive'}
    use {'akinsho/toggleterm.nvim', tag = '*'}
    use {'windwp/nvim-autopairs'}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'folke/todo-comments.nvim'}

    -- dependencies
    use {'nvim-lua/plenary.nvim'}
    use {'ibhagwan/fzf-lua'}

    -- other
    use {'iamcco/markdown-preview.nvim', run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" , "text" } end, ft = { "markdown", "text" }, }
    use {'mistricky/codesnap.nvim', run = 'make'}

    -- use {"lukas-reineke/indent-blankline.nvim"}
end)


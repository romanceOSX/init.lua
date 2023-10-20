-- This file can be loaded by calling `lua require(plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]

-- Bootstrap pakcer ( Required for Docker )
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Packer Startup
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Toggleterm 
    use {"akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end, }

    -- Telescope 
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.2',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} } }

    -- telescope-fzf
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Color Themes
    use 'Mofiqul/dracula.nvim'
    use {'nyoom-engineering/oxocarbon.nvim'}

    -- Tree Sitter
    use { 'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end, }

    -- Nvim-tree -> File Explorer
    use { 'nvim-tree/nvim-tree.lua',
    requires = {
        'nvim-tree/nvim-web-devicons', -- optional
    }, }

    -- Harpoon
    use{'theprimeagen/harpoon'}
    -- Undo Tree
    use{'mbbill/undotree'}
    -- Fugitive -> Vim plugin 
    use{'tpope/vim-fugitive'}
    -- LSP Zero --> https://github.com/VonHeikemen/lsp-zero.nvim
    use { 'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {                                      -- Optional
        'williamboman/mason.nvim',
        run = function()
            pcall(vim.cmd, 'MasonUpdate')
        end, },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }}

    -- cmp_luasnip
    use {"saadparwaiz1/cmp_luasnip"}

    -- Friendly Snippets
    use{"rafamadriz/friendly-snippets"}

    -- indent-blankline.nvim
    use {"lukas-reineke/indent-blankline.nvim"}

    if packer_bootstrap then
        require('packer').sync()
    end
end)


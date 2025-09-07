return {
    "hrsh7th/nvim-cmp",
    enabled = true,
    dependencies = {
        "L3MON4D3/LuaSnip",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path", -- TODO: set cmp path
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
    },
    lazy = true,
    event = "InsertEnter",
    opts = {
        experimental = {
            ghost_text = true,
        },
    },
    config = function (plug, opts)
        local cmp = require("cmp")
        -- TODO: use these capabilities
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- set snippet engine
        opts.snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)    -- luasnip-specific
            end
        }

        -- set cmp sources
        opts.sources = cmp.config.sources({  -- this declares the display order
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'nvim_lsp' },
        })

        -- `/` cmdline setup.
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources(
                {
                    { name = 'path' }
                },
                {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                }
            )
        })

        -- mappings
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        opts.mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        })

        -- apply options
        cmp.setup(opts)
    end,
}


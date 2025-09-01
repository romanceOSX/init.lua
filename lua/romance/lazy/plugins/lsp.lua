-- lsp-related plugins
-- TODO: should I make this into its own module?

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            -- TODO: move this list somewhere else in a config file or something
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "pyright",
                "clangd",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0

                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
            }
        })

        require("conform").setup({
            formatters_by_ft = {
            }
        })

        require("fidget").setup({})

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            }),
            experimental = {
                ghost_text = true,
            }
        })

        local ls = require("luasnip")
        vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, {silent = true})

        local fzf = require("fzf-lua")

        -- lsp related
        vim.keymap.set("n", "<leader>ls", fzf.lsp_workspace_symbols)
        vim.keymap.set("n", "<leader>lr", fzf.lsp_references)
        vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename)
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration)
        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.definition)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
        vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)
        vim.keymap.set("n", "<leader>lc", vim.lsp.buf.incoming_calls)

        --
        -- lsp-toggle.lua
        --

        -- Augroup name for our temporary LSP blocker
        local LSP_DISABLE_GROUP = "LspTempDisabled"

        -- Disable LSP globally
        local function disable_lsp()
            -- stop all running clients
            for _, client in ipairs(vim.lsp.get_clients()) do
                client.stop(true)
            end

            -- create a blocking autocmd so no new clients can attach
            local grp = vim.api.nvim_create_augroup(LSP_DISABLE_GROUP, { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = grp,
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        -- detach just in case some on_attach logic already fired
                        pcall(vim.lsp.buf_detach_client, args.buf, client.id)
                        client.stop(true)
                    end
                end,
            })

            print("🔴🧠✨ LSP disabled")
        end

        -- Re-enable LSP globally
        local function enable_lsp()
            -- remove our blocking autocmds
            pcall(vim.api.nvim_del_augroup_by_name, LSP_DISABLE_GROUP)
            -- reload current buffer so the right server attaches
            vim.cmd("edit")
            print("🟢🧠✨ LSP enabled")
        end

        -- Expose user commands
        vim.api.nvim_create_user_command("LspDisable", disable_lsp, {})
        vim.api.nvim_create_user_command("LspEnable", enable_lsp, {})

        -- disable lsp's hotkey
        vim.keymap.set("n", "<leader>ll", function()
            -- check if there is an lsp running
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            vim.g.lsp_enabled = next(clients) and true or false

            if vim.g.lsp_enabled then
                -- disable all running servers
                for _, client in pairs(vim.lsp.get_active_clients()) do
                    vim.lsp.stop_client(client.id)
                    disable_lsp()
                end
                vim.g.lsp_enabled = false
            else
                -- enable lsps
                vim.g.lsp_enabled = true
                vim.cmd("edit")
                enable_lsp()
            end
        end)
    end
}


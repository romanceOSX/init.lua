-- lsp-related plugins
-- TODO: should I make this into its own module?

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
    },
    lazy = true,
    event = "VeryLazy", -- latests events within Neovim's startup
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua    = { "stylua" },
                python = { "black", "isort" },
                rust   = { "rustfmt" },
                c      = { "clang_format" },
                cpp    = { "clang_format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        require("fidget").setup({})

        -- Broadcast nvim-cmp capabilities to all LSP servers
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        vim.lsp.config('*', { capabilities = capabilities })

        -- lua_ls: teach it about the Neovim runtime
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        })

        -- pyright: basic type checking
        vim.lsp.config('pyright', {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = 'basic',
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        -- clangd: background indexing + clang-tidy
        vim.lsp.config('clangd', {
            cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
        })

        -- rust_analyzer: clippy on save + all features
        vim.lsp.config('rust_analyzer', {
            settings = {
                ['rust-analyzer'] = {
                    cargo = { allFeatures = true },
                    checkOnSave = { command = 'clippy' },
                    inlayHints = { enable = true },
                    -- Use server-side file watching (fixes external edits not being detected)
                    files = { watcher = 'server' },
                    -- Automatically discover new files and modules
                    workspace = { discoverConfig = 'command' },
                },
            },
        })

        -- Reload rust-analyzer workspace when new files are created
        vim.api.nvim_create_autocmd("BufNewFile", {
            pattern = "*.rs",
            callback = function()
                for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
                    client:request("rust-analyzer/reloadWorkspace", nil, function() end, 0)
                end
            end,
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

        -- lsp related
        vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references)
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration)
        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.definition)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
        vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition)
        vim.keymap.set("n", "<leader>lo", vim.lsp.buf.type_definition)
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



return {
    -- The core mason package manager and UI
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    -- provides lsp autoconfiguration from the Mason-provided servers
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            --automatic_enable = false
            -- NOTE: how does this work? say if I have clangd pre-installed, does that mean that
            --       lspconfig calls it automatically?? how does priority works with mason?
            --       will it run mason-enabled first or the system-wide installation
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "pyright",
                "clangd",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        lazy = true,
        cmd = "Mason",
    }
}


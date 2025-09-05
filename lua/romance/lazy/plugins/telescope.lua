return {
    {
        'romanceOSX/telescope-fzf-native.nvim',
        name = "telescope-fzf-native",
        lazy = true,
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        name = "telescope",
        enabled = true,
        dependencies = {
            'treesitter',
            'lspconfig',
            'telescope-fzf-native',
            'nvim-lua/plenary.nvim',
        },
        opts = {
            defaults = {
                theme = "dropdown",

                results_title = false,

                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                border = true,
                borderchars = {
                    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        },
        config = function (plugin, opts)
            --- telescope init ---
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension('fzf')

            --- keymaps ---
            local builtin = require("telescope.builtin")

            -- files
            vim.keymap.set("n", "<leader>pf", builtin.find_files)
            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>bb", builtin.buffers)
            vim.keymap.set({"n", "v"}, "<leader>fw", builtin.grep_string)
            --vim.keymap.set("n", "<leader>ps", fzf.grep)

            -- treesitter
            vim.keymap.set("n", "<leader>fs", builtin.treesitter)

            -- lsp
            vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
            vim.keymap.set("n", "<leader>ls", builtin.lsp_workspace_symbols)
            vim.keymap.set("n", "<leader>lt", builtin.lsp_type_definitions)

            -- git
            vim.keymap.set("n", "<leader>gb", builtin.git_branches)
            vim.keymap.set("n", "<leader>gB", builtin.git_bcommits)
            vim.keymap.set("n", "<leader>gc", builtin.git_commits)
            vim.keymap.set("n", "<leader>gs", builtin.git_status)
            vim.keymap.set("n", "<leader>gs", builtin.git_stash)

            -- telescope
            vim.keymap.set("n", "<leader>tt", builtin.builtin)
        end
    }
}


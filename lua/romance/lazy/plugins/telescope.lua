-- Telescope config

local builtin = require('telescope.builtin')

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {
            extensions = {
                -- aerial plugin extension
                -- TODO: check if this works in a fresh nvim installation
                --       might need to mess with priorities
                aerial = {
                    -- Set the width of the first two columns (the second
                    -- is relevant only when show_columns is set to 'both')
                    col1_width = 4,
                    col2_width = 30,
                    -- How to format the symbols
                    format_symbol = function(symbol_path, filetype)
                        if filetype == "json" or filetype == "yaml" then
                            return table.concat(symbol_path, ".")
                        else
                            return symbol_path[#symbol_path]
                        end
                    end,
                    -- Available modes: symbols, lines, both
                    show_columns = "both",
                },
            },
        },
        keys = {
            {'<leader>pf', builtin.find_files},
            -- find word
            {'<leader>fw', builtin.grep_string},
            --{'<C-p>', builtin.git_files},
            {'<leader>pws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end},
            {'<leader>pWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end},
            -- project search
            {'<leader>pl', builtin.live_grep},
            {'<leader>fl', builtin.live_grep},
            {'<leader>ps', function()
                builtin.grep_string({search = vim.fn.input("grep > ")})
            end},
            {"<leader>bl", "<cmd>Telescope buffers<CR>", { desc = "List buffers" }},
            -- file symbols
            {"<leader>fs", "<cmd>Telescope aerial<CR>", { desc = "List loca-buffer symbols" }},
            -- file find
            {'<leader>ff', builtin.find_files},
            -- file grep
            {'<leader>fg', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end}
            --{'n', '<leader>vh', builtin.help_tags, {}},
            --
        },
        -- always try to use ripgrep, it really is worth it
        find_command = "rg"
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    }
}


-- Telescope config

local builtin = require('telescope.builtin')

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        keys = {
            {'<leader>pf', builtin.find_files},
            {'<C-p>', builtin.git_files},
            {'<leader>pws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end},
            {'<leader>pWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end},
            {'<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end},
            --{'n', '<leader>vh', builtin.help_tags, {}},
        }
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    }
}


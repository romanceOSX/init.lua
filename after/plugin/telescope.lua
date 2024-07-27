-- telescope.nvim -----------------------------------------------------------
-- Telescope configuration grabbed from the telescope GitHub
local builtin = require('telescope.builtin')

local function find_files()
    builtin.find_files({ cwd = require('telescope.utils').buffer_dir()})
end

local function grep_find_files()
    builtin.grep_string({   search = vim.fn.input("Relative Grep > "),
                            cwd = require('telescope.utils').buffer_dir()})
end

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})   -- buffer relative
vim.keymap.set('n', '<leader>pF', find_files, {})           -- nvim cwd relative
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>pw', builtin.grep_string)
vim.keymap.set('n', '<leader>fw', builtin.grep_string)
vim.keymap.set('n', '<leader>ff', function()
  builtin.grep_string({search_file=vim.fn.expand("<cword>")})
end)
vim.keymap.set('n', '<leader>pS', grep_find_files, {})
vim.keymap.set('n','<leader>vh',builtin.help_tags, {})


-- telescope-fzf-native.nvim ------------------------------------------------
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
    defaults = {
        layout_strategy = 'horizontal'
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
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')



-- toggle diagnostics, picked up from :h vim.diagnostic
vim.keymap.set('n', '<leader>dd', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })


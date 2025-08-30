vim.diagnostic.config({
    -- TODO: should I enable virtual_text?
    virtual_text = false,
    -- update_in_insert = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- toggle diagnostics, picked up from :h vim.diagnostic
vim.keymap.set('n', '<leader>dd', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

-- keymaps
vim.keymap.set("n", "<leader>dj", function()
    vim.diagnostic.jump{count = 1}
end)
vim.keymap.set("n", "<leader>dk", function()
    vim.diagnostic.jump{count = -1}
end)


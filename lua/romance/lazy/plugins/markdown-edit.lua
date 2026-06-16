-- markdown editing helpers (the pieces render-markdown/marksman don't cover)
--   - autolist.nvim   : auto-continue & renumber list items, tab to indent
--   - vim-table-mode  : live-align tables as you type (toggle with <leader>tm)
--
-- Rendering lives in markup.lua (in-buffer) and render.lua (browser preview);
-- link navigation/completion comes from marksman in lsp.lua.

return {
    {
        "gaoDean/autolist.nvim",
        ft = { "markdown", "text" },
        config = function()
            require("autolist").setup()

            -- renumber / continue lists on the usual edits
            vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
            vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
            vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
            vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
            vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
            vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")
            -- toggle a checkbox [ ] <-> [x]
            vim.keymap.set("n", "<leader>mc", "<cmd>AutolistToggleCheckbox<cr><cmd>AutolistRecalculate<cr>")
        end,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown" },
        cmd = { "TableModeToggle", "TableModeEnable" },
        keys = {
            { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle markdown table mode" },
        },
        init = function()
            -- use markdown-compatible corner characters
            vim.g.table_mode_corner = "|"
        end,
    },
}

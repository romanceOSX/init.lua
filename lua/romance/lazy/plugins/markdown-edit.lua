-- markdown editing helpers (the pieces render-markdown/marksman don't cover)
--   - autolist.nvim   : auto-continue & renumber list items, tab to indent
--   - vim-table-mode  : live-align tables as you type (toggle with <leader>tm)
--
-- Rendering lives in markup.lua (in-buffer) and render.lua (browser preview);
-- link navigation/completion comes from marksman in lsp.lua.

-- Smart <C-]>: follow markdown links and bare URLs; fall back to tag jump.
local function follow_link()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed

    -- markdown link: [text](target)
    local pos = 1
    while true do
        local s, e, target = line:find("%[.-%]%((.-)%)", pos)
        if not s then break end
        if col >= s and col <= e then
            if target:match("^https?://") then
                vim.ui.open(target)
            else
                -- resolve relative to the current file's directory
                local dir = vim.fn.expand("%:p:h")
                vim.cmd("e " .. vim.fn.fnameescape(dir .. "/" .. target))
            end
            return
        end
        pos = e + 1
    end

    -- bare URL anywhere on the line
    pos = 1
    while true do
        local s, e, url = line:find("(https?://[%w%.%-%+%?%=%&%/%#_!~%(%)@:,]+)", pos)
        if not s then break end
        if col >= s and col <= e then
            vim.ui.open(url)
            return
        end
        pos = e + 1
    end

    -- fall back to tag jump
    vim.cmd("tag " .. vim.fn.expand("<cword>"))
end

vim.keymap.set("n", "<C-]>", follow_link, { desc = "Follow link or tag jump" })

return {
    {
        "gaoDean/autolist.nvim",
        ft = { "markdown", "text" },
        config = function()
            require("autolist").setup()

            -- Keep autolist's maps buffer-local: setting them globally here
            -- (config runs once, on first markdown/text buffer) would leak into
            -- every other buffer for the rest of the session. Notably <C-r> is
            -- the builtin redo, so a global override breaks redo everywhere.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "text" },
                callback = function(ev)
                    local map = function(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf })
                    end
                    -- renumber / continue lists on the usual edits
                    map("i", "<tab>", "<cmd>AutolistTab<cr>")
                    map("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
                    map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
                    map("n", "o", "o<cmd>AutolistNewBullet<cr>")
                    map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
                    -- toggle a checkbox [ ] <-> [x] (also recalculates)
                    map("n", "<leader>mc", "<cmd>AutolistToggleCheckbox<cr><cmd>AutolistRecalculate<cr>")
                end,
            })
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

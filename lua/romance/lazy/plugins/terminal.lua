--> https://github.com/akinsho/toggleterm.nvim

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", desc = "Toggle floating terminal" },
        { "<leader>th", desc = "Toggle horizontal terminal" },
        { "<leader>tg", desc = "Toggle lazygit" },
    },
    opts = {
        open_mapping = [[<C-\>]],
        direction = "float",
        -- always open at project root
        dir = "git_dir",
        float_opts = {
            border = "curved",
            winblend = 0,
        },
        -- keep terminal hidden rather than closed so state persists
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        persist_mode = true,
    },
    config = function(_, opts)
        local toggleterm = require("toggleterm")
        toggleterm.setup(opts)

        local Terminal = require("toggleterm.terminal").Terminal

        -- horizontal split terminal (good for watching build output)
        local hsplit = Terminal:new({ direction = "horizontal", dir = "git_dir" })
        vim.keymap.set("n", "<leader>th", function() hsplit:toggle() end, { desc = "Toggle horizontal terminal" })

        -- lazygit (only registers the map if lazygit is installed)
        if vim.fn.executable("lazygit") == 1 then
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                dir = "git_dir",
                float_opts = { border = "curved" },
                -- close the window automatically when lazygit exits
                on_exit = function(t) t:close() end,
            })
            vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end, { desc = "Toggle lazygit" })
        end
    end,
}

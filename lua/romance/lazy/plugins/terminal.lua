--> https://github.com/akinsho/toggleterm.nvim

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", desc = "Toggle floating terminal", mode = { "n", "t" } },
    },
    opts = {
        direction = "float",
        dir = "git_dir",
        float_opts = {
            border = "curved",
            winblend = 0,
        },
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        persist_mode = true,
    },
    config = function(_, opts)
        local toggleterm = require("toggleterm")
        toggleterm.setup(opts)

        local Terminal = require("toggleterm.terminal").Terminal
        local shell = Terminal:new({ display_name = "🦪 shell" })

        local _opts = { noremap = true, silent = true }
        vim.keymap.set({ "n", "t" }, [[<C-\>]], function() shell:toggle() end, _opts)
        vim.keymap.set("t", "<C-q>", vim.cmd.stopinsert, _opts)
    end,
}

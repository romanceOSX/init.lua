return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = {},
    config = function(plug, table)
        local fzf = require("fzf-lua")
        vim.keymap.set("n", '<leader>pf', fzf.files)
    end
}


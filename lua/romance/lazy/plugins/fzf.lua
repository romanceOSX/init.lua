return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    name = "fzf",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = {},
    config = function(plug, opts)
        local fzf = require("fzf-lua")

        -- keymaps
        vim.keymap.set("n", "<leader>pf", fzf.files)
        vim.keymap.set("n", "<leader>ff", fzf.files)
        vim.keymap.set("n", "<leader>bb", fzf.buffers)
        vim.keymap.set("n", "<leader>fw", fzf.grep_cword)
        vim.keymap.set("v", "<leader>fw", fzf.grep_visual)
        vim.keymap.set("n", "<leader>ps", fzf.grep)
        vim.keymap.set("n", "<leader>fp", fzf.git_files)
        vim.keymap.set("n", "<leader>fg", fzf.git_files)

        vim.keymap.set("n", "<leader>fs", fzf.treesitter)

        vim.keymap.set("n", "<leader>ls", fzf.lsp_workspace_symbols)
        vim.keymap.set("n", "<leader>lr", fzf.lsp_references)
    end
}


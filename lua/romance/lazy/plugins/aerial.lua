return {
    'stevearc/aerial.nvim',
    opts = {
        -- Treesitter first: it parses the buffer on open, so it works the moment
        -- the outline is toggled regardless of LSP attach timing (aerial is
        -- lazy-loaded on <leader>o, by which point marksman has already attached
        -- and aerial's LspAttach hook would have missed the event). LSP is the
        -- fallback for filetypes without a treesitter parser.
        backends = {
            "treesitter",
            "lsp",
        },
        -- jump between symbols inside the buffer
        keymaps = {
            ["{"] = "actions.prev",
            ["}"] = "actions.next",
        },
    },
    -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  keys = {
     { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Toggle outline (sections)" },
     { "<leader>O", "<cmd>AerialNavToggle<cr>", desc = "Floating outline nav" },
  },
}

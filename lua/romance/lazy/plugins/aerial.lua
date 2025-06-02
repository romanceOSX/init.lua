return {
    'stevearc/aerial.nvim',
    opts = {
        -- will use both
        backends = {
            "treesitter",
            --"lsp"
        },
    },
    -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}

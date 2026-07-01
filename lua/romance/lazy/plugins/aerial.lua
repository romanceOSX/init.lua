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
        -- auto-open the outline panel, but only for markdown buffers, and not
        -- for the scratch file Claude Code opens via ^g in its prompt (it sets
        -- CLAUDECODE=1 on the child nvim process; the tmp-path check is a
        -- fallback in case the env var isn't inherited).
        open_automatic = function(bufnr)
            if vim.bo[bufnr].filetype ~= "markdown" then
                return false
            end
            if vim.env.CLAUDECODE == "1" then
                return false
            end
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name:match("^/tmp/") or name:match("^/private/tmp/") then
                return false
            end
            return true
        end,
    },
    -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  -- load on markdown (so the auto-open fires) as well as on the toggle keys
  ft = { "markdown" },
  keys = {
     { "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Toggle outline (sections)" },
     { "<leader>O", "<cmd>AerialNavToggle<cr>", desc = "Floating outline nav" },
  },
  config = function(_, opts)
     require("aerial").setup(opts)
     -- The markdown buffer that lazy-loaded aerial already fired FileType, so
     -- open_automatic missed it — open the panel for it explicitly. Defer it:
     -- opening synchronously here runs inside the markdown FileType cascade,
     -- creating the `aerial` buffer mid-cascade, which makes the treesitter
     -- FileType autocmd throw trying to start a parser for language "aerial".
     if vim.bo.filetype == "markdown" and opts.open_automatic(vim.api.nvim_get_current_buf()) then
        vim.schedule(function() require("aerial").open({ focus = false }) end)
     end
  end,
}

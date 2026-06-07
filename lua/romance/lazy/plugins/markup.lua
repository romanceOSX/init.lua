--> https://github.com/MeanderingProgrammer/render-markdown.nvim
-- markdown-preview.nvim (iamcco) lives in render.lua

return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {
            enabled = true,
        },
        config = function(_, opts)
            require("render-markdown").setup(opts)

            vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle render-markdown" })
        end,
    },
}

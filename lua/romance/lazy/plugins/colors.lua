--> color module

return {
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_background = 'medium'
            vim.g.everforest_better_performance = 1
            vim.g.everforest_enable_italic = 1
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_dim_inactive_windows = 1
            vim.cmd("colorscheme everforest")
        end
    },
}


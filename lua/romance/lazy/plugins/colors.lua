--[[
    True color is defined as the 24-bit based coloring system, having a total of
    2^24 color coding points, $TERM gives out this info.
    In the case of OSX's default terminal is 8-bit color-based, meaning it is restricted
--]]

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


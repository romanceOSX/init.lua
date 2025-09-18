--[[
    True color is defined as the 24-bit based coloring system, having a total of
    2^24 color coding points, $TERM gives out this info.
    In the case of OSX's default terminal is 8-bit color-based, meaning it is restricted
--]]

--> color module

return {
    {
        "sainnhe/everforest",
        enabled = true,
        config = function ()
            vim.g.everforest_background = 'medium'
            vim.g.everforest_better_performance = 1
            vim.g.everforest_enable_italic = 1
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_dim_inactive_windows = 1
            --vim.cmd("colorscheme everforest")
        end
    },
    {
        'matsuuu/pinkmare',
        lazy = false,
        enabled = true,
        priority = 1000,
        init = function ()
            vim.opt.termguicolors = true
            vim.g.pinkmare_transparent_background = 1
        end,
        config = function ()
            vim.g.pinkmare_palette = {
                bg_green = {"#1e25eb", "22", "DarkGreen"},
            }
            --vim.cmd.colorscheme("pinkmare")
        end,
    },
    {
        "rijulpaul/nightblossom.nvim",
        name = "nightblossom",
        lazy = false,
        priority = 1000,
        opts = {
            variant = "pastel",
            transparent = true,
            integrations = {
                treesitter = true,
            },
            --- Overrides
            -- highlights = {
            --     Normal = { bg = "#1a1a1a", fg = "#e0e0e0" },
            --     ["@comment"] = { fg = "#888888", italic = false },
            -- }
        },
        config = function(plugin, opts)
            require("nightblossom").setup(opts)
            --vim.cmd("colorscheme nightblossom-pastel")
        end,
    },
    {
        "anAcc22/sakura.nvim",
        dependencies = "rktjmp/lush.nvim",
        enabled = true,
        lazy = false,
        config = function()
            vim.opt.background = "dark" -- or "light"
            vim.cmd [[
              highlight Normal guibg=none
              highlight NonText guibg=none
              highlight Normal ctermbg=none
              highlight NonText ctermbg=none
            ]]
            vim.cmd('colorscheme everforest') -- sets the colorscheme
        end
    },
}


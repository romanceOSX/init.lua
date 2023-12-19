
vim.opt.termguicolors = true        -- ???

-- dracula theme setup
local dracula = require('dracula')
dracula.setup({
    transparent_bg = true
})

-- nightfox theme setup
require('nightfox').setup({
    options = {
        transparent = true
    }
})

-- sonokai theme setup
vim.g.sonokai_style = 'shusia'
vim.g.sonokai_better_performance = 1
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_transparent_background = 1

-- everforest theme setup
vim.g.everforest_background = 'medium'
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.g.everforest_transparent_background = 1
vim.g.everforest_dim_inactive_windows = 1


-- colorscheme setup
local function applyTheme(color)
    color = color or "pablo"
    vim.cmd.colorscheme(color)
end


--applyTheme("dracula-soft")
--applyTheme("nightfox")
--applyTheme("sonokai")
applyTheme("everforest")


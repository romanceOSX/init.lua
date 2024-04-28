--[[
    True color is defined as the 24-bit based coloring system, having a total of
    2^24 color coding points, $TERM gives out this info.
    In the case of OSX's default terminal is 8-bit color-based, meaning it is restricted
--]]

-- Sets coloring based on terminal's truecolor feature availability
local function setup_term_color()
    local result = false
    local env = string.lower(os.getenv("TERM") or "")
    if env == "" then
        return 0
    end
    if string.find(env, "truecolor") then
        result = true
    end
    if string.find(env, "24bit") then
        result = true
    end
    if string.find(env, "iterm") then
        result = true
    end
    vim.opt.termguicolors = result
end

-- setup terminal colors
setup_term_color()

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


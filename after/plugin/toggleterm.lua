-- toggleterm config
-- TODO: add a more modular way to add custom terminals

-- only to set up autocommands
require("toggleterm").setup{ }

-- mapping between terminal names and their terminal objects
local terminals = { }

-- lazygit toggle terminal
local Terminal  = require('toggleterm.terminal').Terminal

-- keymaps
-- note that there shouldn't be any mappings with <leader> on terminal mode
-- otherwise you won't be able to type properly
function _G.set_terminal_keymaps_shell(term)
    local opts = {buffer = 0}
    vim.keymap.set('t', [[<C-\>]], terminals.shell, opts)
end

function _G.set_terminal_keymaps_lazygit(term)
    local opts = {buffer = 0}
    vim.keymap.set('t', [[<C-\>]], terminals.lazygit, opts)
    -- can't type 'q' in commit messages
    --vim.keymap.set('t', 'q', terminals.lazygit, opts)
end

local lazygit_term = Terminal:new{
    cmd = "lazygit",
    display_name = "⏾ lazygit",
    hidden = false,
    direction = "float",
    on_open = set_terminal_keymaps_lazygit,
}

local shell_term = Terminal:new{
    direction = "float",
    display_name = "🦪 shell",
    on_open = set_terminal_keymaps_shell,
}

terminals.shell = function() return shell_term:toggle() end
terminals.lazygit = function() return lazygit_term:toggle() end

-- spawn processes
lazygit_term:spawn()
shell_term:spawn()

vim.keymap.set("n", [[<C-\>]], terminals.shell, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>l", terminals.lazygit, {noremap = true, silent = true})



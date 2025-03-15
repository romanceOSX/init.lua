-- toggle'd terminal

require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    autochdir = true,
    direction = 'horizontal',
    shade_terminals = true,
    --on_open = function (term)
    --    -- get current buffer directory
    --    local dir = vim.api.nvim_buf_get_name(0)
    --    print(dir,'\n')
    --    term:change_dir(dir,false)
    --end
    float_opts = {border = 'curved',
        title_pos = "left"},
    winbar = {enabled = true}
}

-- lazygit toggle terminal

local Terminal  = require('toggleterm.terminal').Terminal

local function _create_lg_term()
    local term = Terminal:new({
        cmd = "lazygit",
        hidden = false,
        --dir = "gitdir",
    })
    term:spawn()
    return term
end

local lazygit_term = _create_lg_term()

local function _lazygit_toggle()
    lazygit_term:toggle()
end

-- in-terminal mappings

function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', [[<C-\>]], _lazygit_toggle, opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*lazygit* lua set_terminal_keymaps()')

vim.keymap.set("n", "<leader>l", _lazygit_toggle, {noremap = true, silent = true})


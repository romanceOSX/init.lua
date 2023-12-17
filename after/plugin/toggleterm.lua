require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    autochdir = true,
    direction = 'float',
    shade_terminals = true,
    --on_open = function (term)
    --    -- get current buffer directory
    --    local dir = vim.api.nvim_buf_get_name(0)
    --    print(dir,'\n')
    --    term:change_dir(dir,false)
    --end
}


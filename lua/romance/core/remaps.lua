-- core nvim remaps

-- <leader> is defined here
vim.g.mapleader = " "
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)

vim.keymap.set('i','<C-c>','<Esc>')
-- Clear Highlights

vim.keymap.set("n", "<Esc>", "<cmd> noh <CR>")
--- vim.keymap.set('n','<C-f>',"<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- move blocks of lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Buffer navigation
vim.keymap.set("n", "<leader>gb", ":buffers<CR>:buffer <Space>")

-- Marks navigation
vim.keymap.set("n", "<leader>gm", ":marks<CR> <Space>") -- This is wrong

-- Makes the '#' search not to move to the next occurrence
vim.keymap.set('n', '#', function()
        vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
    end,
    { desc = "Search current word without jumping"}
)


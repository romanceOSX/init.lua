local function check_os()
   return  vim.loop.os_uname().sysname
end

local _os = check_os()

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.rnu = true
vim.opt.relativenumber = true

-- Indenting tab to 4 spaces
local tabwidth = 4
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Still deciding what is better
-- Remember I am mostly a laptop user
-- vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

-- Only aply for BSD
if _os == "FreeBSD" then
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
-- vim.opt.foldmethod="indent"

vim.opt.ignorecase = true

vim.opt.wrap = false


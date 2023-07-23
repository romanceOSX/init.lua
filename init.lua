-- Nvim tree configuration
require("neko.nvim_tree_confg")
-- Plugin configs are under the after/pluggin folder

-- Remap
require("neko.remap")
require("neko.packer")
require("neko.set")

-- Color theme thing
vim.cmd [[colorscheme moonfly]]

-- Vim related config and sets
vim.api.nvim_set_option('autoindent',true)
vim.api.nvim_set_option('rnu',true)

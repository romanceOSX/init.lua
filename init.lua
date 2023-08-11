-- Under the 'Commit Message Format'
-- https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines
-- https://www.conventionalcommits.org/en/v1.0.0/
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

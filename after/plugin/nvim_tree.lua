
-- global
-- I wont disable netrw yet since tree-less workflow is also pog
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

-- disable netrw at the very start of your init.lua
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

------------------------------------------------------------------------------------------------

local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    -- opts function
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Recipes https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
    local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
        else
            -- open file
            api.node.open.edit()
            -- Close the tree if file was opened
            api.tree.close()
        end
    end

    -- open as vsplit on current node
    local function vsplit_preview()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
        else
            -- open file as vsplit
            api.node.open.vertical()
        end

        -- Finally refocus on tree if it was lost
        api.tree.focus()
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    -- opt() function makes these key-binds to apply only to the nvim-tree buffer
    vim.keymap.set('n', '<C-[>', api.tree.change_root_to_parent,        opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    -- on_attach
    vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
    vim.keymap.set("n", "L", vsplit_preview,        opts("Vsplit Preview"))
    vim.keymap.set("n", "h", api.tree.close,        opts("Close"))
    vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
end

------------------------------------------------------------------------------------------------

-- pass to setup along with your other options
require("nvim-tree").setup {
    ---
    -- on_attach takes a function that runs when creating the nvim-tree buffer
    on_attach = my_on_attach,

    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}

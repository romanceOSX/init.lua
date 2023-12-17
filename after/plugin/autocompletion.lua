-- Helper Utility Functions ---------------------------------------------------
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


-- Luasnip --------------------------------------------------------------------
local luasnip = require("luasnip")
-- Load snippets provided by friendly snippets
require('luasnip.loaders.from_vscode').lazy_load()
-- Redundant standalone mappings, functionality is already handled by cmp but it
-- might become useful to jump in between luasnip nodes even when cmp is visible
vim.keymap.set({"i", "s"}, "<C-k>", function () luasnip.expand() end)   -- redundant handled by cmp
vim.keymap.set({"i", "s"}, "<C-l>", function () luasnip.expand_or_jump(1) end)
vim.keymap.set({"i", "s"}, "<C-h>", function () luasnip.jump(-1) end)


-- cmp ------------------------------------------------------------------------
local cmp = require("cmp")

-- Only selects the text, it does not actually insert it
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local options = {
    mapping = {
        ["<C-p>"] = cmp.mapping(function (fallback)
            if cmp.visible() then
                -- nothing selected yet, then do normal cmp next action
                cmp.select_prev_item(cmp_select)
            elseif luasnip.expand_or_jumpable(-1) then
                -- Jump to the next luasnip field
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i','s'}),

        ["<C-n>"] = cmp.mapping(function (fallback)
            if cmp.visible() then
                -- nothing selected yet, then do normal cmp next action
                cmp.select_next_item(cmp_select)
            elseif luasnip.expand_or_jumpable() then
                -- Jump to the next luasnip field
                luasnip.expand_or_jump()
            elseif has_words_before() then
                -- Invoke cmp menu
                cmp.complete()
            else
                fallback()
            end
        end, {'i','s'}),

        ["<C-y>"] = cmp.mapping.confirm({ select = true }),     -- snippet engine needs to be available
        ["<C-e>"] = cmp.mapping.close(),

        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = cmp.mapping.complete(),                 -- invoke completion menu
    },

    -- This is how cmp interacts with a specific snippet engine
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },

    sources = {
        { name = "nvim_lsp" },      -- lsp sources (including snippets
        { name = "nvim_lua" },      -- lsp lua source for nvim variables
        { name = "luasnip" },       -- Add external sources, not only snippets from the lsp server
        { name = "buffer" },        -- idk
    }
}

-- Apply settings
cmp.setup(options)

-- cmp-nvim-lsp
-- The nvim-cmp almost supports LSP's capabilities, so you should advertise it
-- to the LSP servers...
-- This tells the lsp server that there is a snippet engine available and is
-- able to call it from the cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- An example to setup clangd to use nvim-cmp cpabilities


-- LSP ------------------------------------------------------------------------
local lsp = require("lspconfig")

-- clangd15
lsp.clangd.setup{
    cmd = {'clangd15'},
    capabilities = capabilities
}

-- lua-language-server
lsp.lua_ls.setup{
    settings = {
        Lua = {
            diagnostics = {
                -- Disable vim warning for nvim lua
                globals = {'vim'}
            }
        }
    }
}

--  pyright
lsp.pyright.setup{}


-- autopairs ------------------------------------------------------------------
-- I'd rather configure autopairs here than in a config packer field
require("nvim-autopairs").setup{}


-- TODO -----------------------------------------------------------------------
-- [ ] - Add cmp for search menu '/' and for cmd menu as well ':'
-- [ ] - Add cmp for cmd menu ':'
-- [ ] - cmp.mapping(function () ... end) vs cmp.mapping.complete()


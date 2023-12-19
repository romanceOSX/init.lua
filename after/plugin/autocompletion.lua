-- Helper Utility Functions ---------------------------------------------------
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


-- LUASNIP --------------------------------------------------------------------
local luasnip = require("luasnip")
-- Load snippets provided by friendly snippets
require('luasnip.loaders.from_vscode').lazy_load()
-- Redundant standalone mappings, functionality is already handled by cmp but it
-- might become useful to jump in between luasnip nodes even when cmp is visible
vim.keymap.set({"i", "s"}, "<C-k>", function () luasnip.expand() end)   -- redundant handled by cmp
vim.keymap.set({"i", "s"}, "<C-l>", function () luasnip.expand_or_jump() end)
vim.keymap.set({"i", "s"}, "<C-h>", function () luasnip.jump(-1) end)


-- CMP ------------------------------------------------------------------------
local cmp = require("cmp")

-- Only selects the text, it does not actually insert it
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local mappings = {
    ["<C-p>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
            -- nothing selected yet, then do normal cmp next action
            cmp.select_prev_item(cmp_select)
        elseif luasnip.jumpable(-1) then
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
}

local exec_mappings = {
    ['<Tab>'] = {
        c = function()
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
    },

    ["<S-Tab>"] ={
        c = function ()
            if cmp.visible() then
                -- nothing selected yet, then do normal cmp next action
                cmp.select_prev_item(cmp_select)
            else
                -- Jump to the next luasnip field
                luasnip.jump(-1)
            end
        end
    },
}

local options = {
    mapping = mappings,

    -- This is how cmp interacts with a specific snippet engine
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },

    sources = {
        { name = "nvim_lsp" },      -- lsp sources (including snippets
        { name = "nvim_lua" },      -- lsp lua source for nvim variables
        { name = "luasnip" },       -- Add external sources, not only snippets from the lsp server
    }
}

-- Apply settings
cmp.setup(options)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = exec_mappings,
    sources = {
        { name = 'path' },
        { name = 'cmdline' }
    }
})

-- cmp-nvim-lsp
-- The nvim-cmp almost supports LSP's capabilities, so you should advertise it
-- to the LSP servers...
-- This tells the lsp server that there is a snippet engine available and is
-- able to call it from the cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- An example to setup clangd to use nvim-cmp cpabilities


-- LSP ------------------------------------------------------------------------
local lsp = require("lspconfig")

-- lsp keybings autocommand, they are only activated if the lsp client is attached to the buffer
local function client_attach(args)
    local opts = {buffer = args.buf, noremap = true}

    vim.keymap.set("n", "gd", function () vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function () vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gr", function () vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gs", function () vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "gR", function () vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "go", function () vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "<F4>", function () vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "K", function () vim.lsp.buf.hover() end, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = client_attach
})

-- Language servers configuration setup calls
-- clangd15
lsp.clangd.setup{
    cmd = {'clangd15'},
    capabilities = capabilities,
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
    },
    capabilities = capabilities,
}

--  pyright
lsp.pyright.setup{
    capabilities = capabilities,
}


-- AUTOPAIRS ------------------------------------------------------------------
-- I'd rather configure autopairs here than in a config packer field
require("nvim-autopairs").setup{}


-- TODO -----------------------------------------------------------------------
-- [X] - Add cmp for search menu '/' and for cmd menu as well ':'
-- [X] - Add cmp for cmd menu ':'
-- [ ] - cmp.mapping(function () ... end) vs cmp.mapping.complete()
-- [ ] - Implement a way to extend the setup keys for each of the servers 
--       programattically, priving the server name i.e. 'clangd' and the key to
--       edit


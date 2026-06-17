-- TODO: create the config and key tables outside the return

return {
    {
        "romanceOSX/telescope-fzf-native.nvim",
        lazy = true,
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    },
    {
        'nvim-telescope/telescope.nvim',
        commit = "b4da76b",
        enabled = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
            "romanceOSX/telescope-fzf-native.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {
            defaults = {
                theme = "dropdown",

                results_title = false,

                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                border = true,
                borderchars = {
                    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        },
        config = function(plugin, opts)
            --- telescope init ---
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension('fzf')

            --- shell history picker (fuzzy-search ~/.history, like ^R in zsh) ---
            local function shell_history()
                local pickers      = require("telescope.pickers")
                local finders      = require("telescope.finders")
                local conf         = require("telescope.config").values
                local actions      = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                local histfile = vim.fn.expand("~/.history")
                local seen, results = {}, {}
                -- newest-first, de-duplicated. Strip zsh extended-history
                -- metadata (": <ts>:<dur>;cmd") when present; plain lines pass through.
                for _, line in ipairs(vim.fn.reverse(vim.fn.readfile(histfile))) do
                    local cmd = line:gsub("^:%s*%d+:%d+;", "")
                    if cmd ~= "" and not seen[cmd] then
                        seen[cmd] = true
                        results[#results + 1] = cmd
                    end
                end

                pickers.new({}, {
                    prompt_title = "Shell history",
                    finder = finders.new_table({ results = results }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(bufnr)
                        -- <CR>  → insert the command at the cursor
                        actions.select_default:replace(function()
                            actions.close(bufnr)
                            vim.api.nvim_put({ action_state.get_selected_entry()[1] }, "", true, true)
                        end)
                        -- <C-y> → yank to the system clipboard instead
                        actions.select_horizontal:replace(function()
                            actions.close(bufnr)
                            vim.fn.setreg("+", action_state.get_selected_entry()[1])
                        end)
                        return true
                    end,
                }):find()
            end

            --- keymaps ---
            local builtin       = require("telescope.builtin")
            local entry_display = require("telescope.pickers.entry_display")
            local make_entry    = require("telescope.make_entry")
            local ts_utils      = require("telescope.utils")

            -- Rainbow-pastel entry makers: colour each column with sakura theme
            -- groups (Function=rose, Number=purple, String=green, Type=blue,
            -- Comment=muted) so the lists match the rest of the colourscheme and
            -- follow the light/dark switch automatically.
            local function keymaps_entry_maker(opts)
                opts = opts or {}
                local displayer
                local function get_displayer()
                    -- built lazily: builtin.keymaps sets opts.width_lhs before render
                    displayer = displayer or entry_display.create({
                        separator = " ▏",
                        items = {
                            { width = 3 },                 -- mode
                            { width = opts.width_lhs or 20 }, -- the shortcut
                            { remaining = true },          -- description / action
                        },
                    })
                    return displayer
                end

                local function get_desc(entry)
                    if entry.callback and not entry.desc then
                        return require("telescope.actions.utils")._get_anon_function_name(debug.getinfo(entry.callback))
                    end
                    return vim.F.if_nil(entry.desc, entry.rhs):gsub("\n", "\\n")
                end

                local make_display = function(e)
                    return get_displayer()({
                        { e.mode, "Number" },   -- purple: mode
                        { e.lhs,  "Function" }, -- rose:   the shortcut keys
                        { e.desc, "String" },   -- green:  what it does
                    })
                end

                return function(entry)
                    local lhs  = ts_utils.display_termcodes(entry.lhs)
                    local desc = get_desc(entry)
                    return make_entry.set_default_entry_mt({
                        mode    = entry.mode,
                        lhs     = lhs,
                        desc    = desc,
                        valid   = entry ~= "",
                        value   = entry,
                        ordinal = entry.mode .. " " .. lhs .. " " .. desc,
                        display = make_display,
                    }, opts)
                end
            end

            local function commands_entry_maker(opts)
                opts = opts or {}
                local displayer = entry_display.create({
                    separator = " ▏",
                    items = {
                        { width = 0.25 }, -- name
                        { width = 4 },    -- nargs
                        { width = 11 },   -- completion type
                        { remaining = true }, -- definition
                    },
                })
                local make_display = function(e)
                    return displayer({
                        { e.name,                                "Function" }, -- rose:   command
                        { e.nargs,                               "Number" },   -- purple: nargs
                        { e.complete or "",                      "Type" },     -- blue:   completion
                        { (e.definition or ""):gsub("\n", " "),  "Comment" },  -- muted:  definition
                    })
                end
                return function(entry)
                    return make_entry.set_default_entry_mt({
                        name       = entry.name,
                        bang       = entry.bang,
                        nargs      = entry.nargs,
                        complete   = entry.complete,
                        definition = entry.definition,
                        value      = entry,
                        ordinal    = entry.name,
                        display    = make_display,
                    }, opts)
                end
            end

            -- Help menu
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

            -- Keymaps & commands (fuzzy search current shortcuts/commands)
            vim.keymap.set('n', '<leader>fk', function()
                local opts = {}
                opts.entry_maker = keymaps_entry_maker(opts) -- share opts so width_lhs propagates
                builtin.keymaps(opts)
            end, { desc = 'Telescope keymaps' })
            vim.keymap.set('n', '<leader>fc', function()
                local opts = {}
                opts.entry_maker = commands_entry_maker(opts)
                builtin.commands(opts)
            end, { desc = 'Telescope commands' })

            -- Buffers
            vim.keymap.set("n", "<leader>b", builtin.buffers)
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })

            -- files
            vim.keymap.set("n", "<leader>pf", builtin.find_files)
            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>pF", function()
                builtin.find_files({ hidden = true, no_ignore = true })
            end)
            vim.keymap.set({ "n", "v" }, "<leader>fw", builtin.grep_string)
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string { search = vim.fn.input({ prompt = "🔎 Grep > " }) }
            end)
            vim.keymap.set("n", "<leader>mm", builtin.marks)

            -- document symbols = headings/sections in this buffer (fuzzy jump)
            vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Outline / sections (this file)" })

            -- lsp
            vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
            vim.keymap.set("n", "<leader>li", builtin.lsp_incoming_calls)
            vim.keymap.set("n", "<leader>ls", builtin.lsp_workspace_symbols)
            vim.keymap.set("n", "<leader>lt", builtin.lsp_type_definitions)
            -- document symbols = headings/sections in this buffer (fuzzy jump)
            vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols, { desc = "Outline / sections (this file)" })

            -- git
            vim.keymap.set("n", "<leader>gb", builtin.git_branches)
            vim.keymap.set("n", "<leader>gB", builtin.git_bcommits)
            vim.keymap.set("n", "<leader>gc", builtin.git_commits)
            vim.keymap.set("n", "<leader>gs", builtin.git_status)
            vim.keymap.set("n", "<leader>gs", builtin.git_stash)

            -- shell history (fuzzy ^R over ~/.history)
            vim.keymap.set("n", "<leader>sh", shell_history, { desc = "Telescope shell history" })

            -- telescope
            vim.keymap.set("n", "<leader>tt", builtin.builtin)
            vim.keymap.set("n", "<leader>tp", builtin.builtin) -- 'tp' as in 'telescope picker'
        end
    }
}

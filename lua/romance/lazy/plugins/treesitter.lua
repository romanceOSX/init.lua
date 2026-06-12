-- treesitter plugin — main branch (the Neovim 0.12 rewrite)
--> https://github.com/nvim-treesitter/nvim-treesitter
--
-- The old `master` branch is frozen and breaks on nvim 0.12 (e.g. the
-- treesitter-context "range (a nil value)" error in markdown). `main` is a full
-- rewrite: it compiles parsers locally via the tree-sitter CLI (installed in
-- dotfiles/home/packages.nix) and no longer auto-enables highlight/indent —
-- those are turned on per-buffer below. There is no nvim-treesitter.configs.

local parsers = {
    "c",
    "cpp",
    "rust",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "xml",
    "bash", -- also drives zsh highlighting (registered to the zsh filetype below)
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            -- Install / keep the parsers above up to date (async on main).
            require("nvim-treesitter").install(parsers)

            -- zsh has no dedicated grammar; drive it with the bash parser so .zsh
            -- files get treesitter highlighting/indent too.
            vim.treesitter.language.register("bash", "zsh")

            local max_filesize = 500 * 1024 -- 500 KB

            -- main does NOT auto-enable highlight/indent — do it per buffer.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    local buf = ev.buf
                    -- Skip very large files (performance).
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return
                    end
                    -- Start TS highlighting if a parser exists for this filetype;
                    -- pcall swallows the error for filetypes without a parser.
                    if pcall(vim.treesitter.start) then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter/nvim-treesitter",
        -- had to rename it for the require(MAIN).setup(opts) to work
        name = "treesitter-context",
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            multiwindow = false, -- Enable multiwindow support.
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 20, -- Maximum number of lines to show for a single context
            trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
        }
    }
}

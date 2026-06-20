--> https://github.com/HakonHarnes/img-clip.nvim
-- paste images from the clipboard into markdown; inserts the link automatically
-- macOS requires `pngpaste` (installed via home-manager, see dotfiles packages.nix)
--
-- Terminal.app can't forward Cmd+V to nvim, so true terminal-paste of an image
-- is impossible here. Image paste is an explicit action via `<leader>p`.
--
-- We deliberately do NOT remap `p`/`P`: a "smart" override had to shell out to
-- the clipboard (pngpaste/osascript) on every paste to sniff for an image,
-- which added noticeable latency and broke counts/registers (`3p`, `"ap`).

return {
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        ft = { "markdown" },
        opts = {
            default = {
                dir_path = "assets",
                relative_to_current_file = true,
                prompt_for_file_name = false,
                use_absolute_path = false,
            },
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                },
            },
        },
        config = function(_, opts)
            require("img-clip").setup(opts)

            -- Buffer-local to markdown; `p`/`P` are left untouched (native).
            local function set_maps(buf)
                vim.keymap.set("n", "<leader>p", "<cmd>PasteImage<cr>",
                    { buffer = buf, desc = "Paste image from clipboard" })
            end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function(ev) set_maps(ev.buf) end,
            })

            -- The buffer that lazy-loaded this plugin already fired FileType, so
            -- map it now too.
            if vim.bo.filetype == "markdown" then
                set_maps(0)
            end
        end,
    },
}

--> https://github.com/HakonHarnes/img-clip.nvim
-- paste images from the clipboard into markdown; inserts the link automatically
-- macOS requires `pngpaste` (installed via home-manager, see home.nix)

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
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
        },
    },
}

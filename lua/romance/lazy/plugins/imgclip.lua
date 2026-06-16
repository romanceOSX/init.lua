--> https://github.com/HakonHarnes/img-clip.nvim
-- paste images from the clipboard into markdown; inserts the link automatically
-- macOS requires `pngpaste` (installed via home-manager, see dotfiles packages.nix)
--
-- Terminal.app can't forward Cmd+V to nvim, so true terminal-paste of an image
-- is impossible here. Instead we make `p`/`P` smart *in markdown buffers only*:
-- if the system clipboard holds an image, paste it as a markdown link; otherwise
-- fall through to a normal Vim paste. `<leader>p` stays as an explicit trigger.

-- image on clipboard -> PasteImage; else behave like the normal paste key.
local function smart_paste(fallback_key)
    return function()
        local ok, clipboard = pcall(require, "img-clip.clipboard")
        if ok and clipboard.content_is_image() then
            require("img-clip").paste_image()
        else
            -- "n" = no remap, so this won't recurse back into this mapping
            vim.api.nvim_feedkeys(fallback_key, "n", false)
        end
    end
end

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

            -- All three maps are buffer-local to markdown so `p`/`P` keep their
            -- normal meaning everywhere else.
            local function set_maps(buf)
                local map = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
                end
                map("p", smart_paste("p"), "Paste (image as markdown link, else normal)")
                map("P", smart_paste("P"), "Paste before (image-aware)")
                map("<leader>p", "<cmd>PasteImage<cr>", "Paste image from clipboard")
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

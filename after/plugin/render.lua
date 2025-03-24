local function _markdown_render()
    print("Rendering markdown...")
    vim.cmd("MarkdownPreviewToggle")
end

-- TODO: call latex renderer here
local function _latex_render()

end

-- TODO: Is there a better pattern for autoregistring these functions?
local _filetype_mapping = {
    ["markdown"] = _markdown_render,
    ["tex"] = _latex_render,
    ["no_filetype"] = function () print("No render engine available") end,
}

local function _render_file()
    local filetype = vim.bo.filetype
    local renderer = _filetype_mapping[filetype] or _filetype_mapping["no_filetype"]
    renderer()
end

vim.keymap.set("n", "<leader>gx", _render_file, {})


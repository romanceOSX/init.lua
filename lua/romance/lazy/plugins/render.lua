local function _markdown_render()
    print("Rendering markdown...") vim.cmd("MarkdownPreviewToggle")
end

local function _latex_render()
    local abs_filepath = vim.fn.expand('%:p')
    local rel_filepath = vim.fn.expand('%:t')
    print("Rendering tex file: " .. rel_filepath)
    vim.fn.system{'pdflatex', rel_filepath}
    vim.fn.system{'open', abs_filepath:sub(1, -5) .. ".pdf"}
end

-- TODO: Is there a better pattern for autoregistring these functions?
local filetype_mapping = {
    ["markdown"] = _markdown_render,
    ["text"] = _markdown_render, -- txt's can also be rendered by markdown
    ["tex"] = _latex_render,
    ["no_filetype"] = function () print("No render engine available") end,
}

local function render_file()
    local filetype = vim.bo.filetype
    local renderer = filetype_mapping[filetype] or filetype_mapping["no_filetype"]
    renderer()
end

-- install with yarn or npm
return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
        {"<leader>gx", render_file, {}},
        {"<leader>fx", render_file, {}},
    }
}


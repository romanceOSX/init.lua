-- XML support: filetype detection, folding, and large file handling

-- Add file extensions that should be treated as XML here
local xml_extensions = {
    "xhtml",
    "xsd",
    "xsl",
    "xslt",
    "wsdl",
    "pom",
    "svg",
    "csproj",
    "vbproj",
    "fsproj",
    "props",
    "targets",
    "resx",
    "nuspec",
    "config",
    "rss",
    "atom",
    "kml",
    "gpx",
    "dae",
    "odx-d",
    "odx-d.tmp",
}

-- Register extensions as xml filetype
local ext_map = {}
for _, ext in ipairs(xml_extensions) do
    ext_map[ext] = "xml"
end
vim.filetype.add({ extension = ext_map })

-- Threshold above which treesitter folding is skipped (bytes)
local LARGE_FILE_THRESHOLD = 500 * 1024 -- 500 KB

local function is_large_file(buf)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > LARGE_FILE_THRESHOLD
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "xml",
    desc = "XML: set up tag folding",
    callback = function(ev)
        local buf = ev.buf
        if is_large_file(buf) then
            -- Indent-based folding is fast on large files
            vim.opt_local.foldmethod = "indent"
        else
            -- Treesitter expression folding for accurate XML tag folding
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        end
        -- Start with all folds open
        vim.opt_local.foldlevel = 99
    end,
})

return {}

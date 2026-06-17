local function _markdown_render()
	print("Rendering markdown...")
	vim.cmd("MarkdownPreviewToggle")
end

local function _latex_render()
	local abs_filepath = vim.fn.expand("%:p")
	local rel_filepath = vim.fn.expand("%:t")
	print("Rendering tex file: " .. rel_filepath)
	vim.fn.system({ "pdflatex", rel_filepath })
	vim.fn.system({ "open", abs_filepath:sub(1, -5) .. ".pdf" })
end

-- TODO: Is there a better pattern for autoregistring these functions?
local filetype_mapping = {
	["markdown"] = _markdown_render,
	["text"] = _markdown_render, -- txt's can also be rendered by markdown
	["tex"] = _latex_render,
	["no_filetype"] = function()
		print("No render engine available")
	end,
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
	-- Download the pre-built preview server synchronously. The plugin's own
	-- `mkdp#util#install()` spawns an async terminal that detaches under lazy's
	-- build step and never finishes (leaves app/bin empty -> preview can't
	-- start). install.sh fetches the right prebuilt binary for the platform
	-- (macOS arm64/x86, Linux x86_64), so node isn't needed at runtime.
	build = "cd app && ./install.sh",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	keys = {
		{ "<leader>gx", render_file, {} },
		{ "<leader>fx", render_file, {} },
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle markdown preview" },
	},
}

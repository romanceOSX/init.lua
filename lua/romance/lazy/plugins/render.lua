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

-- Preferred source: the nixpkgs-built plugin (preview server pre-bundled with
-- vendored node_modules) that home-manager symlinks here (see dotfiles
-- home/programs.nix). Using it makes the preview reproducible with no build
-- step and no network at first launch; the server runs via `node app/index.js`
-- against those vendored modules, so nodejs is the only runtime requirement.
local nix_plugin_dir = vim.fn.stdpath("data") .. "/nix-plugins/markdown-preview.nvim"
local has_nix_plugin = vim.uv and vim.uv.fs_stat(nix_plugin_dir) ~= nil
	or vim.loop.fs_stat(nix_plugin_dir) ~= nil

-- install with yarn or npm
local spec = {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
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

if has_nix_plugin then
	-- Point lazy at the nix-vendored copy; no git clone, no build step.
	spec.dir = nix_plugin_dir
else
	-- Fallback when the home-manager symlink isn't present (e.g. the active
	-- generation predates it, or on a non-nix host): let lazy clone the plugin
	-- and fetch the prebuilt preview server synchronously. The plugin's own
	-- `mkdp#util#install()` spawns an async terminal that detaches under lazy's
	-- build step and never finishes (leaves app/bin empty -> preview can't
	-- start), so we run install.sh directly instead.
	spec.build = "cd app && ./install.sh"
end

return spec

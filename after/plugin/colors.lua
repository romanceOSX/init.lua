-- Function that messes with the background color 
function ColorMyPencils(color)
	color = color or "moonfly"
	vim.cmd.colorscheme(color)

--	vim.api.nvim_set_hl(0,"Normal", {bg = "none", blend=80 })
--	vim.api.nvim_set_hl(0,"NormalFloat", {bg = "none" , blend=80})
end

ColorMyPencils(catppuccin)

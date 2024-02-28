function colormypencils()
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return{ 
	"ellisonleao/gruvbox.nvim",
	name = "gruvbox",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			transparent_mode = true,
		})
		vim.cmd("colorscheme gruvbox")
		colormypencils()

	end
}


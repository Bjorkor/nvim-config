return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			ls.filetype_extend("python", {"base"})
			ls.filetype_extend("python", {"comprehension"})
			ls.filetype_extend("python", {"debug"})
			ls.filetype_extend("python", {"pydoc"})
			ls.filetype_extend("python", {"python"})
			ls.filetype_extend("python", {"unittest"})
			vim.keymap.set({"i"}, "<Tab>", function() ls.expand() end, {silent = true})
			vim.keymap.set({"i", "s"}, "<Tab>", function() ls.jump( 1) end, {silent = true})
			vim.keymap.set({"i", "s"}, "<S-Tab>", function() ls.jump(-1) end, {silent = true})

			vim.keymap.set({"i", "s"}, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, {silent = true})
		end,

	}
}
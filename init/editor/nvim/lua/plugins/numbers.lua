return {
	"nkakouros-original/numbers.nvim",
	config = function(_, opts)
		opts = {
			excluded_filetypes = {
				"tagbar",
				"gundo",
				"minibufexpl",
				"nerdtree",
				"TelescopePrompt",
			}
		}
		require "numbers".setup(opts)
	end,
}

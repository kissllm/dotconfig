return {
	'https://github.com/Yagua/nebulous.nvim',
	lazy = false,
	priority = 1000,
	cond = false,
	config = function()
		local colors = require("nebulous.functions").get_colors("midnight") -- < variant name
		-- if you want to get the colors of the current variant use the function without arguments
		--Put this lines inside your vimrc to set the colorscheme
		require("nebulous").setup {
			variant = "midnight",
			disable = {
				background = true,
				endOfBuffer = false,
				terminal_colors = false,
			},
			italic = {
				comments   = false,
				keywords   = true,
				functions  = false,
				variables  = true,
			},
			custom_colors = { -- this table can hold any group of colors with their respective values
				LineNr        = { fg = "#5BBBDA", bg = "NONE", style = "NONE" },
				CursorLineNr  = { fg = "#E1CD6C", bg = "NONE", style = "NONE" },

				-- it is possible to specify only the element to be changed
				TelescopePreviewBorder = { fg = "#A13413" },
				LspDiagnosticsDefaultError = { bg = "#E11313" },
				TSTagDelimiter = { style = "bold,italic" },
			},
		}
		vim.cmd("colorscheme nebulous")
		local setmap = vim.api.nvim_set_keymap
		local options = { silent = true, noremap = true }

		setmap("n", "<leader>tc", ":lua require('nebulous.functions').toggle_variant()<CR>", options)
		setmap("n", "<leader>rc", ":lua require('nebulous.functions').random_variant()<CR>", options)
		setmap("n", "<leader>tw", ":lua require('nebulous.functions').set_variant('variant_name')<CR>", options)
	end,
}


-- ~/.config/nvim/lua/plugins/lint.lua
return {
	{
		"mfussenegger/nvim-lint",
		cond  = true,
		event = "VeryLazy",
		lazy  = true,
		opts = {
			linters = {
				markdownlint = {
					-- args = { "--disable", "MD013", "--" },
					args = { "--disable", "marksman", "--" },
				},
			},
		},
		config =                    function()                                    end,
	},
}

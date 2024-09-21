return {
	-- 'zorgick/onehalf-lua',
	"gbprod/nord.nvim",
	-- disable = false,
	-- cond = false,
	cond = true,
	lazy = false,
	priority = 1000,
	dependencies = {
		'rktjmp/lush.nvim',
	},
	config = function()
		require("nord").setup({})
		vim.cmd.colorscheme("nord")
		vim.opt.background = 'dark'
		-- vim.api.nvim_command("colorscheme nord")
		-- vim.api.nvim_set_options("background", "dark")
	end,
	install = {
		colorscheme = { "nord" },
	},
}




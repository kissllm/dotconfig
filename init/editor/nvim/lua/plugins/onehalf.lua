return {
	-- 'zorgick/onehalf-lua',
	'CodeGradox/onehalf-lush',
	-- cond = false,
	-- disable = false,
	cond = true,
	lazy = false,
	priority = 1000,
	dependencies = {
		'rktjmp/lush.nvim',
	},
	config = function()
		-- require("onehalf-lush").load()
		-- vim.api.nvim_set_options("background", "light")
		-- vim.cmd("colorscheme onehalf-lush")
		-- E185: Cannot find color scheme 'onehalf-lush-dark'
		-- vim.cmd("colorscheme onehalf-lua")
		-- vim.cmd("colorscheme onehalf-lush-dark")
		vim.opt.background = 'dark'
		vim.api.nvim_command("colorscheme onehalf-lush-dark")
		-- $HOME/.config/nvim/lua/plugins/onehalf.lua:21: attempt to call field 'nvim_set_options' (a nil value)
		-- vim.api.nvim_set_options("background", "dark")
	end,
}



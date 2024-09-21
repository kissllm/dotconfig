return {
	"anuvyklack/help-vsplit.nvim",
	-- event  = "VeryLazy",
	event  = "BufWinEnter",
	lazy   = true,
	opts   = {
		-- always = false, -- Always open help in a vertical split.
		always = true,
		side = 'left', -- 'left' or 'right'
		-- buftype = { 'help' },
		buftype = { 'nofile', 'help' },
		-- filetype = { 'man' }
		filetype = { 'noice', 'man' }
	},
	config = function()
		require('help-vsplit').setup(opts)
	end
}

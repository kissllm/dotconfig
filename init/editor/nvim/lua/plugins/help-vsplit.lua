return {
	"anuvyklack/help-vsplit.nvim",
	-- event  = "VeryLazy",
	event     = "BufWinEnter",
	lazy      = true,
	cond      = false, -- conflicts with messages settings: invalid window id errors
	config    = function()
		opts   = {
			-- always = false, -- Always open help in a vertical split.
			always = true,
			side = 'left', -- 'left' or 'right' -- does not work, always right
			-- buftype = { 'help' },
			buftype = { 'nofile', 'help' },
			-- filetype = { 'man' }
			filetype = { 'noice', 'man' }
		}
		require('help-vsplit').setup(opts)
	end
}

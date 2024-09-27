
return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	-- Example mapping to toggle outline
	keys = {
		{ "<leader>tt", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	config = function()
		opts = {
			-- Your setup opts here
			symbols        = {
				filter = { 'String', 'Variable', exclude = true },
			},
			outline_window = {
				position   = 'left',
				auto_close = true,
			},
		}
		require('outline').setup(opts)
	end
}


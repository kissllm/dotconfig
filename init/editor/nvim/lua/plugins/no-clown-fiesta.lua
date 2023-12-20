return {
	-- https://github.com/aktersnurra/no-clown-fiesta.nvim.git
	'aktersnurra/no-clown-fiesta.nvim',
	lazy = false,
	priority = 1000,
	cond = false,
	config = function()
		vim.cmd("colorscheme no-clown-fiesta")
	end,
}

return {
	"kevinhwang91/nvim-fundo",
	dependencies = {
		'kevinhwang91/promise-async',
	},
	event   = "VeryLazy",
	lazy    = true,
	run     = function() require('fundo').install() end,
	config  = function()

		local path = require('fundo.fs.path')
		vim.o.undofile = true
		require('fundo').setup(
		{
    		archives_dir = vim.fn.stdpath('cache') .. path.sep .. 'fundo',
    		-- archives_dir = {
        	-- 	description = [[The directory to store the archives]],
        	-- 	default = vim.fn.stdpath('cache') .. path.sep .. 'fundo'
    		-- },
    		limit_archives_size = 512,
    		-- limit_archives_size = {
        	-- 	description = [[Limit the archives directory size, unit is MB(megabyte), elder files will be
        	-- 	removed based on their modified time]],
        	-- 	default = 512
    		-- },
		}
		)
	end,
}


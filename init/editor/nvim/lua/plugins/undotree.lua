
return {
	"mbbill/undotree",
    --  event  = "VeryLazy",
    event      = "VimEnter",
    lazy       = false,
    --  lazy   = true,
	config = function()
	vim.cmd[[
	if has("persistent_undo")
		let target_path = expand('~/.undodir')

		" create the directory and any parent directories
		" if the location does not exist.
		if !isdirectory(target_path)
			call mkdir(target_path, "p", 0700)
		endif

		let &undodir=target_path
		set undofile
	endif
	]]
		vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
	end
}

--  return {
--  	"jiaoshijie/undotree",
--  	event         = "VeryLazy",
--  	-- event      = "VimEnter",
--  	-- lazy       = false,
--  	lazy          = true,
--  	dependencies  = "nvim-lua/plenary.nvim",
--  	keys = { -- load the plugin only when using it's keybinding:
--  		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
--  	},
--  	config = function()
--  		local undotree = require('undotree')
--  		-- local log = require('log')
--  		-- local file = io.open(log.address, "w+a")
--  		-- local file = io.open(log.address, "a+")
--  		-- file:write("\n\n")
--  		-- file:write("\nundotree:\n" .. serialize(undotree) .. "\n")
--  		print("undotree serialize", serialize(undotree))
--  		-- file:write("\n\n")
--  		-- file:flush()
--  		-- file:close()
--  		print('undotree', vim.inspect(undotree))
--  		vim.print('undotree: ' .. serialize(undotree))
--  		undotree.setup({
--  			float_diff  = true,           -- using float window previews diff, set this `true` will disable layout option
--  			layout      = "left_bottom",  -- "left_bottom", "left_left_bottom"
--  			position    = "left",         -- "right", "bottom"
--  			ignore_filetype = { 'undotree', 'undotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel', 'tsplayground' },
--  			window = {
--  				winblend = 30,
--  			},
--  			keymaps = {
--  				['j']     = "move_next",
--  				['k']     = "move_prev",
--  				['gj']    = "move2parent",
--  				['J']     = "move_change_next",
--  				['K']     = "move_change_prev",
--  				['<cr>']  = "action_enter",
--  				['p']     = "enter_diffbuf",
--  				['q']     = "quit",
--  			},
--  		})
--  		vim.keymap.set('n', '<leader>u',  require('undotree').toggle, { noremap = true, silent = true })
--  		-- or
--  		vim.keymap.set('n', '<leader>uo', require('undotree').open,   { noremap = true, silent = true })
--  		vim.keymap.set('n', '<leader>uc', require('undotree').close,  { noremap = true, silent = true })
--  	end
--  }




return {
	"trailblazing/tmux.nvim",
	-- cond   = false,
	   cond   = true,
	   branch = 'main',
	   opts      = {
		   copy_sync = {
			-- enable = false, -- default
			-- enable = true,  -- will disable neovim "p"
			-- redirect_to_clipboard = false,
			-- redirect_to_clipboard = true,
			-- sync_registers = true,
			-- sync_registers = false,
			-- sync_unnamed = false,
			   -- enable = false,
			   enable          = true, -- default
			   sync_clipboard  = true, -- default
			   sync_registers  = true, -- default
			   -- sync_deletes    = false,
			   -- No difference
			      redirect_to_clipboard = false, -- default
			   -- redirect_to_clipboard = true,
		   },
		   navigation = {
			   -- enable_default_keybindings = true,
			   enable_default_keybindings = false,
		   },
	   },
	-- event  = "VeryLazy",
	   event  = "TextYankPost",
	   lazy   = true,
	-- lazy   = false,
	config = function()

		return require("tmux").setup(opts)
		-- require("tmux.log").setup()
		-- return require("tmux.copy").setup()
	end,


}

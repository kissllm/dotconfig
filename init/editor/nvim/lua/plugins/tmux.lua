

-- For development
-- find ~/.local/share/nvim/lazy/tmux.nvim/ -type f -name "*.lua" -exec grep -Hn "\-- print" {} +
-- fin "\-- print" ~/.local/share/nvim/lazy/tmux.nvim/ -- [fin is not a typo :)](https://github.com/trailblazing/dotconfig/blob/master/local/bin/fin)

return {
	"trailblazing/tmux.nvim",
	-- cond   = false, -- test
	   cond   = true,
	   branch = 'main',
	-- event  = "VeryLazy",
	   event  = { "TextYankPost", 'VimEnter', 'VimResume', 'FocusGained', 'BufEnter', },
	   lazy   = true,
	-- lazy   = false,
	-- Lazy will process the following "opts" table when no config function was defined
	-- "opts" is a hard coded index name -- lazy/core/loader.lua
	opts = {
		copy_sync = {
			-- enable                 = false, -- default
			-- enable                 = true,  -- will redefine the neovim "p"
			-- redirect_to_clipboard  = false,
			-- redirect_to_clipboard  = true,
			-- sync_registers         = true,
			-- sync_registers         = false,
			-- sync_unnamed           = false,
			enable                    = true, -- default
			sync_clipboard            = true, -- default
			sync_registers            = true, -- default
			-- sync_deletes           = false,
			-- No difference
			redirect_to_clipboard = false, -- default
			-- redirect_to_clipboard = true,
		},
		navigation = {
			enable_default_keybindings = true,
			-- enable_default_keybindings = false,
			cycle_navigation = true,
		},
		resize = {
			enable_default_keybindings = true, -- default
			-- enable_default_keybindings = false,
		},
	},
	-- Lazy won't process this "logging" table and you could not reference it from here
	logging = {
		file    = "disabled",
		notify  = "disabled",
	},
	-- Empty "config" function body will not work
	-- Lazy will not process the upward "opts" if the "config" function was defined
	-- whatever setup() was triggered with or without parameters
	-- Either use the "config" and use it till the end or don't use it at all get no "logging" settings
	config = function()
		opts      = {
		    copy_sync = {
		        -- enable = false, -- default
		        -- enable = true,  -- will redefine the neovim "p"
		        -- redirect_to_clipboard = false,
		        -- redirect_to_clipboard = true,
		        -- sync_registers = true,
		        -- sync_registers = false,
		        -- sync_unnamed = false,
		        enable          = true, -- default
		        sync_clipboard  = true, -- default
		        sync_registers  = true, -- default
		        -- sync_deletes    = false,
		        -- No difference
		        redirect_to_clipboard = false, -- default
		        -- redirect_to_clipboard = true,
		    },
		    navigation = {
		        enable_default_keybindings = true,
		        -- enable_default_keybindings = false,
		        cycle_navigation = true,
		    },
		    resize = {
		        enable_default_keybindings = true, -- default
		        -- enable_default_keybindings = false,
		    },
		}
		logging = {
		    file    = "disabled",
		    notify  = "disabled",
		}

		require("tmux").setup(opts, logging)
		-- require("tmux").setup() -- get the default options (options defined in tmux/init.lua)
		vim.cmd
		[[
		if ! exists('#tmux_is_vim_vimenter#VimEnter')
			let keys_load_path = stdpath("data") . '/lazy/keys/after/plugin/keys.vim'
			exe 'set runtimepath+='.  keys_load_path
			exe 'set packpath+='.     keys_load_path
			execute "source "   .     keys_load_path
			execute "runtime! " .     keys_load_path
		else
			augroup tmux_is_vim | au! | augroup END
		endif
		]]
	end,


}

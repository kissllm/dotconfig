-- Merged into copy-mode
-- vim.keymap.set("n", "<Esc>", function()
--  require("notify").dismiss()
-- end, { desc = "dismiss notify popup and clear hlsearch" })

return {
	"rcarriga/nvim-notify",
	--  lazy    = false,
	lazy    = true,
	--  enable  = false,
	--  cond    = false, --  trying to disable lsp warnings
	config  = function()
		opts    = {
			-- https://www.reddit.com/r/neovim/comments/rbt47s/placing_notification_popup_at_bottom_right_corner/
			-- https://github.com/ldelossa/litee.nvim/blob/7a6d69477b0c10789ffde701eedac476fbb36650/lua/calltree/ui/notify.lua#L49
			-- anchor   = "SE",
			-- https://www.reddit.com/r/neovim/comments/1e294bv/noicenotify_position_of_popup/
			-- https://github.com/rcarriga/nvim-notify/issues/233
			top_down   = false, --  anchor = 'SE'
			timeout    = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.60)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { focusable = false })
			end,
			--  render = "default",
			render = "minimal",
			stages = "fade_in_slide_out",
			-- render = "compact",
			-- stages = "fade",
            background_colour = "#000000",
		}
		require('notify').setup(opts)
	end
}


return {
	"trailblazing/noice.nvim",
	event = "VeryLazy",
	-- cond = false,
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	-- module = "nui",
	module = "noice",
	config = function()
		require("notify").setup({
			background_colour = "#000000",
		})
		-- local Input = require("nui.input")
		-- local event = require("nui.utils.autocmd").event

		-- local input = Input({
		--  position = "50%",
		--  size = {
		--      width = 20,
		--  },
		--  border = {
		--      style = "single",
		--      text = {
		--          top = "[Howdy?]",
		--          top_align = "center",
		--      },
		--  },
		--  win_options = {
		--      winhighlight = "Normal:Normal,FloatBorder:Normal",
		--  },
		-- }, {
		--  prompt = "> ",
		--  default_value = "Hello",
		--  on_close = function()
		--      print("Input Closed!")
		--  end,
		--  on_submit = function(value)
		--      print("Input Submitted: " .. value)
		--  end,
		-- })

		-- local input = Input({
		--      -- module   = "nui",
		--      -- backend  = "nui", -- backend to use to show regular cmdline completions
		--      relative = "cursor",
		--      position = {
		--          row = 10,
		--          -- row = "90%",
		--          col = 10,
		--          -- col = "80%",
		--      },
		--      -- size = {
		--      --  -- width = 60,
		--      --  -- height = "auto",
		--      --  min_width = 60,
		--      --  -- width     = "auto",
		--      --  -- height    = "auto",
		--      -- },
		--      -- position = "50%",
		--      size = { width = 20, },
		--      border = {
		--          style = "single",
		--          text = {
		--              top       = "[Howdy?]",
		--              top_align = "center",
		--          },
		--      },
		--      win_options = {
		--          winhighlight = "Normal:Normal,FloatBorder:Normal",
		--      },
		--  },
		--  {
		--      prompt = "> ",
		--      default_value = "Hello",
		--      on_close = function()
		--          print("Input Closed!")
		--      end,
		--      on_submit = function(value)
		--          print("Input Submitted: " .. value)
		--      end,
		--  })

		require("telescope").load_extension("noice")
		require("telescope").load_extension("notify")
		require("noice").setup({
			-- Trying to resolve nui.nvim invalid window id errors
			module = "noice",
			-- you can enable a preset for easier configuration
			presets = {
				-- you can enable a preset by setting it to true, or a table that will override the preset config
				-- you can also add custom presets that you can enable/disable with enabled=true
				-- bottom_search = false, -- use a classic bottom cmdline for search
				bottom_search            = true, -- use a classic bottom cmdline for search
				-- command_palette       = false, -- position the cmdline and popupmenu together
				command_palette          = true, -- position the cmdline and popupmenu together
				-- long_message_to_split = false, -- long messages will be sent to a split
				long_message_to_split    = true, -- long messages will be sent to a split
				inc_rename               = false, -- enables an input dialog for inc-rename.nvim
				-- inc_rename            = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border           = false, -- add a border to hover docs and signature help
				-- cmdline_output_to_split  = false,
			},
			cmdline = {
				-- conceal = false,
				-- enables the Noice cmdline UI
				-- enabled = false,
				enabled = true, -- enables the Noice cmdline UI
				-- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
				view = "cmdline_popup",
				-- view = "cmdline_popupmenu",
				-- view = "popup",
				-- view = "popupmenu",
				-- view = nil, -- when nil, use defaults from documentation
				-- view = "input",
				-- view = "cmdline",
				-- global options for the cmdline. See section on views
				opts = {
					-- win_options = {
					--  winblend      = 0,
					--  -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					--  concealcursor = "n", conceallevel = 3,
					-- },
				},
				---@type table<string, CmdlineFormat>
				format = {
					-- conceal = false,
					-- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
					-- view: (default is cmdline view)
					-- opts: any options passed to the view
					-- icon_hl_group: optional hl_group for the icon
					-- title: set to anything or empty string to hide
					-- cmdline     = { pattern = "^:", icon = "", lang = "vim" },
					cmdline     = { pattern = "^:", icon = ">", lang = "vim" },
					-- search_down = { view = "cmdline", kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_down = { view = "cmdline", kind = "search", pattern = "^/",  icon = "// ", lang = "regex" },
					-- search_up   = { view = "cmdline", kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					search_up   = { view = "cmdline", kind = "search", pattern = "^%?", icon = "\\ ", lang = "regex" },
					-- filter      = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					filter      = { pattern = "^:%s*!", icon = "$", lang = "sh" },
					-- lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "^", lang = "lua" },
					-- help        = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					help        = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
					-- input       = { view = "input", }, -- Used by input()
					input       = {}, -- Used by input()
					-- input       = { view = "cmdline", }, -- Used by input()
					-- lua = false, -- to disable a format, set to `false`
				},
				-- backend = input,
				backend = "nui",
				-- backend = "popup",
			},
			messages = {
				-- NOTE: If you enable messages, then the cmdline is enabled automatically.
				-- This is a current Neovim limitation.
				enabled      = true, -- enables the Noice messages UI
				-- enabled      = false, -- enables the Noice messages UI
				view         = "notify",       -- default view for messages
				view_error   = "notify",       -- view for errors
				view_warn    = "notify",       -- view for warnings
				view_history = "messages",     -- view for :messages
				view_search  = "virtualtext",  -- view for search count messages. Set to `false` to disable
				-- anchor = "SE",
			},
			popupmenu = {
				enabled    = true, -- enables the Noice popupmenu UI
				---@type 'nui'|'cmp'
				backend    = "nui", -- backend to use to show regular cmdline completions
				-- Won't auto complement -- might because I disabled it in cmdline
				-- backend    = "cmp", -- backend to use to show regular cmdline completions
				---@type NoicePopupmenuItemKind|false
				-- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
				kind_icons = {}, -- set to `false` to disable icons
			},
			-- default options for require('noice').redirect
			-- see the section on Command Redirection
			---@type NoiceRouteConfig
			redirect = {
				view   = "popup",
				filter = { event = "msg_show" },
			},
			-- You can add any custom commands below that will be available with `:Noice command`
			---@type table<string, NoiceCommand>
			commands = {
				history = {
					-- options for the message history that you get with `:Noice`
					view   = "split",
					opts   = { enter = true, format = "details" },
					filter = {
						any = {
							{ event   = "notify" },
							{ error   = true },
							{ warning = true },
							{ event   = "msg_show", kind = { "" } },
							{ event   = "lsp", kind = "message" },
						},
					},
				},
				-- :Noice last
				last = {
					-- relative = "cursor",
					view     = "popup",
					-- view     = "notify",
					-- view  = "split",
					opts     = { enter = true, format = "details" },
					filter   = {
						any = {
							{ event   = "notify" },
							{ error   = true },
							{ warning = true },
							{ event   = "msg_show", kind = { "" } },
							{ event   = "lsp", kind = "message" },
						},
					},
					filter_opts = { count = 1 },
				},
				-- :Noice errors
				errors = {
					-- options for the message history that you get with `:Noice`
					view        = "popup",
					opts        = { enter = true, format = "details" },
					filter      = { error = true },
					filter_opts = { reverse = true },
				},
			},
			notify = {
				-- Noice can be used as `vim.notify` so you can route any notification like other messages
				-- Notification messages have their level and other properties set.
				-- event is always "notify" and kind can be any log level as a string
				-- The default routes will forward notifications to nvim-notify
				-- Benefit of using Noice for this is the routing and consistent history view
				-- anchor = "SE",
				enabled = true,
				view    = "notify",
			},
			lsp = {
				progress = {
					enabled     = true,
					-- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
					-- See the section on formatting for more details on how to customize.
					--- @type NoiceFormat|string
					format      = "lsp_progress",
					--- @type NoiceFormat|string
					format_done = "lsp_progress_done",
					throttle    = 1000 / 30, -- frequency to update lsp progress message
					view        = "mini",
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					-- override the default lsp markdown formatter with Noice
					-- ["vim.lsp.util.convert_input_to_markdown_lines"]    = true,
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					-- override the lsp markdown formatter with Noice
					-- ["vim.lsp.util.stylize_markdown"]                   = true,
					["vim.lsp.util.stylize_markdown"]                = false,
					-- override cmp documentation with Noice (needs the other options to work)
					-- ["cmp.entry.get_documentation"]                     = true,
					["cmp.entry.get_documentation"]                  = false,
				},
				hover = {
					enabled = true,
					silent  = false, -- set to true to not show a message if hover is not available
					view    = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts    = {
						-- anchor = "SE",
					}, -- merged with defaults from documentation
				},
				signature = {
					-- enabled = true,
					enabled = false,
					auto_open = {
						enabled  = true,
						trigger  = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip  = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
				message = {
					-- Messages shown by lsp servers
					enabled = true,
					view    = "notify",
					opts    = {
						-- anchor = "SE",
					},
				},
				-- defaults for hover and signature help
				documentation = {
					view = "hover",
					---@type NoiceViewOptions
					opts = {
						lang        = "markdown",
						replace     = true,
						render      = "plain",
						format      = { "{message}" },
						win_options = { concealcursor = "n", conceallevel = 3 },
					},
				},
			},
			markdown = {
				hover = {
					["|(%S-)|"] = vim.cmd.help, -- vim help links
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
				highlights = {
					["|%S-|"]             = "@text.reference",
					["@%S+"]              = "@parameter",
					["^%s*(Parameters:)"] = "@text.title",
					["^%s*(Return:)"]     = "@text.title",
					["^%s*(See also:)"]   = "@text.title",
					["{%S-}"]             = "@parameter",
				},
			},
			health = {
				checker = true, -- Disable if you don't want health checks to run
			},
			smart_move = {
				-- noice tries to move out of the way of existing floating windows.
				enabled = true, -- you can disable this behaviour here
				-- enabled = false, -- you can disable this behaviour here
				-- add any filetypes here, that shouldn't trigger smart move.
				excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
			},
			---@type NoicePresets
			throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
			---@type NoiceConfigViews
			---@see section on views
			views = {
				-- input = input,
				cmdline = {
					backend   = "popup",
					relative = "cursor",
					-- relative = "editor",
					position = {
						row = 0,
						col = 0,
					},
					size = {
						-- min_width = 60,
						-- width     = "auto",
						width     = "100",
						height    = "auto",
					},
					-- enter     = true,
					focusable = true,
					zindex    = 50,
					border = nil,
					-- border = {
					--  enabled = false,
					--  padding = {
					--      top    = 0,
					--      bottom = 0,
					--      left   = 0,
					--      right  = 0,
					--  },
					--  style = "rounded",
					--  -- text = {
					--  --  top          = " command output ",
					--  --  top_align    = "center",
					--  --  bottom       = "",
					--  --  bottom_align = "left",
					--  -- },
					-- },
					buf_options = {
						modifiable    = true,
						-- modifiable = false,
						readonly      = false,
						-- readonly   = true,
					},
					win_options = {
						winblend     = 10,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						foldenable   = true,
						cursorline   = false,
						cursorcolumn = false,
					},
				},
				popup = {
					-- relative = "cursor",
					-- relative = "win",
					anchor = "SE",
					relative = "editor",
					position = {
						row = 10,
						col = 10,
					},
					size = {
						min_width = 100,
						width     = "auto",
						height    = "auto",
					},
					-- enter     = true,
					focusable = true,
					zindex    = 50,
					border = nil,
					-- border = {
					--  enabled = false,
					--  padding = {
					--      top    = 0,
					--      bottom = 0,
					--      left   = 0,
					--      right  = 0,
					--  },
					--  style = "rounded",
					--  -- text = {
					--  --  top          = " command output ",
					--  --  top_align    = "center",
					--  --  bottom       = "",
					--  --  bottom_align = "left",
					--  -- },
					-- },

					buf_options = nil,
					buf_options = {
						modifiable    = true,
						-- modifiable = false,
						readonly      = false,
						-- readonly   = true,
					},
					win_options = {
						winblend     = 10,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						foldenable   = true,
						cursorline   = false,
						cursorcolumn = false,
					},
					-- close = {
					--  keys = { "<esc>" },
					-- },
				},
				popupmenu = {
					backend   = "popup",
					-- -- relative = "editor",
					-- position = {
					--  row = 8,
					--  -- col = "80%",
					--  col = 8,
					-- },
					-- size = {
					--  -- width     = 60,
					--  -- height    = 10,
					--  min_width = 60,
					--  width     = "auto",
					--  height    = "auto",
					-- },
					-- border = {
					--  style   = "rounded",
					--  padding = { 0, 1 },
					-- },
					-- win_options = {
					--  winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					-- },
					relative = "cursor",
					-- relative = "editor",
					position = {
						row = 0,
						col = 0,
					},
					size = {
						-- min_width = 60,
						-- width     = "auto",
						width     = "60",
						height    = "auto",
					},
					-- enter     = true,
					focusable = true,
					zindex    = 50,
					border = nil,
					-- border = {
					--  enabled = false,
					--  padding = {
					--      top    = 0,
					--      bottom = 0,
					--      left   = 0,
					--      right  = 0,
					--  },
					--  style = "rounded",
					--  -- text = {
					--  --  top          = " command output ",
					--  --  top_align    = "center",
					--  --  bottom       = "",
					--  --  bottom_align = "left",
					--  -- },
					-- },
					buf_options = {
						modifiable    = true,
						-- modifiable = false,
						readonly      = false,
						-- readonly   = true,
					},
					win_options = {
						winblend     = 10,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						foldenable   = true,
						cursorline   = false,
						cursorcolumn = false,
					},
				},
				cmdline_output = {
					-- Fatal
					-- backend   = "popup",

					format  = "details",
					-- view = "popup",
					-- view    = "popupmenu",
					view    = "notify",

					-- view = "input",
					win_options = {
						-- winblend     = 0,
						winblend     = 10,
						-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						foldenable   = true,
						cursorline   = false,
						cursorcolumn = false,
						winbar = "",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						-- foldenable = false,
						-- winhighlight = {
						--  Normal      = "NoiceCmdlinePopup",
						--  FloatTitle  = "NoiceCmdlinePopupTitle",
						--  FloatBorder = "NoiceCmdlinePopupBorder",
						--  IncSearch   = "",
						--  CurSearch   = "",
						--  Search      = "",
						--  -- Cursor      = "NoiceHiddenCursor",
						--  -- lazy/noice.nvim/lua/noice/config/highlights.lua
						--  -- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { blend = 100, nocombine = true })
						--  -- System cursor,please -- otherwise won't show
						--  Cursor      = "Cursor",
						--  -- Cursor      = "",
						-- },
					},
				},
				-- Command itself
				cmdline_popup = {
					backend   = "popup",
					--
					-- -- view = "input",
					relative = "cursor",
					position = {
					 row = 10,
					 -- row = "90%",
					 col = 10,
					 -- col = "80%",
					},
					-- size = {
					--  -- width = 60,
					--  -- height = "auto",
					--  min_width = 60,
					--  width     = "auto",
					--  height    = "auto",
					-- },
					-- backend   = "popup",
					-- -- backend   = "input",
					-- focusable = true,
					-- -- Command line will lost the cursor
					-- -- enter  = true,
					-- enter     = false,
					-- zindex    = 200,
					-- border = {
					--  style   = "rounded",
					--  padding = { 0, 1 },
					-- },
					-- win_options = {
					--  winblend      = 0,
					--  -- pumblend      = 10,
					--  -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					--  concealcursor = "i", conceallevel = 0,
					--  winhighlight = {
					--      Normal      = "NoiceCmdlinePopup",
					--      FloatTitle  = "NoiceCmdlinePopupTitle",
					--      FloatBorder = "NoiceCmdlinePopupBorder",
					--      IncSearch   = "",
					--      CurSearch   = "",
					--      Search      = "",
					--      Cursor      = "NoiceHiddenCursor",
					--  },
					--  winbar = "",
					--  foldenable = false,
					--  -- foldenable = true,
					--  -- cursorline = false,
					--  cursorline = true,
					--  cursorcolumn = true,
					-- },

					-- relative = "editor",
					-- position = {
					--  -- row = 10,
					--  row = "20%",
					--  col = 10,
					-- },
					size = {
						min_width = 100,
						width     = "auto",
						height    = "auto",
					},
					-- Fatal. Make cmdline dysfunctional
					-- enter     = true,
					focusable = true,
					zindex    = 200,
					border = nil,
					-- border = {
					--  enabled = false,
					--  padding = {
					--      top    = 0,
					--      bottom = 0,
					--      left   = 0,
					--      right  = 0,
					--  },
					--  style = "rounded",
					--  -- text = {
					--  --  top          = " command output ",
					--  --  top_align    = "center",
					--  --  bottom       = "",
					--  --  bottom_align = "left",
					--  -- },
					-- },
					buf_options = {
						modifiable    = true,
						-- modifiable = false,
						readonly      = false,
						-- readonly   = true,
					},
					win_options = {
						winbar = "",
						winblend     = 0,
						-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						-- foldenable   = true,
						foldenable = false,
						winhighlight = {
							Normal      = "NoiceCmdlinePopup",
							FloatTitle  = "NoiceCmdlinePopupTitle",
							FloatBorder = "NoiceCmdlinePopupBorder",
							IncSearch   = "",
							CurSearch   = "",
							Search      = "",
							-- Cursor      = "NoiceHiddenCursor",
							-- lazy/noice.nvim/lua/noice/config/highlights.lua
							-- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { blend = 100, nocombine = true })
							-- System cursor,please -- otherwise won't show
							Cursor      = "Cursor",
							-- Cursor      = "",
						},
						-- cursorline   = true,
						cursorline   = false,
						-- cursorcolumn = true,
						cursorcolumn = false,
					},
				},
				cmdline_popupmenu = {
					backend   = "popup",
					-- relative = "editor",
					relative = "cursor",
					position = {
						row = 0,
						col = 0,
					},
					size = {
						min_width = 60,
						width     = "auto",
						height    = "auto",
					},
					-- enter     = true,
					-- focusable = true,
					zindex    = 50,
					border = nil,
					-- border = {
					--  enabled = false,
					--  padding = {
					--      top    = 0,
					--      bottom = 0,
					--      left   = 0,
					--      right  = 0,
					--  },
					--  style = "rounded",
					--  -- style = "single",
					--  -- text = {
					--  --  top          = " command output ",
					--  --  top_align    = "center",
					--  --  bottom       = "",
					--  --  bottom_align = "left",
					--  -- },
					-- },
					buf_options = {
						modifiable    = true,
						-- modifiable = false,
						readonly      = false,
						-- readonly   = true,
					},
					win_options = {
						winbar = "",
						winblend     = 5,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						-- foldenable   = true,
						foldenable   = false,
						cursorline   = false,
						cursorcolumn = false,
					},

					smart_move = {
						-- noice tries to move out of the way of existing floating windows.
						-- enabled = true, -- you can disable this behaviour here
						enabled = false, -- you can disable this behaviour here
						-- add any filetypes here, that shouldn't trigger smart move.
						excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
					},
				},
				notify = {
					backend  = "notify",
					anchor   = "SE",
					relative = "editor",
					win_options = {
						winblend     = 10,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						foldenable   = true,
						cursorline   = false,
						cursorcolumn = false,
						winbar = "",
						-- Fatal
						-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						-- foldenable = false,
						-- winhighlight = {
						--  Normal      = "NoiceCmdlinePopup",
						--  FloatTitle  = "NoiceCmdlinePopupTitle",
						--  FloatBorder = "NoiceCmdlinePopupBorder",
						--  IncSearch   = "",
						--  CurSearch   = "",
						--  Search      = "",
						--  -- Cursor      = "NoiceHiddenCursor",
						--  -- lazy/noice.nvim/lua/noice/config/highlights.lua
						--  -- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { blend = 100, nocombine = true })
						--  -- System cursor,please -- otherwise won't show
						--  Cursor      = "Cursor",
						--  -- Cursor      = "",
						-- },
					},
				},
			},
			---@type NoiceRouteConfig[]
			routes = {
				{
					view   = "notify",
					filter = { event = "msg_showmode" },
				},
				{
					filter = {
						event = "msg_show",
						kind  = "",
						find  = "written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind  = "search_count",
					},
					opts = { skip = true },
				},
			}, --- @see section on routes
			---@type table<string, NoiceFilter>
			status = {}, --- @see section on statusline components
			---@type NoiceFormatOptions
			format = {}, --- @see section on formatting
		})

		-- :Noice last
		vim.keymap.set("n", "<leader>h", function()
			require("noice").cmd("last")
		end)
		-- :Noice history
		vim.keymap.set("n", "<leader>hh", function()
			require("noice").cmd("history")
		end)

		-- lua/noice/util/hacks.lua:256:      vim.go.guicursor = "a:NoiceHiddenCursor"
		-- lua/noice/config/highlights.lua
		-- The following definition does not work
		-- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { blend = 100, nocombine = true })
		-- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { fg = '#ffffff', bg = 'NONE', blend = 0, nocombine = true, reverse = true })
		vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { fg = 'Brown', bg = 'DarkGray', blend = 0, nocombine = true, reverse = true })
		-- vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { fg = 'Brown', bg = 'DarkGray', blend = 0, nocombine = true })

	end,
}








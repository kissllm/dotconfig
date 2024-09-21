-- Bug: generating single quoted file duplication under the same folder of the original file
-- Bug: can not disable tree displaying by default
return {
	"nvim-neo-tree/neo-tree.nvim",
	event  = "VeryLazy",
	lazy   = true,
	-- Can not refresh automatically when switching files
	   cond   = false,
	-- cond   = true,
	branch = "v3.x",
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		{
			's1n7ax/nvim-window-picker',
			version = '2.*',
			config = function()
				require 'window-picker'.setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { 'neo-tree', "neo-tree-popup", "notify" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { 'terminal', "quickfix" },
						},
					},
				})
			end,
		},
	},
	-- https://github.com/LazyVim/LazyVim/blob/3dbace941ee935c89c73fd774267043d12f57fe2/lua/lazyvim/plugins/editor.lua
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			group  = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc   = "Start Neo-tree with directory",
			once   = true,
			callback = function()
				-- return false
				if package.loaded["neo-tree"] then
					-- return
					return false
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/7a6b0d43d70636edfec183fb49c02f725765da73/lua/neo-tree/defaults.lua#L100
						-- require("neo-tree").close_all()
						-- require("neo-tree.command").execute({ action = "close" })
						-- return false
						-- require("neo-tree")
						   vim.cmd([[Neotree close]])
					end
				end
			end,
		})
	end,
	config = function ()
		-- If you want icons for diagnostic errors, you'll need to define them somewhere:
		vim.fn.sign_define("DiagnosticSignError",
			-- {text = " ", texthl = "DiagnosticSignError"})
			{text = "x ", texthl = "DiagnosticSignError"})
		vim.fn.sign_define("DiagnosticSignWarn",
			-- {text = " ", texthl = "DiagnosticSignWarn"})
			{text = "! ", texthl = "DiagnosticSignWarn"})
		vim.fn.sign_define("DiagnosticSignInfo",
			-- {text = " ", texthl = "DiagnosticSignInfo"})
			{text = "* ", texthl = "DiagnosticSignInfo"})
		vim.fn.sign_define("DiagnosticSignHint",
			-- {text = "󰌵", texthl = "DiagnosticSignHint"})
			{text = "#", texthl = "DiagnosticSignHint"})

		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local neotree = require("neo-tree")
		local do_setcd = function(state)
			local p = state.tree:get_node().path
			print(p) -- show in command line
			vim.cmd(string.format('exec(":lcd %s")', p))
		end

		neotree.setup({
			hide_root_node             = true,
			retain_hidden_root_indent  = false,
			close_if_last_window       = false, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style         = "rounded",
			enable_modified_markers    = false,
			use_popups_for_input       = false, -- not floats for input
			-- A list of functions, each representing a global custom command
			-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
			-- see `:h neo-tree-custom-commands-global`
			-- commands = {},
			-- [Why do people like nvim-tree so much? The way you use it feels like an antipattern in vim]
			-- https://www.reddit.com/r/neovim/comments/16siats/show_my_neotree_config_allow_you_to_telescope/
			-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
			commands = {
				setcd = function(state)
					do_setcd(state)
				end,
				find_files = function(state)
					do_setcd(state)
					require('telescope.builtin').find_files()
				end,
				grep = function(state)
					do_setcd(state)
					require('telescope.builtin').live_grep()
				end,
			},
			-- enable_git_status = false,
			enable_git_status   = true,
			enable_diagnostics  = true,
			-- Neotree migrations
			-- enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
			open_files_do_not_replace_types  = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
			sort_case_insensitive            = false, -- used when sorting files and directories in the tree
			sort_function                    = nil , -- use a custom function for sorting files and directories in the tree
			use_libuv_file_watcher           = true,
			-- sort_function                 = function (a,b)
			--       if a.type               =                                                                                                                   = b.type then
			--           return a.path > b.path
			--       else
			--           return a.type > b.type
			--       end
			--   end , -- this sorts files and directories descendantly
			default_component_configs = {
				container = {
					enable_character_fade = true
				},
				indent = {
					indent_size                                   = 2,
					padding                                       = 1, -- extra padding on left hand side
					-- indent guides
					with_markers                                  = true,
					indent_marker                                 = "│",
					last_indent_marker                            = "└",
					highlight                                     = "NeoTreeIndentMarker",
					-- expander config, needed for nesting files
					with_expanders                                = nil, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed                            = "x", -- "",
					expander_expanded                             = "o", -- "",
					expander_highlight                            = "NeoTreeExpander",
				},
				icon = {
					folder_closed  = "x",
					folder_open    = "o",
					folder_empty   = "-",
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
					default = "*",
					highlight = "NeoTreeFileIcon"
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					-- use_git_status_colors = true,
					-- https://www.reddit.com/r/neovim/comments/13mbk7t/neotree_colorschemes/
					use_git_status_colors = false,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
						-- deleted   = "✖",-- this can only be used in the git_status source
						deleted   = "x",-- this can only be used in the git_status source
						-- renamed   = "󰁕",-- this can only be used in the git_status source
						renamed   = "r",-- this can only be used in the git_status source
						-- Status type
						untracked = "",
						-- ignored   = "",
						ignored   = "*",
						-- unstaged  = "󰄱",
						unstaged  = "~",
						staged    = "",
						-- conflict  = "",
						conflict  = "!",
					}
				},
				-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
				file_size = {
					enabled = true,
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					required_width = 122, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					required_width = 88, -- min width of window required to show this column
				},
				created = {
					enabled = true,
					required_width = 110, -- min width of window required to show this column
				},
				symlink_target = {
					enabled = false,
				},
			},
			window = {
				position = "left",
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel", -- close preview or floating neo-tree window
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					-- Read `# Preview Mode` for more information
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					-- ["S"] = "split_with_window_picker",
					-- ["s"] = "vsplit_with_window_picker",
					["t"] = "open_tabnew",
					-- ["<cr>"] = "open_drop",
					-- ["t"] = "open_tab_drop",
					["w"] = "open_with_window_picker",
					--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
					["C"] = "close_node",
					-- ['C'] = 'close_all_subnodes',
					["z"] = "close_all_nodes",
					--["Z"] = "expand_all_nodes",
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
					["d"] = "delete",
					-- ["<c-d>"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					-- ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
					["m"] = {
						"move",
						config = {
							show_path = 'relative'
						}
					},
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
					["f"] = "find_files",
					["g"] = "grep",
					["a"] = {
						"add",
						-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
						-- some commands may take optional config options, see `:h neo-tree-mappings` for details
						config = {
							-- show_path = "none" -- "none", "relative", "absolute"
							show_path = 'relative' -- "none", "relative", "absolute"
						}
					},
					["<C-c>"] = "setcd",
					-- ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
					["c"] = {
						"copy",
						config = {
							show_path = 'relative' -- "none", "relative", "absolute"
						}
					},
				}
			},
			nesting_rules = {},
			-- default_component_configs = { -- makes event_handlers doesn't work
			filesystem = {
				filtered_items = {
					-- show_hidden_count = false,
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						--"node_modules"
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json",
					},
					always_show = { -- remains visible even if other settings would normally hide it
						--".gitignored",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						--".DS_Store",
						--"thumbs.db"
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},
				components = {
					-- hide file icon
					icon = function(config, node, state)
						if node.type == 'file' then
							return {
								text = "",
								highlight = config.highlight,
							}
						end
						return require('neo-tree.sources.common.components').icon(config, node, state)
					end,
				}, -- components
				follow_current_file = {
					autochdir = true,
					-- enabled = false, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					enabled = true,
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					-- leave_dirs_open = true,
				},
				group_empty_dirs = false, -- when true, empty folders will be grouped together
				hijack_netrw_behavior = "open_default",
				-- "open_default",  -- netrw disabled, opening a directory opens neo-tree -- in whatever position is specified in window.position
				-- "open_current",  -- netrw disabled, opening a directory opens within the -- window like netrw would, regardless of window.position
				-- "disabled",      -- netrw left alone, neo-tree does not handle opening dirs
				-- use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes instead of relying on nvim autocmd events.
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						["<bs>"]  = "navigate_up",
						["."]     = "set_root",
						["H"]     = "toggle_hidden",
						["/"]     = "fuzzy_finder",
						["D"]     = "fuzzy_finder_directory",
						["#"]     = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
						-- ["D"]  = "fuzzy_sorter_directory",
						["f"]     = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["[g"]    = "prev_git_modified",
						["]g"]    = "next_git_modified",
						["o"]     = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
						["oc"]    = { "order_by_created", nowait = false },
						["od"]    = { "order_by_diagnostics", nowait = false },
						["og"]    = { "order_by_git_status", nowait = false },
						["om"]    = { "order_by_modified", nowait = false },
						["on"]    = { "order_by_name", nowait = false },
						["os"]    = { "order_by_size", nowait = false },
						["ot"]    = { "order_by_type", nowait = false },
					},
					fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
						["<down>"] = "move_cursor_down",
						["<C-n>"]  = "move_cursor_down",
						["<up>"]   = "move_cursor_up",
						["<C-p>"]  = "move_cursor_up",
					},
				},

				commands = {}, -- Add a custom command or override a global one using the same function name

				bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
				cwd_target = {
					sidebar = "tab",   -- sidebar is when position = left or right
					current = "window" -- current is when position = current
				},
			},
			buffers = {
				follow_current_file = {
					autochdir  = true,
					enabled    = true, -- This will find and focus the file in the active buffer every time
					--                 -- the current file is changed while the tree is open.
					-- enabled = false,
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					-- leave_dirs_open = true,
				},
				-- group_empty_dirs = true, -- when true, empty folders will be grouped together
				group_empty_dirs  = false,
				show_unloaded     = true,
				window = {
					mappings = {
						["bd"]   = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."]    = "set_root",
						["o"]    = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
						["oc"]   = { "order_by_created", nowait = false },
						["od"]   = { "order_by_diagnostics", nowait = false },
						["om"]   = { "order_by_modified", nowait = false },
						["on"]   = { "order_by_name", nowait = false },
						["os"]   = { "order_by_size", nowait = false },
						["ot"]   = { "order_by_type", nowait = false },
					}
				},
			},
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"]  = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
						["o"]  = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					}
				}
			},
			event_handlers = {
				-- {
				-- 	event = "buffer_enter_event",
				-- 	handler = function()
				-- 		-- auto close
				-- 		-- vim.cmd("Neotree close")
				-- 		-- OR
				-- 		require("neo-tree.command").execute({ action = "close" })
				-- 	end
				-- },
				-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#auto-close-on-open-file
				{
					event = "file_open_requested",
					handler = function()
						-- auto close
						-- vim.cmd("Neotree close")
						-- OR
						require("neo-tree.command").execute({ action = "close" })
					end
				},
				-- https://www.reddit.com/r/neovim/comments/1d2yx9s/neotree_focus_when_opening_a_file/
				-- {
				--  event = "file_opened",
				--  handler = function()
				--      require("neo-tree.command").execute({ action = "focus" })
				--  end,
				-- },
				-- ctrl-g show current file path

				-- {
				-- 	event = "file_opened",
				-- 	handler = function(file_path)
				-- 		require("neo-tree.sources.filesystem").reset_search()
				-- 	end
				-- },

				{
					event = "neo_tree_buffer_enter",
					handler = function(arg)
						vim.cmd [[
						setlocal relativenumber
						]]
					end,
				},
			},

			-- },
		})

		-- require("neo-tree.sources.filesystem.commands").refresh(require("neo-tree.sources.manager").get_state("filesystem"))
		-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/1253
		-- Get the commands module from neo-tree.sources.filesystem. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/sources/filesystem/commands.lua
		require("neo-tree.sources.filesystem.commands")
		-- Call the refresh function found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/filesystem/commands.lua#L11-L13
		.refresh(
		-- Pull in the manager module. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/manager.lua
		require("neo-tree.sources.manager")
		-- Fetch the state of the "filesystem" source, feeding it to the filesystem refresh call since most everything in neo-tree
		-- expects to get its state fed to it
		.get_state("filesystem")
		)

		-- vim.cmd([[nnoremap \ :Neotree reveal reveal_force_cwd toggle<cr>]])
		   vim.cmd([[nnoremap \ :Neotree reveal_force_cwd toggle<cr>]])
	    -- [If you remove show, it'll move the focus to NeoTree.](https://www.reddit.com/r/neovim/comments/1eum82a/which_neovim_file_explorer_minifiles_or/)
		-- vim.cmd([[nnoremap \ :Neotree filesystem show toggle reveal_force_cwd<cr>]])
		--
		-- vim.cmd([[nnoremap \ :Neotree reveal_file=<cfile> reveal_force_cwd toggle<cr>]])
		-- vim.cmd([[nnoremap \ :Neotree reveal=<cfile> reveal_force_cwd toggle<cr>]])
		-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/70ab62c8cc5d039766c039597c7c33a76d74fd11/doc/neo-tree.txt#L53
		-- vim.cmd([[nnoremap \ :Neotree filesystem reveal left reveal_force_cwd toggle<cr>]])
		-- vim.cmd([[nnoremap \ :Neotree focus toggle<cr>]])
		-- open neotree in current window
		-- vim.cmd([[nnoremap \ :Neotree reveal position=current toggle<cr>]])
		-- vim.keymap.set({ "n" }, "\", ":Neotree reveal position=current toggle<cr>", { desc = "Toggle neotree" })

		-- https://www.reddit.com/r/neovim/comments/16siats/show_my_neotree_config_allow_you_to_telescope/
		-- set keymaps
		-- local keymap = vim.keymap -- for conciseness
		-- keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem right<cr>")
		-- keymap.set("n", "<space>e", "<cmd>Neotree filesystem reveal right<cr>")
	end
}

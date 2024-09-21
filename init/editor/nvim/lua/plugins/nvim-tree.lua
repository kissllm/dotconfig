
return  {
	-- https://gitee.com/kongjun18/nvim-tree.lua
	-- "kyazdani42/nvim-tree.lua",
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- "kyazdani42/nvim-web-devicons" ,
		-- https://stackoverflow.com/questions/71346431/neovim-nvim-tree-doesnt-open-current-directory-only-the-parent-directory-with-g
		"ahmedkhalf/project.nvim",
	},
	   cond = false,
	-- cond = true,
	cmd  = "NvimTreeToggle",
	-- NvimTreeRefresh
	-- config = true,
	config = function()
		local function on_attach(bufnr)
			local api = require "nvim-tree.api"

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
			vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
		end

		-- https://github.com/nvim-tree/nvim-tree.lua/issues/777
		-- update_focused_file.enable = true
		-- https://www.reddit.com/r/neovim/comments/rqb0xv/nvimtree_setting_cwd_to_where_current_file_was/
		vim.g.nvim_tree_respect_buf_cwd = 1
		--
		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- set termguicolors to enable highlight groups
		vim.opt.termguicolors = true
		require("nvim-tree").setup({
			disable_netrw          = true,
			hijack_netrw           = true,
			-- open_on_setup       = false,
			-- ignore_ft_on_setup  = {},
			-- auto_close          = false,
			open_on_tab            = false,
			hijack_cursor          = false,
			-- update_cwd          = false,
			sync_root_with_cwd     = true,
			update_cwd             = true,
			-- update_to_buf_dir  = {
			--     enable = true,
			--     auto_open = true,
			-- },
			diagnostics = {
				enable = false,
				icons = {
					-- hint    = "",
					hint       = "~",
					-- info    = "",
					info       = "?",
					-- warning = "",
					warning    = "!",
					-- error   = "",
					error      = "e",
				}
			},
			update_focused_file = {
				enable              = true,
				-- enable           = false,
				update_cwd          = true,
				-- update_cwd       = false,
				ignore_list         = {},
				-- https://github.com/nvim-tree/nvim-tree.lua/discussions/2888
				update_root         = {
					   enable = true,
					-- :e /usr/include/kiss/init <- ${MNGR_ROOT-}/usr/include/kiss/init
					-- enable = false,
				}
			},
			system_open = {
				cmd  = nil,
				args = {}
			},
			filters = {
				dotfiles     = false,
				-- dotfiles  = true,
				custom       = {"^\\.git"},
				-- custom    = {}
			},
			git = {
				enable  = true,
				ignore  = true,
				timeout = 500,
			},
			-- [NvimTree] unknown option: view.mappings
			-- | [NvimTree] unknown option: view.height
			-- | [NvimTree] unknown option: update_to_buf_dir
			-- | [NvimTree] unknown option: auto_close
			-- | [NvimTree] unknown option: open_on_setup
			-- | see :help nvim-tree-opts for available configuration options

			view = {
				width                = 50,
				-- height            = 30,
				-- hide_root_folder  = false,
				side                 = 'left',
				-- auto_resize       = false,
				-- mappings = {
				--  custom_only = false,
				--  list = {}
				-- },
				number          = false,
				relativenumber  = false,
				signcolumn      = "yes"
			},
			trash = {
				cmd              = "trash",
				require_confirm  = true
			},
			sort_by = "case_sensitive",
			renderer = {
				group_empty = true,
				-- https://www.reddit.com/r/neovim/comments/vyxgvo/how_to_get_nice_indent_lines_in_nvimtree/
				indent_markers = {
					enable = true,
				},
				icons = {
					symlink_arrow = " -> ",
					glyphs = {
						default  = " ",
						symlink  = ">",
						bookmark = "*",
						modified = "?",
						folder = {
							arrow_closed = "x",
							arrow_open   = "^",
							default      = " ",
							open         = "o",
							empty        = "/",
							empty_open   = "$",
							symlink      = "<",
							symlink_open = ">",
						},
						git = {
							unstaged  = "t",
							staged    = "s",
							unmerged  = "m",
							renamed   = "r",
							untracked = "*",
							deleted   = "x",
							ignored   = "~",
						},
					},
				},
			},
			actions = {
				-- https://www.reddit.com/r/neovim/comments/yftm83/nvimtree_is_driving_me_nuts/
				change_dir = {
					-- https://www.reddit.com/r/neovim/comments/17niwv2/how_do_i_stop_nvimtree_from_jumping_to_a/
					-- enable = false,
					   enable = true,
					-- :e /usr/include/kiss/init <- ${MNGR_ROOT-}/usr/include/kiss/init
					   global = true
					-- global = false
				},
				open_file = {
					window_picker = { enable = false },
					quit_on_open = true,
				},
			},
			on_attach = on_attach,
		})
	end,
}

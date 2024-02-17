-- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
-- https://vimawesome.com/plugin/telescope-nvim-care-of-itself
-- https://medium.com/@shaikzahid0713/telescope-333594836896
-- https://linovox.com/install-and-use-telescope-in-neovim/
-- https://morioh.com/a/03cf7258db58/telescopenvim-find-filter-preview-pick-all-lua-all-the-time
-- telescope.lua

-- Telescope (Fuzzy Finder)
-- Added these plugins to install Telescope

local U = require('utils')

return {
	'nvim-telescope/telescope.nvim',
	event = "VeryLazy",
	lazy = true,
	-- lazy = false,
	dependencies = {
		{'nvim-lua/plenary.nvim'},
		{'BurntSushi/ripgrep'},
		{'sharkdp/fd'},
		{'nvim-telescope/telescope-fzf-native.nvim',
			build = "make",
			-- https://zyree.hashnode.dev/neovim-as-an-ide
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
			-- https://www.barbarianmeetscoding.com/notes/neovim-lazyvim/#custom-telescope-configs
			-- config = function()
			-- 	require("telescope").load_extension("fzf")
			-- end,
		},
		{"nvim-telescope/telescope-live-grep-args.nvim"},
		{"debugloop/telescope-undo.nvim"},
		{'nvim-telescope/telescope-media-files.nvim'},
		-- Converted from "after" keyword
		{'neovim/nvim-lspconfig'},
		{"nvim-treesitter/nvim-treesitter"},
	},
	-- Lazy does not know it
	-- after = {
	-- 	'nvim-lspconfig',
	-- 	'nvim-treesitter',
	-- },
	cmd = 'Telescope',
	module = "telescope",
	config = function()
		-- Put this pcall outside return will end up with include this file per se
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			return
		end
		--
		local actions    = require("telescope.actions")
		-- https://www.harrisoncramer.me/building-a-powerful-neovim-configuration/
		-- https://github.com/harrisoncramer/nvim/blob/main/lua/plugins/telescope/init.lua
		local finders    = require("telescope.finders")
		local conf       = require("telescope.config").values
		local previewers = require("telescope.previewers")
		local pickers    = require("telescope.pickers")
		local builtin    = require("telescope.builtin")
		-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
		local actions_undo = require("telescope-undo.actions")
		local lga_actions  = require("telescope-live-grep-args.actions")
		-- $HOME/.local/share/nvim/lazy
		local cwd = require("lazy.core.config").options.root
		-- require("telescope").setup()
		telescope.setup{

			-- https://www.lazyvim.org/configuration/examples
			-- https://www.reddit.com/r/neovim/comments/11m3575/howwhere_to_set_plugin_keymaps_with_lazynvim/
			keys = {
				-- add a keymap to browse plugin files
				-- stylua: ignore
				{
					-- "<leader>ff",
					"<leader>fp",
					function() builtin.find_files({ cwd = cwd }) end,
					desc = "Find Plugin File",
				},
				{
					"<leader>fg",
					function() builtin.live_grep({ cwd = cwd }) end,
					desc = "Find String in Files",
				},
				{
					"<leader>fb",
					function() builtin.buffers({ cwd = cwd }) end,
					desc = "Find String in Buffers",
				},
				{
					"<leader>fh",
					function() builtin.help_tags({ cwd = cwd }) end,
					desc = "Find Help Tags",
				},
				-- https://www.reddit.com/r/neovim/comments/zko4tf/difficulty_loading_telescopenvim_lazy_or_eager/
				{
					"gd",
					function() builtin.lsp_definitions({ cwd = cwd }) end,
					desc = "Find lsp definitions",
				},
				{
					"gy",
					function() builtin.lsp_type_definitions({ cwd = cwd }) end,
					desc = "Find lsp type definitions",
				},
				{
					"gr",
					function() builtin.lsp_references({ cwd = cwd }) end,
					desc = "Find lsp references",
				},
			},
			-- telescope.setup{
			--
			opts = {
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					-- https://lee-phillips.org/nvimTelescopeConfig/
					scroll_strategy      = "limit";
					file_ignore_patterns = { ".git/[^h]" };
					-- file_ignore_patterns = { '^node_modules/', },
					-- prompt_prefix        = " ",
					prompt_prefix        = "< ",
					-- selection_caret      = " ",
					selection_caret      = "-> ",
					path_display         = { "smart" },
					-- https://www.lazyvim.org/configuration/examples
					layout_strategy      = "horizontal",
					layout_config        = { prompt_position = "top" },
					sorting_strategy     = "ascending",
					winblend             = 0,

					mappings = {
						i = {
							["<C-n>"]      = actions.cycle_history_next,
							["<C-p>"]      = actions.cycle_history_prev,

							["<C-j>"]      = actions.move_selection_next,
							["<C-k>"]      = actions.move_selection_previous,

							["<C-c>"]      = actions.close,

							["<Down>"]     = actions.move_selection_next,
							["<Up>"]       = actions.move_selection_previous,

							["<CR>"]       = actions.select_default,
							["<C-x>"]      = actions.select_horizontal,
							["<C-v>"]      = actions.select_vertical,
							["<C-t>"]      = actions.select_tab,

							["<C-u>"]      = actions.preview_scrolling_up,
							["<C-d>"]      = actions.preview_scrolling_down,

							["<PageUp>"]   = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["<Tab>"]      = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"]    = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"]      = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"]      = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"]      = actions.complete_tag,
							-- ["<C-_>"]      = actions.which_key, -- keys from pressing <C-/>
						},

						n = {
							["<esc>"]      = actions.close,
							["<CR>"]       = actions.select_default,
							["<C-x>"]      = actions.select_horizontal,
							["<C-v>"]      = actions.select_vertical,
							["<C-t>"]      = actions.select_tab,

							["<Tab>"]      = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"]    = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"]      = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"]      = actions.send_selected_to_qflist + actions.open_qflist,

							["j"]          = actions.move_selection_next,
							["k"]          = actions.move_selection_previous,
							["H"]          = actions.move_to_top,
							["M"]          = actions.move_to_middle,
							["L"]          = actions.move_to_bottom,

							["<Down>"]     = actions.move_selection_next,
							["<Up>"]       = actions.move_selection_previous,
							["gg"]         = actions.move_to_top,
							["G"]          = actions.move_to_bottom,

							-- ["<C-u>"]      = actions.preview_scrolling_up,
							["u"]      = actions.preview_scrolling_up,
							-- ["<C-d>"]      = actions.preview_scrolling_down,
							["m"]      = actions.preview_scrolling_down,

							["<PageUp>"]   = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							-- ["?"]          = actions.which_key,
							-- https://www.reddit.com/r/neovim/comments/qspemc/close_buffers_with_telescope/
							['<c-d>']      = actions.delete_buffer,
						},
					}
				},
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_ key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
				-- https://lee-phillips.org/nvimTelescopeConfig/
				find_files = {
					hidden = true;
				},
				-- https://www.reddit.com/r/neovim/comments/udx0fi/telescopebuiltinlive_grep_and_operator/
				live_grep = {
					on_input_filter_cb = function(prompt)
						-- AND operator for live_grep like how fzf handles spaces with wildcards in rg
						return { prompt = prompt:gsub("%s", ".*") }
					end,
				},
				-- nnoremap gb :buffers<CR>:buffer<Space>
				buffers = {
					show_all_buffers = true,
					-- theme = "dropdown",
					-- previewer = false,
					previewer        = true,
					sort_mru         = true,
					sort_lastused    = true,
					mappings = {
						n = {
							["d"] = "delete_buffer",
						-- :lua vim.api.nvim_buf_delete(term_bufnr, { force = true })).
						},
						i = {
							-- ["<c-d>"]  = "delete_buffer",
							["<c-d>"]     = actions.delete_buffer + actions.move_to_top,
							["<C-j>"]     = actions.move_selection_next,
							["<C-k>"]     = actions.move_selection_previous,
						},
					},
				},
			},
			extensions = {
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
				-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
					-- ... also accepts theme settings, for example:
					-- theme = "dropdown", -- use dropdown theme
					-- theme = { }, -- use own theme spec
					-- layout_config = { mirror=true }, -- mirror preview pane
				},
				-- https://www.reddit.com/r/neovim/comments/13936zq/editing_the_telescope_extension_seems_finnicky/
				undo = {
					mappings = {
						i = {
							-- function() ["<S-cr>"] = require("telescope-undo.actions").yank_additions() end,
							["<S-cr>"] = actions_undo.yank_additions(),
							-- function() ["<d-cr>"] = require("telescope-undo.actions").yank_deletions() end,
							["<d-cr>"] = actions_undo.yank_deletions(),
							-- function() ["<cr>"]   = require("telescope-undo.actions").restore() end,
							["<cr>"]   = actions_undo.restore(),
						},
					},
				},
			}
		}
		-- require("telescope").load_extension("live_grep_args")
		-- telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("undo")
		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
		-- vim.keymap.set("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor)
		U.map("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor)

		-- [telescope.builtin.lsp_*]: no client attached
		-- U.map("n", "gd", function() builtin.lsp_definitions({ cwd = cwd }) end,      { noremap = true, silent = true })
		-- U.map("n", "gy", function() builtin.lsp_type_definitions({ cwd = cwd }) end, { noremap = true, silent = true })
		-- U.map("n", "gr", function() builtin.lsp_references({ cwd = cwd }) end,       { noremap = true, silent = true })

		-- U.map("n", "<leader>ff", function() builtin.find_files({ cwd = cwd }) end,   { noremap = true, silent = true })
		-- U.map("n", "<leader>fg", function() builtin.live_grep({ cwd = cwd }) end,    { noremap = true, silent = true })
		-- U.map("n", "<leader>fb", function() builtin.buffers({ cwd = cwd }) end,      { noremap = true, silent = true })
		-- U.map("n", "<leader>fh", function() builtin.help_tags({ cwd = cwd }) end,    { noremap = true, silent = true })

		-- https://git.osdec.gov.my/hardynobat/my-dot-config/-/blob/master/init.lua.lazy
		-- vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true})
		-- vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>ft', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>fo', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })


		-- return telescope
	end,
}

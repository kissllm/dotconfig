--
--
-- [lsp_definitions doesn't work for builtins and deps in Deno LSP #2768](https://github.com/nvim-telescope/telescope.nvim/issues/2768)
-- https://nvimluau.dev/nvim-telescope-telescope-nvim
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
-- https://vimawesome.com/plugin/telescope-nvim-care-of-itself
-- https://medium.com/@shaikzahid0713/telescope-333594836896
-- https://linovox.com/install-and-use-telescope-in-neovim/
-- https://morioh.com/a/03cf7258db58/telescopenvim-find-filter-preview-pick-all-lua-all-the-time
-- telescope.lua

-- Telescope (Fuzzy Finder)
-- Added these plugins to install Telescope

-- local U = require('utils')
-- :Telescope treesitter
-- :checkhealth telescope
return {
	'nvim-telescope/telescope.nvim',
	-- branch = '0.1.x',
	-- branch = '0.1.x',
	tag = '0.1.6',
	-- branch = 'master',
	event = "VeryLazy",
	lazy = true,
	-- lazy = false,
	cond = true,
	-- cond = false,
	dependencies = {
		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},
		{ 'nvim-lua/plenary.nvim' },
		{ 'BurntSushi/ripgrep' },
		-- { 'sharkdp/fd' },
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = "make",
			-- https://zyree.hashnode.dev/neovim-as-an-ide
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
			-- https://www.barbarianmeetscoding.com/notes/neovim-lazyvim/#custom-telescope-configs
			-- config = function()
			--  require("telescope").load_extension("fzf")
			-- end,
		},
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{ 'nvim-telescope/telescope-media-files.nvim' },
		-- Converted from "after" keyword
		{ 'neovim/nvim-lspconfig' },
		{ "nvim-treesitter/nvim-treesitter" },
		-- For lsp_capabilities
		-- { 'hrsh7th/nvim-cmp' },
		-- { "hrsh7th/cmp-nvim-lsp" },
		-- { "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "gbrlsnchs/telescope-lsp-handlers.nvim" },
		--{ "Slotos/telescope-lsp-handlers.nvim" },
	},
	-- Lazy does not know it
	after = {
		'nvim-lspconfig',
		'nvim-treesitter',
	},
	-- https://github.com/wbthomason/packer.nvim/issues/781
	-- Remove cmd = "Telescope"
	-- cmd = 'Telescope',
	module = "telescope",
	config = function()
		-- This shows lsp.lua never work?
		-- local lspzero = require('lspconfig.lsp-zero').setup()
		-- This is a nil value
		-- local lspconfig = lspzero["lsp"]
		local lspconfig = require('lspconfig')

		-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
		-- lspconfig.clangd.setup {}
		-- local lua_ls = require("lspconfig.lua_ls")
		-- lua_ls.setup {
		--  -- settings = {
		--  -- lspzero = lspzero,
		--  lsp = lsp,
		--  capabilities = lsp_capabilities,
		--  lua = {
		--      format = {
		--          enable = true,
		--          defaultConfig = {
		--              indent_style = "space",
		--              indent_size = "2",
		--              align_continuous_assign_statement = false,
		--              align_continuous_rect_table_field = false,
		--              align_array_table = false
		--          },
		--      },
		--      -- https://github.com/folke/neodev.nvim
		--      completion = {
		--          callSnippet = "Replace"
		--      },
		--      runtime = {
		--          -- LuaJIT in the case of Neovim
		--          version = 'LuaJIT',
		--          path = vim.split(package.path, ';'),
		--      },
		--      diagnostics = {
		--          globals = { 'vim' }
		--      },
		--      workspace = {
		--          -- Make the server aware of Neovim runtime files
		--          library = {
		--              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
		--          [vim.fn.stdpath("config") .. "/lua"] = true,
		--              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
		--          },
		--      },

		--  },
		--  single_file_support = false,
		--  on_attach = on_attach
		--  -- on_attach = function(client, bufnr)
		--  --      --  print('hello world')
		--  --      -- end,
		--  -- },
		-- }

		lspconfig.on_attach = function(client, bufnr)
			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lspconfig.default_keymaps({ buffer = bufnr })

			local opts = { buffer = bufnr }

			-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
			vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
			vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
			vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
			vim.keymap.set('n', 'gC', '<cmd>Telescope lsp_document_symbols<cr>', opts)

			local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

			buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

			local opts = { buffer = bufnr }
			vim.keymap.set('n',  'K',    '<cmd>lua vim.lsp.buf.hover()<cr>',           opts)
			-- vim.keymap.set('n',  '<leader>d',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
			vim.keymap.set('n',  'gd',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
			vim.keymap.set('n',  'gD',   '<cmd>lua vim.lsp.buf.declaration()<cr>',     opts)
			vim.keymap.set('n',  'gi',   '<cmd>lua vim.lsp.buf.implementation()<cr>',  opts)
			vim.keymap.set('n',  'go',   '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
			-- vim.keymap.set('n',  '<leader>r',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
			vim.keymap.set('n',  'gr',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
			vim.keymap.set('n',  'gs',   '<cmd>lua vim.lsp.buf.signature_help()<cr>',  opts)
			-- vim.keymap.set('n',  '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',          opts)
			vim.keymap.set('n',  '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',     opts)

			vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

			vim.keymap.set('n',  'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
			vim.keymap.set('n',  '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  opts)
			vim.keymap.set('n',  ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',  opts)

			-- Set some keybinds conditional on server capabilities
			-- :lua =vim.lsp.get_active_clients()[1].server_capabilities
			-- if client.resolved_capabilities.document_formatting then
			if client.server_capabilities.documentFormattingProvider then
				buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
				-- elseif client.resolved_capabilities.document_range_formatting then
			elseif client.server_capabilities.documentRangeFormattingProvider then
				buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
			end

			-- Set autocommands conditional on server_capabilities
			-- if client.resolved_capabilities.document_highlight then
			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_exec([[
augroup lsp_document_highlight
	autocmd! * <buffer>
	autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END
				]], false)
			end

			local caps = client.server_capabilities
			if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
				local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
				vim.api.nvim_create_autocmd("TextChanged", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.semantic_tokens_full()
					end,
				})
				-- fire it first time on load as well
				-- vim.lsp.buf.semantic_tokens_full()
			end
		end

		local U = require('utils')
		local map = U.map
		-- https://github.com/nvim-telescope/telescope.nvim/blob/master/plugin/telescope.lua
		local colors = require("catppuccin.palettes").get_palette()
		-- local colors = require("onehalf-lush").get_palette()
		local TelescopeColor = {
			TelescopeMatching      = { fg = colors.flamingo },
			TelescopeSelection     = { bg = colors.surface0, fg = colors.text, bold = true },

			TelescopePromptPrefix  = { bg = colors.surface0 },
			TelescopePromptNormal  = { bg = colors.surface0 },
			TelescopeResultsNormal = { bg = colors.mantle },
			TelescopePreviewNormal = { bg = colors.mantle },
			TelescopeResultsTitle  = { fg = colors.mantle },
			TelescopePromptBorder  = { bg = colors.surface0, fg = colors.surface0 },
			TelescopeResultsBorder = { bg = colors.mantle,   fg = colors.mantle },
			TelescopePreviewBorder = { bg = colors.mantle,   fg = colors.mantle },
			TelescopePromptTitle   = { bg = colors.pink,     fg = colors.mantle },
			TelescopePreviewTitle  = { bg = colors.green,    fg = colors.mantle },
		}

		for hl, col in pairs(TelescopeColor) do
			vim.api.nvim_set_hl(0, hl, col)
		end

		-- Put this pcall outside return will end up with include this file per se
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			print("telescope pcall failed")
			return
		end
		--
		local actions      = require("telescope.actions")
		-- https://www.harrisoncramer.me/building-a-powerful-neovim-configuration/
		-- https://github.com/harrisoncramer/nvim/blob/main/lua/plugins/telescope/init.lua
		local finders      = require("telescope.finders")
		local conf         = require("telescope.config").values
		local previewers   = require("telescope.previewers")
		local pickers      = require("telescope.pickers")
		local builtin      = require("telescope.builtin")
		-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
		local actions_undo = require("telescope-undo.actions")
		local lga_actions  = require("telescope-live-grep-args.actions")
		local fb_actions   = require "telescope".extensions.file_browser.actions
		-- $HOME/.local/share/nvim/lazy
		local cwd          = require("lazy.core.config").options.root
		-- require("telescope").setup()
		telescope.setup {

			-- https://www.lazyvim.org/configuration/examples
			-- https://www.reddit.com/r/neovim/comments/11m3575/howwhere_to_set_plugin_keymaps_with_lazynvim/
			-- keys = {
			--  -- add a keymap to browse plugin files
			--  -- stylua: ignore
			--  {
			--      -- "<leader>ff",
			--      "<leader>fp",
			--      function() builtin.find_files({ cwd = cwd }) end,
			--      desc = "Find Plugin File",
			--  },
			--  {
			--      "<leader>fg",
			--      function() builtin.live_grep({ cwd = cwd }) end,
			--      desc = "Find String in Files",
			--  },
			--  {
			--      "<leader>fb",
			--      function() builtin.buffers({ cwd = cwd }) end,
			--      desc = "Find String in Buffers",
			--  },
			--  {
			--      "<leader>fh",
			--      function() builtin.help_tags({ cwd = cwd }) end,
			--      desc = "Find Help Tags",
			--  },
			--  -- https://www.reddit.com/r/neovim/comments/zko4tf/difficulty_loading_telescopenvim_lazy_or_eager/
			--  {
			--      "gd",
			--      function() builtin.lsp_definitions({ cwd = cwd }) end,
			--      desc = "Find lsp definitions",
			--  },
			--  {
			--      "gy",
			--      function() builtin.lsp_type_definitions({ cwd = cwd }) end,
			--      desc = "Find lsp type definitions",
			--  },
			--  {
			--      "gr",
			--      function() builtin.lsp_references({ cwd = cwd }) end,
			--      desc = "Find lsp references",
			--  },
			-- },

			-- opts = {
			defaults = {
				-- initial_mode = "normal", -- Open telescope buffers in normal mode -- https://www.reddit.com/r/neovim/comments/zc5fuy/open_telescope_buffers_in_normal_mode/
				selection_strategy   = "closest",
				-- Default configuration for telescope goes here:
				-- config_key = value,
				-- https://lee-phillips.org/nvimTelescopeConfig/
				scroll_strategy      = "limit",
				file_ignore_patterns = { ".git/[^h]" },
				-- file_ignore_patterns = { '^node_modules/', },
				-- prompt_prefix        = " ",
				prompt_prefix        = "< ",
				-- selection_caret      = " ",
				selection_caret      = "-> ",
				path_display         = { "smart" },
				-- https://www.lazyvim.org/configuration/examples
				layout_strategy      = 'horizontal',
				-- layout_strategy      = 'vertical',
				layout_config        = {
					-- vertical = { width = 0.7 },
					horizontal       = { height = 0.999 },
					prompt_position  = 'top',
					-- prompt_position     = 'left',
					-- prompt_position     = 'bottom',
					-- preview_cutoff   = 10,
					preview_cutoff   = 0,
					-- height              = 0.999,

					-- height           = { padding = 0 },
					-- width            = { padding = 0 },

					-- height              = 1,
					-- width               = 1,
					preview_width    = 0.67,
					-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
					-- width = function(_, cols, _)
					--  if cols > 200 then
					--      return 170
					--  else
					--      return math.floor(cols * 0.87)
					--  end
					-- end,
					width            = function(_, max_columns)
						-- local percentage = 0.95
						local percentage = 1
						local max = 900
						-- return math.min(math.floor(percentage * max_columns), max)
						return math.max(math.floor(percentage * max_columns), max)
					end,
					height          = function(_, _, max_lines)
						-- local percentage = 0.95
						local percentage = 1
						local min = 900
						return math.max(math.floor(percentage * max_lines), min)
					end,
					center = {
						width = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
				},
				sorting_strategy     = 'ascending',
				winblend             = 0,


				mappings             = {
					i = {
						["\\"] = [[close]],
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
						["\\"] = [[close]],
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
						["u"]          = actions.preview_scrolling_up,
						-- ["<C-d>"]      = actions.preview_scrolling_down,
						["m"]          = actions.preview_scrolling_down,

						["<PageUp>"]   = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,

						-- ["?"]          = actions.which_key,
						-- https://www.reddit.com/r/neovim/comments/qspemc/close_buffers_with_telescope/
						['<c-d>']      = actions.delete_buffer,
					},
				},
			},
			-- },

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
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					hidden          = true,
					layout_strategy = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config   = {
						-- vertical = { width = 0.3 },
						horizontal      = { height = 0.999 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					mappings         = {
						n = {
							["\\"] = [[close]],
						},
						i = {
							["\\"] = [[close]],
						},
					},
				},
				grep_string = {
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					layout_strategy = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config   = {
						-- vertical = { width = 0.3 },
						horizontal      = { height = 0.999 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					mappings         = {
						n = {
							["\\"] = [[close]],
						},
						i = {
							["\\"] = [[close]],
						},
					},
				},
				-- https://www.reddit.com/r/neovim/comments/udx0fi/telescopebuiltinlive_grep_and_operator/
				live_grep = {
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					on_input_filter_cb = function(prompt)
						-- AND operator for live_grep like how fzf handles spaces with wildcards in rg
						return { prompt = prompt:gsub("%s", ".*") }
					end,
					layout_strategy    = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config      = {
						-- vertical = { width = 0.3 },
						horizontal      = { height = 0.999 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					mappings         = {
						n = {
							["\\"] = [[close]],
						},
						i = {
							["\\"] = [[close]],
						},
					},
				},
				-- nnoremap gb :buffers<CR>:buffer<Space>
				buffers = {
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					show_all_buffers = true,
					-- theme = "dropdown",
					-- previewer = false,
					previewer        = true,
					sort_mru         = true,
					sort_lastused    = true,
					mappings         = {
						n = {
							["d"] = "delete_buffer",
							-- :lua vim.api.nvim_buf_delete(term_bufnr, { force = true })).
							["\\"] = [[close]],
						},
						i = {
							-- ["<c-d>"]  = "delete_buffer",
							["<c-d>"] = actions.delete_buffer + actions.move_to_top,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["\\"] = [[close]],
						},
					},
					layout_strategy  = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config    = {
						vertical        = { width = 0.3 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					-- Can not go back to indert mode ?
					-- on_complete = { function() vim.cmd"stopinsert" end },
				},
				help_tags = {
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					layout_strategy  = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config    = {
						vertical        = { width = 0.3 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					mappings         = {
						n = {
							["\\"] = [[close]],
						},
						i = {
							["\\"] = [[close]],
						},
					},
				},
			},

			extensions = {
				-- https://github.com/stevearc/aerial.nvim/issues/169
				aerial = {
					sorting_strategy = "descending",
				},
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

				-- https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim
				lsp_handlers = {
					disable = {},
					location = {
						telescope = {},
						no_results_message = 'No references found',
					},
					symbol = {
						telescope = {},
						no_results_message = 'No symbols found',
					},
					call_hierarchy = {
						telescope = {},
						no_results_message = 'No calls found',
					},
					code_action = {
						telescope = {},
						no_results_message = 'No code actions available',
						prefix = '',
					},
				},
				-- https://github.com/nvim-telescope/telescope-file-browser.nvim
				-- No upward directories showing by default <i:ctrl-g> or backspace
				file_browser = {
					grouped = true,
					-- initial_mode = "normal", -- Open telescope buffers in normal mode
					theme = "ivy",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						["i"] = {
							-- your custom insert mode mappings
							-- ["\\"] = fb_actions.toggle_browser,
							   ["\\"] = [[close]],
							-- vim.keymap.set("n", "\\", [[<cmd>lua require "telescope".extensions.file_browser.actions.toggle_browser()<cr>]])
						},
						["n"] = {
							-- your custom normal mode mappings
							-- ["g"] = fb_actions.goto_parent_dir,
							["<BackSpace>"] = fb_actions.goto_parent_dir,
							-- unmap toggling `fb_actions.toggle_browser`
							-- ["f"] = fb_actions.close,
							-- ["\\"] = fb_actions.toggle_browser,
							   ["\\"] = [[close]],
							-- vim.keymap.set("n", "\\", [[<cmd>lua require "telescope".extensions.file_browser.actions.toggle_browser()<cr>]])

						},
					},

					layout_strategy  = 'horizontal',
					-- layout_strategy      = 'vertical',
					layout_config    = {
						vertical        = { width = 0.3 },
						prompt_position = 'top',
						-- prompt_position     = 'left',
						-- prompt_position     = 'bottom',
						-- preview_cutoff   = 10,
						preview_cutoff  = 0,
						height          = 0.999,
						width           = { padding = 0 },
						-- height              = 1,
						-- width               = 1,
						preview_width   = 0.67,
						-- https://www.reddit.com/r/neovim/comments/yrqm9f/comment/ivv8hoa/
						-- width = function(_, cols, _)
						--  if cols > 200 then
						--      return 170
						--  else
						--      return math.floor(cols * 0.87)
						--  end
						-- end,
						width           = function(_, max_columns)
							-- local percentage = 0.95
							local percentage = 1
							local max = 900
							-- return math.min(math.floor(percentage * max_columns), max)
							return math.max(math.floor(percentage * max_columns), max)
						end,
						height          = function(_, _, max_lines)
							-- local percentage = 0.95
							local percentage = 1
							local min = 900
							return math.max(math.floor(percentage * max_lines), min)
						end,
					},
					-- on_complete = { function() vim.cmd"stopinsert" end },
				},
			},
		}
		-- To get telescope-file-browser loaded and working with telescope,
		-- you need to call load_extension, somewhere after setup function:
		telescope.load_extension("lsp_handlers")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("undo")
		telescope.load_extension "file_browser"
		-- require("telescope").load_extension("live_grep_args")
		-- telescope.load_extension("fzf")
		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
		-- vim.keymap.set("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor)
		map("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor)

		-- vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>")
		-- vim.keymap.set("n", "\\", ":Telescope file_browser<CR>")

		-- open file_browser with the path of the current buffer
		-- vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
		   vim.keymap.set("n", "\\", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
		-- vim.keymap.set("n", "\\", [[<cmd>lua require "telescope".extensions.file_browser.actions.toggle_browser()<cr>]])
		   vim.keymap.set("n", "<leader>\\", ":Telescope live_grep<CR>")

		-- Alternatively, using lua API
		-- vim.keymap.set("n", "<leader>fb", function()
		--  require("telescope").extensions.file_browser.file_browser()
		-- end)

		-- USE_TELESCOPE_GOTO=1

		if USE_TELESCOPE_GOTO ~= nil then

			-- [telescope.builtin.lsp_*]: no client attached
			map("n", "gd", function() builtin.lsp_definitions     ({ cwd = cwd }) end, { noremap = true, silent = true })
			-- map("n", "gd", [[<cmd>lua require('telescope.builtin').lsp_definitions({ cwd = require("lazy.core.config").options.root })<cr>]], { noremap = true, silent = true })
			-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', [[<cmd>Telescope lsp_definitions<CR>]], { noremap = true, silent = true })
			-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { noremap = true, silent = true })

			map("n", "gy", function() builtin.lsp_type_definitions({ cwd = cwd }) end, { noremap = true, silent = true })

			-- map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ cwd = require("lazy.core.config").options.root }) end, { noremap = true, silent = true })

			map("n", "gr", function() builtin.lsp_references      ({ cwd = cwd }) end, { noremap = true, silent = true })

			-- map("n", "gr", function() require("telescope.builtin").lsp_references({ cwd = require("lazy.core.config").options.root }) end, { noremap = true, silent = true })
			-- map("n", "gr", function() require("telescope-bibtex.actions").bibtex ({ cwd = require("lazy.core.config").options.root }) , { noremap = true, silent = true })

			-- map("n", "<leader>ff", function() builtin.find_files({ cwd = cwd }) end, { noremap = true, silent = true })
			-- map("n", "<leader>fg", function() builtin.live_grep ({ cwd = cwd }) end, { noremap = true, silent = true })
			-- map("n", "<leader>fb", function() builtin.buffers   ({ cwd = cwd }) end, { noremap = true, silent = true })
			-- map("n", "<leader>fh", function() builtin.help_tags ({ cwd = cwd }) end, { noremap = true, silent = true })

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
		else
			map('n',  'gd', function() vim.lsp.buf.definition     ({ cwd = cwd }) end, { noremap = true, silent = true })
			map('n',  'gD', function() vim.lsp.buf.declaration    ({ cwd = cwd }) end, { noremap = true, silent = true })
			map('n',  'gr', function() vim.lsp.buf.references     ({ cwd = cwd }) end, { noremap = true, silent = true })
			-- map('n',  'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true })

		end

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
			pattern = "*",
			callback = function(args)
				local opts = { buffer = args.buf }
				local U = require('utils')
				local map = U.map
				map("n", "<leader>a", vim.lsp.buf.code_action, opts)

				if USE_TELESCOPE_GOTO ~= nil then
					local builtin = require("telescope.builtin")
					local cwd = require("lazy.core.config").options.root
					-- Defined in telescope.lua
					map("n", "gd", function() builtin.lsp_definitions     ({ cwd = cwd }) end, opts)
					map("n", "gy", function() builtin.lsp_type_definitions({ cwd = cwd }) end, opts)
					map("n", "gr", function() builtin.lsp_references      ({ cwd = cwd }) end, opts)

					map("n", "<leader>ff", function() builtin.find_files  ({ cwd = cwd }) end, opts)
					map("n", "<leader>fg", function() builtin.live_grep   ({ cwd = cwd }) end, opts)
					map("n", "<leader>fb", function() builtin.buffers     ({ cwd = cwd }) end, opts)
					map("n", "<leader>fh", function() builtin.help_tags   ({ cwd = cwd }) end, opts)
				end
				map({ "n", "x" }, "<leader>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
				map({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
				map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
				map("n", "<leader>r", vim.lsp.buf.rename, opts)

				local bufnr = args.buf
				-- local bufnr = vim.fn.winbufnr(0)
				-- local client = args.client
				-- local client = vim.lsp.buf_get_clients()
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local function buf_set_keymap(...) vim.keymap.set(...) end
				local function buf_set_option(name, value) vim.api.nvim_set_option_value(name, value, { buf = args.buf }) end

				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

				local opts = { buffer = bufnr }
				vim.keymap.set('n',  'K',    '<cmd>lua vim.lsp.buf.hover()<cr>',           opts)
				-- vim.keymap.set('n',  '<leader>d',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
				vim.keymap.set('n',  'gd',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
				vim.keymap.set('n',  'gD',   '<cmd>lua vim.lsp.buf.declaration()<cr>',     opts)
				vim.keymap.set('n',  'gi',   '<cmd>lua vim.lsp.buf.implementation()<cr>',  opts)
				vim.keymap.set('n',  'go',   '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				-- vim.keymap.set('n',  '<leader>r',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
				vim.keymap.set('n',  'gr',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
				vim.keymap.set('n',  'gs',   '<cmd>lua vim.lsp.buf.signature_help()<cr>',  opts)
				-- vim.keymap.set('n',  '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',          opts)
				vim.keymap.set('n',  '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',     opts)

				vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

				vim.keymap.set('n',  'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
				vim.keymap.set('n',  '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  opts)
				vim.keymap.set('n',  ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',  opts)

				-- Set some keybinds conditional on server capabilities
				-- :lua =vim.lsp.get_active_clients()[1].server_capabilities
				-- if client.resolved_capabilities.document_formatting then
				if client.server_capabilities.documentFormattingProvider then
					buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
					-- elseif client.resolved_capabilities.document_range_formatting then
				elseif client.server_capabilities.documentRangeFormattingProvider then
					buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
				end

				-- Set autocommands conditional on server_capabilities
				-- if client.resolved_capabilities.document_highlight then
				if client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_exec([[
augroup lsp_document_highlight
	autocmd! * <buffer>
	autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END
					]], false)
				end

				local caps = client.server_capabilities
				if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
					local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
					vim.api.nvim_create_autocmd("TextChanged", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- vim.lsp.buf.semantic_tokens_full()
							vim.lsp.semantic_tokens.force_refresh()
						end,
					})
					-- fire it first time on load as well
					-- vim.lsp.buf.semantic_tokens_full()
					vim.lsp.semantic_tokens.force_refresh()
				end

			end,
		})


		-- return telescope
	end,
}



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

return {
	{
		"trailblazing/vim-repeat",
		-- event = "VeryLazy",
		lazy   = false,
	},

	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},

	{
		-- https://gitee.com/kongjun18/nvim-tree.lua
		"kyazdani42/nvim-tree.lua",
		dependencies = {
			"kyazdani42/nvim-web-devicons" ,
			-- https://stackoverflow.com/questions/71346431/neovim-nvim-tree-doesnt-open-current-directory-only-the-parent-directory-with-g
			"ahmedkhalf/project.nvim",
		},
		cmd = "NvimTreeToggle",
		-- config = true,
		config = function()
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
				disable_netrw      = true,
				hijack_netrw       = true,
				-- open_on_setup       = false,
				-- ignore_ft_on_setup = {},
				-- auto_close          = false,
				open_on_tab        = false,
				hijack_cursor      = false,
				-- update_cwd      = false,
				sync_root_with_cwd = true,
				update_cwd = true,
				-- update_to_buf_dir    = {
				--  enable = true,
				--  auto_open = true,
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
						error      = "x",
					}
				},
				update_focused_file = {
					enable        = true,
					update_cwd    = true,
					-- enable     = false,
					-- update_cwd = false,
					ignore_list   = {}
				},
				system_open = {
					cmd  = nil,
					args = {}
				},
				filters = {
					-- dotfiles = false,
					dotfiles = true,
					custom = {"^\\.git"},
					-- custom = {}
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
					width = 50,
					-- height = 30,
					-- hide_root_folder = false,
					side = 'left',
					-- auto_resize = false,
					-- mappings = {
					--  custom_only = false,
					--  list = {}
					-- },
					number = false,
					relativenumber = false,
					signcolumn = "yes"
				},
				trash = {
					cmd = "trash",
					require_confirm = true
				},
				sort_by = "case_sensitive",
				renderer = {
					group_empty = true,
				},
				actions = {
					open_file = {
						window_picker = { enable = false },
					},
				},
				on_attach = on_attach,
			})
		end,
	},

	{
		"tpope/vim-surround",
		event = { "BufReadPost", "BufNewFile" }
	},

	{
		"tpope/vim-fugitive",
		event = "VeryLazy"
	},

	{
		"tpope/vim-eunuch",
		event = "VeryLazy"
	},

	"thinca/vim-localrc",

	{
		"simnalamburt/vim-mundo",
		event = "VeryLazy"
	},

	-- Tons of errors puped up
	{
		"wellle/targets.vim",
		cond  = false,
		event = { "BufReadPost", "BufNewFile" }
	},

	-- {
	--     "neoclide/coc.nvim",
	--     event = "VeryLazy",
	--     branch = 'release',
	--     build =
	--     ':CocInstall coc-json coc-yaml coc-snippets coc-ultisnips coc-css coc-eslint coc-prettier coc-tsserver coc-vetur coc-pyright coc-rust-analyzer coc-elixir coc-diagnostic coc-stylelint coc-flutter'
	-- },

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true
	},

	{
		"junegunn/vim-easy-align",
		event = "VeryLazy"
	},

	{
		"NvChad/nvim-colorizer.lua",
		event  = { "BufReadPost", "BufNewFile" },
		config = true,
	},

	"gpanders/editorconfig.nvim",

	{
		-- git remote set-url origin --push "git@github.com:trailblazing/boot.git"
		"trailblazing/boot",
		event = { "VimEnter" },
		lazy  = false,
	},

	{
		-- git remote set-url origin --push "git@github.com:trailblazing/keys.git"
		"trailblazing/keys",
		-- cond  = false,
		event = { "VimEnter" },
		lazy  = false,
	},

	{
		-- git remote set-url origin --push "git@github.com:trailblazing/session_auto.git"
		"trailblazing/session_auto",
		event = { "VimEnter", "VimLeavePre" },
		lazy  = false,
	},

	{
		-- git remote set-url origin --push "git@github.com:trailblazing/vim-buffergator.git"
		"trailblazing/vim-buffergator",
		event = { "VimEnter" },
		lazy  = true,
	},

	{
		"preservim/tagbar",
		event = { "VimEnter" },
		lazy  = true,
	},

	{
		'lambdalisue/nerdfont.vim',
		event = "VeryLazy",
		lazy  = true,
	},

	-- The default shortcut "-" is very bad
	{
		'justinmk/vim-dirvish',
		cond   = false,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"chrisbra/vim-sh-indent",
		cond   = false,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"nvim-lua/plenary.nvim",
		event = "VeryLazy",
		lazy  = true,
	},

	-- Telescope (Fuzzy Finder)
	-- Added these plugins to install Telescope
	-- {
	--  'nvim-telescope/telescope.nvim',
	--  event = "VeryLazy",
	--  lazy = true,
	--  -- lazy = false,
	--  dependencies = {
	--      {'nvim-lua/plenary.nvim'},
	--      {'BurntSushi/ripgrep'},
	--      {'sharkdp/fd'},
	--      {'nvim-telescope/telescope-fzf-native.nvim'},
	--  },
	--  after = {
	--      'nvim-lspconfig',
	--      'nvim-treesitter',
	--  },
	--  cmd = 'Telescope',
	--  module = "telescope",
	--  -- config = function() require("telescope").setup() end,
	-- },

	{
		"vimwiki/vimwiki",
		dependencies = {
			{'Konfekt/FastFold'},
		},
		-- "lervag/wiki.vim",
		-- https://www.reddit.com/r/neovim/comments/ksyydr/how_to_convert_vimwiki_list_variable_to_lua/
		config = function()
			vim.g.vimwiki_global_ext = 0

			local wiki = {}

			wiki.path = '~/.wiki/'
			wiki.syntax = 'markdown'
			wiki.ext = '.md'

			local wiki_personal = {}
			wiki_personal.path = '~/.vimwiki_personal/'
			wiki_personal.syntax = 'markdown'
			wiki_personal.ext = '.md'

			vim.g.vimwiki_list = {
				wiki, wiki_personal
				-- {
				--  path = '~/.wiki/',
				--  syntax = 'markdown',
				--  ext = '.md',
				-- },
				-- {
				--  path = '~/.vimwiki_personal/',
				--  syntax = 'markdown',
				--  ext = '.md',
				-- },
			}
			-- https://stackoverflow.com/questions/65549814/setting-vimwiki-list-in-a-lua-init-file
			vim.g.vimwiki_ext2syntax = {['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown'}
		end,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"godlygeek/tabular",
		event = "VeryLazy",
		lazy  = true,
	},

	-- TSInstall markdown
	-- TSInstall markdown_inline
	-- Fixed <Enter> generate markdown link issue ( when without this plugin? ) -- No
	-- session_auto sent the feedkeys of <Enter>
	{
		"tadmccorkle/markdown.nvim",
		event = "VeryLazy",
		lazy  = true,
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
			-- configuration here or empty for defaults
		},
	},

	--
	--  vimwiki and vim-markdown <Enter> issue #514
	-- https://github.com/vimwiki/vimwiki/issues/514
	{
		-- $HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim
		-- b:Markdown_GetUrlForPosition -> s:Markdown_GetUrlForPosition
		"preservim/vim-markdown",
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"MDeiml/tree-sitter-markdown",
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
	},
	--
	-- Rainbow Highlighting
	{
		"HiPhish/rainbow-delimiters.nvim",
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
	},

	-- Always report error
	-- RetabIndent
	{
		"Thyrum/vim-stabs",
		-- cond  = false,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"mbbill/undotree",
		-- event = "VeryLazy",
		-- lazy  = true,
		lazy  = false,
	},

	{
		"folke/neodev.nvim",
		opts   = {},
		event  = "VeryLazy",
		lazy   = true,
	},

	-- Copy from nvim to tmux [TextYankPost]
	-- set.clipboard = set.clipboard + "unnamedplus"
	-- [TextYankPost], needs "lazy = false,"
	-- Void session_auto saved old session -- restart a brand new session
	{
		"roxma/vim-tmux-clipboard",
		dependencies = {
			{'tmux-plugins/vim-tmux-focus-events'},
		},
		opts     = {},
		-- event = "VeryLazy",
		lazy     = false,
		config   = function() end,
	},

	-- proper syntax highlighting
	-- commentstring - so that plugins like vim-commentary work as intended
	-- K - jumps to the *exact* place in man tmux where the word under cursor is explained (a helluva time saver). This should work correctly on practically anything in .tmux.conf.
	-- :make - invokes tmux source .tmux.conf and places all the errors (if any) in quicklist
	-- g! - executes lines as tmux commands. Works on visual selection or as a motion. g!! executes just the current line.
	{
		"tmux-plugins/vim-tmux",
		opts     = {},
		-- event = "VeryLazy",
		lazy     = true,
		config   = true,
	},

	-- Copy from nvim to tmux ? [TextYankPost]
	-- As my workflow has changed over time, I no longer use tmux. This means that while I will continue to maintain this plugin, I will no longer implement fixes, features, or maintenance. PRs are always welcome and will be merged upon review.
	-- set.clipboard = set.clipboard + "unnamedplus"
	-- "show-buffer -s" error
	{
		"aserowy/tmux.nvim",
		cond   = false,
		opts   = {},
		event  = "VeryLazy",
		lazy   = true,
		config = function() return require("tmux").setup() end,
	},

	{
		"vigoux/notifier.nvim",
		cond   = false,
		event  = "VeryLazy",
		lazy   = true,
		config = function()
			require'notifier'.setup {
				-- You configuration here
			}
		end
	},

	{
		"j-hui/fidget.nvim",
		-- event  = "VeryLazy",
		-- lazy   = true,
		opts = {
			-- options
		},
	},

	{
		"ggandor/leap.nvim",
		dependencies = {
			{
				"trailblazing/vim-repeat",
			},
		},
		config = function ()
			require('leap').create_default_mappings()
		end,
		event  = "VeryLazy",
		lazy   = true,
		cond   = false,
	},

	{
		"inkarkat/vim-ShowTrailingWhitespace",
		cond   = false,
		event  = "VeryLazy",
		lazy   = true,
	},

	-- {
	--  "toppair/peek.nvim",
	--  event = { "VeryLazy" },
	--  build = "deno task --quiet build:fast",
	--  config = function()
	--      require("peek").setup({
	--          auto_load = true,         -- whether to automatically load preview when
	--          -- entering another markdown buffer
	--          close_on_bdelete = true,  -- close preview window on buffer delete

	--          syntax = true,            -- enable syntax highlighting, affects performance

	--          theme = 'dark',           -- 'dark' or 'light'

	--          update_on_change = true,

	--          app = 'webview',          -- 'webview', 'browser', string or a table of strings
	--          -- explained below

	--          filetype = { 'markdown' },-- list of filetypes to recognize as markdown

	--          -- relevant if update_on_change is true
	--          throttle_at = 200000,     -- start throttling when file exceeds this
	--          -- amount of bytes in size
	--          throttle_time = 'auto',   -- minimum amount of time in milliseconds
	--          -- that has to pass before starting new render
	--      })
	--      -- refer to `configuration to change defaults`
	--      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
	--      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	--  end,
	-- },


	-- Make posix shell extremely slow
	{
		"RRethy/vim-illuminate",
		cond   = false,
		event  = "VeryLazy",
		lazy   = true,
	},

	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
	},

	{
		"nvim-treesitter/playground",
		cond   = false,
		event  = "VeryLazy",
		lazy   = true,
	},

	{
		"nacro90/numb.nvim",
		event  = "VeryLazy",
		lazy   = true,
		config = function()
			require("numb").setup {
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
				hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
				number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
				centered_peeking = true, -- Peeked line will be centered relative to window
			}
		end
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		event  = "VeryLazy",
		lazy   = true,
	},




}

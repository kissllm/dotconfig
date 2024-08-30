

return {
	-- Does not work
	{
		"trailblazing/vim-repeat",
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
		-- lazy  = false,
	},

	{
		"ahmedkhalf/project.nvim",
		config = function()
			return require("project_nvim").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end,
	},

	-- Moved to file
	-- {
	--  -- https://gitee.com/kongjun18/nvim-tree.lua
	--  "kyazdani42/nvim-tree.lua",
	--  dependencies = {
	--      "kyazdani42/nvim-web-devicons" ,
	--      -- https://stackoverflow.com/questions/71346431/neovim-nvim-tree-doesnt-open-current-directory-only-the-parent-directory-with-g
	--      "ahmedkhalf/project.nvim",
	--  },
	--  cond = false,
	--  -- cond = true,
	--  cmd  = "NvimTreeToggle",
	-- },

	-- Does not work
	{
		"tpope/vim-unimpaired",
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
	},

	{
		"tpope/vim-surround",
		cond  = false,
		event = { "BufReadPost", "BufNewFile" }
	},

	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
	},

	{
		"tpope/vim-eunuch",
		event = "VeryLazy",
	},

	"thinca/vim-localrc",

	{
		"simnalamburt/vim-mundo",
		event = "VeryLazy",
	},

	-- Tons of errors puped up
	{
		"wellle/targets.vim",
		cond  = false,
		event = { "BufReadPost", "BufNewFile" }
	},

	{
		"neoclide/coc.nvim",
		cond   = false,
		event  = "VeryLazy",
		branch = 'release',
		build  =
			':CocInstall coc-json coc-yaml coc-snippets coc-ultisnips coc-css coc-eslint coc-prettier coc-tsserver coc-vetur coc-pyright coc-rust-analyzer coc-elixir coc-diagnostic coc-stylelint coc-flutter'
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
	},

	{
		"junegunn/vim-easy-align",
		event = "VeryLazy",
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
		"yuntan/neovim-indent-guides",
		cond     = false,
		-- event = "VeryLazy",
		event    = "VimEnter",
		lazy     = true,
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
	--  -- config = function() return require("telescope").setup() end,
	-- },


	{
		'renerocksai/telekasten.nvim',
		dependencies = {'nvim-telescope/telescope.nvim'},
		event = "VeryLazy",
		lazy  = true,
		config = function()
			return require('telekasten').setup({
				-- home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
				home = vim.fn.expand("~/.wiki"), -- Put the name of your notes directory here
			})
		end,
	},

	{
		-- "lervag/wiki.vim",
		"lervag/wiki.vim",
		event   = "VeryLazy",
		-- lazy = false,
		lazy    = true,
		config  = function()
			vim.g.wiki_root = "~/.wiki"
			vim.cmd([[
			let g:wiki_root = '~/.wiki'
			]])
		end,
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
		cond  = false,
		event = "VeryLazy",
		lazy  = true,
		ft    = "markdown", -- or 'event = "VeryLazy"'
		opts  = {
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

	{
		-- Always report error
		-- RetabIndent
		-- Insert "0" at the beginning of the next line when inputting <Enter>
		-- "Thyrum/vim-stabs",
		-- RetabIndent
		-- Does not insert "0" at the beginning of the next line when inputting <Enter>
		"rhlobo/vim-super-retab",
		-- cond  = false,
		cond  = true,
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

	-- E353: Nothing in register " especially in tty
	-- Copy from nvim to tmux [TextYankPost]
	-- set.clipboard = set.clipboard + "unnamedplus"
	-- [TextYankPost], needs "lazy = false,"
	-- Void session_auto saved old session -- restart a brand new session
	{
		"roxma/vim-tmux-clipboard",
		-- Update: this plugin is now obsolete and no longer needed as both neovim and vim (since version 8.2.2345) have native support for this functionality.
		-- dependencies = {
		--  {'tmux-plugins/vim-tmux-focus-events'},
		-- },
		-- https://github.com/roxma/vim-tmux-clipboard/issues/7
		cond     = false,
		opts     = {},
		-- event    = "VeryLazy",
		event     = "TextYankPost",
		-- lazy     = true,
		lazy     = false,
		config   = function()
			vim.cmd([[
			" let g:vim_tmux_clipboard#loadb_option = '-w'
			]])
		end,
	},

	-- E353: Nothing in register " especially in tty
	-- Copy from nvim to tmux ? [TextYankPost]
	-- As my workflow has changed over time, I no longer use tmux. This means that while I will continue to maintain this plugin, I will no longer implement fixes, features, or maintenance. PRs are always welcome and will be merged upon review.
	-- set.clipboard = set.clipboard + "unnamedplus"
	-- "show-buffer -s" error
	{
		"aserowy/tmux.nvim",
		cond      = false,
		opts      = {
			copy_sync = {
				-- enable = false,
				enable = true,
				-- redirect_to_clipboard = false,
				redirect_to_clipboard = true,
			},
			navigation = {
				-- enable_default_keybindings = true,
				enable_default_keybindings = false,
			},
		},
		-- event  = "VeryLazy",
		event     = "TextYankPost",
		-- lazy   = true,
		lazy      = false,
		config = function()
			return require("tmux").setup({
				copy_sync = {
					-- enable = false,
					enable = true,
					-- redirect_to_clipboard = false,
					redirect_to_clipboard = true,
				},
				navigation = {
					-- enable_default_keybindings = true,
					enable_default_keybindings = false,
				},
			})
		end,
	},

	{
		"bfredl/nvim-miniyank",
		lazy     = true,
		config   = true,
	},

	-- proper syntax highlighting when editing .tmux.conf
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

	{
		"vigoux/notifier.nvim",
		cond   = false,
		event  = "VeryLazy",
		lazy   = true,
		config = function()
			return require'notifier'.setup {
				-- You configuration here
			}
		end
	},

	-- {
	--  "j-hui/fidget.nvim",
	--  -- event  = "VeryLazy",
	--  -- lazy   = true,
	--  dependencies = { "rcarriga/nvim-notify" },
	--  config = function()
	--      return require'fidget'.setup {
	--          -- You configuration here
	--      }
	--  end,
	-- },

	{
		"ggandor/leap.nvim",
		dependencies = {
			{
				"trailblazing/vim-repeat",
			},
		},
		config = function ()
			return require('leap').create_default_mappings()
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
	--      return require("peek").setup({
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
			return require("numb").setup {
				show_numbers         = true,   -- Enable 'number' for the window while peeking
				show_cursorline      = true,   -- Enable 'cursorline' for the window while peeking
				hide_relativenumbers = true,   -- Enable turning off 'relativenumber' for the window while peeking
				number_only          = false,  -- Peek only when the command is only a number instead of when it starts with a number
				centered_peeking     = true,   -- Peeked line will be centered relative to window
			}
		end
	},

	{
		"catppuccin/nvim",
		name     = "catppuccin",
		priority = 1000,
		event    = "VeryLazy",
		lazy     = true,
	},

	{
		'aymericbeaumet/vim-symlink',
		cond   = false,
		dependencies = { 'moll/vim-bbye' },
		-- event  = "VeryLazy",
		lazy   = false,
	},

	{
		"lambdalisue/suda.vim",
		-- cond   = false,
		event  = "VeryLazy",
		lazy   = true,
	},

	{
		"tadhg-ohiggins/vim-tmux-send",
		event  = "VeryLazy",
		lazy   = true,
	},

	-- outline
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
		{ "<leader>tt", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			-- Your setup opts here
		},
	},

	-- outline
	{
		'stevearc/aerial.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		event  = "VeryLazy",
		lazy   = true,
	},

	{
		"christoomey/vim-tmux-navigator",
		cond   = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	{

	},
}

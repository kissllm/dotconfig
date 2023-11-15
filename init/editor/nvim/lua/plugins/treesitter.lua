
local function ts_disable(_, bufnr)
	return api.nvim_buf_line_count(bufnr) > 5000
end

return {
	"nvim-treesitter/nvim-treesitter",
	-- requires = { "nvim-treesitter/nvim-treesitter-refactor", opt = false },
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-refactor" },
	},
	build = ":TSUpdate",
	-- Lazy does not know it
	-- run = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {

		-- one of "all", "maintained" (parsers with maintainers), or a list of languages
		-- A list of parser names, or "all"
		--
		-- [lsp-zero] The function .ensure_installed() has been removed.
			-- Use the module mason-lspconfig to install your LSP servers.
			-- See :help lsp-zero-guide:integrate-with-mason-nvim

		-- ensure_installed = "maintained",
		-- ensure_installed = { "c", "lua", "rust" },
		-- Add a language of your choice
		-- ensure_installed = "all", -- one of "all", "maintained", or a list of languages
		-- ensure_installed = { "cpp", "python", "lua", "java", "javascript", "rust" },
		-- ensure_installed = { "cpp", "python", "lua", "javascript", "rust" },

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- List of parsers to ignore installing (for "all")
		-- ignore_install = { "javascript" },
		-- ignore_install = { "css" }, -- List of parsers to ignore installing
		ignore_install = { "" }, -- List of parsers to ignore installing


		-- highlight = {
		--  enable = true,  -- enable = true (false will disable the whole extension)
		--  disable = {},   -- list of language that will be disabled
		--  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		--  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		--  -- Using this option may slow down your editor, and you may see some duplicate highlights.
		--  -- Instead of true it can also be a list of languages
		--  additional_vim_regex_highlighting = false
		-- },
		highlight = {
			enable = true, -- false will disable the whole extension
			-- disable = { "" }, -- list of language that will be disabled
			disable = function(lang, bufnr)
				return lang == "cmake" or ts_disable(lang, bufnr)
			end,

			additional_vim_regex_highlighting = true,

		},
		-- Error detected while processing function StabsFixAlign[43]..function StabsFixAlign[25]..nvim_treesitter#indent:
		-- line    1:
		-- E48: Not allowed in sandbox
		-- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable/
		-- 'Vimjas/vim-python-pep8-indent'
		indent = { enable = false },
		-- indent = { enable = true, disable = { "yaml" } },
		-- indent = {
		-- 	enable = true,
		-- },
		--
		-- https://medium.com/@shaikzahid0713/rainbow-parenthesis-and-indentation-in-neovim-dd379f4e516f
		-- [nvim-treesitter has deprecated the module system](https://gitlab.com/HiPhish/rainbow-delimiters.nvim)
		-- rainbow = {
		-- 	enable = true,
		-- 	-- list of languages you want to disable the plugin for
		-- 	-- disable = { "jsx", "cpp" },
		-- 	-- Which query to use for finding delimiters
		-- 	query = 'rainbow-parens',
		-- 	-- Highlight the entire buffer all at once
		-- 	strategy = require 'rainbow_delimiters.strategy.global',
		-- 	-- Do not enable for files with more than n lines
		-- 	max_file_lines = 3000
		-- },

		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
			disable = { "ruby" }, -- optional, list of language that will be disabled
		},

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			disable = { "c", "rust" },

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			-- additional_vim_regex_highlighting = false,
			-- https://paste.rs/BW9.lua
			-- Make `:set spell` only hightlight misspelled words in strings and comments
			-- additional_vim_regex_highlighting = true,
			-- additional_vim_regex_highlighting = false,
			additional_vim_regex_highlighting = {
				cpp = true,
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		playground = {
			enable = true,
			updatetime = 25,
		},
		refactor = {
			highlight_definitions = {
				enable = true,
				-- Set to false if you have an `updatetime` of ~100.
				clear_on_cursor_move = true,
			},
			highlight_current_scope = { enable = true },
			smart_rename = {
				enable = true,
				keymaps = {
					smart_rename = "grr",
				},
			},
			navigation = {
				enable = true,
				keymaps = {
					goto_definition = "gnd",
					list_definitions = "gnD",
					list_definitions_toc = "gO",
					goto_next_usage = "<a-*>",
					goto_previous_usage = "<a-#>",
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}

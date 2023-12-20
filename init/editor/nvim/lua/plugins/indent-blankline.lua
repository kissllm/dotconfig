-- https://github.com/jdhao/nvim-config/blob/master/lua/config/indent-blankline.lua
-- Merged from:
-- https://medium.com/@shaikzahid0713/rainbow-parenthesis-and-indentation-in-neovim-dd379f4e516f
-- indentline-config.lua


-- vim.opt.list = true
return {
	'lukas-reineke/indent-blankline.nvim',
	dependencies = {
		{
			'HiPhish/rainbow-delimiters.nvim',
			config = function()
				-- This module contains a number of default definitions
				local rainbow_delimiters = require 'rainbow-delimiters'
				vim.g.rainbow_delimiters = {
					strategy = {
						['']  = rainbow_delimiters.strategy['global'],
						vim   = rainbow_delimiters.strategy['local'],
					},
					query = {
						['']  = 'rainbow-delimiters',
						lua   = 'rainbow-blocks',
					},
					highlight = {
						'RainbowDelimiterRed',
						'RainbowDelimiterYellow',
						'RainbowDelimiterBlue',
						'RainbowDelimiterOrange',
						'RainbowDelimiterGreen',
						'RainbowDelimiterViolet',
						'RainbowDelimiterCyan',
					},
				}
			end,
		},
	},

	main = "ibl",
	-- opt = true,
	enabled = true,
	cond    = true,
	-- The following line will kill ibl from loading
	-- lazy = false,

	-- enabled = false,
	-- cond    = false,
	--
	-- cond = function() return false end,
	event = { "BufRead", "BufReadPost", "BufNewFile", "WinEnter", "BufEnter" },

	config = function()

		local exclude_ft = {
			"help",
			'txt',
			'log',
			"git",
			"markdown",
			"snippets",
			"text",
			"gitconfig",
			"alpha",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NvimTree",
			"Trouble",
		}

		-- vim.g.indentLine_enabled = 1
		-- vim.opt.termguicolors = true

		-- vim.cmd [[hi! RainbowRed    guifg=#E06C75 guibg=NONE gui=nocombine ctermfg=Brown  ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowYellow guifg=#E5C07B guibg=NONE gui=nocombine ctermfg=Yellow ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowGreen  guifg=#98C379 guibg=NONE gui=nocombine ctermfg=Green  ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowCyan   guifg=#56B6C2 guibg=NONE gui=nocombine ctermfg=Cyan   ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowBlue   guifg=#61AFEF guibg=NONE gui=nocombine ctermfg=Blue   ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowViolet guifg=#C678DD guibg=NONE gui=nocombine ctermfg=Red    ctermbg=NONE cterm=nocombine term=NONE ]]
		-- vim.cmd [[hi! RainbowOrange guifg=#D19A66 guibg=NONE gui=nocombine ctermfg=White  ctermbg=NONE cterm=nocombine term=NONE ]]
		--
		-- This is out of date
		-- local highlight = {
		--  "RainbowRed",
		--  "RainbowYellow",
		--  "RainbowBlue",
		--  "RainbowOrange",
		--  "RainbowGreen",
		--  "RainbowViolet",
		--  "RainbowCyan",
		-- }

		-- local highlight_delimiter = {
		local highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterYellow",
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		}

		local highlight_guides = {
			"CursorColumn",

			-- "Whitespace",
			-- "Comment",
			"SignColumn",
		}

		local highlight_empty = {
			-- "Whitespace",
			-- "Comment",
			"SignColumn",

			-- "SignColumn",
			"CursorColumn",
		}

		local opts = {

			enabled = true,
			-- disable_with_nolist = true,
			-- show_trailing_blankline_indent = true,
			-- show_trailing_blankline_indent = false,
			-- show_first_indent_level        = false,
			exclude = {
				-- filetype_exclude = exclude_ft,
				filetypes          = exclude_ft,
				-- buftype_exclude = { 'terminal', "nofile" },
				buftypes           = { 'terminal', "nofile" },
			},
			-- viewport_buffer     = 20,
			whitespace = {
				-- highlight = "IndentBlanklineSpaceChar",
				-- highlight = highlight,

				highlight = highlight_guides,
				-- highlight = highlight_empty,

				remove_blankline_trail = false,
			},
			indent = {
				-- https://www.compart.com/en/unicode/U+2502
				-- U+2502 may also be a good choice, it will be on the middle of cursor.
				-- https://www.compart.com/en/unicode/U+250A
				-- U+250A is also a good choice
				-- char = "⦚",  -- "U+299A"
				-- Won't show correctly in tty (left aligned vertical line)
				-- char = "▏",  -- "U+258F"
				-- Won't show correctly in tty (vertical dots in GUI)
				-- char = "┊",  -- "U+250A"
				-- char = "│",  -- "U+2502"
				-- char = "︳", -- "U+FE33"
				-- char = "▎",  -- "U+258E"
				char = "",
				-- char = "│",  -- "U+2502"
				-- char = "∣",  -- "U+2223"
				-- char = "|",  -- "U+007C"
				-- char = "❘",  -- "U+2758"
				-- char = "│",  -- "U+2502"
				-- For RainbowDelimiter
				-- highlight = highlight,

				-- highlight = highlight_guides,

				highlight = highlight_empty,

				-- highlight = highlight,
				-- char_highlight_list            = {
					--  "RainbowRed",
					--  "RainbowYellow",
					--  "RainbowGreen",
					--  "RainbowCyan",
					--  "RainbowBlue",
					--  "RainbowViolet",
					-- },
				tab_char = "│", -- "U+2502"
			},
			-- TSCurrentScope sets this?
			scope = {
				-- injected_languages = true,
				-- enabled      = true,
				enabled      = false,
				-- reverse      = true,
				-- highlight = highlight,
				-- highlight = "IndentBlanklineContextChar",
				highlight    = "Function",
				show_start   = false,
				show_end     = false,
				include = {
					node_type = {
						["*"] = { "*" },
					},
				},
			},

			-- show_current_context_start_on_current_line = false,

			-- The following options all were out of date
			-- show_first_indent_level     = false,
			-- Equal to scope.enabled
			-- show_current_context        = true,
			-- show_current_context_start  = true,
			-- strict_tabs                 = true,
			-- context_char                = "│",
			-- use_treesitter              = true,
    		-- show_foldtext               = false,
			-- space_char_blankline        = " ",
		}

		-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/172
		-- context_patterns = {
		vim.g.indent_blankline_context_patterns = {
			"class",
			"return",
			"function",
			"method",
			"^if",
			"^while",
			"jsx_element",
			"^for",
			"^object",
			"^table",
			"block",
			"arguments",
			"if_statement",
			"else_clause",
			"jsx_element",
			"jsx_self_closing_element",
			"try_statement",
			"catch_clause",
			"import_statement",
			"operation_type",
			-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/61
			"abstract_class_declaration", "abstract_method_signature",
			"accessibility_modifier", "ambient_declaration", "arguments", "array",
			"array_pattern", "array_type", "arrow_function", "as_expression",
			"asserts", "assignment_expression", "assignment_pattern",
			"augmented_assignment_expression", "await_expression",
			"binary_expression", "break_statement", "call_expression",
			"call_signature", "catch_clause", "class", "class_body",
			"class_declaration", "class_heritage", "computed_property_name",
			"conditional_type", "constraint", "construct_signature",
			"constructor_type", "continue_statement", "debugger_statement",
			"declaration", "decorator", "default_type", "do_statement",
			"else_clause", "empty_statement", "enum_assignment", "enum_body",
			"enum_declaration", "existential_type", "export_clause",
			"export_specifier", "export_statement", "expression",
			"expression_statement", "extends_clause", "finally_clause",
			"flow_maybe_type", "for_in_statement", "for_statement",
			"formal_parameters", "function", "function_declaration",
			"function_signature", "function_type", "generator_function",
			"generator_function_declaration", "generic_type", "if_statement",
			"implements_clause", "import", "import_alias", "import_clause",
			"import_require_clause", "import_specifier", "import_statement",
			"index_signature", "index_type_query", "infer_type",
			"interface_declaration", "internal_module", "intersection_type",
			"jsx_attribute", "jsx_closing_element", "jsx_element", "jsx_expression",
			"jsx_fragment", "jsx_namespace_name", "jsx_opening_element",
			"jsx_self_closing_element", "labeled_statement", "lexical_declaration",
			"literal_type", "lookup_type", "mapped_type_clause",
			"member_expression", "meta_property", "method_definition",
			"method_signature", "module", "named_imports", "namespace_import",
			"nested_identifier", "nested_type_identifier", "new_expression",
			"non_null_expression", "object", "object_assignment_pattern",
			"object_pattern", "object_type", "omitting_type_annotation",
			"opting_type_annotation", "optional_parameter", "optional_type", "pair",
			"pair_pattern", "parenthesized_expression", "parenthesized_type",
			"pattern", "predefined_type", "primary_expression", "program",
			"property_signature", "public_field_definition", "readonly_type",
			"regex", "required_parameter", "rest_pattern", "rest_type",
			"return_statement", "sequence_expression", "spread_element",
			"statement", "statement_block", "string", "subscript_expression",
			"switch_body", "switch_case", "switch_default", "switch_statement",
			"template_string", "template_substitution", "ternary_expression",
			"throw_statement", "try_statement", "tuple_type",
			"type_alias_declaration", "type_annotation", "type_arguments",
			"type_parameter", "type_parameters", "type_predicate",
			"type_predicate_annotation", "type_query", "unary_expression",
			"union_type", "update_expression", "variable_declaration",
			"variable_declarator", "while_statement", "with_statement",
			"yield_expression"
		}
		-- Version 2
		-- local indent_blankline = require('indent_blankline')
		-- Version 3
		local api    = vim.api
		local set_hl = api.nvim_set_hl
		local ibl    = require('ibl')
		ibl.setup(opts)

		-- vim.g.show_first_indent_level = 0
		-- vim.g.indentLine_enabled = 1
		-- vim.g.indent_blankline_enabled = 1
		-- vim.opt.termguicolors = true
		-- vim.wo.colorcolumn = "99999"
		-- vim.opt.list = true
		local gid = api.nvim_create_augroup("indent_blankline", { clear = true })

		-- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
		-- vim.wo.colorcolumn = "99999"
		-- vim.g.rainbow_delimiters = { highlight = highlight }

		local hooks = require "ibl.hooks"
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- set_hl(0, "RainbowRed",    { fg = "#E06C75" })
			-- set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
			-- set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
			-- set_hl(0, "RainbowOrange", { fg = "#D19A66" })
			-- set_hl(0, "RainbowGreen",  { fg = "#98C379" })
			-- set_hl(0, "RainbowViolet", { fg = "#C678DD" })
			-- set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
		end)

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

		-- ~/.local/share/nvim/lazy/rainbow-delimiters.nvim/plugin/rainbow-delimiters.lua
		-- hooks.register(hooks.type.SCOPE_HIGHLIGHT, function()
		--  set_hl(0, 'RainbowDelimiterRed'   , {default = true, fg = '#cc241d', ctermfg= 'Red'    })
		--  set_hl(0, 'RainbowDelimiterOrange', {default = true, fg = '#d65d0e', ctermfg= 'White'  })
		--  set_hl(0, 'RainbowDelimiterYellow', {default = true, fg = '#d79921', ctermfg= 'Yellow' })
		--  set_hl(0, 'RainbowDelimiterGreen' , {default = true, fg = '#689d6a', ctermfg= 'Green'  })
		--  set_hl(0, 'RainbowDelimiterCyan'  , {default = true, fg = '#a89984', ctermfg= 'Cyan'   })
		--  set_hl(0, 'RainbowDelimiterBlue'  , {default = true, fg = '#458588', ctermfg= 'Blue'   })
		--  set_hl(0, 'RainbowDelimiterViolet', {default = true, fg = '#b16286', ctermfg= 'Magenta'})
		-- end)
		--
		--
		-- show_first_indent_level        = false,
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

		-- api.nvim_create_autocmd("InsertEnter", {
		--  pattern = "*",
		--  group = gid,
		--  command = "IndentBlanklineDisable",
		-- })

		-- api.nvim_create_autocmd("InsertLeave", {
		--  pattern = "*",
		--  group = gid,
		--  callback = function()
		--      if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
		--          vim.cmd([[IndentBlanklineEnable]])
		--      end
		--  end,
		-- })
	end,
}








local M = {}
local cmp      = require("cmp")
print("cmp: \n" .. serialize(cmp))
local cmp_api  = require("cmp.utils.api")
local feedkeys = require('cmp.utils.feedkeys')
local keymap   = require('cmp.utils.keymap')

-- Handle the various cases where a tab character may be used
local function tab_completion(select_item_action)
	local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
	return function(fallback)
		-- tabs should only pass through when there's no text preceding the cursor
		local _, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line_prefix = string.sub(vim.api.nvim_get_current_line(), 1, col)
		local all_whitespace = line_prefix:match("^%s*$") ~= nil
		if cmp.visible() then
			-- We're selecting a menu item
			select_item_action(cmp_select_opts)
		elseif cmp_api.is_insert_mode() and all_whitespace then
			-- We're not actively completing, pass through
			fallback()
		else
			-- We're completing a word, load the completions
			cmp.complete()
		end
	end
end

local function confirm_completion(fallback)
	-- from cmp https://github.com/hrsh7th/nvim-cmp/issues/1326
	if vim.fn.pumvisible() == 1 then
		-- native pumenu
		-- workaround for neovim/neovim#22892
		if vim.fn.complete_info({ "selected" }).selected == -1 then
			-- nothing selected, insert newline
			feedkeys.call(keymap.t("<CR>"), "in")
		else
			-- something selected, confirm selection by stopping Ctrl-X mode
			-- :h i_CTRL-X_CTRL-Z*
			feedkeys.call(keymap.t("<C-X><C-Z>"), "in")
		end
	else
		-- `nvim-cmp` default confirm action
		-- Accept currently selected item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		cmp.mapping.confirm({ select = false })(fallback)
	end
end

function M.setup(settings)
	if settings ~= nil then
		local cmp_action = settings["cmp_action"]
	end
	local lspkind = require("lspkind")
	cmp.setup({
		-- Not sure if I need to swap to this new syntax at some point...
		-- mapping = cmp.mapping.preset.insert({})
		-- https://www.reddit.com/r/neovim/comments/15s4huv/cant_override_cr_in_lazyvim_nvimcmp_config/
		-- mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, { ... },
		mapping = {
			-- `Enter` key to confirm completion
			-- ['<CR>']   = cmp.mapping.confirm({ select = false }),
			-- ["<CR>"]   = cmp.config.disable,
			-- ['<CR>']   = confirm_completion,
			-- ["<CR>"] = cmp.mapping.confirm {
			-- 	behavior = cmp.ConfirmBehavior.Replace,
			-- 	select = false,
			-- },
			-- Ctrl+Space to trigger completion menu
			['<C-Space>'] = cmp.mapping.complete(),
			--  -- Ctrl+Space to trigger completion menu
			--  ['<C-Space>'] = cmp.mapping.complete(),

			--  -- Navigate between snippet placeholder
			--  ['<C-f>'] = cmp_action.luasnip_jump_forward(),
			--  ['<C-b>'] = cmp_action.luasnip_jump_backward(),
			-- Navigate between snippet placeholder
			['<C-b>']     = cmp.mapping.scroll_docs(-4),
			['<C-f>']     = cmp.mapping.scroll_docs(4),
			['<Tab>']     = cmp.mapping(tab_completion(cmp.select_next_item)),
			['<S-Tab>']   = cmp.mapping(tab_completion(cmp.select_prev_item)),
			-- ["<Tab>"] = cmp.mapping({
			--  c = function()
			--      if cmp.visible() then
			--          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			--      else
			--          cmp.complete()
			--      end
			--  end,
			--  i = function(fallback)
			--      if cmp.visible() and vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_forward)"), 'm', true)
			--      elseif cmp.visible() then
			--          cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
			--      elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_forward)"), 'm', true)
			--      else
			--          fallback()
			--      end
			--  end,
			--  s = function(fallback)
			--      if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_forward)"), 'm', true)
			--      else
			--          fallback()
			--      end
			--  end
			-- }),
			-- ["<S-Tab>"] = cmp.mapping({
			--  c = function()
			--      if cmp.visible() then
			--          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			--      else
			--          cmp.complete()
			--      end
			--  end,
			--  i = function(fallback)
			--      if cmp.visible() and vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_backward)"), 'm', true)
			--      elseif cmp.visible() then
			--          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Replace })
			--      elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_backward)"), 'm', true)
			--      else
			--          fallback()
			--      end
			--  end,
			--  s = function(fallback)
			--      if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
			--          vim.api.nvim_feedkeys(repterm("<Plug>(ultisnips_jump_backward)"), 'm', true)
			--      else
			--          fallback()
			--      end
			--  end
			-- }),
			["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }), {'i'}),
			["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }), {'i'}),
			["<C-n>"] = cmp.mapping({
				c = function()
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
					else
						vim.api.nvim_feedkeys(repterm('<Down>'), 'n', true)
					end
				end,
				i = function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
					else
						fallback()
					end
				end
			}),
			["<C-p>"] = cmp.mapping({
				c = function()
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Replace })
					else
						vim.api.nvim_feedkeys(repterm('<Up>'), 'n', true)
					end
				end,
				i = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Replace })
					else
						fallback()
					end
				end
			}),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
			["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
			-- ['<CR>'] = { '\n', '\r', '\r\n' },
			-- ["<CR>"] = cmp.mapping({
			--  -- i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			--  i = function(fallback)
			--      if cmp.visible() then
			--          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
			--      elseif not cmp.confirm({ select = true }) then
			--          require("pairs.enter").type()
			--      else
			--          fallback()
			--      end
			--  end,
			--  c = function(fallback)
			--      if cmp.visible() then
			--          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
			--      else
			--          fallback()
			--      end
			--  end
			-- }),
			-- https://www.reddit.com/r/neovim/comments/y19uyw/do_anybody_else_getting_this_error_in_nvimcmp/
			-- ['<CR>'] = cmp.mapping(function(fallback)
			-- if cmp.visible() then
			--      cmp.confirm({select = true})
			--  else
			--      local cr = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
			--      vim.api.nvim_feedkeys(cr, "n", false)
			--  end
			-- end),
			-- ['<CR>'] = function(fallback)
			--  -- Don't block <CR> if signature help is active
			--  -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
			--  if not cmp.visible() or not cmp.get_selected_entry() or cmp.get_selected_entry().source.name == 'nvim_lsp_signature_help' then
			--      fallback()
			--  else
			--      cmp.confirm({
			--          -- Replace word if completing in the middle of a word
			--          -- https://github.com/hrsh7th/nvim-cmp/issues/664
			--          behavior = cmp.ConfirmBehavior.Replace,
			--          -- Don't select first item on CR if nothing was selected
			--          select = false,
			--      })
			--  end
			-- end,
			-- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
			-- ['<CR>'] = cmp.mapping(function(fallback)
			--  -- workaround for https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
			--  if cmp.get_selected_entry().source.name == 'nvim_lsp_signature_help' then
			--      fallback()
			--  else
			--      cmp.mapping.confirm {
			--          behavior = cmp.ConfirmBehavior.Replace,
			--          select = true,
			--      }(fallback)
			--  end
			-- end),
		},
		window = {
			documentation = cmp.config.window.bordered(),
			completion    = cmp.config.window.bordered(),
		},
		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = lspkind.cmp_format({
				mode = "symbol",       -- show only symbol annotations
				maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				menu = ({
					-- buffer = "",
					buffer   = "#",
					-- nvim_lsp = "λ",
					nvim_lsp = "&",
					-- luasnip = "⋗",
					luasnip  = ">",
					-- nvim_lua = "󰢱",
					nvim_lua = "$",
					-- path = "🖫"
					path     = "/"
				}),
			})
		},
		sources = {
			{ name = 'path' },
			-- { name = "nvim_lsp" },
			-- { name = "nvim_lsp_signature_help" },
			-- { name = 'buffer', keyword_length = 3 },
			-- { name = 'luasnip', keyword_length = 2 },
			{ name = 'luasnip', option = { show_autosnippets = true } },
			-- { name = "ultisnips", priority = 90 },
			{ name = "nvim_lsp_signature_help", priority = 3 },  -- Disabled because using Noice.nvim for sig-help.
			{ name = "nvim_lua", priority = 2 },
			{ name = "nvim_lsp", priority = 2 },
			{ name = "buffer", keyword_length = 3, priority = 1 },
		},

		-- https://github.dev/Aumnescio/dotfiles/blob/c647e3a73150af8eb0eb0713cda2667f11c07571/nvim/init.lua#L677
		--
		enabled = function()
			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
			return true
		end,  -- Disables completion in Telescope.

		performance = {
			debounce = 80,
			throttle = 80,
		},

		-- [how to prevent enter key select first suggestion of nvim-cmp?](https://www.reddit.com/r/neovim/comments/10x2ryc/how_to_prevent_enter_key_select_first_suggestion/)
		preselect = cmp.PreselectMode.None,  -- Alt: cmp.PreselectMode.Item

		-- snippet = {
		--  expand = function(args)
		--      vim.fn["UltiSnips#Anon"](args.body)
		--  end,
		-- },
		snippet = {
			expand = function(args)
				require'luasnip'.lsp_expand(args.body)
			end
		},

		completion = {
			-- autocomplete = cmp.TriggerEvent | false,
			keyword_length = 2,
			-- completeopt = "menu,menuone,preview,noselect,noinsert",
			completeopt = { "menuone" , "preview", "noselect", "noinsert", },
			-- vim.opt.completeopt = { "menuone", "noselect", "preview" }
		},

		matching = {
			disallow_fuzzy_matching = false,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = false,
		},

		-- Completion popup formatting.
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol',
				maxwidth = 36,
				before = function (entry, vim_item)
					return vim_item
				end
			})
		},

		sorting = {
			priority_weight = 3,
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.score,
				cmp.config.compare.kind,
				cmp.config.compare.exact,
				cmp.config.compare.recently_used,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			}
		},
	})
	return cmp
end

return M

-- Log address
-- lua =require('vim.lsp.log').get_filename()
-- $HOME/.local/state/nvim/lsp.log
-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
-- https://github.com/kabouzeid/nvim-lspinstall/wiki
-- keybindings.lua
local function on_attach(client, bufnr)
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
		vim.lsp.buf.semantic_tokens_full()
	end
end
-- https://github.com/nvim-lua/kickstart.nvim/blob/9b256d93688b3d295dab89f06faeff741af58a68/init.lua#L474-L488
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	"rust_analyzer",
	"bashls",
	"pyright",
	-- "marksman",
	"sourcekit",
	-- jsonls = {},
	-- glint = {},
	-- "pyright",
	-- ruff_lsp = {},
	-- rust_analyzer = {},
	-- "tsserver",
	-- cssls = {},
	-- }
	-- local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},
	"tsserver",
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },
	"lua_ls",
	-- lua_ls = {},
	-- lua_ls = {
	--  Lua = {
	--      workspace = { checkThirdParty = false },
	--      telemetry = { enable = false },
	--  },
	-- },
}

return {

	-- {
	-- 	"VonHeikemen/lsp-zero.nvim",
	-- 	cond = false,
	-- 	-- cond = true,
	-- 	-- lazy = true,
	-- 	lazy = false,
	-- 	-- branch = "v2.x",
	-- 	branch = "v3.x",
	-- 	dependencies = {
	-- 		-- LSP Support
	-- 		{ 'neovim/nvim-lspconfig' },              -- Required
	-- 		{ 'williamboman/mason.nvim' },            -- Optional
	-- 		{ 'williamboman/mason-lspconfig.nvim' },  -- Optional

	-- 		-- Autocompletion
	-- 		{ 'hrsh7th/nvim-cmp' },                   -- Required
	-- 		{ 'hrsh7th/cmp-nvim-lsp' },               -- Required
	-- 		{ 'hrsh7th/cmp-buffer' },                 -- Optional
	-- 		{ 'hrsh7th/cmp-path' },                   -- Optional
	-- 		{ 'saadparwaiz1/cmp_luasnip' },           -- Optional
	-- 		{ 'hrsh7th/cmp-nvim-lua' },               -- Optional

	-- 		-- Snippets
	-- 		{ 'rafamadriz/friendly-snippets' },       -- Optional
	-- 		{ 'L3MON4D3/LuaSnip',
	-- 			dependencies = { { 'rafamadriz/friendly-snippets' }, },
	-- 		},                   -- Required
	-- 	},
	-- 	config = function()
	-- 		-- local servers = { "jsonls", "lua_ls", "glint", "pyright", "ruff_lsp", "rust_analyzer", "tsserver", "cssls" }
	-- 		-- No such file
	-- 		-- require("lsp-zero.settings").preset({})
	-- 		-- https://github.com/VonHeikemen/lsp-zero.nvim
	-- 		-- Do not introduce "plugins.lspconfig" to package.path?
	-- 		-- Look into
	-- 		-- :lua print(serialize(vim.split(package.path, ";")))
	-- 		-- "~/.config/nvim/lua/?.lua" did this
	-- 		-- This is in the config tree (XDG_CONFIG_HOME)
	-- 		local lspzero = require("lspconfig.lsp-zero").setup()
	-- 		-- local lsp = require('lsp-zero').preset({})
	-- 		local lsp = lspzero["lsp"]
	-- 		if lsp ~= nil then
	-- 			lsp.preset('lsp-only')
	-- 		end
	-- 		if lsp then
	-- 			local log = require("log")
	-- 			if log then
	-- 				print(tostring(serialize(lsp)))
	-- 			else
	-- 				print(tostring(lsp))
	-- 			end
	-- 		else
	-- 			print("lsp doesn't initialzed")
	-- 			return
	-- 		end

	-- 		lsp.on_attach  = function(client, bufnr)
	-- 			-- see :help lsp-zero-keybindings
	-- 			-- to learn the available actions
	-- 			lsp.default_keymaps({ buffer = bufnr })

	-- 			local opts = { buffer = bufnr }

	-- 			-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
	-- 			vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
	-- 			vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
	-- 			vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)

	-- 		end
	-- 		--
	-- 		-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
	-- 		lsp.omnifunc.setup({
	-- 			tabcomplete      = true,
	-- 			trigger          = '<C-Space>',
	-- 			update_on_delete = true,
	-- 			autocomplete     = true,
	-- 			use_fallback     = true,
	-- 		})

	-- 		-- lsp.setup()
	-- 		-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
	-- 		-- LspInfo to see server list
	-- 		lsp.setup_servers(servers)
	-- 		lsp.setup()
	-- 	end,
	-- },

	{
		-- https://github.com/sspaeti/dotfiles/blob/master/nvim/lua/sspaeti/plugins/lsp/mason.lua
		'williamboman/mason.nvim',
		cmd   = "Mason",
		event = "BufReadPre",
		--no lazy loading
		-- lazy  = true,
		dependencies = {
			-- "jayp0521/mason-null-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- lazy = true,
		},
		config = function()
			-- import mason
			-- local mason = require("mason").setup()
			local mason = require("mason")

			local mason_tool_installer = require("mason-tool-installer")


			mason.setup({
				-- https://github.com/williamboman/mason.nvim/issues/1101
				registries = {
					"github:mason-org/mason-registry",
					"lua:mason-registry.index"
				},
				-- https://github.com/williamboman/nvim-lsp-installer/discussions/509
				PATH = "prepend", -- "skip" seems to cause the spawning error
				log_level = vim.log.levels.DEBUG,
				ui = {
					icons = {
						-- package_installed = "✓",
						package_installed = "v",
						-- package_pending = "➜",
						package_pending = "->",
						-- package_uninstalled = "✗"
						package_uninstalled = "x"
					}
				}
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",  -- prettier formatter
					"stylua",    -- lua formatter
					"isort",     -- python formatter
					"black",     -- python formatter
					"pylint",    -- python linter
					"eslint_d",  -- js linter
					-- "lua_ls",
					"bashls",
				},
			})

			local lspconfig = require('lspconfig')
			local configs   = require 'lspconfig.configs'
			-- local lspzero   = require("lspconfig.lsp-zero").setup()
			-- local lsp = lspzero["lsp"]
			-- local lsp = lspconfig.preset({})
			local lsp = lspconfig
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
			local get_servers  = require('mason-lspconfig').get_installed_servers

			-- import mason-lspconfig
			-- local mason_lspconfig = require("mason-lspconfig").setup()
			local mason_lspconfig = require("mason-lspconfig")

			local default_setup = function(server)
				require('lspconfig')[server].setup({
					capabilities = capabilities,
				})
			end

			mason_lspconfig.setup({
				-- [lsp-zero] The function .ensure_installed() has been removed.
				-- Use the module mason-lspconfig to install your LSP servers.
				-- See :help lsp-zero-guide:integrate-with-mason-nvim

				-- ensure_installed = servers,
				--
				-- ensure_installed = {
				--  -- Replace these with whatever servers you want to install
				--  "rust_analyzer",
				--  "tsserver",
				-- }
				automatic_installation = true,
				-- handlers = require('functions.mason.handlers').handlers,
				handlers = {
					-- lspzero.default_setup,
					default_setup,
					tsserver = function()
						require('lspconfig').tsserver.setup({
							single_file_support = false,
							on_attach = function(client, bufnr)
								print('hello tsserver')
							end
						})
					end,
				}
			})

			for _, server_name in ipairs(get_servers()) do
			--  https://www.reddit.com/r/neovim/comments/109gdka/how_can_i_disable_pylsp/
				if
					server_name ~= "marksman" and server_name ~= "lua_ls"
					-- and
					-- server_name ~= "bash-language-server"
					then
					lspconfig[server_name].setup({
						lsp = lsp,
						capabilities = capabilities,
					})
				end
			end
		end,
	},

	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
	-- {
	--  'williamboman/mason-lspconfig.nvim',
	--  lazy = true,
	-- Merged into 'williamboman/mason.nvim'
	--  config = function()
	--      local lspconfig = require('lspconfig')
	--      local configs   = require 'lspconfig.configs'
	--      -- local lspzero   = require("lspconfig.lsp-zero").setup()
	--      -- local lsp = lspzero["lsp"]
	--      -- local lsp = lspconfig.preset({})
	--      local lsp = lspconfig
	--      local capabilities = require('cmp_nvim_lsp').default_capabilities()
	--      local get_servers  = require('mason-lspconfig').get_installed_servers
	--      -- import mason-lspconfig
	--      local mason_lspconfig = require("mason-lspconfig")

	--      mason_lspconfig.setup({
	--          -- [lsp-zero] The function .ensure_installed() has been removed.
	--          -- Use the module mason-lspconfig to install your LSP servers.
	--          -- See :help lsp-zero-guide:integrate-with-mason-nvim

	--          -- ensure_installed = servers,
	--          --
	--          -- ensure_installed = {
	--          --  -- Replace these with whatever servers you want to install
	--          --  "rust_analyzer",
	--          --  "tsserver",
	--          -- }
	--          automatic_installation = true,
	--          -- handlers = require('functions.mason.handlers').handlers,
	--          handlers = {
	--              -- lspzero.default_setup,
	--              tsserver = function()
	--                  require('lspconfig').tsserver.setup({
	--                      single_file_support = false,
	--                      on_attach = function(client, bufnr)
	--                          print('hello tsserver')
	--                      end
	--                  })
	--              end,
	--          }
	--      })

	--      for _, server_name in ipairs(get_servers()) do
	--      --  https://www.reddit.com/r/neovim/comments/109gdka/how_can_i_disable_pylsp/
	--          if
	--              server_name ~= "marksman"
	--              -- and
	--              -- server_name ~= "bash-language-server"
	--              then
	--              lspconfig[server_name].setup({
	--                  lsp = lsp,
	--                  capabilities = capabilities,
	--              })
	--          end
	--      end
	--  end,
	-- },

	-- https://github.com/sspaeti/dotfiles/blob/7891329b8ca61e829966cace388ea823bc97e0b9/nvim/lua/sspaeti/plugins/lsp/none-ls.lua
	{
		"nvimtools/none-ls.nvim", --before: jose-elias-alvarez/null-ls.nvim"
		lazy = true,
		-- event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local mason_null_ls = require("mason-null-ls")

			local null_ls = require("null-ls")

			local null_ls_utils = require("null-ls.utils")

			mason_null_ls.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"black", -- python formatter
					"pylint", -- python linter
					"eslint_d", -- js linter
					"jq",   --json format
				},
			})

			-- for conciseness
			local formatting = null_ls.builtins.formatting -- to setup formatters
			local diagnostics = null_ls.builtins.diagnostics -- to setup linters

			-- to setup format on save
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			-- old autoformat: TODO: still needed?
			-- vim.cmd([[
			-- " Python: auto format on save with Black
			-- autocmd BufWritePre *.py execute ':Black'
			-- " set virtual env -> still needed with lsp?
			-- let g:python3_host_prog = expand($HOME."/.venvs/nvim/bin/python3")
			-- " format JSON
			-- :command! Formatj :%!jq .
			-- :command! Unformatj :%!jq -c .
			-- ]])


			-- configure null_ls
			null_ls.setup({
				-- add package.json as identifier for root (for typescript monorepos)
				root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
				-- setup formatters & linters
				sources = {
					--  to disable file types use
					--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
					formatting.prettier.with({ extra_filetypes = { "svelte" } }), -- js/ts formatter
					formatting.stylua.with({ extra_args = { "indent_type=space" } }), -- lua formatter
					formatting.isort,
					formatting.black,
					-- formatting.black.with({ extra_args = { "--fast" } }),
					diagnostics.pylint,
					diagnostics.eslint_d.with({                                   -- js/ts linter
						condition = function(utils)
							return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
						end,
					}),
					--see also ~/.pylintrc or .my_example.toml
					-- R - refactoring related checks => snake_case
					-- C - convention related checks
					-- W0511 disable TODO warning
					-- W1201, W1202 disable log format warning. False positives (I think)
					-- W0231 disable super-init-not-called - pylint doesn't understand six.with_metaclass(ABCMeta)
					-- W0707 disable raise-missing-from which we cant use because py2 back compat
					-- C0301 Line too long => disabled as black-formatter handles long lines automatically
					diagnostics.flake8.with({
						extra_args = {
							"--max-line-length=88",
							"--disable=R,duplicate-code,W0231,W0511,W1201,W1202,W0707,C0301,no-init",
						},
					}),
					diagnostics.mypy.with({ extra_args = { "--ignore-missing-imports" } }),
					diagnostics.write_good,
				},
				-- configure format on save TODO: this seem not to work yet, at least for python
				on_attach = function(current_client, bufnr)
					local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
					if current_client.supports_method("textDocument/formatting")
						-- and filetype == 'python' --only python formatin on save
					then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(client)
										--  only use null-ls for formatting instead of lsp server
										print("on_attach called for buffer", bufnr)
										return client.name == "null-ls"
									end,
									bufnr = bufnr,
								})
							end,
						})
					end
				end,
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		lazy = true,
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			-- Autocompletion
			-- local lspzero = require("lspconfig.lsp-zero").setup()
			-- local lsp = lspzero["lsp"]
			local lspconfig = require('lspconfig')
			local configs   = require 'lspconfig.configs'

			-- local lsp = lspconfig.preset({})
			local lsp = lspconfig
			-- local cmp_action = lspzero.cmp_action()
			local cmp_action = lspconfig.cmp_action
			-- local cmp_action = lspzero["cmp_action"]
			-- local cmp = require('cmp')
			local cmp = require('lspconfig.cmp').setup()
			-- https://github.com/Ashwani1330/Vim-Nvim/blob/4fa54b3dedb18317a34ecc42f9089f582c30cabb/after/plugin/lsp.lua
			local select_opts = { behavior = cmp.SelectBehavior.Select }
			-- local lspkind = require("lspkind")
			print("cmp: \n" .. serialize(cmp))
			local luasnip = require('luasnip')
			-- https://neovim.discourse.group/t/how-to-avoid-pressing-enter-twice-to-create-a-new-line/2649
			---
			-- Autocomplete
			---
			-- vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
			-- vim.opt.completeopt = { "menuone", "noselect" }
			-- vim.opt.completeopt = { "menuone", "noselect", "preview" }
			vim.opt.completeopt = { "menuone", "noselect", "preview", "noinsert", }
			-- https://gist.github.com/VonHeikemen/8fc2aa6da030757a5612393d0ae060bd
			require('luasnip.loaders.from_vscode').lazy_load()
			-- require("plugins.lspconfig.cmp").setup({
			-- Duplicated with lspconfig.cmp
			cmp.setup({
				completion = {
					autocomplete = false,
				},
				enabled = function()
					return vim.g.cmptoggle
				end,
				cmp_action = cmp_action,
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					-- [lsp-zero will setup for you](https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/autocomplete.md#add-an-external-collection-of-snippets)
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- LuaSnips supports LSP snippets
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					-- Enter key confirms completion item
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					-- ['<CR>']   = cmp.mapping.confirm({ select = true }),
					-- ['<CR>']   = cmp.mapping.confirm({ select = false }),
					-- ["<CR>"]   = cmp.config.disable,

					-- Ctrl + space triggers completion menu
					['<C-Space>'] = cmp.mapping.complete(),

					['<C-f>']     = cmp.mapping.scroll_docs(4),
					-- ['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>']     = cmp.mapping.abort(),
					['<C-y>']     = cmp.mapping.confirm({ select = true }),
					['<C-p>']     = cmp.mapping.select_prev_item( select_opts ),
					['<C-n>']     = cmp.mapping.select_next_item( select_opts ),

					['<Up>']      = cmp.mapping.select_prev_item( select_opts ),
					['<Down>']    = cmp.mapping.select_next_item( select_opts ),


					['<C-u>']     = cmp.mapping.scroll_docs(-4),
					['<C-d>']     = cmp.mapping.scroll_docs(4),

					['<C-e>']     = cmp.mapping.abort(),
					-- https://gist.github.com/VonHeikemen/8fc2aa6da030757a5612393d0ae060bd
					['<C-f>']     = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, {'i', 's'}),

					-- ['<C-b>']  = cmp.mapping.scroll_docs(-4),
					['<C-b>']     = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {'i', 's'}),

					['<Tab>']     = cmp.mapping(function(fallback)
						local col = vim.fn.col('.') - 1

						if cmp.visible() then
							cmp.select_next_item( select_opts )
						elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
							fallback()
						else
							cmp.complete()
						end
					end, {'i', 's'}),

					['<S-Tab>']   = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item( select_opts )
						else
							fallback()
						end
					end, {'i', 's'}),
				}),

				-- sources = {
				-- },
				sources = cmp.config.sources({
					-- { name = 'nvim_lsp' },
					-- { name = 'vsnip' }, -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					-- { name = 'buffer' },
					-- {name = 'nvim_lsp'},
					{name = 'path'},
					{name = 'nvim_lsp', keyword_length = 1},
					{name = 'buffer',   keyword_length = 3},
					{name = 'luasnip',  keyword_length = 2},
				}),
				formatting = {
					fields = { 'menu', 'abbr', 'kind' },
					format = function(entry, item)
						local menu_icon = {
							-- nvim_lsp = 'λ',
							nvim_lsp = '&',
							-- luasnip  = '⋗',
							luasnip  = '>',
							-- buffer   = 'Ω',
							buffer   = '@',
							-- path     = '🖫',
							path     = '~',
						}

						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},
				preselect = cmp.PreselectMode.None,  -- Alt: cmp.PreselectMode.Item
			})
			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = 'buffer' },
				})
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				})
			})
			-- Did this job in mason-lspconfig.nvim
			-- -- Set up lspconfig.
			-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
			-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
			-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
			--  capabilities = capabilities
			-- }
		end
	},

	-- {
	-- 	-- "folke/neodev.nvim",
	-- 	"folke/lazydev.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		local neodev_status_ok, neodev = pcall(require, "neodev")

	-- 		if not neodev_status_ok then
	-- 			return
	-- 		end

	-- 		-- neodev.setup()
	-- 	end,
	-- },

	-- https://dx13.co.uk/articles/2023/04/24/neovim-lsp-without-plugins/
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo" },
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		dependencies = {
			-- LSP Support
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{
				"williamboman/mason.nvim",
				config = true,
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
			-- { "jose-elias-alvarez/null-ls.nvim" },
			{ "Roger-Takeshita/null-ls.nvim" },

			-- Useful status updates for LSP
			-- LSP customizations
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {}, tag = "legacy" },
			{ "simrat39/inlay-hints.nvim" },
			-- { "tamago324/nlsp-settings.nvim" },

			-- Language customizations
			{ "simrat39/rust-tools.nvim" },
			{ "b0o/schemastore.nvim" },
			-- Additional lua configuration, makes nvim stuff amazing!
			{ 'folke/neodev.nvim' },
		},
		-- https://github.com/sspaeti/dotfiles/blob/7891329b8ca61e829966cace388ea823bc97e0b9/nvim/lua/sspaeti/plugins/lsp/lspconfig.lua
		keys = {
			{ "K",          vim.lsp.buf.hover,                                    desc = "LSP Documentation Hover" },
			{ "gd",         vim.lsp.buf.definition,                               desc = "LSP Definition" },
			{ "gD",         vim.lsp.buf.declaration,                              desc = "LSP Declaration" },
			{ "gR",         vim.lsp.buf.references,                               desc = "LSP References" },
			-- { "gr",         require("telescope.builtin").lsp_references,          desc = "Telescope LSP References" },
			-- { "gC",         require("telescope.builtin").lsp_document_symbols,    desc = "Telescope LSP Document Symbols" },
			{ "gI",         vim.lsp.buf.implementation,                           desc = "LSP Implementation" },
			{ "gs",         vim.lsp.buf.signature_help,                           desc = "LSP Signature Help" },
			--{ "ga",         vim.lsp.buf.code_action,                              desc = "LSP Code Action" }, -- easy alignment
			{ "<Leader>la", vim.lsp.buf.code_action,                              desc = "LSP Code Action" },
			{ "<Leader>lf", vim.lsp.buf.format,                                   desc = "LSP Format" },
			{ "<Leader>lr", vim.lsp.buf.rename,                                   desc = "LSP Rename" },
			{ "<Leader>lc", vim.diagnostic.disable,                               desc = "Diagnostic Disable" },
			{ "<Leader>le", vim.diagnostic.enable,                                desc = "Diagnostic Enable" },
			-- vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
			{ "gl",         vim.diagnostic.open_float,                            desc = "Diagnostic Open (Float)"  },
			{ "<leader>lo", vim.diagnostic.open_float,                            desc = "Diagnostic Open (Float)" },
			{ "<Leader>ln", vim.diagnostic.goto_next,                             desc = "Diagnostic Go To Next" },
			{ "]d",         vim.diagnostic.goto_next,                             desc = "Diagnostic Go To Next" },
			{ "]]",         vim.diagnostic.goto_next,                             desc = "Diagnostic Go To Next" },
			{ "<Leader>lp", vim.diagnostic.goto_prev,                             desc = "Diagnostic Go To Previous" },
			{ "[d",         vim.diagnostic.goto_prev,                             desc = "Diagnostic Go To Previous" },
			{ "[[",         vim.diagnostic.goto_prev,                             desc = "Diagnostic Go To Previous" },
			{ "<leader>lh", vim.lsp.buf.signature_help,                           desc = "LSP Signature Help" },
			{ "<leader>ls", ":LspRestart<CR>",                                                    desc = "LSP Restart" },
			--prime
			-- { "sC",         function() vim.lsp.buf.workspace_symbol() end,                        desc = "LSP Workspace Symbol" },
			-- { "<Leader>lw", function() vim.lsp.buf.workspace_symbol() end,                        desc = "LSP Workspace Symbol (Leader)" },
		},

		config = function(_, _)
			-- import lspconfig plugin
			local lspconfig = require('lspconfig')
			local configs   = require 'lspconfig.configs'
			-- local lsp = lspconfig.preset({})
			local lsp = lspconfig
			-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			-- used to enable autocompletion (assign to every lsp server config)
			-- import cmp-nvim-lsp plugin
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- local capabilities = cmp_nvim_lsp.default_capabilities()
			-- https://www.reddit.com/r/neovim/comments/119hi6n/how_do_i_achieve_javascript_code_completition/
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities       = cmp_nvim_lsp.default_capabilities(capabilities)

			lspconfig.pyright.setup {}
			lspconfig.rust_analyzer.setup {
				-- Server-specific settings. See `:help lspconfig-setup`
				settings = {
					['rust-analyzer'] = {},
				},
			}

			local keymap = vim.keymap -- for conciseness
			local opts = { noremap = true, silent = true }

			-- local function on_attach(client, bufnr)
			--  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			--  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

			--  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

			--  local opts = {buffer = bufnr}

			--  vim.keymap.set('n',  'K',    '<cmd>lua vim.lsp.buf.hover()<cr>',           opts)
			--  vim.keymap.set('n',  'gd',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
			--  vim.keymap.set('n',  'gD',   '<cmd>lua vim.lsp.buf.declaration()<cr>',     opts)
			--  vim.keymap.set('n',  'gi',   '<cmd>lua vim.lsp.buf.implementation()<cr>',  opts)
			--  vim.keymap.set('n',  'go',   '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
			--  vim.keymap.set('n',  'gr',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
			--  vim.keymap.set('n',  'gs',   '<cmd>lua vim.lsp.buf.signature_help()<cr>',  opts)
			--  vim.keymap.set('n',  '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',          opts)
			--  vim.keymap.set('n',  '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',     opts)

			--  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

			--  vim.keymap.set('n',  'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
			--  vim.keymap.set('n',  '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  opts)
			--  vim.keymap.set('n',  ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',  opts)

			--  -- Set some keybinds conditional on server capabilities
			--  -- :lua =vim.lsp.get_active_clients()[1].server_capabilities
			--  -- if client.resolved_capabilities.document_formatting then
			--  if client.server_capabilities.documentFormattingProvider then
			--      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
			--      -- elseif client.resolved_capabilities.document_range_formatting then
			--  elseif client.server_capabilities.documentRangeFormattingProvider then
			--      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
			--  end

			--  -- Set autocommands conditional on server_capabilities
			--  -- if client.resolved_capabilities.document_highlight then
			--  if client.server_capabilities.documentHighlightProvider then
			--      vim.api.nvim_exec([[
			--      augroup lsp_document_highlight
			--      autocmd! * <buffer>
			--      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			--      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			--      augroup END
			--      ]], false)
			--  end
			-- end
			-- local servers = { "jsonls", "lua_ls", "glint", "pyright", "ruff_lsp", "rust_analyzer", "tsserver", "cssls" }



			-- Comment this out for debugging
			-- vim.lsp.set_log_level("off")
			-- vim.lsp.set_log_level("on")



			-- local lspzero = require("lspconfig.lsp-zero").setup()
			-- local lsp = lspzero["lsp"]
			--
			-- [Deprecated functions](https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#deprecated-functions)
			--
			-- [How to add a custom server to `nvim-lspconfig`? ](https://neovim.discourse.group/t/how-to-add-a-custom-server-to-nvim-lspconfig/3925)
			--

			-- In an ftplugin for your filetype, or in a FileType autocommand:
			-- Many of the Neovim maintainers do not use nvim-lspconfig. It is mostly a community maintained plugin.
			-- vim.lsp.start({
			--  cmd = { "command" },
			--  root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
			-- })

			-- local lsp = require 'lspconfig'

			-- vim.tbl_deep_extend('keep', lsp, {
			--  lsp_name = {
			--      cmd = { 'command' },
			--      filetypes = 'filetype',
			--      name = 'lsp_name',
			--  }
			-- })

			-- When boot nvim with file list:
			-- [lspconfig] Cannot access configuration for lua. Ensure this server is listed in `server_configurations.md` or added as a custom server.
			-- [lspconfig] Cannot access configuration for typescript. Ensure this server is listed in `server_configurations.md` or added as a custom server.
			-- [lspconfig] Cannot access configuration for rust. Ensure this server is listed in `server_configurations.md` or added as a custom server.
			-- [lspconfig] Cannot access configuration for json. Ensure this server is listed in `server_configurations.md` or added as a custom server.
			-- [lspconfig] Cannot access configuration for null. Ensure this server is listed in `server_configurations.md` or added as a custom server.

			-- Server "tsserver" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "pyright" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "tsserver" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "svelte" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "rust_analyzer" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "yamlls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "glint" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "marksman" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "html" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "dockerls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "ruff_lsp" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "lua_ls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "jsonls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "eslint" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "bashls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "cssls" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart
			-- Server "docker_compose_language_service" is being set up before mason.nvim is set up. :h mason-lspconfig-quickstart


			-- [lsp-zero] The function .ensure_installed() has been removed.
			-- Use the module mason-lspconfig to install your LSP servers.
			-- See :help lsp-zero-guide:integrate-with-mason-nvim

			-- lsp.ensure_installed({
			--  "tsserver",
			--  "lua_ls",
			--  "pyright",
			--  "bashls",
			--  "gopls",
			--  "docker_compose_language_service",
			--  "dockerls",
			--  "eslint",
			--  "html",
			--  -- Needs dotnet, and musl libc build failed
			--  -- "marksman",
			--  "ruff_lsp",
			--  "rust_analyzer",
			--  "svelte",
			--  "yamlls",
			--  "jsonls",
			-- })
			local inlay = require("lspconfig.inlay").setup()
			local function on_attach(client, bufnr)
				opts.buffer = bufnr
				-- Fixed column for diagnostics to appear
				vim.opt.signcolumn = "yes"
				-- Is this a correct syntax? - No
				-- lsp.default_keymaps {
				-- default_keymaps is lsp-zero specific
				-- lsp.default_keymaps.insert({
				--  buffer = bufnr,
				--  preserve_mappings = false,
				-- })

				if client.supports_method "textDocument/documentHighlight" then
					local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end

--   noice.nvim                                                                             12:54:19
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- vim.lsp.handlers["textDocument/hover"] has been overwritten by another plugin?
--
-- Either disable the other plugin or set config.lsp.hover.enabled = false in your Noice config.
--   - plugin: nvim
--   - file: /usr/share/nvim/runtime/lua/vim/lsp.lua
--   - line: 2318
				-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				--  vim.lsp.handlers.hover,
				--  { border = 'rounded' }
				-- )

				vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
					vim.lsp.handlers['signature_help'],
					{ border = 'single', close_events = { "CursorMoved", "BufHidden", "InsertCharPre" } }
				)

				vim.diagnostic.config({
					virtual_text   = true,
					severity_sort  = true,
					float = {
						border = 'rounded',
						source = 'always',
					},
				})
				-- turn on grammarly language server only for filetype=markdown
				if client.name == "grammarly" then
					vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
				end
			end
			lsp.on_attach = on_attach -- (
				-- function(client, bufnr)
				--  lsp.default_keymaps({
				--      buffer = bufnr,
				--      preserve_mappings = false,
				--  })
				--  if client.supports_method "textDocument/documentHighlight" then
				--      local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
				--      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				--          group = group,
				--          buffer = bufnr,
				--          callback = vim.lsp.buf.document_highlight,
				--      })
				--      vim.api.nvim_create_autocmd("CursorMoved", {
				--          group = group,
				--          buffer = bufnr,
				--          callback = vim.lsp.buf.clear_references,
				--      })
				--  end
				--  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				--      vim.lsp.handlers['signature_help'],
				--      { border = 'single', close_events = { "CursorMoved", "BufHidden", "InsertCharPre" } }
				--  )
				-- end
			-- )
			--
			---
			-- Diagnostics
			---

			local sign = function(opts)
				vim.fn.sign_define(opts.name, {
					texthl = opts.name,
					text = opts.text,
					numhl = ''
				})
			end

			-- sign({name = 'DiagnosticSignError', text = '✘'})
			sign({name = 'DiagnosticSignError', text = 'x'})
			-- sign({name = 'DiagnosticSignWarn', text = '▲'})
			sign({name = 'DiagnosticSignWarn',  text = '^'})
			-- sign({name = 'DiagnosticSignHint', text = '⚑'})
			sign({name = 'DiagnosticSignHint',  text = '!'})
			-- sign({name = 'DiagnosticSignInfo', text = ''})
			sign({name = 'DiagnosticSignInfo',  text = '?'})
			lsp.set_sign_icons = {
				-- error = "",
				error = "x",
				-- warn  = "",
				warn  = "^",
				-- hint  = "",
				hint  = "!",
				-- info  = "",
				info  = "?",
			}

			for type, icon in pairs(lsp.set_sign_icons) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			--
			-- (Optional) Configure lua language server for neovim
			-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
			-- This is in the share tree (XDG_DATA_HOME)
			local lspconfig = require('lspconfig')
			local configs   = require 'lspconfig.configs'
			-- require("fidget").setup()
			-- lspconfig.lua.setup( { lsp = lsp } )
			lspconfig.typescript.setup({ inlay = inlay })
			lspconfig.rust.setup({ inlay = inlay, lsp = lsp })
			-- require("plugins.lspconfig.json")
			-- https://github.com/neovim/nvim-lspconfig/issues/372
			lspconfig.json.setup(lsp)
			lspconfig.null.setup()
			--
			-- [Semantic Highlighting in Neovim](https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316)
			local function show_unconst_caps(args)
				local token = args.data.token
				if token.type ~= "variable" or token.modifiers.readonly then return end

				local text = vim.api.nvim_buf_get_text(
				args.buf, token.line, token.start_col, token.line, token.end_col, {})[1]
				if text ~= string.upper(text) then return end

				vim.lsp.semantic_tokens.highlight_token(
				token, args.buf, args.data.client_id, "Error")
			end
			-- LspUninstall marksman solved it
			-- Spawning language server with cmd: `marksman` failed.
			-- The language server is either not installed, missing from PATH, or not executable.
			-- [ disable diagnostic from a specific source #20745 ](https://github.com/neovim/neovim/issues/20745)
			-- [make_diagnostics_handler](https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/main/lua/nvim-lsp-ts-utils/client.lua#L47-L110)
			local function filter_diagnostics(diagnostic)
				-- Filter out all diagnostics from sumneko_lua
				if diagnostic.source:find('marksman', 1, true) then
					return false
				end
				return true
			end
			-- Doesn't work
			vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			function(_, result, ctx, config)
				-- Keep non marksman items
				result = vim.tbl_filter(filter_diagnostics, result.diagnostics)
				if result ~= nil then
					-- vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
					return vim.lsp.diagnostic.on_publish_diagnostics
				else
					return function(_, result, ctx, config) end
				end
			end,
			{
				-- Enable underline, use default values
				underline = true,
				-- Enable virtual text, override spacing to 4
				virtual_text = {
					spacing = 4,
				},
				-- Use a function to dynamically turn signs off
				-- and on, using buffer local variables
				signs = function(namespace, bufnr)
					return vim.b[bufnr].show_signs == true
				end,
				-- Disable a feature
				update_in_insert = false,
			}
			)

			-- Doesn't work
			-- local client = vim.lsp.get_active_clients({ name = 'marksman' })[1]
			-- if client then
			--  local ns = vim.lsp.diagnostic.get_namespace(client.id)
			--  vim.diagnostic.disable(nil, ns)
			-- end

			-- Semantic Highlighting in Neovim
			-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
			-- Doesn't work
			-- vim.api.nvim_set_hl(0, '@lsp.type.function.marksman', {})

			-- local function show_unconst_caps(args)
			--  local client = vim.lsp.get_client_by_id(args.data.client_id)
			--  if client.name ~= "marksman" then return end

			--  local token = args.data.token
			--  -- etc
			-- end

			-- Moved to mason section
			-- local default_setup = function(server)
			--  require('lspconfig')[server].setup({
			--      capabilities = capabilities,
			--  })
			-- end
			-- require("mason").setup({})
			-- require("mason-lspconfig").setup({
			--  ensure_installed = {},
			--  handlers = {
			--      default_setup,
			--  },
			-- })



			--
			-- :lua require('lspconfig').marksman.setup{}
			-- require('lspconfig').marksman.setup {}
			lspconfig.marksman.setup({
				on_attach = function(client, buffer)
					vim.api.nvim_create_autocmd("LspTokenUpdate", {
						buffer = buffer,
						-- callback = show_unconst_caps,
						callback = function (args)
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							-- Ignore marksman items
							if client.name == "marksman" then return end

							local token = args.data.token
							-- etc
						end,
					})

					-- other on_attach logic
				end
			})

			lspconfig["bashls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			local lua_settings = {
				-- https://www.reddit.com/r/neovim/comments/15dr01d/running_lazyvim_starter_on_alpine_docker/
				mason = false,
				-- lspzero = lspzero,
				lsp = lsp,
				capabilities = capabilities,
				lua = {
					mason = false,
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
							align_continuous_assign_statement = false,
							align_continuous_rect_table_field = false,
							align_array_table = false
						},
					},
					-- https://github.com/folke/neodev.nvim
					completion = {
						callSnippet = "Replace"
					},
					runtime = {
						-- LuaJIT in the case of Neovim
						version = 'LuaJIT',
						path = vim.split(package.path, ';'),
					},
					diagnostics = {
						globals = { 'vim' }
					},
					workspace = {
						checkThirdParty = false,
						-- Make the server aware of Neovim runtime files
						library = {
							vim.env.VIMRUNTIME,
							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
							[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
						},
					},
					telemetry = { enable = false },

					-- },

					single_file_support = false,
					on_attach = on_attach,
					-- on_attach = function(client, bufnr)
					--  --  print('hello world')
					-- end,
				},

				on_init = function(client)
					local path = client.workspace_folders[1].name
					if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
						client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
							Lua = {
								runtime = {
									-- Tell the language server which version of Lua you're using
									-- (most likely LuaJIT in the case of Neovim)
									version = 'LuaJIT'
								},
								-- Make the server aware of Neovim runtime files
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME
										-- Depending on the usage, you might want to add additional paths here.
										-- E.g.: For using `vim.*` functions, add vim.env.VIMRUNTIME/lua.
										-- "${3rd}/luv/library"
										-- "${3rd}/busted/library",
									}
									-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
									-- library = vim.api.nvim_get_runtime_file("", true)
								}
							}
						})
					end
					return true
				end,
			}

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
			local lua_ls = require("lspconfig.lua_ls")
			-- if lspconfig.lua_ls ~= nil then
			if lua_ls ~= nil then
				-- lspconfig.lua_ls.setup({
				lua_ls.setup(lua_settings)
			else
				print("lua_ls got wrong object in lsp.lua")
				-- Intentional trigger an error
				local lua_ls = require("lspconfig.lua_ls")
			end
			-- config that activates keymaps and enables snippet support
			local function make_config()
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
				capabilities.textDocument.completion.completionItem.snippetSupport = true
				return {
					-- enable snippet support
					capabilities = capabilities,
					-- map buffer local keybindings when the language server attaches
					on_attach = on_attach,
				}
			end

			-- lsp-install
			local function setup_servers()
				-- require'lspinstall'.setup()
				-- lsp.setup = {}

				-- get all installed servers
				-- local servers = require'lspinstall'.installed_servers()
				-- local servers = lsp.servers()
				-- ... and add manually installed servers
				-- The current platform is unsupported.
				-- table.insert(servers, "clangd")
				table.insert(servers, "sourcekit")

				for _, server in pairs(servers) do
					local config = make_config()

					-- language specific config
					if server == "lua" then
						config.settings = lua_settings
					end
					if server == "sourcekit" then
						config.filetypes = {"swift", "objective-c", "objective-cpp"}; -- we don't want c and cpp!
					end
					if server == "clangd" then
						config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
					end

					require'lspconfig'[server].setup(config)
				end
			end

			setup_servers()

			-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
			-- require'lspinstall'.post_install_hook = function ()
			lsp.post_install_hook = function ()
				setup_servers() -- reload installed servers
				vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
			end

			-- https://neovim.discourse.group/t/how-do-you-configure-an-lsp-to-disable-another-lsp/2547
			lspconfig.glint.setup({
				on_attach = function()
					for i, server in ipairs(vim.lsp.buf_get_clients()) do
						print(server.name)
						if server.name == 'marksman' then
							vim.lsp.get_client_by_id(server.id).stop()
						end
					end
				end,
			})
			-- typescript server
			-- lua print(vim.inspect(require("lspconfig.configs").cssls))
			-- lua print(vim.inspect(require("lspconfig").tsserver)) -- will return the setup
			-- if lspconfig.tsserver ~= nil then
			-- 	lspconfig.tsserver.setup({
			-- 		capabilities = capabilities,
			-- 		single_file_support = false,
			-- 		-- on_attach = function(client, bufnr)
			-- 			--  print('hello tsserver')
			-- 			-- end
			-- 			on_attach = on_attach,
			-- 		})
			-- end
			vim.api.nvim_create_autocmd("LspTokenUpdate", {
				pattern = {"*.md", "*.markdown"},
				callback = show_unconst_caps,
			})
			-- https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = 'LSP actions',
				-- callback = function(args)
				callback = function(event)
					local bufnr = event.buf
					local opts = { buffer = event.buf }
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- Ignore marksman items
					if client.name == "marksman" then return end
					-- these will be buffer-local keybindings
					-- because they only work if you have an active language server
					-- set some keymap here, or put anything you want to set after attach ls
					-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

					vim.keymap.set('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
					vim.keymap.set('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
					vim.keymap.set('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
					vim.keymap.set('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
					vim.keymap.set('n', 'go',         '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
					vim.keymap.set('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<cr>', opts)
					vim.keymap.set('n', 'gs',         '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
					-- vim.keymap.set('n', '<F2>',       '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
					vim.keymap.set({'n', 'x'},        '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
					vim.keymap.set('n', '<F4>',       '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

					vim.api.nvim_create_autocmd("LspTokenUpdate", {
						buffer = event.buf,
						callback = show_unconst_caps,
					})
				end
			})

			-- lsp.setup = {}
		end
	},

	-- :LspInstall jsonls
	{
		"tamago324/nlsp-settings.nvim",
		lazy = true,
		dependencies = {
			-- Readonly (frozen)
			{ "williamboman/nvim-lsp-installer" },
			{ "rcarriga/nvim-notify" },
		},
		config = function()
			-- https://github.com/tamago324/nlsp-settings.nvim
			local lsp_installer = require('nvim-lsp-installer')
			local lspconfig     = require("lspconfig")
			local nlspsettings  = require("nlspsettings")

			nlspsettings.setup({
				config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
				local_settings_dir = ".nlsp-settings",
				local_settings_root_markers_fallback = { '.git' },
				append_default_schemas = true,
				loader = 'json'
			})

			local function on_attach(client, bufnr)
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.util.default_config =
			vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = capabilities,
			})

			lsp_installer.on_server_ready(function(server)
				local config = {
					-- on_attach = on_attach[server.name],
					on_attach    = on_attach,
					capabilities = capabilities,
					autostart    = true,
					settings = {
						lua = {
							diagnostics = {
								globals = { 'vim' }
							}
						}
					},
				}
				server:setup(config)
			end)
		end,
	},


}










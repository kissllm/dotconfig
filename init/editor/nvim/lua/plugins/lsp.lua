-- Log address
-- lua =require('vim.lsp.log').get_filename()
-- $HOME/.local/state/nvim/lsp.log
-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
-- https://github.com/kabouzeid/nvim-lspinstall/wiki
local function on_attach(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = {buffer = bufnr}

	vim.keymap.set('n',  'K',    '<cmd>lua vim.lsp.buf.hover()<cr>',           opts)
	vim.keymap.set('n',  'gd',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
	vim.keymap.set('n',  'gD',   '<cmd>lua vim.lsp.buf.declaration()<cr>',     opts)
	vim.keymap.set('n',  'gi',   '<cmd>lua vim.lsp.buf.implementation()<cr>',  opts)
	vim.keymap.set('n',  'go',   '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	vim.keymap.set('n',  'gr',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
	vim.keymap.set('n',  'gs',   '<cmd>lua vim.lsp.buf.signature_help()<cr>',  opts)
	vim.keymap.set('n',  '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',          opts)
	vim.keymap.set('n',  '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',     opts)

	vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

	vim.keymap.set('n',  'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
	vim.keymap.set('n',  '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  opts)
	vim.keymap.set('n',  ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',  opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], false)
	end
end

local servers = { "jsonls", "lua_ls", "glint", "pyright", "ruff_lsp", 'rust_analyzer', "tsserver", "cssls" }

return {

	{
		"VonHeikemen/lsp-zero.nvim",
		-- branch = "v2.x",
		branch = "v3.x",
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},              -- Required
			{'williamboman/mason.nvim'},            -- Optional
			{'williamboman/mason-lspconfig.nvim'},  -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},                   -- Required
			{'hrsh7th/cmp-nvim-lsp'},               -- Required
			{'hrsh7th/cmp-buffer'},                 -- Optional
			{'hrsh7th/cmp-path'},                   -- Optional
			{'saadparwaiz1/cmp_luasnip'},           -- Optional
			{'hrsh7th/cmp-nvim-lua'},               -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},                   -- Required
			{'rafamadriz/friendly-snippets'},       -- Optional
		},
		lazy = true,
		config = function()
			-- No such file
			-- require("lsp-zero.settings").preset({})
			-- https://github.com/VonHeikemen/lsp-zero.nvim
			-- Do not introduce "plugins.lspconfig" to package.path?
			-- Look into
			-- :lua print(serialize(vim.split(package.path, ";")))
			-- "~/.config/nvim/lua/?.lua" did this
			-- This is in the config tree (XDG_CONFIG_HOME)
			local lspzero = require("lspconfig.lsp-zero").setup()
			-- local lsp = require('lsp-zero').preset({})
			local lsp = lspzero["lsp"]
			lsp.preset('lsp-only')

			if lsp then
				local log = require("log")
				if log then
					print(tostring(serialize(lsp)))
				else
					print(tostring(lsp))
				end
			else
				print("lsp doesn't initialzed")
				return
			end

			lsp.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp.default_keymaps({buffer = bufnr})

				local opts = {buffer = bufnr}

				vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)

			end)
			--
			-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
			lsp.omnifunc.setup({
				tabcomplete      = true,
				trigger          = '<C-Space>',
				update_on_delete = true,
				autocomplete     = true,
				use_fallback     = true,
			})

			-- lsp.setup()
			-- https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80
			-- LspInfo to see server list
			lsp.setup_servers(servers)
			lsp.setup()
		end,
	},

	{
		'williamboman/mason.nvim',
		cmd   = "Mason",
		event = "BufReadPre",
		lazy  = true,
		dependencies = {
			"jayp0521/mason-null-ls.nvim",
			"williamboman/mason-lspconfig.nvim",
			lazy = true,
		},
		config = function()
			require("mason").setup({
			-- https://github.com/williamboman/nvim-lsp-installer/discussions/509
				PATH = "prepend", -- "skip" seems to cause the spawning error
				log_level = vim.log.levels.DEBUG,
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end,
	},

	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		config = function()
			local lspconfig = require('lspconfig')
			local lspzero   = require("lspconfig.lsp-zero").setup()
			local lsp = lspzero["lsp"]
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local get_servers  = require('mason-lspconfig').get_installed_servers

			require('mason-lspconfig').setup({
				-- [lsp-zero] The function .ensure_installed() has been removed.
				-- Use the module mason-lspconfig to install your LSP servers.
				-- See :help lsp-zero-guide:integrate-with-mason-nvim

				-- ensure_installed = servers,
				--
				-- ensure_installed = {
				--  -- Replace these with whatever servers you want to install
				--  'rust_analyzer',
				--  'tsserver',
				-- }
				automatic_installation = true,
				-- handlers = require('functions.mason.handlers').handlers,
				handlers = {
					lspzero.default_setup,
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
					server_name ~= "marksman"
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
			local lspzero = require("lspconfig.lsp-zero").setup()
			local lsp = lspzero["lsp"]
			local cmp_action = lspzero["cmp_action"]
			local cmp = require('cmp')
			-- https://github.com/Ashwani1330/Vim-Nvim/blob/4fa54b3dedb18317a34ecc42f9089f582c30cabb/after/plugin/lsp.lua
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			-- local lspkind = require("lspkind")
			print("cmp: \n" .. serialize(cmp))
			-- https://neovim.discourse.group/t/how-to-avoid-pressing-enter-twice-to-create-a-new-line/2649
			vim.opt.completeopt = { "menuone", "noselect" }

			-- require("plugins.lspconfig.cmp").setup({
			cmp.setup({
				completion = {
					autocomplete = false,
				},
				mapping = {
					['<C-Space>'] = cmp.mapping.complete()
				},
				enabled = function()
					return vim.g.cmptoggle
				end,
				cmp_action = cmp_action,
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>']     = cmp.mapping.scroll_docs(-4),
					['<C-f>']     = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>']     = cmp.mapping.abort(),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					-- ['<CR>']   = cmp.mapping.confirm({ select = true }),
					-- ['<CR>']      = cmp.mapping.confirm { select = false },
					['<C-y>']     = cmp.mapping.confirm({ select = true }),
					['<C-p>']     = cmp.mapping.select_prev_item( cmp_select ),
					['<C-n>']     = cmp.mapping.select_next_item( cmp_select ),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' }, -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					},
					{
					{ name = 'buffer' },
				})
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
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
			-- { "jose-elias-alvarez/null-ls.nvim" },
			{ "Roger-Takeshita/null-ls.nvim" },

			-- LSP customizations
			{ "j-hui/fidget.nvim", tag = "legacy" },
			{ "simrat39/inlay-hints.nvim" },
			-- { "tamago324/nlsp-settings.nvim" },

			-- Language customizations
			{ "simrat39/rust-tools.nvim" },
			{ "b0o/schemastore.nvim" },
		},
		config = function(_, _)
			-- Comment this out for debugging
			vim.lsp.set_log_level("off")
			local lspzero = require("lspconfig.lsp-zero").setup()
			local lsp = lspzero["lsp"]
			-- [Deprecated functions](https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#deprecated-functions)
			--
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
			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({
					buffer = bufnr,
					preserve_mappings = false,
				})
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
				vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
					vim.lsp.handlers['signature_help'],
					{ border = 'single', close_events = { "CursorMoved", "BufHidden", "InsertCharPre" } }
				)
			end)
			lsp.set_sign_icons({
				error = "",
				warn  = "",
				hint  = "",
				info  = "",
			})
			--
			-- (Optional) Configure lua language server for neovim
			-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
			-- This is in the share tree (XDG_DATA_HOME)
			local lspconfig = require('lspconfig')
			require("lspconfig.fidget")
			lspconfig.lua.setup( { lsp = lsp } )
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

			vim.api.nvim_create_autocmd("LspTokenUpdate", {
				pattern = {"*.md", "*.markdown"},
				callback = show_unconst_caps,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					-- Ignore marksman items
					if client.name == "marksman" then return end

					vim.api.nvim_create_autocmd("LspTokenUpdate", {
						buffer = args.buf,
						callback = show_unconst_caps,
					})
				end
			})
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

			if lspconfig.lua_ls ~= nil then
				lspconfig.lua_ls.setup({
					-- settings = {
					lspzero = lspzero,
					lsp = lsp,
					lua = {
						runtime = {
							-- LuaJIT in the case of Neovim
							version = 'LuaJIT',
							path = vim.split(package.path, ';'),
						},
						diagnostics = {
							globals = { 'vim' }
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = {
								[vim.fn.expand('$VIMRUNTIME/lua')] = true,
								[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
							},
						},

					},
					single_file_support = false,
					on_attach = on_attach
					--  -- on_attach = function(client, bufnr)
					--      --  print('hello world')
					--      -- end,
					-- },
					})
			else
				print("Wrong object")
				-- Intentional trigger an error
				local lua_ls = require("lspconfig.lua_ls")
			end
			-- config that activates keymaps and enables snippet support
			local function make_config()
				local capabilities = vim.lsp.protocol.make_client_capabilities()
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
				lsp.setup()

				-- get all installed servers
				-- local servers = require'lspinstall'.installed_servers()
				-- local servers = lsp.servers()
				-- ... and add manually installed servers
				table.insert(servers, "clangd")
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
			lspconfig.tsserver.setup({
				single_file_support = false,
				on_attach = function(client, bufnr)
					print('hello tsserver')
				end
			})
			lsp.setup()
		end
	},

	-- :LspInstall jsonls
	{
		"tamago324/nlsp-settings.nvim",
		lazy = true,
		dependencies = {
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

			function on_attach(client, bufnr)
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
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








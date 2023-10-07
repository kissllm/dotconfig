
local servers = { "jsonls", "lua_ls", "pyright", "ruff_lsp", 'rust_analyzer', "tsserver", "cssls" }

return {

	{
		"VonHeikemen/lsp-zero.nvim",
		-- branch = "v2.x",
		branch = "v3.x",
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},			   -- Required
			{'williamboman/mason.nvim'},		   -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},		  -- Required
			{'hrsh7th/cmp-nvim-lsp'},	  -- Required
			{'hrsh7th/cmp-buffer'},		  -- Optional
			{'hrsh7th/cmp-path'},		  -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},	  -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},			  -- Required
			{'rafamadriz/friendly-snippets'}, -- Optional
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
			local lspzero = require("plugins.lspconfig.lsp-zero").setup()
			-- local lspzero = require("lspconfig.lsp-zero").setup()
			-- local lsp = require('lsp-zero').preset({})
			local lsp = lspzero["lsp"]
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
			end)

			-- (Optional) Configure lua language server for neovim
			-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
			local lspconfig = require('lspconfig')
			-- require('lspconfig').marksman.setup {
			lspconfig.marksman.setup {
				on_attach = function(client, buffer)
					vim.api.nvim_create_autocmd("LspTokenUpdate", {
						buffer = buffer,
						callback = show_unconst_caps,
					})

					-- other on_attach logic
				end
			}
			lspconfig.lua.setup {
				settings = {
					lua = {
						diagnostics = {
							globals = { 'vim' }
						}
					}
				}
			}
			lspconfig.lua_ls.setup (
				lsp.nvim_lua_ls({
					single_file_support = false,
					on_attach = function(client, bufnr)
						print('hello world')
					end,
				})
			)
			-- https://neovim.discourse.group/t/how-do-you-configure-an-lsp-to-disable-another-lsp/2547
			lspconfig.glint.setup {
				on_attach = function()
					for i, server in ipairs(vim.lsp.buf_get_clients()) do
						print(server.name)
						if server.name == 'marksman' then
							vim.lsp.get_client_by_id(server.id).stop()
						end
					end
				end,
			}

			lsp.setup()
		end
	},

	{
		'williamboman/mason.nvim',
		cmd = "Mason",
		event = "BufReadPre",
		lazy = true,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			lazy = true
		},
		config = function()
			require("mason").setup({
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
			require('mason-lspconfig').setup({
				ensure_installed = servers,
				-- ensure_installed = {
				--	-- Replace these with whatever servers you want to install
				--	'rust_analyzer',
				--	'tsserver',
				-- }
				automatic_installation = true,
				handlers = require('functions.mason.handlers').handlers
			})

			local lspconfig = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local get_servers = require('mason-lspconfig').get_installed_servers

			for _, server_name in ipairs(get_servers()) do
				lspconfig[server_name].setup({
					capabilities = lsp_capabilities,
				})
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
			local lspzero = require("plugins.lspconfig.lsp-zero").setup()
			local lsp = lspzero["lsp"]
			local cmp_action = lspzero["cmp_action"]
			local cmp = require('cmp')
			-- local lspkind = require("lspkind")
			print("cmp: \n" .. serialize(cmp))
			require("plugins.lspconfig.cmp").setup({
				cmp_action = cmp_action,
			})
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
			{ "jose-elias-alvarez/null-ls.nvim" },

			-- LSP customizations
			{ "j-hui/fidget.nvim",				  tag = "legacy" },
			{ "simrat39/inlay-hints.nvim" },
			{ "tamago324/nlsp-settings.nvim" },

			-- Language customizations
			{ "simrat39/rust-tools.nvim" },
			{ "b0o/schemastore.nvim" },
		},
		config = function(_, _)
			-- Comment this out for debugging
			vim.lsp.set_log_level("off")
			local lspzero = require("plugins.lspconfig.lsp-zero").setup()
			local lsp = lspzero["lsp"]
			lsp.ensure_installed({
				"tsserver",
				"lua_ls",
				"pyright",
				"bashls",
				"docker_compose_language_service",
				"dockerls",
				"eslint",
				"html",
				-- Needs dotnet, and musl libc build failed
				-- "marksman",
				"ruff_lsp",
				"rust_analyzer",
				"svelte",
				"yamlls",
				"jsonls",
			})
			local inlay = require("plugins.lspconfig.inlay").setup()
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
			require("plugins.lspconfig.fidget")
			require("plugins.lspconfig.lua").setup({ lsp = lsp })
			require("plugins.lspconfig.typescript").setup({ inlay = inlay })
			require("plugins.lspconfig.rust").setup({ inlay = inlay, lsp = lsp })
			-- require("plugins.lspconfig.json")
			-- https://github.com/neovim/nvim-lspconfig/issues/372
			require("plugins.lspconfig.json").setup(lsp)
			require("plugins.lspconfig.null").setup()
			lsp.setup()
		end
	},

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
			local lspconfig = require("lspconfig")
			local nlspsettings = require("nlspsettings")

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

			local global_capabilities = vim.lsp.protocol.make_client_capabilities()
			global_capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = global_capabilities,
			})

			lsp_installer.on_server_ready(function(server)
				local config = {
					-- on_attach = on_attach[server.name],
					on_attach = on_attach,
					capabilities = capabilities,
					autostart = true,
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

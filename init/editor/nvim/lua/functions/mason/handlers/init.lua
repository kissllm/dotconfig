local M = {}

-- local pyright_config_path = parent_dir() .. 'pyrightconfig.json'

local function get_base_opts()
	local opts = {
		on_attach = function(clinet, bufnr)
			require('v3rganz.keymaps').lsp_keymaps(bufnr)
			local illuminate_ok, illuminate = pcall(require, 'illuminate')
			if illuminate_ok then
				illuminate.on_attach(clinet)
			end
		end
	}

	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		opts.capabilities = cmp_nvim_lsp.default_capabilities()
	end
	return opts
end

local function override_opts(overriden)
	return vim.tbl_deep_extend("force",  get_base_opts(), overriden)
end

-- add custom settings for language-servers
M.handlers = {
	function (server_name)
		require("lspconfig")[server_name].setup(get_base_opts())
	end,
	['pyright'] = function ()
		-- disable diagnostics here. all diagnostics are in mypy & ruff
		require("lspconfig").pyright.setup(override_opts {
			handlers = {
				['textDocument/publishDiagnostics'] = function() end
			}
		})
	end,
	['lua_ls'] = function ()
		require("lspconfig").lua_ls.setup(override_opts {
			settings = {
				Lua = {
					diagnostics = {
						globals = {'vim'}
					},
					workspace = {
						library = {
							-- vim.api.nvim_get_runtime_file("", true)
							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
							[vim.fn.stdpath('config') .. '/lua'] = true
						}
					}
				}
			}
		})
	end
}

return M

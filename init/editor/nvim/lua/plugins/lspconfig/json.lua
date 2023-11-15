local M = {}

local function extend(tab1, tab2)
	for _, value in ipairs(tab2 or {}) do
		table.insert(tab1, value)
	end
	return tab1
end

function M.setup(lsp)
	local lsp = lsp
	local lspconfig = require("lspconfig")
	-- local nlspsettings = require("nlspsettings")
	-- local nlsp_schemas = nlspsettings.get_default_schemas()
	local schema_store = require('schemastore').json.schemas()

	local schemas = {}
	schemas = extend(schemas, schema_store)
	-- schemas = extend(schemas, nlsp_schemas)
	-- nlspsettings.setup({
	-- 	config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
	-- 	-- local_settings_dir = ".vim",
	-- 	local_settings_dir = ".nlsp-settings",
	-- 	local_settings_root_markers_fallback = { '.git' },
	-- 	append_default_schemas = true,
	-- 	loader = "json",
	-- })
	lspconfig.jsonls.setup({
		settings = {
			json = {
				schemas = schemas,
				validate = { enable = true },
			},
		},
		on_attach = function(_, bufnr)
			local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

			buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

			-- Mappings.
			local opts = { noremap=true, silent=true }
			buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})<CR>', opts)
		end,
	})
end

return M

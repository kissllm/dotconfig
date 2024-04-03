local M = {}

function M.setup()
	local lspzero = require('lspconfig.lsp-zero')
	return {
		-- lsp = lspzero.preset({}),
		lsp = lspzero["lsp"],
		-- cmp_action = lspzero.cmp_action(),
		cmp_action = lspzero["cmp_action"],
	}
end

return M








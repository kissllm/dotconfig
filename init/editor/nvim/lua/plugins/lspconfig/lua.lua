local M = {}

function M.setup(lsp)
	local lspconfig = require("lspconfig")
	-- (Optional) Configure lua language server for neovim
	lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
end

return M

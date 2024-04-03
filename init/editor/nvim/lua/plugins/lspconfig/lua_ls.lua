local M = {}

function M.setup(settings)
	-- local lspconfig = require("lspconfig")
	local lsp = settings["lsp"]
	-- local lsp = lspconfig
	-- if lsp == nil then
	-- 	local lspzero = require("lspconfig.lsp-zero").setup()
	-- 	local lsp = lspzero["lsp"]
	-- end
	-- (Optional) Configure lua language server for neovim
	-- Failed here
	local lua_ls = require("lspconfig.lua_ls")
	-- local lua_ls = lspconfig.lua_ls
	if lua_ls ~= nil and lsp ~= nil  then
		-- lua_ls.setup(lsp.nvim_lua_ls(settings))
		lsp.nvim_lua_ls = settings
		-- Recursive calling
		-- lua_ls.setup(lsp.nvim_lua_ls)
	else
		print("lua_ls got wrong object in lsp_ls.lua")
	end
end

return M

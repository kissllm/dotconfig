-- vim: ts=2 sw=2 et:
-- https://github.com/ur4ltz/nvim-config/blob/d69351c1c17dc1a93efaeae8866b3fdbd3e060c0/lua/plugins/config/lsp/diagnostic.lua
local api = vim.api
local lspconfig = require('lspconfig')
local sign_define = vim.fn.sign_define

vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = {
			spacing = 2,
			--prefix = '~'
		},
		signs = true,
		update_in_insert = true,
	}
)

sign_define("LspDiagnosticsSignError", {
	-- text   = ' ',
	text   = 'x ',
	texthl = 'LspDiagnosticsSignError',
	numhl  = 'LspDiagnosticsSignError'
}
)

sign_define("LspDiagnosticsSignWarning", {
	-- text   = ' ',
	text   = '^ ',
	texthl = 'LspDiagnosticsSignWarning',
	numhl  = 'LspDiagnosticsSignWarning'
}
)

sign_define("LspDiagnosticsSignInformation", {
	-- text   = ' ',
	text   = '? ',
	texthl = 'LspDiagnosticsSignInformation',
	numhl  = 'LspDiagnosticsSignInformation'
}
)

sign_define("LspDiagnosticsSignHint", {
	-- text   = ' ',
	text   = '! ',
	texthl = 'LspDiagnosticsSignHint',
	numhl  = 'LspDiagnosticsSignHint'
}
)



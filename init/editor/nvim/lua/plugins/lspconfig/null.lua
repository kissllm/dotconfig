local M = {}
-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/469
-- [What are null-ls alternatives? 15 new plugins, neogit, neo-tree and lsp-zero updates](https://dotfyle.com/this-week-in-neovim/48)
-- :NullLsInfo
function M.setup(settings)
	-- local on_attach = require("lsp.lsp_util").on_attach
	local null_ls   = require("null-ls")
	local builtins  = null_ls.builtins
	local sources = {
		-- builtins.formatting.black,
		-- builtins.formatting.prettier,

		builtins.diagnostics.eslint,
		builtins.completion.spell,
		builtins.formatting.stylua,
		-- builtins.diagnostics.luacheck,
		builtins.formatting.black.with({ extra_args = { "--fast" } }),
		builtins.diagnostics.flake8,
		builtins.diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file(".eslintrc.json")
			end,
		}),
		builtins.formatting.eslint_d,
		builtins.formatting.stylelint,
		builtins.formatting.clang_format,
		builtins.diagnostics.stylelint,
		-- builtins.diagnostics.htmlhint,
		builtins.formatting.prettier_d_slim.with({
			-- filetypes = { "html", "json", "css", "scss", "less", "yaml", "markdown" },
			filetypes = { "html", "json", "yaml", "markdown" },
		}),

		builtins.code_actions.gitsigns,
	}
	null_ls.setup({
		sources = sources,
		debug = true,
		-- on_attach = on_attach,
	})
end

return M

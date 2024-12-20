local fn = vim.fn
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		install_path,
	})
end
vim.opt.rtp:prepend(install_path)
vim.opt.rtp:prepend(install_path .. "/lua/lazy")
package.path = package.path .. ";" .. install_path .. "/*/?.lua"
package.path = package.path .. ";" .. install_path .. "/lua/lazy/?.lua"
-- local plugins = {}
-- local opts = {}
-- setmetatable(plugins, {
--     __call = function(tbl, spec)
--         if type(spec) == 'table' or type(spec) == 'string' then
--             tbl[#tbl+1] = spec
--         end
--     end
-- })
-- import by table
-- require("lazy").setup(plugins, opts)
-- import by folder
-- require("lazy").setup("plugins")
-- config.defaults.lazy = true
-- https://stackoverflow.com/questions/75616837/how-to-include-configure-lua-ls-on-lspconfig
-- https://vi.stackexchange.com/questions/41393/how-to-include-configure-lua-ls-on-lspconfig
-- Must do not set this version option
-- config.defaults.version = "*"
-- Demo
-- https://github.com/LazyVim/starter
require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		-- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- import any extras modules here
		-- { import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.lang.json" },
		-- { import = "lazyvim.plugins.extras.ui.mini-animate" },
		-- import/override with your plugins
		{ import = "plugins" },
		-- { import = "telescope" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		-- lazy = false,
		lazy = true,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	lockfile    = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	--  concurrency = jit.os:find("Windows") and (vim.loop.available_parallelism() * 2) or nil, ---@type number limit the maximum amount of concurrent tasks
	--  install  = { colorscheme                                                                                                                          = { "tokyonight", "habamax" } },
	checker = {
		enabled = true,
		--  enabled = false,
		concurrency = 1,
		notify = false,
	}, -- automatically check for plugin updates
	concurrency = 1, --  8,
	git = {
		timeout = 600,
		-- url_format = { "https://github.com/%s.git", "git@github.com:%s.git" },
		-- url_format = "git@github.com:%s.git",
		url_format = "https://github.com/%s.git",
	},
	dev = {
		fallback = true,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		listing = {
			enabled = false,
		},
	},
})


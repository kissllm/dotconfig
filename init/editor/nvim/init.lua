#! /bin/luajit

local log_address = vim.fn.stdpath('config') .. "/lua/?.lua"
-- local log_address = os.getenv("SHARE_PREFIX") .. '/init/editor/nvim/lua' .. "/?.lua"
-- if not string.find(package.path, log_address) then
-- if not string.match("*;" .. package.path .. ";*", "*;" .. log_address .. ";*") then
--  print("Not found" .. log_address)
--  package.path = package.path .. ";" .. log_address
-- end
local path_list = vim.split(package.path, ";")
local found = false
for _, v in ipairs(path_list) do
	if v == log_address then
		found = true
		break
	end
end
if found == false then
	print("Not found" .. log_address)
	package.path = package.path .. ";" .. log_address
end

local log = require("log")

-- local home    = os.getenv("HOME")
if log == nil then
	print("What")
else
	-- print("log: \n" .. tostring(serialize(log)))
	print("log: \n" .. serialize(log))
end

if log.home == nil then
	print("What")
	return
end
log.os_execute('ls')
-- print("local home: "  .. home)
-- print("log.home: "     .. log.home)
print("log.address: " .. log.address)

local file = io.open(log.address, "w+a")

file:write("\n\n")
-- file:write("environment package.path: " .. package.path .. "\n")
file:write("\npackage.path:\n" .. serialize(runtime_path) .. "\n")
-- file:write("environment package.cpath: " .. package.cpath .. "\n")
file:write("\npackage.cpath:\n" .. serialize(runtime_cpath) .. "\n")
file:write("\n")
-- file:write("home:         " .. home .. "\n")
local config_root  = vim.fn.stdpath 'config'
file:write("config_root:  " .. config_root .. "\n")
local cache_root   = vim.fn.stdpath("cache")
file:write("cache_root:   " .. cache_root .. "\n")
local data_root    = vim.fn.stdpath 'data'
file:write("data_root:    " .. data_root .. "\n")
local execute      = vim.api.nvim_command
local fn           = vim.fn
local packages_root = data_root .. "/lazy"
file:write("packages_root: " .. packages_root .. "\n")
local manager_perse_path = packages_root .. "/lazy.nvim"

local plug_url_format = ""

if vim.g.is_linux then
	plug_url_format = "https://hub.fastgit.org/%s.git"
else
	plug_url_format = "https://github.com/%s.git"
end

function require_rel(...)
	if arg and arg[0] then
		package.path = arg[0]:match("(.-)[^\\/]+$") .. "?.lua;" .. package.path
		require_rel = require
	elseif ... then
		local d = (...):match("(.-)[^%.]+$")
		function require_rel(module)
			return require(d .. module)
		end
	end
end

local package_manager_repo = string.format(plug_url_format, "folke/lazy.nvim")
local install_cmd = string.format("10split | term git clone --depth=1 %s %s", package_manager_repo, manager_perse_path)
local packer_bootstrap = nil
if fn.empty(fn.glob(manager_perse_path)) > 0 then
	vim.api.nvim_echo({ { "Installing lazy.nvim", "Type" } }, true, {})
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--depth=1",
		package_manager_repo .. '.git',
		"--branch=stable",
		manager_perse_path
	})
end
-- vim.opt.rtp:prepend(packages_root)
vim.opt.rtp:prepend(manager_perse_path)
-- vim.opt.rtp:prepend(manager_perse_path .. "/lua/lazy")
-- For rainbow settings
package.path = path_insert(package.path, packages_root .. "/nvim-treesitter/lua/?.lua", "append")
package.path = path_insert(package.path, manager_perse_path .. "/lua/?/?.lua", "append")
if fn.empty(fn.glob(manager_perse_path)) > 0 then
	os.exit()
	do return end
else

end




-- vim.opt.rtp:prepend(config_root)
package.path = path_insert(package.path, config_root .. "/after/plugin/?.lua", "append")
package.path = path_insert(package.path, data_root .. '/after/plugin' .. "/?.lua", "append")

local configs = require("configs")
if not configs then
	file:write("configs initialization failed")
	return
end
local keybindings = require("keybindings")
if not keybindings then
	file:write("keybindings initialization failed")
	return
end
-- require("plugins")
local functions = require("functions")
if not functions then
	file:write("functions initialization failed")
	return
end

local colors = require("colors")
if not colors then
	file:write("colors initialization failed")
	return
end
-- vim.opt.rtp:prepend(packages_root)
-- vim.opt.rtp:prepend(manager_perse_path)
package.path = path_insert(package.path, config_root  .. "/lua/?.lua", "append")
package.path = path_insert(package.path, config_root  .. "/lua/plugins/?.lua", "append")

local runtime_path  = vim.split(package.path, ";")
local runtime_cpath = vim.split(package.cpath, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- Oneline command: :lua print(serialize(vim.split(package.path, ";")))
print("runtime_path: \n" .. serialize(runtime_path))

local lazy_config = require("lazy-config")
if not lazy_config then
	print("lazy_config initialization failed")
	file:write("lazy_config initialization failed")
	return
end
-- lazy.nvim might overwrite keybindings
keybindings_again = require("keybindings")
if not keybindings_again then
	file:write("keybindings_again initialization failed")
	return
end
file:write("\n\n")
file:flush()
file:close()
-- :lua require'lazy'.install()
-- :scriptnames
--
--
-- References
-- https://github.com/arusahni/dotfiles.git
-- https://github.com/cpow/cpow-dotfiles.git
-- https://github.com/LazyVim/starter

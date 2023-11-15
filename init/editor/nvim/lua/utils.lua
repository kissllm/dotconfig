local U = {}

function U.is_mac()
	return vim.loop.os_uname().sysname == "Darwin"
end

function U.is_linux()
	return vim.loop.os_uname().sysname == "Linux"
end

function U.map(mode, lhs, rhs, opts)
	local options = { }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	-- local original_definition =
	-- vim.api.nvim_exec("call maparg('" .. lhs .. "', '" ..  mode .. "', " .. "v:false" .. ")", "false")
	-- if original_definition then
	--  vim.cmd(mode .. "unmap " .. lhs)
	-- end
	--
	-- if (type(rhs) == "function") then
		vim.keymap.set(mode, lhs, rhs, options)
	-- elseif (type(rhs) == "string") then
	-- Does not work on most mappings
	-- 	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	-- end
end

return U


local log = {}
-- https://www.domoticz.com/forum/viewtopic.php?t=27630
-- local function osExecute(cmd)
log.osExecute = function(cmd)
	local fileHandle     = assert(io.popen(cmd, 'r'))
	local commandOutput  = assert(fileHandle:read('*all'))
	local returnTable    = {fileHandle:close()}
	print("commandOutput:" .. commandOutput)
	print("returnTable:" .. serialize(returnTable))
	print("returnTable:" .. vim.inspect(returnTable) )
	return commandOutput,returnTable[3]            -- rc[3] contains returnCode
end

-- https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
-- function os.capture(cmd, raw)
log.capture = function(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	-- local s = assert(f:read('*a'))
	local s = assert(f:read('*all'))
	f:close()
	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end
-- https://stackoverflow.com/questions/9676113/lua-os-execute-return-value
-- local function os_execute(cmd)
log.execute = log.capture
-- log.execute = function (cmd, raw)
-- 	local f = io.popen(cmd) -- runs command
-- 	local s = f:read("*all") -- read output of command
-- 	-- print(l)
-- 	f:close()
-- 	if raw then return s end
-- 	s = string.gsub(s, '^%s+', '')
-- 	s = string.gsub(s, '%s+$', '')
-- 	s = string.gsub(s, '[\n\r]+', ' ')
-- 	return s
-- end

log.get_files = function(mask)
	local files = {}
	local tmpfile = '/tmp/stmp.txt'
	os.execute('ls -1 '..mask..' > '..tmpfile)
	local f = io.open(tmpfile)
	if not f then return files end
	local k = 1
	for line in f:lines() do
		files[k] = line
		k = k + 1
	end
	f:close()
	return files
end

-- log.debug = function(message)
-- 	local file  = io.open(log.address, "a")
-- 	file:write(tostring(message) .. "\n")
-- 	file:flush()
-- 	file:close()
-- end

-- https://zserge.com/posts/luash/
-- https://github.com/mnemnion/luash
-- luarocks install --server=http://luarocks.org/dev luash
-- doas luarocks --lua-version 5.1 install  --server=http://luarocks.org/dev luash

-- lua-realpath
-- https://luarocks.org/modules/mah0x211/realpath
-- https://github.com/mah0x211/lua-realpath
-- luarocks install realpath

-- LuaFileSystem - File System Library for Lua
-- https://github.com/keplerproject/luafilesystem
-- Is Lua suitable for general unix server shell scripting?
-- https://www.reddit.com/r/lua/comments/1v0kih/is_lua_suitable_for_general_unix_server_shell/
--
-- Just process integers
-- https://stackoverflow.com/questions/23177573/format-string-to-number-with-minimum-length-in-lua
function format(num, width)
	-- local p = math.ceil(math.log10(num))
	-- local prec = num <= 1 and wwidth - 1 or p > width and 0 or width - p
	-- return string.format('%.' .. prec .. 'f', num)
	--
	-- get number of digits before decimal
	-- local intWidth = math.ceil(math.log10(num))
	local intWidth = #tostring(num)
	-- if intWidth > width then ... end -- may need this
	-- local fmt='%'.. width .. '.' .. (width - intWidth) .. 'd'
	local fmt='%'.. width .. '.' .. (width - intWidth) .. 'd'
	return string.format(fmt, num)
end

-- https://stackoverflow.com/questions/41942289/display-contents-of-tables-in-lua
function serialize(t, delimiter)
	if not delimiter then delimiter = ";" end
	local indent = 0 -- if not indent then indent = 0 end
	local toprint = ""
	if t == nil then return toprint end
	local len = #tostring(#t)
	if len == 0 then return toprint end
	print("object type: " .. type(t))
	toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	-- for index, data in ipairs(t) do
	-- print(index)
	-- for k, v in ipairs(data) do
	if (type(t) == "number") then
		toprint = toprint .. t .. ",\r\n"
	elseif type(t) == "string" then
		if t:find(";") then
			-- toprint = toprint .. string.rep(" ", indent)
			local list_table = vim.split(t,  delimiter)
			len = #tostring(#list_table)
			for k, v in ipairs(list_table) do
				if (type(k) == "number") then
					toprint = toprint .. "[" .. format(k, len) .. "] = "
				elseif (type(k) == "string") then
					toprint = toprint  .. k ..  "= "
				end
				if (type(v) == "number") then
					toprint = toprint .. v .. ",\r\n"
				elseif (type(v) == "string") then
					-- toprint = toprint .. "\"" .. string.format("%-4s", k) .. ': ' .. v .. "\",\r\n"
					toprint = toprint .. "\"" .. v .. "\",\r\n"
				end
			end
		else
			toprint = toprint .. "\"" .. t .. "\",\r\n"
		end
	elseif type(t) == "table" then
		for k, v in ipairs(t) do
			toprint = toprint .. string.rep(" ", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. format(k, len) .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint  .. k ..  "= "
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				-- toprint = toprint .. "\"" .. v .. "\",\r\n"
				if v:find(";") then
					local list_table = vim.split(v,  delimiter)
					len = #tostring(#list_table)
					for k, v in ipairs(list_table) do
						if (type(k) == "number") then
							toprint = toprint .. "[" .. format(k, len) .. "] = "
						elseif (type(k) == "string") then
							toprint = toprint  .. k ..  "= "
						end
						if (type(v) == "number") then
							toprint = toprint .. v .. ",\r\n"
						elseif (type(v) == "string") then
							-- toprint = toprint .. "\"" .. string.format("%-4s", k) .. ': ' .. v .. "\",\r\n"
							toprint = toprint .. "\"" .. v .. "\",\r\n"
						end
					end
				else
					toprint = toprint .. "\"" .. v .. "\",\r\n"
				end
			elseif (type(v) == "table") then
				toprint = toprint .. serialize(v, indent + 2) .. ",\r\n"
			else
				toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
			end
		end
	else
		toprint = toprint .. "\"" .. tostring(t) .. "\",\r\n"
		-- Does not work
		-- return vim.inspect(t)
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end

--  vim.opt.rutimepath:append()
function path_insert(path, value, position, delimiter)
	if path == nil then return nil end
	if value == nil then return path end
	position = position or "prepend"
	delimiter = delimiter or ";"
	local path_table = vim.split(path, delimiter)
	-- print("origin path" .. serialize(path_table))
	local found = false
	for _, v in ipairs(path_table) do
		print((type(v) == "string") and "" or type(v))
		if v == value then
			found = true
			break
		end
	end
	if found == false then
		if position == "append" then
			path = path .. ";" .. value
		elseif position == "prepend" then
			path = value .. ";" .. path
		end
	end

	-- path_table = vim.split(path, delimiter)
	-- print("output path" .. serialize(path_table))

	return path
end

log.init = function()
	-- print("log: \n" .. serialize(log))

	-- print("log.address: " .. log.address)
	-- print("log _file: " .. home .. "/.vim.log" .. "\n")
	local _file  = io.open(log.address, "w+a")
	_file:write("log: " .. "loaded" .. "\n")
	-- log["_file"] = _file
	_file:write("\n\n")
	_file:flush()
	_file:close()
	-- return _file
	vim.api.nvim_create_autocmd(
	{ "VimLeavePre" },
	{
		pattern = { '*' },
		group = vim.api.nvim_create_augroup("log_file_close", { clear = true }),
		callback = function()
			if file then
				file:flush()
				file:close()
			end
		end,
	}
	)
end

function print(key, value)
	if type(key) ~= "string" and key ~= nil then
		key = tostring(key)
	end
	if key == nil then key = "" end

	-- if key:find("object type") then
	--  vim.print("key: " .. key)                   -- object type: table
	--  vim.print("value: " .. vim.inspect(value))  -- nil
	-- end

	if type(value) ~= "string" and value ~= nil then
		value = tostring(value)
	end
	if value == nil then value = "" end

	if value == "" then
		begin_index, end_index = string.find(key, ":")
		if begin_index ~= nil and end_index ~= nil and value == "" then
			local str = key
			-- vim.print("str: " .. str)
			-- vim.print("begin_index: " .. begin_index)
			-- vim.print("end_index: " .. end_index)
			key    = str:sub(1, begin_index - 1)
			-- vim.print("key: " .. key)
			value  = str:sub(end_index + 1)
			-- vim.print("value: " .. value)
		end
	end
	-- https://stackoverflow.com/questions/51181222/lua-trailing-space-removal
	key    = string.gsub(key,   '^%s*(.-)%s*$', '%1')
	value  = string.gsub(value, '^%s*(.-)%s*$', '%1')

	file:write(string.format("%-37s", key) .. ': ' .. value .. "\n")
end

-- local sh = require("sh")
-- local echo = sh.command('echo')
-- local home = tostring(echo('$HOME'))

-- https://rosettacode.org/wiki/Environment_variables
local home  = os.getenv("HOME")
-- print("home: " .. home .. "\n")
-- https://stackoverflow.com/questions/17636812/read-console-output-realtime-in-lua?rq=1
--
log.home    = home
log.address = home .. "/.vim.log"

file = io.open(log.address, "a")

return log

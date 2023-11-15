local log = {}
-- https://www.domoticz.com/forum/viewtopic.php?t=27630
-- local function osExecute(cmd)
log.osExecute = function(cmd)
	local fileHandle     = assert(io.popen(cmd, 'r'))
	local commandOutput  = assert(fileHandle:read('*a'))
	local returnTable    = {fileHandle:close()}
	return commandOutput,returnTable[3]            -- rc[3] contains returnCode
end

-- https://stackoverflow.com/questions/9676113/lua-os-execute-return-value
-- local function os_execute(cmd)
log.os_execute = function (cmd)
	local f = io.popen(cmd) -- runs command
	local result = f:read("*a") -- read output of command
	-- print(l)
	f:close()
	return result
end

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

-- https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

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
function serialize(tbl, indent)
	if not indent then indent = 0 end
	local toprint = ""
	if tbl == nil then return toprint end
	local len = #tostring(#tbl)
	if len == 0 then return toprint end
	toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	-- for index, data in ipairs(tbl) do
	-- print(index)
	print(type(tbl))
	-- for k, v in ipairs(data) do
	for k, v in ipairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. format(k, len) .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. serialize(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	-- end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end

function path_insert(path, value, position, delimiter)
	if path == nil then return nil end
	if value == nil then return path end
	position = position or "prepend"
	delimiter = delimiter or ";"
	local path_list = vim.split(path, delimiter)
	-- print("origin path" .. serialize(path_list))
	local found = false
	for _, v in ipairs(path_list) do
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

	-- path_list = vim.split(path, delimiter)
	-- print("output path" .. serialize(path_list))

	return path
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

print("log: \n" .. serialize(log))

-- print("log.address: " .. log.address)
-- print("log file: " .. home .. "/.vim.log" .. "\n")
local file  = io.open(log.address, "w+a")
file:write("log: " .. "loaded" .. "\n")
-- log["file"] = file
file:write("\n\n")
file:flush()
file:close()
-- return file
return log

-- https://www.domoticz.com/forum/viewtopic.php?t=27630
local function osExecute(cmd)
    local fileHandle     = assert(io.popen(cmd, 'r'))
    local commandOutput  = assert(fileHandle:read('*a'))
    local returnTable    = {fileHandle:close()}
    return commandOutput,returnTable[3]            -- rc[3] contains returnCode
end

-- https://stackoverflow.com/questions/9676113/lua-os-execute-return-value
local function os_execute(cmd)
    local f = io.popen(cmd) -- runs command
    local result = f:read("*a") -- read output of command
    -- print(l)
    f:close()
    return result
end

function GetFiles(mask)
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

-- -- https://stackoverflow.com/questions/41942289/display-contents-of-tables-in-lua
-- function tprint (tbl, indent)
--     if not indent then indent = 0 end
--     local toprint = string.rep(" ", indent) .. "{\r\n"
--     indent = indent + 2
--     for k, v in pairs(tbl) do
--         toprint = toprint .. string.rep(" ", indent)
--         if (type(k) == "number") then
--             toprint = toprint .. "[" .. k .. "] = "
--         elseif (type(k) == "string") then
--             toprint = toprint  .. k ..  "= "
--         end
--         if (type(v) == "number") then
--             toprint = toprint .. v .. ",\r\n"
--         elseif (type(v) == "string") then
--             toprint = toprint .. "\"" .. v .. "\",\r\n"
--         elseif (type(v) == "table") then
--             toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
--         else
--             toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
--         end
--     end
--     toprint = toprint .. string.rep(" ", indent-2) .. "}"
--     return toprint
-- end

-- local sh = require("sh")
-- local echo = sh.command('echo')
-- local home = tostring(echo('$HOME'))

-- https://rosettacode.org/wiki/Environment_variables
local home = os.getenv("HOME")
-- https://stackoverflow.com/questions/17636812/read-console-output-realtime-in-lua?rq=1
local log_file = io.open(home .. "/.vim.log", "w+a")
log_file:write("boot: " .. "loaded" .. "\n")
-- log_file:write("\n\n")
-- log_file:flush()
-- log_file:close()
return log_file

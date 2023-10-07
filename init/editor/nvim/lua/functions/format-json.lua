
-- lua/functions/format-json.lua

-- run the current through Python's builtin JSON formatter
vim.cmd([[ com! FormatJSON %!python -m json.tool ]])

-- Now, I can execute the :FormatJSON command any time!


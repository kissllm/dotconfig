U = require('utils')

local function map(mode, lhs, rhs, opts)
	local options = { }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	-- local original_definition =
	-- vim.api.nvim_exec("call maparg('" .. lhs .. "', '" ..  mode .. "', " .. "v:false" .. ")", "false")
	-- if original_definition then
	-- 	vim.cmd(mode .. "unmap " .. lhs)
	-- end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- * mode - the editor mode for the mapping (e.g., i for "insert" mode).
-- * lhs - the keybinding to detect.
-- * rhs - the command to execute.
-- * opts - additional options for the configuration (e.g., silent).

-- Let's put it to use!

-- Use jj to exit insert mode
map("i", "jj", "<Esc>")

-- use leader-nt to toggle the NvimTree plugin's visibility in normal mode
map("n", "<leader>nt",   ":NvimTreeToggle<CR>")
map("n", "<leader>nq",   ":NvimTreeClose<CR>")
map("",  "<leader>n",    ":bn<CR>")
map("",  "<leader>p",    ":bp<CR>")
--
-- map("t", "<ESC>",        "<C-\\><C-n>")
--
map("n", "[g",           vim.diagnostic.goto_prev, { silent = true })
map("n", "]g",           vim.diagnostic.goto_next, { silent = true })
map("",  "<C-/><C-/>",   "<C-_><C-_>",             { remap = true })
map("",  "<C-_><C-_>",   "cc",                     { remap = true })
map("v", "<C-_><C-_>",   "gc",                     { remap = true })
map("n", "<leader>t",    ":TestNearest<CR>",       { silent = true })
map("n", "<leader>T",    ":TestFile<CR>",          { silent = true })
map("n", "<leader>A",    ":TestSuite<CR>",         { silent = true })
map("n", "<leader>l",    ":TestLast<CR>",          { silent = true })
map("n", "<leader>g",    ":TestVisit<CR>",         { silent = true })
--
map("n", ",",            "<PageDown>")
map("n", "m",            "<PageDown>")
-- n  u             <Plug>(RepeatUndo)
vim.cmd([[
let key = maparg('u', 'n', v:false)
if key != ""
	unmap u
	endif
]])
map("n", "u",            "<PageUp>",               { unique = true})
vim.cmd([[
let key = maparg('<c-u>', 'n', v:false)
if key != ""
	unmap <c-u>
	endif
]])
-- vim.cmd("unmap <c-u>")
-- map("n", "<c-u>",        "<Plug>(RepeatUndo)",     { unique = true })
map("n", "<c-u>",        "<Undo>",                 { unique = true })
-- map("n", "<c-k>",        ":wincmd k<cr>")
-- map("n", "<c-j>",        ":wincmd j<cr>")
-- map("n", "<c-h>",        ":wincmd h<cr>")
-- map("n", "<c-l>",        ":wincmd l<cr>")
--
map("n", "<Left>",       ":exe 'vertical resize ' . (winwidth(0) + 10)<cr>")
map("n", "<Right>",      ":exe 'vertical resize ' . (winwidth(0) - 10)<cr>")
map("n", "<Up>",         ":exe 'resize ' . (winheight(0) + 5)<cr>")
map("n", "<Down>",       ":exe 'resize ' . (winheight(0) - 5)<cr>")

map("n", "<leader>[",    "m`O<Esc>``")
map("n", '[ ',           "m`O<Esc>``")
map("n", "<S-CR>",       "m`O<Esc>``")
map("n", "<leader>]",    "m`o<Esc>``")
map("n", '] ',           "m`o<Esc>``")
map("n", "<C-CR>",       "m`o<Esc>``")
map("n", "<leader><CR>", "m`o<Esc>``")

map("n", "<F5>",         ':let _s=@/<bar>:%s/\\s\\+$//e<bar>:let @/=_s<bar><cr>')
map("c", "s!!",          ':let _s=@/<bar>:%s/\\s\\+$//e<bar>:let @/=_s<bar><cr>')
-- map("n", "<F7>",         ":set list!<cr>")
-- map("i", "<F7>",         "<C-o>:set list!<cr>")
-- map("c", "<F7>",         "<C-c>:set list!<cr>")
map("n", "gb",           ":ls<cr>:b<space>")
--
map("n", "<leader>/",    ":nohlsearch | diffupdate<CR>",        { silent = true })
-- They are the same
map("n", "<C-[>",        ":nohlsearch | diffupdate<cr>",        { silent = true })
-- map("n", "<esc>",        ":nohlsearch | diffupdate<cr>",     { silent = true })
--
map("n", "<F2>",         ":TagbarToggle<cr>")
map("n", "t",            ":NvimTreeToggle<cr>")
-- map("n",      "<F3>", ":ls<cr>:b<space>")
-- map("n", "<F3>",      ":BuffergatorToggle<cr>")
-- Won't work correctly
-- map("n", "<Esc>",         "if exists(\"b:is_gt_buffer\") <bar> :BuffergatorClose<CR> <bar> endif")
map("n", "<leader>l",    ":BuffergatorToggle<cr>")
map("n", "<Leader>d",    ":<C-U>bprevious <bar> bdelete #<cr>", { silent = true })
map("n", "<Leader>q",    ":Bdelete<CR>",                        { silent = true })

-- Prevent x from overriding what's in the clipboard.
map("n", "x", "\"_x")
map("n", "X", "\"_x")

-- Prevent selecting and pasting from overwriting what you originally copied.
map("x", "p", "pgvy")

-- Keep cursor at the bottom of the visual selection after you yank it.
map("v", "y", "ygv<Esc>")
map("n", "xx", "dd")
map("n", "X", "D")



-- use leader-t to run the unit test under my cursor, but don't display the command in the UI
map("n", "<leader>t", ":TestNearest<CR>", { silent = true })

-- Remember utils.lua? Its platform detection helpers make another appearance here:

-- use `gx` to open the path under the cursor using the system handler
if U.is_linux() then
	map("n", "gx", "<Cmd>call jobstart(['xdg-open', expand('<cfile>')])<CR>")
elseif U.is_mac() then
	map("n", "gx", "<Cmd>call jobstart(['open', expand('<cfile>')])<CR>")
end
map("n", "<leader>qt",  ":Tclose!<CR>", { silent = true })

map("n", "ea",          "<Plug>(EasyAlign)")
map("x", "ea",          "<Plug>(EasyAlign)")
--  Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
map("v", "<Enter>",     "<Plug>(EasyAlign)", { remap = true })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map("n", "ga",          "<Plug>(EasyAlign)", { remap = true })

-- local telescope = require('telescope.builtin')
-- map("n", "<C-p>", telescope.find_files)
-- map("n", "<leader>rg", telescope.live_grep)
-- map("n", "<C-Space>", telescope.buffers)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		map("n", "<leader>a", vim.lsp.buf.code_action, opts)
		-- map("n", "gd", telescope.lsp_definitions, opts)
		-- map("n", "gy", telescope.lsp_type_definitions, opts)
		-- map("n", "gr", telescope.lsp_references, opts)
		map({ "n", "x" }, "<leader>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>r", vim.lsp.buf.rename, opts)
	end
})









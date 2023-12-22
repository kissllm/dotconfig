local U = require('utils')

-- local function map(mode, lhs, rhs, opts)
--  local options = { }
--  if opts then
--      options = vim.tbl_extend("force", options, opts)
--  end
--  -- local original_definition =
--  -- vim.api.nvim_exec("call maparg('" .. lhs .. "', '" ..  mode .. "', " .. "v:false" .. ")", "false")
--  -- if original_definition then
--  --  vim.cmd(mode .. "unmap " .. lhs)
--  -- end
--  vim.keymap.set(mode, lhs, rhs, options)
-- end


-- Register a global internal keymap that wraps `rhs` to be repeatable.
-- @param mode string table keymap mode, see vim.keymap.set()
-- @param lhs string lhs of the internal keymap to be created, should be in the form `<Plug>(...)`
-- @param rhs string function rhs of the keymap, see vim.keymap.set()
-- @return string The name of a registered internal `<Plug>(name)` keymap. Make sure you use { remap = true }.
local make_repeatable_keymap = function (mode, lhs, rhs)
	vim.validate {
		mode = { mode, { 'string', 'table' } },
		rhs  = { rhs,  { 'string', 'function' },
		lhs  = { name = 'string' } }
	}
	if not vim.startswith(lhs, "<Plug>") then
		error("`lhs` should start with `<Plug>`, given: " .. lhs)
	end
	vim.keymap.set(mode, lhs, function()
		rhs()
		vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(lhs, true, true, true))
	end)
	return lhs
end


local map = U.map

-- local function map(...)
--  return U.map(...)
-- end
--
-- Check definitions
-- :verbose map =

-- * mode - the editor mode for the mapping (e.g., i for "insert" mode).
-- * lhs - the keybinding to detect.
-- * rhs - the command to execute.
-- * opts - additional options for the configuration (e.g., silent).

-- Let's put it to use!

-- Use jj to exit insert mode
map("i", "jj", "<Esc>")
map("n", "-", "g_")

-- use leader-nt to toggle the NvimTree plugin's visibility in normal mode
map("n", "<leader>nt",   ":NvimTreeToggle<CR>")
map("n", "<leader>nq",   ":NvimTreeClose<CR>")
map("",  "<leader>n",    ":bn<CR>")
map("",  "<leader>p",    ":bp<CR>")
--
-- map("t", "<ESC>",        "<C-\\><C-n>")
--
map("n", "[g",           vim.diagnostic.goto_prev, { silent  = true })
map("n", "]g",           vim.diagnostic.goto_next, { silent  = true })
map("",  "<C-/><C-/>",   "<C-_><C-_>",             { noremap = true })
map("",  "<C-_><C-_>",   "cc",                     { noremap = true })
map("v", "<C-_><C-_>",   "gc",                     { noremap = true })
map("n", "<leader>t",    ":TestNearest<CR>",       { silent  = true })
map("n", "<leader>T",    ":TestFile<CR>",          { silent  = true })
map("n", "<leader>A",    ":TestSuite<CR>",         { silent  = true })
map("n", "<leader>l",    ":TestLast<CR>",          { silent  = true })
map("n", "<leader>g",    ":TestVisit<CR>",         { silent  = true })
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
-- map("n", "<c-u>",        "<Plug>(RepeatUndo)",     { unique = true, noremap = true })
-- map("n", "<C-U>",        "<Plug>(RepeatUndo)",     { unique = true })
-- map("n", "<C-U>",
-- function()
--  vim.call('repeat#set', '<C-U>')
-- end, { }
-- )

-- vim.keymap.set("n", "<C-U>", function()
--  vim.cmd("undo")
--  vim.call('repeat#set', '<C-U>', vim.v.count)
-- end, { buffer = 0 })

-- vim.keymap.set('n', '<C-U>', make_repeatable_keymap('n', '<Plug>(RepeatUndo)', function()
--     -- the actual body (rhs) goes here: some complex logic that you want to repeat
--  vim.cmd("undo")
-- end, { remap = true }))

-- map("n", "<c-u>",        "<Undo>",                 { unique = true, noremap = true })
map("n", "<c-u>",        "<Undo>",                 { unique = true, noremap = true })
-- map("n", "<c-k>",        ":wincmd k<cr>")
-- map("n", "<c-j>",        ":wincmd j<cr>")
-- map("n", "<c-h>",        ":wincmd h<cr>")
-- map("n", "<c-l>",        ":wincmd l<cr>")

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
-- map("n", "<F3>",         ":ls<cr>:b<space>")
-- map("n", "<F3>",         ":BuffergatorToggle<cr>")
-- Won't work correctly
-- map("n", "<Esc>",        "if exists(\"b:is_gt_buffer\") <bar> :BuffergatorClose<CR> <bar> endif")
--
-- map("n", "<leader>l",    ":BuffergatorToggle<cr>")
-- :nnoremap <Leader>pp :lua require'telescope.builtin'.buffers{}
map("n", "<leader>l",    ":lua require'telescope.builtin'.buffers{}<cr>")

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

map("t", "<Esc>", "<C-\\><C-n>")
map("t", "<A-h>", "<C-\\><C-N><C-w>h")
map("t", "<A-j>", "<C-\\><C-N><C-w>j")
map("t", "<A-k>", "<C-\\><C-N><C-w>k")
map("t", "<A-l>", "<C-\\><C-N><C-w>l")

-- https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
-- inoremap <c-u> <c-g>u<c-u>
-- inoremap <c-w> <c-g>u<c-w>
map("i", "<c-u>", "<c-g>u<c-u>", { noremap = true })
map("i", "<c-w>", "<c-g>u<c-w>", { noremap = true })





-- use leader-t to run the unit test under my cursor, but don't display the command in the UI
map("n", "<leader>t", ":TestNearest<CR>", { silent = true })

-- Remember utils.lua? Its platform detection helpers make another appearance here:

-- use `gx` to open the path under the cursor using the system handler
if U.is_linux() then
	map("n", "gx", "<Cmd>call jobstart(['xdg-open', expand('<cfile>')])<CR>")
elseif U.is_mac() then
	map("n", "gx", "<Cmd>call jobstart(['open', expand('<cfile>')])<CR>")
end

-- map('n', "w", "<Cmd>call boot#write_generic()<cr>")
-- vim.keymap.set('ca', 'w', ":getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w'")

map("n", "<leader>qt",  ":Tclose!<CR>", { silent = true })

map("n", "ea",          "<Plug>(EasyAlign)")
map("x", "ea",          "<Plug>(EasyAlign)")
--  Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
map("v", "<Enter>",     "<Plug>(EasyAlign)", { noremap = true })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map("n", "ga",          "<Plug>(EasyAlign)", { noremap = true })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
	pattern = "*",
	callback = function(ev)
		local opts = { buffer = ev.buf }
		map("n", "<leader>a", vim.lsp.buf.code_action, opts)

		local builtin = require("telescope.builtin")
		local cwd = require("lazy.core.config").options.root

		map("n", "gd", function() builtin.lsp_definitions({ cwd = cwd }) end, opts)
		map("n", "gy", function() builtin.lsp_type_definitions({ cwd = cwd }) end, opts)
		map("n", "gr", function() builtin.lsp_references({ cwd = cwd }) end, opts)

		map("n", "<leader>ff", function() builtin.find_files({ cwd = cwd }) end, opts)
		map("n", "<leader>fg", function() builtin.live_grep({ cwd = cwd }) end, opts)
		map("n", "<leader>fb", function() builtin.buffers({ cwd = cwd }) end, opts)
		map("n", "<leader>fh", function() builtin.help_tags({ cwd = cwd }) end, opts)

		map({ "n", "x" }, "<leader>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>r", vim.lsp.buf.rename, opts)
	end,
})

-- nvim-cmp
vim.keymap.set("n", "<leader>ua", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>", { desc = "toggle nvim-cmp" })

-- local builtin = require('telescope.builtin')
-- map("n", "<C-p>", builtin.find_files)
-- map("n", "<leader>rg", builtin.live_grep)
-- map("n", "<C-Space>", builtin.buffers)

-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})






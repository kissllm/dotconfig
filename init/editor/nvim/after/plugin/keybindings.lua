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
local make_repeatable_keymap = function(mode, lhs, rhs)
	vim.validate {
		mode = { mode, { 'string', 'table' } },
		rhs  = {
			rhs,
			{ 'string', 'function' },
			lhs = { name = 'string' }
		}
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
map("n", "-",  "g_")

-- map('n', "\\", "<Plug>(dirvish_up)", { noremap = true })

-- use leader-nt to toggle the NvimTree plugin's visibility in normal mode
-- Defined in corresponding .lua
-- map("n", "\\", ":NvimTreeToggle<cr>")
-- map("n", "<leader>nt", ":NvimTreeToggle<CR>")
-- map("n", "<leader>nq", ":NvimTreeClose<CR>")
-- map("n", "<leader>nq", ":Neotree close<CR>")
-- map("n", "t", ":Neotree toggle<CR>")
-- map("n", "t", ":Neotree<cr>")

--
-- map("t", "<ESC>",        "<C-\\><C-n>")
--
map("n", "[g",         vim.diagnostic.goto_prev, { silent  = true })
map("n", "]g",         vim.diagnostic.goto_next, { silent  = true })
map("",  "<C-/><C-/>", "<C-_><C-_>",             { noremap = true })
map("",  "<C-_><C-_>", "cc",                     { noremap = true })
map("v", "<C-_><C-_>", "gc",                     { noremap = true })
map("n", "<leader>t",  ":TestNearest<CR>",       { silent  = true })
map("n", "<leader>T",  ":TestFile<CR>",          { silent  = true })
map("n", "<leader>A",  ":TestSuite<CR>",         { silent  = true })
map("n", "<leader>l",  ":TestLast<CR>",          { silent  = true })
map("n", "<leader>g",  ":TestVisit<CR>",         { silent  = true })
--
map("n", ",", "<PageDown>")
map("n", "m", "<PageDown>")
-- n  u             <Plug>(RepeatUndo)
vim.cmd([[
let key = maparg('u', 'n', v:false)
if key != ""
	unmap u
	endif
]])
map("n", "u", "<PageUp>", { unique = true })
vim.cmd([[
	let key = maparg('<c-u>', 'n', v:false)
	if key != ""
		unmap <c-u>
	endif
]])

-- https://www.reddit.com/r/vim/comments/19sm9v/replace_all_instances_of_currently_highlighted/
-- nnoremap * *<c-o>
-- vim.cmd([[
-- let key = maparg('*', 'n', v:false)
-- if key != ""
--  unmap *
--  endif
-- ]])
-- map("n", "*", "*<c-o>")
--
-- nnoremap <c-n> :%s///g<left><left>
map("n", "<c-n>", ":%s///gIc<left><left><left><left>")

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

-- map("n", "<c-u>", "<Undo>", { unique = true, noremap = true })
   map("n", "<c-u>", "<Undo>", { unique = true, noremap = true })
-- map("n", "<c-k>",        ":wincmd k<cr>")
-- map("n", "<c-j>",        ":wincmd j<cr>")
-- map("n", "<c-h>",        ":wincmd h<cr>")
-- map("n", "<c-l>",        ":wincmd l<cr>")

-- These is occupied by tty switches
-- map("n", "<A-Left>",     ":exe 'vertical resize ' . (winwidth(0) + 10)<cr>")
-- map("n", "<A-Right>",    ":exe 'vertical resize ' . (winwidth(0) - 10)<cr>")
-- map("n", "<A-Up>",       ":exe 'resize ' . (winheight(0) + 5)<cr>")
-- map("n", "<A-Down>",     ":exe 'resize ' . (winheight(0) - 5)<cr>")

map("n", "<A-h>", ":exe 'vertical resize ' . (winwidth(0) - 20)<cr>")
map("n", "<A-l>", ":exe 'vertical resize ' . (winwidth(0) + 20)<cr>")
map("n", "<A-j>", ":exe 'resize ' . (winheight(0) - 5)<cr>")
map("n", "<A-k>", ":exe 'resize ' . (winheight(0) + 5)<cr>")


-- map("n", '[ ', "m`O<Esc>``")
-- Paired with tmux.conf bind-key -n \{
-- Hard to input {, you need to wait for a while
-- map("i", "[ ", "{")

map("n", "<leader>[", "m`O<Esc>``")
map("n", '{',         "m`O<Esc>``")
map("n", "<S-CR>",    "m`O<Esc>``")


-- map("n", '] ', "m`o<Esc>``")
-- Paired with tmux.conf bind-key -n \}
-- Hard to input }, you need to wait for a while
-- map("i", "] ", "}")

map("n", "<leader>]",    "m`o<Esc>``")
map("n", '}',            "m`o<Esc>``")
map("n", "<C-CR>",       "m`o<Esc>``")
map("n", "<leader><CR>", "m`o<Esc>``")

map("n", "<F5>", ':let _s=@/<bar>:%s/\\s\\+$//e<bar>:let @/=_s<bar><cr>')
map("c", "s!!",  ':let _s=@/<bar>:%s/\\s\\+$//e<bar>:let @/=_s<bar><cr>')
-- https://github.com/neovim/neovim/issues/19198
-- With #19238
local abbrev = vim.cmd.abbrev

-- Without #19238
local function abbrev(l, r)
	vim.cmd{ cmd = 'abbrev', args = { l, r } }
end
-- https://vi.stackexchange.com/questions/33220/make-cabbrev-work-from-command-line-but-not-search-prompt
-- abbrev(':w:', [[getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w']])
-- map('i', [[getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w']])
-- vim.keymap.set({ 'i', 's' }, 'w', function()
-- vim.api.nvim_set_keymap("c", "<c-k>", [[ wildmenumode() ? "c-k>" : "<up>" ]], { noremap = true, expr = true }) -- expr mapping
-- https://www.reddit.com/r/neovim/comments/sdozdw/command_mode_keybindings/

-- vim.api.nvim_set_keymap("c", 'w', [[(getcmdtype() == ':' && getcmdline() == 'w' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W']], { expr = true, noremap = true })

-- Works but how to input 'w' inside a readonly buffer ?
-- vim.api.nvim_set_keymap("c", 'w', [[
-- Works
-- vim.api.nvim_set_keymap("ca", 'w', [[
-- (getcmdtype() == ':' && getcmdline() == 'w' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W'
-- ]],
-- { expr = true, noremap = true })

-- vim.api.nvim_set_keymap("c", 'w', [[(getcmdtype() == ':' && getcmdline() == 'w') ? 'W' : 'w']], { expr = true, noremap = true })

-- map('n', "w", "<Cmd>call boot#write_generic()<cr>")
-- vim.keymap.set("ca", 'w', ":getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w'")
-- vim.cmd([[ca w (getcmdtype() == ':' && getcmdline() == 'w' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W']])

-- Works
-- vim.cmd([[cnoreabbrev <expr> w (getcmdtype() == ':' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W']])
-- Works
-- vim.cmd([[cnoreabbrev <expr> w (getcmdtype() == ':' && getcmdline() == 'w') ? 'W' : 'w']])
-- Does not work
-- vim.cmd([[:cnoremap    <expr> w (getcmdtype() == ':' && getcmdline() == 'w' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W']])

-- Won't work
-- map('c', 'w', function()
--  vim.cmd[[(getcmdtype() == ':' && system('whoami') == system('stat -c %U ' . shellescape(expand('%')))) ? 'w' : 'W']]
--  -- if vim.snippet.active({ direction = 1 }) then
--  --  return '<Cmd>lua vim.snippet.wjump(1)<CR>'
--  -- else
--  --  return '<Tab>'
--  -- end
-- end, { expr = true, noremap = true })
-- map("n", "<F7>",         ":set list!<cr>")
-- map("i", "<F7>",         "<C-o>:set list!<cr>")
-- map("c", "<F7>",         "<C-c>:set list!<cr>")
map("n", "gb", ":ls<cr>:b<space>")
--
map("n", "<leader>/", ":nohlsearch | diffupdate<CR>", { silent = true })
-- They are the same
-- map("n", "<C-[>",        ":nohlsearch | diffupdate<cr>",     { silent = true })
-- map("n", "<esc>",        ":nohlsearch | diffupdate<cr>",     { silent = true })
--
--  map("n", "<F2>", ":TagbarToggle<cr>")
--  [With ! cursor stays in current window](https://github.com/stevearc/aerial.nvim/issues/364)
--  map("n", "<c-a>", "<cmd>AerialToggle!<cr>")
	map("n", "<leader>o", "<cmd>AerialToggle<cr>")
--  map("n", "<leader>o", ":TagbarToggle<cr>")
--  vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
--  map("n", "<F3>",         ":ls<cr>:b<space>")

map("n", "<Leader>d", ":<C-U>bprevious <bar> bdelete #<cr>", { silent = true })
map("n", "<Leader>q", ":Bdelete<CR>", { silent = true })

-- Prevent selecting and pasting from overwriting what you originally copied.
-- "p" became invalid might bicause of tmux default-command sesstings
-- map("x", "p", "pgvy")
-- map("x", "p", "pgvy",         { noremap = true })
-- map("x", "p", "P",            { noremap = true })
-- map("x", "p", "P")
--
-- vim.cmd([[
-- " https://vi.stackexchange.com/questions/25259/clipboard-is-reset-after-first-paste-in-visual-mode/25260#25260
-- " Paste without delete the content in registers, and now it is possible to paste many times over selected text
-- " xnoremap <expr> p '""pgv"' . v:register . 'y`>'
--   xnoremap <expr> p '"' . v:register . 'pgv"' . v:register . 'y`>'
-- " xnoremap <expr> P '""Pgv"' . v:register . 'y`>'
--   xnoremap <expr> P '"' . v:register . 'Pgv"' . v:register . 'y`>'
--   nnoremap <leader>p m`o<ESC>p``
--   nnoremap <leader>P m`O<ESC>p``
-- " xnoremap p m`o<ESC>p``
-- " xnoremap P m`O<ESC>p``
-- " https://stackoverflow.com/questions/1346737/how-to-paste-in-a-new-line-with-vim
-- " This implementation won't insert copies
-- " nmap p :pu<CR>
-- " nmap P :pu!<CR>
-- ]])

-- map('x', 'p', vim.api.nvim_replace_termcodes('\"' .. vim.v.register .. 'pgv"' .. vim.v.register .. 'y`>', true, true, true), { expr = true, noremap = true })
-- map('x', 'P', vim.api.nvim_replace_termcodes('\"' .. vim.v.register .. 'Pgv"' .. vim.v.register .. 'y`>', true, true, true), { expr = true, noremap = true })
map('x', 'p', [['"' . v:register . 'pgv"' . v:register . 'y`>']], { expr = true, noremap = true })
map('x', 'P', [['"' . v:register . 'Pgv"' . v:register . 'y`>']], { expr = true, noremap = true })
-- map('n', '<leader>p', 'm`o<Esc>p``', { noremap = true })
-- map('n', '<leader>P', 'm`O<Esc>p``', { noremap = true })
map("",  "<leader>n",  ":bn<CR>")
map("",  "<leader>p",  ":bp<CR>")

-- Keep cursor at the bottom of the visual selection after you yank it.
map("v", "y", "ygv<Esc>")
-- https://www.reddit.com/r/neovim/comments/1b9n736/deleting_overwriting_clipboard/
-- map({'n', 'v'}, 'x', '"_x') -- keeping the default x
map({'n', 'v'}, 'd', '"_d')
-- Prevent x from overriding what's in the clipboard.
-- [Remapping x, X and Del in Vim to Not Overwrite Your Clipboard](https://nickjanetakis.com/blog/remapping-x-and-del-in-vim-to-not-overwrite-your-clipboard)
-- map("n", "x", '"_x')
-- map("n", "X", '"_x')
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

-- map("n", "<leader>cd", ':lua vim.api.nvim_command("colorscheme onehalf-lush-dark")<cr>')
map("n", "<leader>cd", ":lua vim.opt.background = 'dark'<cr>")
-- map("n", "<leader>cl", ':lua vim.api.nvim_command("colorscheme onehalf-lush")<cr>')
map("n", "<leader>cl", ":lua vim.opt.background = 'light'<cr>")

map("n", "<leader>qt", ":Tclose!<CR>", { silent = true })

map("n", "ea", "<Plug>(EasyAlign)")
map("x", "ea", "<Plug>(EasyAlign)")

--  Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
map("v", "<Enter>", "<Plug>(EasyAlign)", { noremap = true })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map("n", "ga",      "<Plug>(EasyAlign)", { noremap = true })


local log      = require("log")

-- print(log.os_execute("ls"))
-- print(log.os_execute("grep prefixground /mnt/init/terminal/tmux.conf | grep %hidden | awk -F = '{print $2}' | xargs"))
local tmux_key_enabled = false
local prefixground = log.os_execute(
"grep prefix_background " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep %hidden | awk -F = '{print $2}' | xargs | tr -d \"$IFS\"")
vim.g.prefixground = prefixground
print("prefixground : " .. vim.g.prefixground)

local prefix_key   = log.os_execute(
"grep prefix_key   " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep %hidden | awk -F = '{print $2}' | xargs | tr -d \"$IFS\"")
vim.g.prefix_key   = prefix_key
print("prefix_key   : " .. vim.g.prefix_key)

--  local cmd_copy_mode_key = "/usr/bin/tmux list-keys | grep 'Escape' | awk -v key='root' '$3 == key { print }' | awk -F 'copy-mode' '{print $1}' | awk '{print $NF}'"
--  print("cmd_copy_mode_key: " .. cmd_copy_mode_key)
--  local copy_mode_key  -- = os.capture(cmd_copy_mode_key)
--  if copy_mode_key == "" then
--  copy_mode_key = log.os_execute(
--  "grep 'copy-mode' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep -v copy-mode-vi | grep -v unbind | grep -v cancel | grep -v clear | awk -F 'copy-mode' '{print $1}' | awk '{print $NF}'")
--  "grep 'copy-mode' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | awk -F 'if-shell' '{print $1}' | awk '{print $NF}'")
local copy_mode_key = log.os_execute(
	"grep copy_mode_key " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep %hidden | awk -F = '{print $2}' | xargs | tr -d \"$IFS\"")
--  end
vim.g.copy_mode_key  = copy_mode_key
print("copy_mode_key: " .. vim.g.copy_mode_key)

-- local cmd_prefix_per_se = "/usr/bin/tmux list-keys | grep '" .. vim.g.prefix_key .. "' | awk -v key=\"prefix\" \"\\$3 == key { print }\""
local cmd_prefix_per_se = "/usr/bin/tmux list-keys -T prefix | grep '" .. prefix_key .. "'"
-- https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
local prefix_per_se = os.capture(cmd_prefix_per_se)
if prefix_per_se == "" then
	prefix_per_se = log.os_execute(
	-- "grep 'copy-mode' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep -v copy-mode-vi | grep -v unbind | grep -v cancel | grep -v clear")
	"grep 'send-prefix' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf  | grep -v '#' | grep -v 'unbind' | grep -v 'root' | grep bind | grep '\\-T'"
	)
	prefix_per_se = prefix_per_se:gsub("%$prefix_key", prefix_key)
end
if prefix_root ~= "" then
	prefix_per_se = prefix_per_se:gsub('`', [['`']])
	prefix_per_se = prefix_per_se:gsub("''", "'")
end
-- prefix_per_se       =  string.format('%q', prefix_per_se)
vim.g.prefix_per_se = prefix_per_se
print("prefix_per_se: " .. vim.g.prefix_per_se)
-- -- vim.g.prefix_per_se  = log.os_execute("tmux list-keys | grep Escape | awk -v key=\"prefix\"       '$3 == key {for (i = 5; i < NF; i ++) printf \"%s \", $(i) ; printf \"%s\", $NF ; print \"\"}'")
-- -- vim.g.prefix_per_se  = log.os_execute(
-- -- "\'" .. "tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"prefix\" \"\\$3 == key { print }\"" .. "\'"
-- -- "'tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"prefix\" \"\\$3 == key { print }\"'"
-- -- )
-- vim.g.prefix_per_se  = log.os_execute("'" .. cmd_prefix_per_se .. "'")
-- -- vim.g.prefix_per_se  = posix.exec(
-- -- "/usr/bin/tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"prefix\" \"\\$3 == key { print }\"", { }
-- -- )
-- print("cmd_prefix_per_se: " .. cmd_prefix_per_se)
-- print("prefix_per_se: " .. vim.g.prefix_per_se)
-- local cmd_prefix_root = "/usr/bin/tmux list-keys | grep '" .. vim.g.prefix_key .. "' | awk -v key='root' '$3 == key { print }'"
local cmd_prefix_root = "/usr/bin/tmux list-keys -T root | grep '" .. prefix_key .. "'"
-- -- vim.g.prefix_root    = log.os_execute("'" .. "tmux list-keys | grep Escape | awk -v key=\"root\" \"\$3 == key {for (i = 5; i < NF; i ++) printf \"%s \", \$(i) ; printf \"%s\", \$NF ; print \"\"}\"" .. "'")
-- -- vim.g.prefix_root    = log.os_execute(
-- -- "\'" .. "tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"root\"   \"\\$3 == key { print }\"" .. "\'"
-- -- "'tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"root\"   \"\\$3 == key { print }\"'"
-- -- "'" .. cmd_prefix_root .. "'"
-- -- )
print("cmd_prefix_root  : " .. cmd_prefix_root)
-- vim.g.prefix_root    = log.os_execute("'" .. cmd_prefix_root .. "'")
local prefix_root    = os.capture(cmd_prefix_root)
print("prefix_root  : " .. prefix_root)
if prefix_root == "" then
	prefix_root = log.os_execute(
	-- "grep 'copy-mode' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep -v copy-mode-vi | grep -v unbind | grep -v cancel | grep -v clear")
	"grep 'send-prefix' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf  | grep -v '#' | grep 'root' | grep -v 'unbind' | grep bind | grep '\\-T'"
	)
	prefix_root = prefix_root:gsub("%$prefix_key", prefix_key)
end
if prefix_root ~= "" then
	prefix_root = prefix_root:gsub('`', [['`']])
	prefix_root = prefix_root:gsub("''", "'")
end
-- prefix_root       =  string.format('%q', prefix_root)
vim.g.prefix_root    = prefix_root
-- -- vim.g.prefix_per_se  = posix.exec(
-- -- "/usr/bin/tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"root\"   \"\\$3 == key { print }\"", { }
-- -- )
-- print("cmd_prefix_root: " .. cmd_prefix_root)
print("prefix_root  : " .. vim.g.prefix_root)
-- local cmd_copy_mode_vi = "/usr/bin/tmux list-keys | grep '" .. vim.g.prefix_key .. "' | awk -v key=\"copy-mode-vi\" \"\\$3 == key { print }\""
local cmd_copy_mode_vi  = "/usr/bin/tmux list-keys -T copy-mode-vi | grep '" .. vim.g.prefix_key .. "'"
-- local cmd_copy_mode    = "/usr/bin/tmux list-keys | grep 'Escape' | awk -v key='copy-mode'   " .. "'$3 == key { print }'"

-- local cmd_copy_mode     = "/usr/bin/tmux list-keys | grep '" .. copy_mode_key .. "' | awk -v key='root' '$3 == key { print }'"
local cmd_copy_mode     = "/usr/bin/tmux list-keys -T root | grep '" .. copy_mode_key .. "'"

-- -- vim.g.copy_mode_vi   = log.os_execute("'" .. "tmux list-keys | grep Escape | awk -v key=\"copy-mode-vi\" \"\$3 == key {for (i = 5; i < NF; i ++) printf \"%s \", \$(i) ; printf \"%s\", \$NF ; print \"\"}\"" .. "'")
-- -- vim.g.copy_mode_vi   = log.os_execute(
-- -- "\'" .. "tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"copy-mode-vi\" \"\\$3 == key { print }\"" .. "\'"
-- -- "'tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"copy-mode-vi\" \"\\$3 == key { print }\"'"
-- -- "'" .. cmd_copy_mode_vi .. "'"
-- -- )
print("cmd_copy_mode    : " .. cmd_copy_mode)
-- vim.g.copy_mode_vi   = log.os_execute("'" .. cmd_copy_mode_vi .. "'")
local copy_mode_vi   = os.capture(cmd_copy_mode_vi)
if copy_mode_vi ~= "" then
	copy_mode_vi = copy_mode_vi:gsub('`', [['`']])
	copy_mode_vi = copy_mode_vi:gsub("''", "'")
end
vim.g.copy_mode_vi   = copy_mode_vi
-- print("cmd_copy_mode_vi: " .. cmd_copy_mode_vi)
print("copy_mode_vi : " .. vim.g.copy_mode_vi)

local copy_mode      = os.capture(cmd_copy_mode)
if copy_mode == "" then
	copy_mode = log.os_execute(
	"grep 'copy-mode' " .. os.getenv("DOT_CONFIG") .. "/terminal/tmux.conf | grep -v '#' | grep -v copy-mode-vi | grep -v unbind | grep -v cancel | grep -v clear")
	copy_mode = copy_mode:gsub("%$copy_mode_key", copy_mode_key)
end
if copy_mode ~= "" then
	copy_mode = copy_mode:gsub('`', [['`']])
	copy_mode = copy_mode:gsub("''", "'")
end
vim.g.copy_mode      = copy_mode
-- -- vim.g.prefix_per_se  = posix.exec(
-- -- "/usr/bin/tmux list-keys | grep " .. vim.g.prefix_key .. " | awk -v key=\"copy-mode-vi\" \"\\$3 == key { print }\"", { }
-- -- )
print("copy_mode    : " .. vim.g.copy_mode)

-- -- [Split a string and store in an array in lua](https://www.iditect.com/program-example/split-a-string-and-store-in-an-array-in-lua.html)

-- When using Escape as prefix and triggerd prefix-w, use ctrl-m to quit it
-- Works
-- vim.cmd[[
--
-- " if g:prefix_key ==? 'Escape'
--
-- " let g:prefix_per_se = system("/usr/bin/tmux list-keys | grep " . g:prefix_key . " | awk -v key = \"prefix\" \"\\$3       =  = key { print }\"")
-- " let g:prefix_root   = system("/usr/bin/tmux list-keys | grep " . g:prefix_key . " | awk -v key = \"root\"   \"\\$3       =  = key { print }\"")
-- " let g:copy_mode_vi  = system("/usr/bin/tmux list-keys | grep " . g:prefix_key . " | awk -v key = \"copy-mode-vi\" \"\\$3 =  = key { print }\"")
--
-- " let g:prefix_key = "Escape"
-- " let g:prefix_key = "Backtick"
-- " let g:prefix_key = "`"
--
-- " if g:prefix_key == "`"
-- function! s:tmux_prefix_cancel()
--  " prefix_key_1_0
--    call system(split('/usr/bin/tmux unbind ' . g:prefix_key))
--
--  " prefix_key_1_1
--    call system(split('/usr/bin/tmux set prefix None'))
--
--  " prefix_key_2_0
--    call system(split('/usr/bin/tmux unbind -T root ' . g:prefix_key))
--  " call system(['/usr/bin/tmux', 'unbind',   '-T', 'root', g:copy_mode_key])
--    call system(split('/usr/bin/tmux unbind ' . g:copy_mode_key))
--    call system(split('/usr/bin/tmux unbind -T root ' . g:copy_mode_key))
--  " call system('/usr/bin/tmux unbind -T root Escape')
--
--  " prefix_key_3_0
--  " call system(['/usr/bin/tmux', 'unbind',   '-T', 'copy-mode-vi', g:prefix_key])
--  " prefix_key_4
--    call system(split('/usr/bin/tmux set -g window-active-style fg=default,bg=terminal'))
-- endfunction
--
-- function! s:tmux_prefix_reenable(mode = "")
--  " prefix_key_1_1
--    call system(split('/usr/bin/tmux set prefix ' . g:prefix_key))
--  " prefix_key_1_2
--  " let g:prefix_per_se_list = split(g:prefix_per_se)
--  " call system(g:prefix_per_se_list)
--
--    call system(split('/usr/bin/tmux ' . g:prefix_per_se))
--
--  " call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix',       g:prefix_key,
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=' . g:prefixground, '\;',
--  "   \ 'send-keys',  g:prefix_key,  '\;',
--  "   \ 'switch-client',  '-T', 'prefix', '\;',
--  "   \ 'display-panes', '-N', '\;',
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'
--  "   \ ])
--      " \ 'display-panes', '-N'])
--      " \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal', '\;',
--      " \ 'send-keys',  g:prefix_key,  '\;',
--      " \ 'switch-client',  '-T', 'prefix', '\;',
--
--  " prefix_key_2_1
--    call system(split('/usr/bin/tmux ' . g:prefix_root))
--    if mode() =~# '^[n]' || a:mode =~? "leave"
--        call system(split('/usr/bin/tmux ' . g:copy_mode))
--    endif
--  " call system(split('/usr/bin/tmux ' . 'bind-key -T root Escape copy-mode'))
--  " call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',         g:prefix_key,
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=' . g:prefixground, '\;',
--  "   \ 'send-keys',  g:prefix_key,  '\;',
--  "   \ 'switch-client',  '-T', 'prefix', '\;',
--  "   \ 'display-panes', '-N', '\;',
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'
--  "   \ ])
--
--      " \ 'display-panes', '-N'])
--      " \ 'display-panes', '-N', '\;',
--      " \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
--      " \ 'send-keys',  g:prefix_key,  '\;',
--      " \ 'switch-client',  '-T', 'prefix', '\;',
--
--  " prefix_key_3_1
--  " call system(split('/usr/bin/tmux' . " " . g:copy_mode_vi))
--
--  " call system(['/usr/bin/tmux', 'bind-key', '-T', 'copy-mode-vi', g:prefix_key,
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=' . g:prefixground, '\;',
--  "   \ 'send-keys',  g:prefix_key,  '\;',
--  "   \ 'switch-client',  '-T', 'prefix', '\;',
--  "   \ 'display-panes', '-N', '\;',
--  "   \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'
--  "   \ ])
--      " \ 'send-keys',  g:prefix_key,  '\;',
--      " \ 'switch-client',  '-T', 'prefix', '\;',
-- endfunction
-- " endif
--
-- " if g:prefix_key == "Escape"
-- "   function! s:tmux_prefix_cancel()
-- "       call system(['/usr/bin/tmux', 'unbind', 'Escape'])
-- "       call system(['/usr/bin/tmux', 'unbind',   '-T', 'root',         'Escape'])
-- "       call system(['/usr/bin/tmux', 'set', 'prefix', 'None'])
-- "       call system(['/usr/bin/tmux', 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
-- "   endfunction
-- "   function! s:tmux_prefix_reenable()
-- "       call system(['/usr/bin/tmux', 'set', 'prefix',                  'Escape'])
-- "       call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix',       'Escape',
-- "           \ 'send-keys',  'Escape',  '\;',
-- "           \ 'set', '-g', 'window-active-style', '"fg=default,bg=\#{prefixground}"', '\;',
-- "           \ 'display-panes', '-N', '\;',
-- "           \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
-- "           " \ 'display-panes', '-N'])
-- "           " \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal', '\;',
-- "       call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',         'Escape',
-- "           \ 'send-keys',  'Escape',  '\;',
-- "           \ 'set', '-g', 'window-active-style', '"fg=default,bg=\#{prefixground}"', '\;',
-- "           \ 'display-panes', '-N', '\;',
-- "           \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
-- "           " \ 'display-panes', '-N'])
-- "           " \ 'display-panes', '-N', '\;',
-- "           " \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
-- "           " \ 'switch-client',  '-T', 'prefix', '\;',
-- "       call system(['/usr/bin/tmux', 'bind-key', '-T', 'copy-mode-vi', 'Escape',
-- "           \ 'switch-client',  '-T', 'prefix', '\;',
-- "           \ 'set', '-g', 'window-active-style', '"fg=default,bg=\#{prefixground}"', '\;',
-- "           \ 'display-panes', '-N', '\;',
-- "           \ 'set', '-g', 'window-active-style', 'fg=default,bg=terminal'])
-- "   endfunction
-- " endif
--
-- " https://stackoverflow.com/questions/43691961/does-vim-have-a-trigger-or-event-which-is-fired-whenever-a-command-is-typed
-- " function! s:command_callback()
-- "   let last_command = @:
-- "
-- "   " if last_command =~ 'tabnew'
-- "   "   echomsg "Tabnew was called"
-- "   " endif
-- "   " call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
-- "
-- "   call <sid>tmux_prefix_reenable()
-- "   echohl WarningMsg
-- "       echomsg "tmux_prefix_reenable() was called"
-- "   echohl None
-- " endfunction
-- " cnoremap <silent> <cr> <cr>:call <sid>command_callback()<cr>
--
-- augroup tmux_prefix_mutx_switch
--  autocmd!
--  au InsertEnter,CmdlineEnter * :call <sid>tmux_prefix_cancel()
--
--      " \ call system(['/usr/bin/tmux', 'unbind',   '-T', 'prefix', g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'unbind',   '-T', 'root',   g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'set', 'prefix', 'None'])
--
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix', g:prefix_key, 'send-keys', g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',   g:prefix_key, 'send-keys', g:prefix_key])
--
--
--      " \ call system(['/usr/bin/tmux', 'bind-key', 'Escape', 'switch-client', '-T', 'prefix']) |
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',   'Escape', 'switch-client', '-T', 'prefix']) |
--      " \ call system(['/usr/bin/tmux', 'set', '-g', 'prefix', 'Escape']) |
--
--  au InsertLeave,CmdlineLeave * :call <sid>tmux_prefix_reenable("leave")
--
--      " \ call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
--
--      " \ call system(['/usr/bin/tmux', 'unbind',   '-T', 'prefix', g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'unbind',   '-T', 'root',   g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'set', '-g', 'prefix', g:prefix_key]) |
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix', g:prefix_key, 'send-prefix']) |
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',   g:prefix_key, 'switch-client', '-T', 'prefix']) |
--
--      " \ call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix', g:prefix_key, 'send-prefix']) |
--
--  au ModeChanged *:[trcvV\x16]* :call <sid>tmux_prefix_cancel()
--  " au ModeChanged *:*i* :call <sid>tmux_prefix_cancel()
--
--  " au ModeChanged [is]*:n* :call <sid>tmux_prefix_reenable()
--      " \ call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
--  " au ModeChanged [c\x16]*:n* :call <sid>tmux_prefix_reenable()
--      " \ call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
--  " au ModeChanged [trcvV\x16]*:n* :call <sid>tmux_prefix_reenable()
--      " \ call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
--
--  au ModeChanged *:n* :call <sid>tmux_prefix_reenable()
--
--      " \ call system(['/usr/bin/tmux', 'source-file', $DOT_CONFIG . '/terminal/tmux.conf'])
-- augroup end
--
-- " g:prefix_key
-- " endif
--
-- ]]

local tmux_prefix_cancel = function()
	-- If you do not quote "prefix_key" (it might be a "`" -- backquote)
	-- sh: syntax error: EOF in backquote substitution
	log.os_execute("/usr/bin/tmux unbind '" .. prefix_key .. "'")
	log.os_execute("/usr/bin/tmux set prefix None")
	log.os_execute("/usr/bin/tmux unbind -T root '" .. prefix_key .. "'")

	-- log.os_execute("/usr/bin/tmux unbind '" .. copy_mode_key .. "'")
	-- log.os_execute("/usr/bin/tmux unbind -T root '" .. copy_mode_key .. "'")

	log.os_execute("/usr/bin/tmux set -g window-active-style fg=default,bg=terminal")
	tmux_key_enabled = false
end

local tmux_prefix_reenable = function(mode)
	log.os_execute("/usr/bin/tmux set prefix '" .. prefix_key .. "'")
	if prefix_per_se ~= "" then
		log.os_execute("/usr/bin/tmux " .. prefix_per_se)
	end
	-- "open terminal failed: not a terminal" if prefix_per_se is empty
	if prefix_root ~= "" then
		log.os_execute("/usr/bin/tmux " .. prefix_root)
	end

	-- if copy_mode ~= "" then
	--  -- if mode == '^[n]' or mode == "leave" then
	--  -- if string.find(mode, "n") == 1 then
	--  log.os_execute("/usr/bin/tmux " .. copy_mode)
	--  -- end
	-- end

	tmux_key_enabled = true
end

---$XDG_DATA_HOME/nvim/lazy/oil.nvim/lua/oil/util.lua
---This is a hack so we don't end up in insert mode after starting a task
---@param prev_mode string The vim mode we were in before opening a terminal
-- local hack_around_termopen_autocmd = function(prev_mode)
--   -- It's common to have autocmds that enter insert mode when opening a terminal
--   vim.defer_fn(function()
--  local new_mode = vim.api.nvim_get_mode().mode
--  if new_mode ~= prev_mode then
--    if string.find(new_mode, "i") == 1 then
--      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "n", false)
--      if string.find(prev_mode, "v") == 1 or string.find(prev_mode, "V") == 1 then
--        vim.cmd.normal({ bang = true, args = { "gv" } })
--      end
--    end
--  end
--   end, 10)
-- end

-- [Pass winID as a Lua Callback Argument for Autocommands](https://github.com/neovim/neovim/pull/26430)
-- [Add FloatNew and FloatClosed events](https://github.com/neovim/neovim/issues/26548)
local function has_floating_window(tabnr)
	tabnr = tabnr or 0  -- by default, the current tabpage
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
		return vim.api.nvim_win_get_config(win).relative ~= ""
	end
	return false
end
-- last_version -- im.api.nvim_create_autocmd('WinNew', {
-- last_version --    pattern = '*',
-- last_version --    group = augroup,
-- last_version --    callback = function()
-- last_version --      local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
-- last_version --      if is_floating then
-- last_version --          tmux_prefix_cancel()
-- last_version --      end
-- last_version --    end,
-- last_version -- )
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	group = vim.api.nvim_create_augroup("tmux_prefix_modechanged", { clear = true }),
	pattern = { "*" },
	callback = function(prev_mode)
		vim.defer_fn(function()
			local new_mode = vim.api.nvim_get_mode().mode
			if new_mode ~= prev_mode then

				if has_floating_window(0) == false then
					if string.find(new_mode, "n") == 1 then
						tmux_prefix_reenable(new_mode)
					end
				end
				if string.find(new_mode, "i") == 1 or string.find(new_mode, "[trcvV\x16]") == 1 then
					tmux_prefix_cancel()
					-- vim.cmd[[
					-- function! s:tmux_prefix_cancel()
					-- " prefix_key_1_0
					-- call system(split('/usr/bin/tmux unbind ' . g:prefix_key))

					-- " prefix_key_1_1
					-- call system(split('/usr/bin/tmux set prefix None'))

					-- " prefix_key_2_0
					-- call system(split('/usr/bin/tmux unbind -T root ' . g:prefix_key))
					-- " call system(['/usr/bin/tmux', 'unbind',   '-T', 'root', g:copy_mode_key])
					-- call system(split('/usr/bin/tmux unbind ' . g:copy_mode_key))
					-- call system(split('/usr/bin/tmux unbind -T root ' . g:copy_mode_key))
					-- " call system('/usr/bin/tmux unbind -T root Escape')

					-- " prefix_key_3_0
					-- " call system(['/usr/bin/tmux', 'unbind',   '-T', 'copy-mode-vi', g:prefix_key])
					-- " prefix_key_4
					-- call system(split('/usr/bin/tmux set -g window-active-style fg=default,bg=terminal'))
					-- endfunction
					-- :call s:tmux_prefix_cancel()
					-- ]]
					-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "n", false)
					-- if string.find(prev_mode, "v") == 1 or string.find(prev_mode, "V") == 1 then
					--  vim.cmd.normal({ bang = true, args = { "gv" } })
					-- end
				end
				-- Resolve float window Escape quit
				-- For float window
				if has_floating_window(0) then
					-- if string.find(new_mode, "n") == 1 then
					--  tmux_prefix_reenable(new_mode)
					-- end
					if string.find(new_mode, "i") == 1 or string.find(new_mode, "[trcvV\x16]") == 1 then
						-- it will trigger when input { or } ot assert new line in normal mode
						tmux_prefix_cancel()
					end
					-- vim.cmd[[
					-- function! s:tmux_prefix_cancel()
					-- " prefix_key_1_0
					-- call system(split('/usr/bin/tmux unbind ' . g:prefix_key))

					-- " prefix_key_1_1
					-- call system(split('/usr/bin/tmux set prefix None'))

					-- " prefix_key_2_0
					-- call system(split('/usr/bin/tmux unbind -T root ' . g:prefix_key))
					-- " call system(['/usr/bin/tmux', 'unbind',   '-T', 'root', g:copy_mode_key])
					-- call system(split('/usr/bin/tmux unbind ' . g:copy_mode_key))
					-- call system(split('/usr/bin/tmux unbind -T root ' . g:copy_mode_key))
					-- " call system('/usr/bin/tmux unbind -T root Escape')

					-- " prefix_key_3_0
					-- " call system(['/usr/bin/tmux', 'unbind',   '-T', 'copy-mode-vi', g:prefix_key])
					-- " prefix_key_4
					-- call system(split('/usr/bin/tmux set -g window-active-style fg=default,bg=terminal'))
					-- endfunction
					-- :call s:tmux_prefix_cancel()
					-- ]]
					-- return true
				end
			end
		end, 10)
	end
})

-- http://kflu.github.io/2021/05/24/2021-05-24-tmux-tricks/
-- Does not work
-- vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
--  group = vim.api.nvim_create_augroup("tmux_prefix_mutx", { clear = true }),
--  pattern = { "*" },
--  callback = function(args)
--      if vim.api.nvim_eval('v:insertmode') == 'i' then
--          local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'prefix', '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'root',   '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'set', '-sg', 'prefix', 'None' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'bind-key', '-T', 'prefix', '\\`', 'send-keys', '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'bind-key', '-T', 'root',   '\\`', 'send-keys', '\\`' }
--      else
--          -- log.os_execute('/usr/bin/tmux set -s prefix \\` ENTER')
--          -- local output = vim.fn.system { '/usr/bin/tmux', 'set', '\\-s', 'prefix', 'None', ';',
--          --  '/usr/bin/tmux', 'unbind', '\\`', ';', '/usr/bin/tmux', 'bind', '-T', 'root', '\\`', 'send-keys', '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'prefix', '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'root',   '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'set', 'prefix', '\\`' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'bind-key', '-T', 'prefix', '\\`', 'send-prefix' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'bind-key', '-T', 'root',   '\\`', 'switch-client', '-T', 'prefix' }
--          local output = vim.fn.system { '/usr/bin/tmux', 'source-file', '/mnt/init/terminal/tmux.conf' }
--          -- vim.cmd[[
--          -- call system(['/usr/bin/tmux', 'unbind', g:prefix_key])
--          -- call system(['/usr/bin/tmux', 'unbind', '-T', 'root', g:prefix_key])
--          -- call system(['/usr/bin/tmux', 'set', 'prefix', '\`'])
--          -- call system(['/usr/bin/tmux', 'bind-key', '-T', 'prefix', '\`', 'send-prefix'])
--          -- call system(['/usr/bin/tmux', 'bind-key', '-T', 'root',   '\`', 'switch-client', '-T', 'prefix'])
--          -- call system(['/usr/bin/tmux', 'source-file', '/mnt/init/terminal/tmux.conf'])
--          -- ]]
--      end
--  end,
-- })

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
	group = vim.api.nvim_create_augroup("tmux_prefix_leave", { clear = true }),
	pattern = { "*" },
	callback = function(args)
		local new_mode = vim.api.nvim_get_mode().mode
		tmux_prefix_reenable(new_mode)
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	group = vim.api.nvim_create_augroup("tmux_prefix_enter", { clear = true }),
	pattern = { "*" },
	callback = function(args)
		tmux_prefix_cancel()
		-- vim.cmd[[
		-- call system(['/usr/bin/tmux', 'unbind', g:prefix_key])
		-- call system(['/usr/bin/mux', 'unbind', '-T', 'root', g:prefix_key])
		-- call system(['/usr/bin/mux', 'set-option', 'prefix', 'None'])
		-- call system(['/usr/bin/mux', 'bind-key', '\`', 'send-keys', '\`'])
		-- call system(['/usr/bin/mux', 'bind-key', '-T', 'root', '\`', 'send-keys', '\`'])
		-- ]]

		-- log.os_execute('/usr/bin/tmux -t . set -s prefix None ENTER')

		-- os.execute('/usr/bin/tmux -t . set -s prefix None ENTER')
		-- os.execute('/usr/bin/tmux -t . unbind \\` ENTER')
		-- os.execute('/usr/bin/tmux -t . unbind -T root \\` ENTER')
		-- os.execute('/usr/bin/tmux -t . bind -T root \\` send-keys \\` ENTER')

		-- local job = vim.fn.jobstart(' \
		-- /usr/bin/tmux set -s prefix None ENTER; \
		-- /usr/bin/tmux unbind \\` ENTER; \
		-- /usr/bin/tmux bind -T root \\` send-keys \\` ENTER \
		-- ')
		-- local output = vim.fn.system { '/usr/bin/tmux set -s prefix None ENTER;', '/usr/bin/tmux unbind \\` ENTER;', '/usr/bin/tmux bind -T root \\` send-keys \\` ENTER' }

		-- local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'prefix', '\\`' }
		-- local output = vim.fn.system { '/usr/bin/tmux', 'unbind', '-T', 'root',   '\\`' }
		-- local output = vim.fn.system { '/usr/bin/tmux', 'set', 'prefix', 'None' }
		-- local output = vim.fn.system { '/usr/bin/tmux', 'bind', '-T', 'prefix', '\\`', 'send-keys', '\\`' }
		-- local output = vim.fn.system { '/usr/bin/tmux', 'bind', '-T', 'root',   '\\`', 'send-keys', '\\`' }
	end,
})

local function win_info(id)
	-- https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments
	-- https://www.lua.org/manual/5.1/manual.html#pdf-setmetatable
    setmetatable(id or {}, {__index={id=0}})
	api                = vim.api
	local all_options  = api.nvim_get_all_options_info()
	local win_number
	print('type(id): ' .. type(id))
	if type(id) == "number" then
	-- if type(id) ~= nil then
		win_number   = id
	else
	-- if id == nil or id == "" or type(id) == 'nil' then
		win_number   = api.nvim_get_current_win()
	-- else
	-- 	local win_number   = id
	end
	local v            = vim.wo[win_number]
	local all_options  = api.nvim_get_all_options_info()
	local result       = ""
	for key, val in pairs(all_options) do
		if val.global_local == false and val.scope == "win" then
			result = result .. "\n" .. key .. "=" .. tostring(v[key] or "<not set>")
		end
	end
	print(result)
end

local function buf_info(id)
    setmetatable(id or {}, {__index={id=0}})
	api                = vim.api
	local all_options  = api.nvim_get_all_options_info()
	local buf_number
	if type(id) == "number" then
	-- if type(id) ~= nil then
		buf_number   = id
	else
	-- if id == nil or id == "" or type(id) == 'nil' then
		buf_number   = api.nvim_get_current_buf()
	-- else
	-- 	local buf_number   = id
	end
	local v            = vim.bo[buf_number]
	local all_options  = api.nvim_get_all_options_info()
	local result       = ""
	for key, val in pairs(all_options) do
		if val.global_local == false and val.scope == "buf" then
			result = result .. "\n" .. key .. "=" .. tostring(v[key] or "<not set>")
		end
	end
	print(result)
end
--  map('i', 'tmux', "<Nope>", { noremap = true })
--  map('i', 'tmux', "<Escape>", { noremap = true })
--  When the map key is tmux, you can't input "tmux" quickly / normally
--  map({ 'i', 'c' }, 'tmux',
--  function()
	-- When the map key is Escape, don't recursively trigger it here
--      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Escape>', true, false, true), 'm', true)
--  end, { noremap = true })
	-- https://vi.stackexchange.com/questions/36542/how-to-use-cmdline-to-send-key-esc
	-- vim.api.nvim_feedkeys('', 't', true)
	-- Does not work
	-- map({'n', 'x' }, 'tmux', [[:call feedkeys('\<Escape>') | silent execute('! tmux copy-mode')]], { noremap = true })
	-- [Sending '<ESC>' through nvim_feedkeys?](https://github.com/neovim/neovim/issues/12312)
--  map({ 'n', 'x' }, 'tmux',
--  map({ 'n', 'x' }, '<Escape>', -- don't trigger copy-mode when has selections
	map('n', '<Escape>',
	function()
		-- https://stackoverflow.com/questions/73850771/how-to-get-all-of-the-properties-of-window-in-neovim

		win_info()
		buf_info()


		-- [For vim 9.1](https://vimhelp.org/popup.txt.html)
		-- vim.cmd[[
		-- let id = popup_findinfo()
		-- :call popup_clear(1)
		-- ]]
		-- if has_floating_window(0) then
			require("notify").dismiss() -- popup window
		-- else
			os.execute("tmux copy-mode")
		-- end
		-- if has_floating_window(0) == false then
		--  -- if tmux_key_enabled == true then
		--  --  tmux_key_enabled = false -- tmux_prefix_cancel()
		--  -- else
		--      os.execute("tmux copy-mode")
		--  -- end
		--  -- When the map key is Escape, don't recursively trigger it here
		--  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Escape>', true, false, true), 'm', true)
		--  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Escape>', true, false, true), 'm', true)
		--  -- print("relative ~= \"\"")
		-- else
		--  -- last_version -- if tmux_key_enabled == false then
		--  -- last_version --  -- local new_mode = vim.api.nvim_get_mode().mode
		--  -- last_version --  tmux_key_enabled = true -- tmux_prefix_reenable(new_mode)
		--  -- last_version --  -- When the map key is Escape, don't recursively trigger it here
		--  -- last_version --  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Escape>', true, false, true), 't', true)
		--  -- last_version --  -- os.execute("tmux copy-mode")
		--  -- last_version -- else
		--      -- When the map key is Escape, don't recursively trigger it here
		--      -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Escape>', true, false, true), 't', true)
		--      os.execute("tmux copy-mode")
		--  -- last_version -- end
		--  -- print("relative == \"\"")
		-- end
	end, { noremap = true })

-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
vim.cmd(
	[[
	cnoremap <C-v> <C-r>+
	" vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
	" E488: Trailing characters
	" vnoremap // :<c-u>let temp_variable=@"<CR>gvy:<c-u>let @/='\V<C-R>=escape(@",'/\')<CR>'<CR>:let @"=temp_variable<CR>:<c-u>set hlsearch<CR>
	" Works for multiple lines
	set incsearch
	set hlsearch
	" set ignorecuase
	function s:get_visual_selection()
		let raw_search = @"
		let @/=substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
	endfunction
	xnoremap // ""y:call <sid>get_visual_selection()<bar>:set hls<cr>
	if has('nvim')
		set inccommand=nosplit
		xnoremap /s ""y:call <sid>get_visual_selection()<cr><bar>:%s/
	else
		xnoremap /s ""y:call <sid>get_visual_selection()<cr><bar>:%s//
	endif


" Breaks yank -- remove new line from yank and lost special characters
" Copy the text affected by a TextYankPost event to tmux's copy buffer
" https://superuser.com/questions/827748/vim-yank-to-tmux-clipboard
" function! s:text_yankpost_to_tmux_buffer(event)
"   if a:event['operator'] == 'd' || a:event['operator'] == 'y'
"       let string_list = a:event['regcontents']
"       let stringified_list = ""
"       let first_pass = 1
"       for current_string in string_list
"           if first_pass == 0
"               let stringified_list = stringified_list . "\n"
"           endif
"           let stringified_list = stringified_list . current_string
"           let first_pass = 0
"       endfor
"       silent execute "\!printf " . shellescape(stringified_list, 1) . " | tmux loadb -"
"   endif
" endfunction
"
" augroup TmuxCopy
" autocmd!
" autocmd TextYankPost * call <sid>text_yankpost_to_tmux_buffer(v:event)
" augroup END


]])

	-- Works for single line
	-- vim.keymap.set('v', '//', "\"fy/\\V<C-R>f<CR>" )


--
-- Won't work correctly
-- map("n", "<Esc>",        "if exists(\"b:is_gt_buffer\") <bar> :BuffergatorClose<CR> <bar> endif")
--
-- map("n", "<F3>",         ":BuffergatorToggle<cr>")
-- map("n", "<leader>l",    ":BuffergatorToggle<cr>")
local cwd = require("lazy.core.config").options.root
-- :nnoremap <Leader>pp :lua require'telescope.builtin'.buffers{}
-- No resizing -- can not full-screen
-- map("n", "<leader>l",    ":lua require'telescope.builtin'.buffers{}<cr>")
-- map("n", "<leader>l",    ": Telescope find_files<cr>")

map("n", "<leader>l", ":lua require'telescope.builtin'.buffers   ({ cwd = cwd })<cr>")
map("n", "<leader>f", ":lua require'telescope.builtin'.find_files({ cwd = cwd })<cr>")

if USE_TELESCOPE_GOTO ~= nil then
	vim.cmd([[
	let key = maparg('gd', 'n', v:false)
	if key != ""
	unmap gd
	endif
]])
	map("n", "gd", [[
<cmd>lua require'telescope.builtin'.lsp_definitions
({ cwd = cwd })<cr>
]], { noremap = true, silent = true })
	map("n", "gr", ":lua require'telescope.builtin'.lsp_references \
({ cwd = cwd })<cr>", { noremap = true, silent = true })
else
	-- map('n',  'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true })
	map('n',  'gd', function() vim.lsp.buf.definition ({ cwd = cwd }) end, { noremap = true, silent = true })
	map('n',  'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true })
end
-- smartq did this
map('n', 'q',
	function()
		-- :silent! bprevious <bar> bdelete<bang> #
		vim.cmd("bprevious | bdelete! #")
	end, { noremap = true, silent = true }
)
-- No resizing -- can not full-screen
-- map("n", "<leader>j",    ":lua require'telescope.builtin'.grep_string()<cr>")
-- map("n", "<leader>j",    ": Telescope grep_string<cr>")

map("n", "<leader>j", ":lua require'telescope.builtin'.grep_string({ cwd = cwd })<cr>")

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
	pattern = "*",
	callback = function(args)
		local opts = { buffer = args.buf }
		local U = require('utils')
		local map = U.map
		map("n", "<leader>a", vim.lsp.buf.code_action, opts)

		if USE_TELESCOPE_GOTO ~= nil then
			local builtin = require("telescope.builtin")
			local cwd = require("lazy.core.config").options.root
			-- Defined in telescope.lua
			map("n", "gd", function() builtin.lsp_definitions     ({ cwd = cwd }) end, opts)
			map("n", "gy", function() builtin.lsp_type_definitions({ cwd = cwd }) end, opts)
			map("n", "gr", function() builtin.lsp_references      ({ cwd = cwd }) end, opts)

			map("n", "<leader>ff", function() builtin.find_files  ({ cwd = cwd }) end, opts)
			map("n", "<leader>fg", function() builtin.live_grep   ({ cwd = cwd }) end, opts)
			map("n", "<leader>fb", function() builtin.buffers     ({ cwd = cwd }) end, opts)
			map("n", "<leader>fh", function() builtin.help_tags   ({ cwd = cwd }) end, opts)
		end
		map({ "n", "x" }, "<leader>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>r", vim.lsp.buf.rename, opts)

--      local bufnr = args.buf
--      -- local bufnr = vim.fn.winbufnr(0)
--      -- local client = args.client
--      -- local client = vim.lsp.buf_get_clients()
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--      -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--
--      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--      local opts = { buffer = bufnr }
--      vim.keymap.set('n',  'K',    '<cmd>lua vim.lsp.buf.hover()<cr>',           opts)
--      -- vim.keymap.set('n',  '<leader>d',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
--      vim.keymap.set('n',  'gd',   '<cmd>lua vim.lsp.buf.definition()<cr>',      opts)
--      vim.keymap.set('n',  'gD',   '<cmd>lua vim.lsp.buf.declaration()<cr>',     opts)
--      vim.keymap.set('n',  'gi',   '<cmd>lua vim.lsp.buf.implementation()<cr>',  opts)
--      vim.keymap.set('n',  'go',   '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
--      -- vim.keymap.set('n',  '<leader>r',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
--      vim.keymap.set('n',  'gr',   '<cmd>lua vim.lsp.buf.references()<cr>',      opts)
--      vim.keymap.set('n',  'gs',   '<cmd>lua vim.lsp.buf.signature_help()<cr>',  opts)
--      vim.keymap.set('n',  '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',          opts)
--      vim.keymap.set('n',  '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',     opts)
--
--      vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
--
--      vim.keymap.set('n',  'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
--      vim.keymap.set('n',  '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>',  opts)
--      vim.keymap.set('n',  ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>',  opts)
--
--      -- Set some keybinds conditional on server capabilities
--      -- :lua =vim.lsp.get_active_clients()[1].server_capabilities
--      -- if client.resolved_capabilities.document_formatting then
--      if client.server_capabilities.documentFormattingProvider then
--          -- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
--          -- elseif client.resolved_capabilities.document_range_formatting then
--      elseif client.server_capabilities.documentRangeFormattingProvider then
--          -- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
--      end
--
--      -- Set autocommands conditional on server_capabilities
--      -- if client.resolved_capabilities.document_highlight then
--      if client.server_capabilities.documentHighlightProvider then
--          vim.api.nvim_exec([[
-- augroup lsp_document_highlight
--  autocmd! * <buffer>
--  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
-- augroup END
-- ]], false)
--      end
--
--      local caps = client.server_capabilities
--      if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
--          local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
--          vim.api.nvim_create_autocmd("TextChanged", {
--              group = augroup,
--              buffer = bufnr,
--              callback = function()
--                  vim.lsp.buf.semantic_tokens_full()
--              end,
--          })
--          -- fire it first time on load as well
--          -- vim.lsp.buf.semantic_tokens_full()
--      end

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

vim.cmd([[
" https://github.com/shyun3/nvimrc/blob/98813267db761db51f59ecfccfed463cb3960f55/init.vim
function! s:check_highlight(lineNum, colNum)
	let mode = "name"

	" Highest highlighting group: name of syntax keyword, match or region
	let hi = synIDattr(synID(a:lineNum, a:colNum, 1), mode)

	" For transparent groups, the group it's in
	let trans = synIDattr(synID(a:lineNum, a:colNum, 0), mode)

	" Lowest group: basic highlighting spec such as a default highlighting group
	let lo = synIDattr(synIDtrans(synID(a:lineNum, a:colNum, 1)), mode)

	echo 'hi<' . hi . '> ' . 'trans<' . trans . '> ' . 'lo<' . lo . '> '
	CocCommand semanticTokens.inspect
endfunction

command! CheckHighlightUnderCursor call <SID>check_highlight(line('.'), col('.'))

" https://gist.github.com/MaienM/1258015
inoremap <silent> = =<Esc>:call <SID>ealign()<CR>
" https://stackoverflow.com/questions/10572996/passing-command-range-to-a-function
" command! -range TL '<,'>:call <SID>ealign()<CR>

function! s:ealign()
	let p = '^.*=\s.*$'
	if exists(':Tabularize') && getline('.') =~# '^.*=' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
		let column   = strlen(substitute(getline('.')[0:col('.')],'[^=]','','g'))
		let position = strlen(matchstr(getline('.')[0:col('.')],'.*=\s*\zs.*'))
		Tabularize/=/r1
		normal! 0
		call search(repeat('[^=]*=',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
	endif

endfunction

" https://stackoverflow.com/questions/8964953/align-text-on-an-equals-sign-in-vim
inoremap <silent> :   :<Esc>:call <SID>align(':')<CR>a
inoremap <silent> =   =<Esc>:call <SID>align('=')<CR>a
command! -range TL '<,'>:call <SID>align('=')<CR>

function! s:align(aa)
  let p = '^.*\s'.a:aa.'\s.*$'
  if exists(':Tabularize') && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
	let column = strlen(substitute(getline('.')[0:col('.')],'[^'.a:aa.']','','g'))
	let position = strlen(matchstr(getline('.')[0:col('.')],'.*'.a:aa.':\s*\zs.*'))
	exec 'Tabularize/'.a:aa.'/l1'
	normal! 0
	call search(repeat('[^'.a:aa.']*'.a:aa,column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" "roxma/vim-tmux-clipboard", -- 'w' for world ? target-client(tty) of tmux
let g:vim_tmux_clipboard#loadb_option = '-w'

" unmap <c-h>
" unmap <c-l>
" unmap <c-j>
" unmap <c-k>
" nnoremap <unique> <silent> <c-h> :call keys#tmux_move('left',  g:navigate)
" nnoremap <unique> <silent> <c-l> :call keys#tmux_move('right', g:navigate)
" nnoremap <unique> <silent> <c-j> :call keys#tmux_move('down',  g:navigate)
" nnoremap <unique> <silent> <c-k> :call keys#tmux_move('up',    g:navigate)

" Moved to keys.vim
" [is_vim does not detect vim running in a subshell #295](https://github.com/christoomey/vim-tmux-navigator/issues/295)
" https://github.com/christoomey/vim-tmux-navigator/issues/295#issuecomment-1123455337
" function! s:set_is_vim()
"   " call s:TmuxCommand("set-option -p @is_vim yes")
"   call system("tmux set-option -p @is_vim \"on\"")
" endfunction
"
" function! s:unset_is_vim()
"   " call s:TmuxCommand("set-option -p -u @is_vim")
"   call system("tmux set-option -p -u @is_vim")
" endfunction
"
" augroup tmux_navigator_is_vim
"   au!
"   autocmd VimEnter * call <SID>set_is_vim()
"   autocmd VimLeave * call <SID>unset_is_vim()
"   if exists('##VimSuspend')
"       autocmd VimSuspend * call <SID>unset_is_vim()
"       autocmd VimResume * call <SID>set_is_vim()
"   endif
" augroup END

" augroup ibl_init | au!
"   autocmd BufEnter * :call <sid>IBLEnable()<cr>
" augroup END


]])










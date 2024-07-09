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

-- use leader-nt to toggle the NvimTree plugin's visibility in normal mode
map("n", "<leader>nt", ":NvimTreeToggle<CR>")
-- map("n", "<leader>nq", ":NvimTreeClose<CR>")
map("n", "<leader>nq", ":Neotree close<CR>")
-- map("n", "t", ":Neotree toggle<CR>")
map("n", "\\", ":NvimTreeToggle<cr>")
-- map("n", "t", ":Neotree<cr>")
map("",  "<leader>n",  ":bn<CR>")
map("",  "<leader>p",  ":bp<CR>")
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

-- Prevent x from overriding what's in the clipboard.
map("n", "x", "\"_x")
map("n", "X", "\"_x")

-- Prevent selecting and pasting from overwriting what you originally copied.
-- "p" became invalid might bicause of tmux default-command sesstings
-- map("x", "p", "pgvy")
-- map("x", "p", "pgvy",         { noremap = true })
-- map("x", "p", "P",            { noremap = true })
--
vim.cmd([[
" https://vi.stackexchange.com/questions/25259/clipboard-is-reset-after-first-paste-in-visual-mode/25260#25260
" now it is possible to paste many times over selected text
  xnoremap <expr> p '""pgv"'.v:register.'y`>'
  xnoremap <expr> P '""Pgv"'.v:register.'y`>'
  nnoremap <leader>p m`o<ESC>p``
  nnoremap <leader>P m`O<ESC>p``
" xnoremap p m`o<ESC>p``
" xnoremap P m`O<ESC>p``
" https://stackoverflow.com/questions/1346737/how-to-paste-in-a-new-line-with-vim
" This implementation won't insert copies
" nmap p :pu<CR>
" nmap P :pu!<CR>
]])
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

-- map("n", "<leader>cd", ':lua vim.api.nvim_command("colorscheme onehalf-lush-dark")<cr>')
map("n", "<leader>cd", ":lua vim.opt.background = 'dark'<cr>")
-- map("n", "<leader>cl", ':lua vim.api.nvim_command("colorscheme onehalf-lush")<cr>')
map("n", "<leader>cl", ":lua vim.opt.background = 'light'<cr>")

-- map('n', "w", "<Cmd>call boot#write_generic()<cr>")
-- vim.keymap.set("ca", 'w', ":getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w'")
vim.cmd("ca w getcmdtype() == ':' && getcmdline() == 'w' ? 'W' : 'w'")

map("n", "<leader>qt", ":Tclose!<CR>", { silent = true })

map("n", "ea", "<Plug>(EasyAlign)")
map("x", "ea", "<Plug>(EasyAlign)")

--  Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
map("v", "<Enter>", "<Plug>(EasyAlign)", { noremap = true })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map("n", "ga",      "<Plug>(EasyAlign)", { noremap = true })

-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
vim.cmd(
	[[
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
function! s:CheckHighlight(lineNum, colNum)
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

command! CheckHighlightUnderCursor call <SID>CheckHighlight(line('.'), col('.'))

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

" "roxma/vim-tmux-clipboard",
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


]])










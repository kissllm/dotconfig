local U       = require("utils")
-- local cmd     = vim.cmd -- execute Vim commands
local exec     = vim.api.nvim_exec -- execute Vimscript
local api      = vim.api           -- neovim commands
local autocmd  = vim.api.nvim_create_autocmd -- execute autocommands
local augroup  = vim.api.nvim_create_augroup -- group autocommands
local set      = vim.opt -- global options
local setlocal = vim.opt_local -- global options
local cmd      = vim.api.nvim_command -- execute Vim commands
local fn       = vim.fn

-- vim.opt.guifont -- need to be determined
-- set.clipboard     = "unnamed,unnamedplus"
-- set.clipboard = set.clipboard + "unnamedplus"
set.ignorecase   = true
-- Default is 0 -- no limitation
-- set.pumheight     = 10 -- maybe too big ?
set.swapfile     = false -- not sure
set.timeoutlen   = 300
-- vim.g.mapleader      = "<Space>"
vim.g.mapleader     = ' '
set.termguicolors   = true
set.bg              = 'dark'
set.background      = 'dark'
vim.o.background    = 'dark'
-- vim.api.nvim_set_options("background", "dark")
-- if vim.g.colors_name ~= "onehalf-lush" then
--     vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy")
--     vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/onehalf-lush")
--     local onehalf = require("plugins.onehalf")
--   -
--     -- cmd("colorscheme onehalf-lush")
-- end
set.list            = true
set.tabstop         = 4
set.shiftwidth      = 4
vim.g.vim_indent_cont = vim.opt.shiftwidth:get()
set.softtabstop     = -1
-- set.expandtab       = true
set.expandtab       = false
set.smarttab        = true
set.copyindent      = true
set.preserveindent  = true
set.textwidth       = 120
set.formatoptions   = "tcqrn1"
-- set.formatoptions:remove({ "c", "r", "o" })
set.mouse           = "a"
set.showcmd         = true
set.number          = true
set.relativenumber  = true
set.hidden          = true
set.hlsearch        = true
-- set.backspace        = "2"
-- set.laststatus       = 2
set.shortmess       = "actWAOFS"
set.shortmess       = set.shortmess + "c"
-- set.shortmess:append "c"
set.signcolumn      = "number"
-- set.signcolumn = "yes"
set.inccommand      = "split"

set.autowriteall    = true
set.whichwrap       = "b,s,<,>,h,l,[,]"
-- set.whichwrap        = "bs<>[]hl" -- travel prev/next line

set.wrap            = false
set.linebreak       = true -- good if wrap is turned off
set.wrapmargin      = 0
set.backspace       = "indent,eol,start"
set.eadirection     = "ver"
set.equalalways     = false
-- set.cursorline      = true
set.cursorline      = false
set.cursorcolumn    = false

-- set.cmdheight       = 1
set.cmdheight        = 0
set.ruler           = false
set.laststatus      = 0
set.showtabline     = 0          -- Always display the tabline, even if there is only one tab
set.showmode        = false      -- Hide the default mode text (e.g. -- INSERT -- below the statusline)
set.complete        = set.complete + 'kspell'
-- set.cryptmethod      = "blowfish2"
if vim.opt_local.modifiable:get() == true then
	set.fileencoding = 'utf-8'
end
set.encoding        = "utf-8"
set.termencoding    = "utf-8"
set.spelllang       = "en_us"
-- E167: :scriptencoding used outside of a sourced file
-- cmd([[:scriptencoding utf-8]])
set.matchpairs      = set.matchpairs  + '<:>'
set.maxmempattern   = 5000
set.modeline        = true
set.modelines       = 2
set.errorbells      = false
set.visualbell      = false
-- set.t_vb             = ''
	cmd([[set t_vb=]])
set.shiftround      = false
set.spell           = false
set.startofline     = false
set.scrolloff       = 20
-- set.scrolloff        = 8
set.sidescrolloff   = 30
-- set.sidescrolloff    = 8
set.scrollopt       = set.scrollopt - 'ver'
set.showcmd         = false
set.showmatch       = true
set.splitbelow      = true
set.splitright      = true
set.ttimeout        = true
set.ttimeoutlen     = 1
set.ttyfast         = true
set.virtualedit     = "block"
set.wildmenu        = true
set.wildmode        = "full"
set.paste           = false
set.title           = true
set.more            = true
setlocal.cino       = "e-2"
set.smartcase       = true
set.smartindent     = true
set.incsearch       = true
if vim.fn.exists('$TMUX') then
	-- set.t_ut = ''
	cmd([[set t_ut=]])
end
set.backup          = false
set.writebackup     = false
set.tags            = "./tags,tags;" .. vim.env.HOME
set.switchbuf       = 'uselast'
-- set.completeopt  = { "menuone", "noselect" }
set.completeopt     = 'menu,menuone'
set.completeopt     = set.completeopt + 'noinsert,noselect'
set.completeopt     = set.completeopt - 'preview'
set.belloff         = set.belloff + 'ctrlg'
set.redrawtime      = 1000
set.lazyredraw      = true
set.sessionoptions  = 'blank,buffers,curdir,help,tabpages,winsize,terminal'
set.sessionoptions  = set.sessionoptions - 'options'
set.sessionoptions  = set.sessionoptions - 'blank'
set.sessionoptions  = set.sessionoptions - 'help'
-- set.sessionoptions   = set.sessionoptions + 'buffers'
-- This "options" will include deprecated maps
-- set.sessionoptions   = set.sessionoptions + 'options'
set.viewoptions     = 'folds,cursor,unix,slash'
set.undofile        = true
-- set.conceallevel = 2
-- set.conceallevel = 1
set.conceallevel    = 0
set.fillchars       = "vert:│,horiz:_,eob: "
-- https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
-- set.modelineexpr = false
--
-- commented this, because bwe ge keys are also interpreted hyphenated
-- words as single word
-- vim.opt.iskeyword:append "-" -- hyphenated-words recognizerd by search

-- Illuminate plugin higlighting
vim.api.nvim_set_hl(0, "IlluminatedWordText",  { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })

-- undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])












set.listchars = {
	-- nbsp     = '⦸',
	nbsp        = '%',
	-- extends  = '»',
	extends     = '>',
	-- precedes = '«',
	precedes    = '<',
	-- tab      = '▷─',
	-- tab      = '>-',
	-- tab      = ' U+FF3F',
	tab         = ' \'',
	tab         = '│ ',
	-- tab      = ' _',
	-- trail    = '•',
	trail       = '·',
	space       = ' '
	--eol       = '↴'
}

function filetype_autocmd(filetype, cmd, params)
	autocmd("FileType", { pattern = filetype, command = cmd .. ' ' .. params })
end

function buffer_autocmd(pattern, cmd, params)
	autocmd("BufRead", { pattern = pattern, command = cmd .. ' ' .. params })
end

function hold_autocmd(pattern, cmd)
	autocmd("CursorHold", { pattern = pattern, command = cmd })
end

set.titleold = [[ ${substitute(system("uname"),'\(.*\)\n','%\1%','')} ]]

local group = augroup("on_bufenter", { clear = true })
autocmd("BufEnter", {
	callback = function()
		-- Will erase file name
		-- set.titlestring = [[ %{expand("%:p:~:.:h")} ]]
		-- set.titlestring = [[ %{expand("%:p:~:.")} ]]
		-- https://vim.fandom.com/wiki/Insert_current_filename
		set.titlestring = [[ %{expand("%:t") . " @ " . expand("%:p:~:.:h")} ]]
	end,
	desc = "Set the window title",
	group = group,
	pattern = "*",
})

vim.api.nvim_create_user_command(
	"RT",
	function()
		set.expandtab = true
		vim.cmd("retab")
		set.expandtab = false
		vim.cmd("RetabIndent")
		-- vim.cmd("write " .. vim.fn.expand('%'))
		vim.cmd("W")
		vim.cmd("redraw!")
	end,
	{ nargs = '?', bang = true, silent }
)

-- Heavy operation
-- local group = augroup("retab_on_save", { clear = true })
-- autocmd("BufWritePre", {
--  callback = function()
--      -- set tabstop=4
--      set.expandtab = true
--      vim.cmd("retab")
--      set.expandtab = false
--      -- vim.cmd(" %retab!")
--      vim.cmd("RetabIndent")
--      vim.cmd("redraw!")
--  end,
--  desc = "retab! on save",
--  group = group,
--  pattern = "*",
-- })

-- https://stackoverflow.com/questions/20426986/vim-tab-oddities-have-to-retab-every-save
-- autocmd BufWritePre *.slim :call ResetSpaces()

-- https://neovim.discourse.group/t/how-to-create-a-new-vim-command-in-lua/986
vim.api.nvim_create_user_command(
	"BW",
	function()
		-- :silent! bprevious <bar> bdelete<bang> #
		vim.cmd("bprevious | bdelete! #")
	end,
	{ nargs = '?', bang = true, silent }
)

-- https://vi.stackexchange.com/questions/41798/make-colorscheme-change-when-background-change
vim.api.nvim_create_autocmd({"OptionSet"}, {
	pattern = {"background"},
	callback = function()
		if vim.o.background == 'dark' then
			print('late dark')
			-- vim.cmd("colorscheme modus-vivendi")
			vim.cmd("colorscheme onehalf-lush-dark")
			-- vim.cmd("colorscheme dracula")
		else
			print('late light')
			-- vim.cmd("colorscheme modus-operandi")
			vim.cmd("colorscheme onehalf-lush")
			-- vim.cmd("colorscheme gruvbox")
		end
		-- force a full redraw:
		vim.cmd("mode")
		vim.cmd.source(os.getenv("SHARE_PREFIX") .. '/init/editor/nvim/after/plugin' .. "/colors.lua")
	end
})

vim.api.nvim_create_autocmd({"RecordingEnter"}, {
	callback = function()
		vim.opt.cmdheight = 1
	end,
})

vim.api.nvim_create_autocmd({"RecordingLeave"}, {
	callback = function()
		vim.opt.cmdheight = 0
	end,
})

-- vim.cmd([[
-- function! SessionState(updating)
--     if a:updating
--         let g:statusline_session_flag = "S"
--     else
--         let g:statusline_session_flag = ""
--     endif
--     execute "redrawstatus!"
-- endfunction
-- ]])
--
-- local session_auto_setup = augroup("on_bufenter", { clear = true })
-- autocmd("VimEnter", {
--     callback = function()
--         vim.cmd([[
--         :call session_auto#setup(function("SessionState"))
--         ]])
--     end,
--     desc = "Session status global variable updating",
--     group = session_auto_setup,
--     pattern = "*",
-- })

-- local file = vim.fn.expand("%:p:t")
-- local cwd = vim.fn.split(vim.fn.expand("%:p:h"):gsub("/", "\\"), "\\")
--
-- if file ~= "" and not utils.buff

set.title = true
-- set.updatetime = 100
set.updatetime = 1000

filetype_autocmd("html", "setlocal", "ts=4 sts=4 sw=4 omnifunc=htmlcomplete#CompleteTags")
filetype_autocmd("xml", "set", "omnifunc=xmlcomplete#CompleteTags")
filetype_autocmd("javascript", "setlocal", "ts=4 sts=4 sw=4")
filetype_autocmd("typescript", "setlocal", "ts=4 sts=4 sw=4")
-- pip install black
filetype_autocmd("python", "setlocal", "ts=4 sts=4 sw=4 formatprg=black\\ -q\\ -")
filetype_autocmd("yaml", "setlocal", "ts=2 sts=2 sw=2")
filetype_autocmd("css", "setlocal", "ts=4 noet sw=4")
filetype_autocmd("scss", "setlocal", "ts=4 noet sw=4 omnifunc=csscomplete#CompleteCSS")
filetype_autocmd("vue", "syntax", "sync fromstart")
filetype_autocmd("elixir", "setlocal", "formatprg=mix\\ format\\ -")
buffer_autocmd("*.coffee", "set", "ft=coffee")
buffer_autocmd("*.less", "set", "ft=less")
buffer_autocmd("*.md", "set", "ft=markdown")
buffer_autocmd("Cakefile", "set", "ft=coffee")
buffer_autocmd("*.pp", "set", "ft=ruby")
buffer_autocmd("*.conf", "set", "ft=dosini")
buffer_autocmd("*.tsx", "set", "ft=typescript.tsx")
buffer_autocmd("*.cls", "set", "ft=apex syntax=java")
buffer_autocmd("*.trigger", "set", "ft=apex syntax=java")
buffer_autocmd("*.nomad.template", "set", "ft=hcl")

-- hold_autocmd("*", "silent call CocActionAsync('highlight')")

if U.is_linux() then
	vim.g.python3_host_prog = "/bin/python"
elseif U.is_mac() then
	vim.g.python3_host_prog = "/usr/local/bin/python3"
end
local boot_path = vim.fn.stdpath("data") .. "lazy/boot"

vim.opt.rtp:prepend(boot_path)

vim.g.vimwiki_filetypes = { "markdown" }

-- local log_file = require("log")
-- local result = os_execute([[
-- echo "\$HOME = $HOME" >> $HOME/.vim.log
-- sed -i -e 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g'
--  "$HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim"
-- ]])

-- print(result)

-- Works
-- os.execute([[
-- sed -i -e 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g' \
--  "$HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim"
-- ]])

-- Works
-- os.execute([[
-- sh -c "sed -i -e 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g' \
--  '$HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim'"
-- ]])

-- Works
-- fn.system(
-- { 'sed', '-i', '-e',
-- 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g',
-- os.getenv("HOME") .. "/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim" }
-- )

-- Will block
-- cmd (
-- "!sed -i -e 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g' " ..
-- " $HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim"
-- )

-- Will block
-- vim.api.nvim_cmd(
--  {
--      cmd = '!',
--      args = { 'sed', '-i', '-e', 's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g',
--      "$HOME/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim", '>', '/dev/null' }
--  },
--  {}  -- { mods = { silent = true } }
-- )

-- https://www.reddit.com/r/neovim/comments/y1qibu/is_there_a_way_to_run_a_command_silently_with/
-- vim.fn.jobstart({ "firefox", vim.fn.expand("%") }, { detach = true })
-- Works
-- vim.fn.jobstart(
--  {
--      'sed', '-i', '-e',
--      's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g',
--      os.getenv("HOME") .. "/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim"
--  },
--  { detach = true }
-- )

-- -- Works
local vim_markdown_path = os.getenv("XDG_DATA_HOME") .. "/nvim/lazy/vim-markdown/ftplugin"
if vim.loop.fs_stat(vim_markdown_path) then
	local job = vim.fn.jobstart(
		-- fn.system(
		{
			'sed', '-i', '-e',
			's/b:Markdown_GetUrlForPosition/s:Markdown_GetUrlForPosition/g',
			vim_markdown_path .. "/mkd.vim"
		}
		-- )
		,
		{
			cwd = vim_markdown_path,
			on_exit = '',
			on_stdout = '',
			on_stderr = '',
			detach = true,
		}
	)
end

-- will run before jobstart
-- vim.api.nvim_cmd(
--  {
--      cmd = 'source ',
--      args = { os.getenv("HOME") .. '/.local/share/nvim/lazy/vim-markdown/ftplugin/mkd.vim'}
--  },
--  {}  -- { mods = { silent = true } }
-- )

local vim_repeat_path = os.getenv("XDG_DATA_HOME") .. "/nvim/lazy/vim-repeat/autoload"
if vim.loop.fs_stat(vim_repeat_path) then
	local job = vim.fn.jobstart(
		-- fn.system(
		{
			'sed', '-i', '-e',
			-- 's/nmap u <Plug>(RepeatUndo)/nmap <c-u> <Plug>(RepeatUndo)/g',
			's/nmap u <Plug>(RepeatUndo)/nmap <c-u> <Undo>/g',
			'-e',
			's/repeat#wrap(\'u\',v:count)/repeat#wrap(\'<c-u>\',v:count)/g',
			vim_repeat_path .. "/repeat.vim"
		}
		-- )
		,
		{
			cwd = vim_repeat_path,
			on_exit = '',
			on_stdout = '',
			on_stderr = '',
			detach = true,
		}
	)
end

--
-- https://stackoverflow.com/questions/65549814/setting-vimwiki-list-in-a-lua-init-file
vim.g.vimwiki_ext2syntax = {['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown'}

vim.cmd([[
" echom "\$HOME = " . $HOME
let g:buffergator_use_new_keymap = 1
" https://github.com/preservim/vim-markdown
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_no_extensions_in_markdown = 1

let g:vimwiki_markdown_link_ext = 1

" https://www.reddit.com/r/vim/comments/9riu4c/using_vimwiki_with_markdown/
let g:vimwiki_global_ext = 0

let wiki = {}
let wiki.path = '~/.wiki/'
let wiki.syntax = 'markdown'
let wiki.ext = '.md'

let wiki_personal = {}
let wiki_personal.path = '~/.vimwiki_personal/'
let wiki_personal.syntax = 'markdown'
let wiki_personal.ext = '.md'

let g:vimwiki_list = [wiki, wiki_personal]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" let boot_load_path = stdpath("data") . '/*/pack/*/start/boot/autoload/boot.vim'
let boot_load_path = stdpath("data") . '/lazy/boot/autoload/boot.vim'
execute "source " . boot_load_path
execute "runtime! " . boot_load_path
command! -nargs=1 -complete=help H :wincmd l | :enew | :set buftype=help | :keepalt h <args>

let g:vim_tags_auto_generate               = 1

if has('nvim')
	let g:vim_tags_ctags_binary
		\  = boot#chomp(system(['which', 'ctags']))
else
	let g:vim_tags_ctags_binary
		\  = boot#chomp(system('which ctags'))
endif

let g:vim_tags_project_tags_command
	\  = "{CTAGS} -R {OPTIONS} {DIRECTORY} 2>/dev/null"
let g:vim_tags_gems_tags_command
	\  = "{CTAGS} -R {OPTIONS} `bundle show --paths` 2>/dev/null"
let g:vim_tags_use_vim_dispatch            = 0
let g:vim_tags_use_language_field          = 1
let g:vim_tags_ignore_files
	\  = ['.gitignore', '.svnignore', '.cvsignore']
let g:vim_tags_ignore_file_comment_pattern = '^[#"]'
let g:vim_tags_directories
	\  = [".git", ".hg", ".svn", ".bzr", "_darcs", "CVS"]
let g:vim_tags_main_file                   = 'tags'
let g:vim_tags_extension                   = '.tags'
" let g:vim_tags_cache_dir                   = expand($HOME)
let g:vim_tags_cache_dir                   = expand(stdpath('cache'))
let g:tagbar_left                          = 1
let g:tagbar_expand                        = 1
let g:qf_bufname_or_text = 1

" Only works on vim
:command! -nargs=0 -bang Quit :noautocmd qa!
:cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Quit' : 'q'

augroup Mkd
	au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
	au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setlocal syntax=markdown
augroup END

" Moved to keybindings.lua
" command! -nargs=? -bang BW :silent! bprevious <bar> bdelete<bang> #
" nnoremap <silent> <Leader>d :<C-U>bprevious <bar> bdelete #<cr>
" nnoremap <silent> <Leader>q :Bdelete<CR>

]])

-- command! -nargs=0 Quit :noautocmd qa!
-- :cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Quit' : 'q'

-- vim.api.nvim_add_user_command('H', ':wincmd l | :enew | :set buftype=help | :keepalt h <args>', { nargs = 1, complete = help })
-- https://github.com/nanotee/nvim-lua-guide#vimapinvim_exec
vim.api.nvim_create_user_command(
	'H',
	':wincmd l | :enew | :set buftype=help | :keepalt h <args>',
	-- function(opts) -- "opts" for lua codes inside the function body
	--  -- ':wincmd l | :enew | :set buftype=help | :keepalt h <args>'
	--  vim.cmd([[
	--      :wincmd l | :enew | :set buftype=help | :keepalt h <args>
	--  ]])
	--  -- vim.api.nvim_exec([[
	--  -- :wincmd l | :enew | :set buftype=help | :keepalt h <args>
	--  --  ]], true)
	-- end,
	{ nargs = 1, complete = help }
)
-- Neovim automatically supports auto read by default

-- LspUninstall marksman solved it
-- Spawning language server with cmd: `marksman` failed. The language server is either not installed, missing from PATH, or not executable.
-- https://github.com/neovim/neovim/issues/20745
-- local function filter_diagnostics(diagnostic)
--  -- Filter out all diagnostics from sumneko_lua
--  if diagnostic.source:find('marksman', 1, true) then
--      return false
--  end
--  return true
-- end
-- -- Doesn't work
-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
--  function(_, result, ctx, config)
--      filter(result.diagnostics, filter_diagnostics)
--      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
--  end,
--  {}
-- )
--
-- -- Doesn't work
-- local client = vim.lsp.get_active_clients({ name = 'marksman' })[1]
-- if client then
--  local ns = vim.lsp.diagnostic.get_namespace(client.id)
--  vim.diagnostic.disable(nil, ns)
-- end
--
-- -- Semantic Highlighting in Neovim
-- -- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
-- -- Doesn't work
-- vim.api.nvim_set_hl(0, '@lsp.type.function.marksman', {})
--
-- local function show_unconst_caps(args)
--  local client = vim.lsp.get_client_by_id(args.data.client_id)
--  if client.name ~= "marksman" then return end
--
--  local token = args.data.token
--  -- etc
-- end
--
-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--  pattern = {"*.md", "*.markdown"},
--  callback = show_unconst_caps,
-- })
--
-- -- require('lspconfig').marksman.setup {
-- --   on_attach = function(client, buffer)
-- --       vim.api.nvim_create_autocmd("LspTokenUpdate", {
-- --           buffer = buffer,
-- --           callback = show_unconst_caps,
-- --       })
-- --
-- --       -- other on_attach logic
-- --   end
-- -- }
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--  callback = function(args)
--      local client = vim.lsp.get_client_by_id(args.data.client_id)
--      if client.name ~= "marksman" then return end
--
--      vim.api.nvim_create_autocmd("LspTokenUpdate", {
--          buffer = args.buf,
--          callback = show_unconst_caps,
--      })
--  end
-- })


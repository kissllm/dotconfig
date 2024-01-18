" "initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
" put this line first in ~/.vimrc
" if &compatible
if exists('+compatible') && &compatible
	set nocompatible " don't simulate vi
endif

" set nocompatible | filetype indent plugin on | syn on
" filetype indent plugin on | syn on
filetype indent plugin on
" syntax enable
syntax on   " enable highlight
"
" In busybox, sometimes HOME is missing
if "" == $HOME || ! exists('$HOME')
	if has('nvim')
		let s:session_user  = system(['whoami'])
	else
		let s:session_user  = system('whoami')
	endif
	let s:session_user  =
		\ strtrans(substitute(s:session_user, '\%(\r\n\|[\r\n]\)$', '', ''))
	if has('nvim')
		let s:session_user_home =
			\ system(['/usr/bin/awk',  '-v', 'FS=:', '-v', 'user=' .
			\ s:session_user, '{if ($1 == user) print $6}', '/etc/passwd'])
	else
		let s:session_user_home =
			\ system('/usr/bin/awk -v FS=: -v user=' .
			\ s:session_user. ' "{if (\$1 == user) print \$6}" /etc/passwd')
	endif

	let $HOME  =
		\ strtrans(substitute(s:session_user_home, '\%(\r\n\|[\r\n]\)$', '', ''))

	echohl WarningMsg
	echom "Session \$HOME == " . $HOME
	call feedkeys("\<CR>")
	echohl None
endif

" if 1 == $HAS_LIBCXX
"     let $XDG_DATA_HOME = "$HOME/.local/share/clang"
"     if filewritable("$HOME/.local/share/clang") != 2
"         mkdir("$HOME/.local/share/clang", "p")
"     endif
" endif

" Disable search highlight
" :noh
" Open terminal inside vim
" :topleft terminal
" Debug/debug/breaking point/breakpoint
" breakadd here


" https://stackoverflow.com/questions/25341062/vim-let-mapleader-space-annoying-cursor-movement
" https://stackoverflow.com/questions/446269/can-i-use-space-as-mapleader-in-vim
noremap <Space> <Nop>
map     <Space> <Leader>
" let mapleader       = ','
" let g:_use_indent_guides        = 1
let g:loaded_ruby_provider      = 0
let g:loaded_perl_provider      = 0

let s:_init_develop             = 0

let g:_log_address              = $HOME . '/.vim.log'
let g:_log_verbose              = 0
let g:_script_develop           = 0
" let g:_boot_develop            = 1
let g:_keys_develop             = 0
if has("cscope")
	let g:_cscope_auto_develop  = 1
endif

" Time consuming
let g:_session_auto_develop     = 1

let g:_fixed_tips_width         = 37
" let g:_buffergator_develop     = 1
" let g:_log_func_name           = 'boot#log_silent'
let g:_use_terminal_transparent = 1
let g:_use_dynamic_color        = 1
let g:restore_each_buffer_view  = 1
" if has('nvim')
	if exists('g:_highlight_cursor_line_column')
		unlet g:_highlight_cursor_line_column
		" Heavy CPU usage if both enabled cursorcolumn/cursorline and indent-blankline
		" else
		"     let g:_highlight_cursor_line_column
		"         \ = 1
	endif
" else
"     if ! exists('g:_highlight_cursor_line_column')
"         let g:_highlight_cursor_line_column
"             \ = 1
"     endif
" endif

let g:_disable_direction_key    = 1
if ! has('nvim')
	let g:_use_wl_clipboard     = 1
elseif exists('g:_use_wl_clipboard')
	unlet g:_use_wl_clipboard
endif
let g:_log_one_line             = 0
let g:_job_start                = has('nvim') ? 'jobstart' : 'job_start'

let g:debug                     = 1
let g:navi_protect              = 1
let g:polyglot_disabled         = ['markdown']
" let g:polyglot_disabled          = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
" plugin which unfortunately interferes with mkdx list indentation.

" https://github.com/tpope/vim-obsession/pull/9
" https://github.com/blueyed/SudoEdit.vim/commit/947b0092ef5d55196a71d6238aff8cf9ee1853b2
" Vim has not been booted at this moment, so there are not so many functions available
" expand() never work as expected at this moment when using # or %
" let s:_file_name = resolve(expand('#'. bufnr(). ':p'))
" let s:_file_name = resolve(expand("#:p"))
" let s:_file_name = resolve(expand("%:p"))
"
" Following code of '<sfile>' will work when booting vim/nvim.
" But after you've finished booting vim, command mode won't show you <sfile>
" let s:_file_name = resolve(expand('<sfile>'))
" echo "s:_file_name = " . s:_file_name
" let _file_name = boot#chomp(system('basename ' . resolve(expand('<sfile>'))))
" let s:_file_name = execute('echon bufname("%")')
" let s:_file_name = execute('echon resolve(expand("%:p"))')
" let s:_file_name = fnamemodify(resolve(expand('<sfile>:p')), ':h')  " current path ~ pwd
" let s:_file_name = expand('<sfile>:p')  " current path ~ pwd

" boot.vim has not launched yet
" let s:_file_name = boot#chomp(system('basename ' . resolve(expand('<script>'))))
let s:_file_name = $MYVIMRC

" truncate the log file
silent! execute '!printf "\n\n"' . ' >> ' . g:_log_address . ' 2>&1 & > /dev/null'
silent! execute '!printf "\n\n"' . ' > '  . g:_log_address . ' 2>&1 & > /dev/null'

if has("win32") || has("win95") || has("win64") || has("win16") " check operating system
	let g:_is_windows  = 1
else
	let g:_is_windows  = 0
endif

let s:environment = {}

function! s:print_to_log(header, key, value,
	\ fixed_tips_width = 37, log_address = $HOME . '/.vim.log')
	silent! execute(
		\ '!printf ' . '"\%-' . 37  . 's: \%s\n"' .
		\ ' "' . a:header . '::' . a:key . '"' .
		\ ' "' . a:value . '"' .
		\ ' >> ' . a:log_address . ' 2>&1 &' )
endfunction

function! s:environment.new(
	\ _log_address       = $HOME . '/.vim.log'
	\, _log_verbose      = 1
	\, _fixed_tips_width = 37
	\, _is_windows       = 0
	\, _script_develop   = 1
	\, _job_start        = has('nvim') ? 'jobstart' : 'job_start'
	\ ) dict
	let object = copy(self)
	if exists('g:_log_address')
		let object._log_address = g:_log_address
	else
		let object._log_address = a:_log_address
	endif
	if exists('g:_log_verbose')
		let object._log_verbose = g:_log_verbose
	else
		let object._log_verbose = a:_log_verbose
	endif
	if exists('g:_fixed_tips_width')
		let object._fixed_tips_width = g:_fixed_tips_width
	else
		let object._fixed_tips_width = a:_fixed_tips_width
	endif
	if exists('g:_is_windows')
		let object._is_windows = g:_is_windows
	else
		let object._is_windows = a:_is_windows
	endif
	if exists('g:_script_develop')
		let object._script_develop = g:_script_develop
	else
		let object._script_develop = a:_script_develop
	endif

	if exists('g:_job_start')
		let object._job_start = g:_job_start
	else
		let object._job_start = a:_job_start
	endif

	call s:print_to_log(s:_file_name, "log_address", object._log_address, a:_fixed_tips_width, a:_log_address)
	call s:print_to_log(s:_file_name, "log_verbose", object._log_verbose, a:_fixed_tips_width, a:_log_address)
	call s:print_to_log(s:_file_name, "fixed_tips_width", object._fixed_tips_width, a:_fixed_tips_width, a:_log_address)
	call s:print_to_log(s:_file_name, "is_windows", object._is_windows, a:_fixed_tips_width, a:_log_address)
	call s:print_to_log(s:_file_name, "script_develop", object._script_develop, a:_fixed_tips_width, a:_log_address)

	return object
endfunction

let g:_environment = s:environment.new()

if 0 == s:_init_develop
	" boot#log_silent will generate nothing when g:_buffergator_develop is 0
	let s:log_silent = {-> "" }
elseif exists("g:_log_func_name")
	let s:log_silent = function(g:_log_func_name)
elseif exists("g:_environment._log_func_name")
	let s:log_silent = function(g:_environment._log_func_name)
else
	" Just for development
	" https://github.com/trailblazing/boot
	let s:log_silent = function('boot#log_silent')
endif

" Initialization of the plugin directory of vim
if ! exists("g:config_dir") || ! exists("g:plugin_dir") || 1 == g:debug


	" > /dev/null will hang up the process on vim-huge musl
	" vim-huge --version
	" VIM - Vi IMproved 8.2 (2019 Dec 12, compiled Oct 29 2021 14:03:34)
	" Included patches: 1-3565
	" Compiled by void-buildslave@a-hel-fi

	call s:print_to_log(s:_file_name, "date", strftime("%c"), g:_fixed_tips_width, g:_log_address)
	if has("nvim")
		let g:init_file = resolve(stdpath('config') . '/init.vim')
	else
		" let g:init_file = resolve(expand($MYVIMRC))
		let g:init_file = expand($MYVIMRC)
	endif

	call s:print_to_log(s:_file_name, "g:init_file", g:init_file, g:_fixed_tips_width, g:_log_address)

	if has("nvim")
		let g:config_dir = resolve(stdpath('config'))
	else
		" let vimrc_base = boot#chomp(system("basename \"". g:init_file . "\""))
		" let g:config_dir  = substitute(g:init_file, "\/" . vimrc_base, '', 'g')

		" let g:config_dir = substitute(system("dirname \"". g:init_file ."\" | cat - | xargs realpath"), '\n\+$', '', '')
			"
		let g:config_dir = fnamemodify(g:init_file, ':p:h')

	endif

	call s:print_to_log(s:_file_name, "g:config_dir", g:config_dir, g:_fixed_tips_width, g:_log_address)

	let g:plugin_dir = {}
	let g:package_manager = {}

	if has('nvim')
		let g:lua_plugin_dir = resolve(stdpath('data') . '/site')

		let runtime_index = stridx(&runtimepath, g:lua_plugin_dir)
		if -1 == runtime_index
			exe 'set runtimepath^='. g:lua_plugin_dir
		endif

		let g:lua_config_dir = expand(g:config_dir, 1) . '/lua'

		let runtime_index = stridx(&runtimepath, g:lua_config_dir)
		if -1 == runtime_index
			exe 'set runtimepath^='. g:lua_config_dir
		endif
		let g:plugin_dir['vim'] = resolve($HOME . '/.vim')
		let g:plugin_dir['lua'] = g:lua_plugin_dir
		let g:package_manager['lua']  = 'packer'

	else " if ! has('vim')
		let g:vim_plugin_dir = resolve(expand(g:config_dir, 1) . '/.vim')
		" let g:vim_plugin_dir = expand(g:config_dir, 1)

		let runtime_index = stridx(&runtimepath, g:vim_plugin_dir)
		if -1 == runtime_index
			exe 'set runtimepath^='. g:vim_plugin_dir
			" set runtimepath^=g:vim_plugin_dir
		endif
		let g:plugin_dir['vim'] = g:vim_plugin_dir
		let g:plugin_dir['lua'] = ''
		let g:package_manager['lua']  = ''
	endif

	let g:config_root = fnamemodify(g:plugin_dir['vim'], ':h')

	if has('nvim')
		let g:cache_root = expand(stdpath('cache'))
	else
		let g:cache_root = expand($HOME . '/.cache/vim')
	endif

	call s:print_to_log(s:_file_name, "g:config_root", g:config_root, g:_fixed_tips_width, g:_log_address)

	let g:package_manager['vim'] = 'packager'

	call s:print_to_log(s:_file_name, "g:plugin_dir['vim']", g:plugin_dir['vim'], g:_fixed_tips_width, g:_log_address)
	call s:print_to_log(s:_file_name, "g:plugin_dir['lua']", g:plugin_dir['lua'], g:_fixed_tips_width, g:_log_address)
	call s:print_to_log(s:_file_name, "g:package_manager['vim']", g:package_manager['vim'], g:_fixed_tips_width, g:_log_address)
	call s:print_to_log(s:_file_name, "g:package_manager['lua']", g:package_manager['lua'], g:_fixed_tips_width, g:_log_address)

endif

" help nvim
" set runtimepath^=g:plugin_dir['vim'] runtimepath+=g:plugin_dir['vim']/after
" let &packpath = &runtimepath


" set noloadplugins

" let runtime_index = stridx(&runtimepath, "/usr/share/vim/vimfiles")
" if -1 == runtime_index
"       exe 'set runtimepath^='. "/usr/share/vim/vimfiles"
" endif
" let runtime_index = stridx(&runtimepath, "/usr/share/vim/vimfiles/colors")
" if -1 == runtime_index
"       exe 'set runtimepath^='. "/usr/share/vim/vimfiles/colors"
" endif
" let runtime_index = stridx(&runtimepath, "/usr/share/color")
" if -1 == runtime_index
"       exe 'set runtimepath^='. "/usr/share/color"
" endif

let runtime_index = stridx(&runtimepath, $VIMRUNTIME)
if -1 == runtime_index
	exe 'set runtimepath^='. $VIMRUNTIME
endif

let runtime_index = stridx(&runtimepath, g:plugin_dir['vim'])
if -1 == runtime_index
	exe 'set runtimepath^='. g:plugin_dir['vim']
	" set runtimepath^=g:plugin_dir['vim']
endif

let runtime_index = stridx(&runtimepath, g:plugin_dir['vim'] . '/after')
if -1 == runtime_index
	exe 'set runtimepath+='. g:plugin_dir['vim'] . '/after'
	" set runtimepath+=g:plugin_dir['vim'] . '/after'
	" " set runtimepath =.,/usr/share/vim/vimfiles,/usr/share/vim/vimfiles/colors,/usr/share/color,$VIMRUNTIME
	" let &runtimepath.=','. g:plugin_dir['vim']
	" " set rtp+=$HOME/.vim/pack/packager/start/google/vim-codefmt  " not portable
endif

" let runtime_index = stridx(&runtimepath, ".")
" if -1 == runtime_index
"     exe 'set runtimepath^='. "."
" endif

if exists("g:_use_fzf")
	" https://github.com/junegunn/fzf.vim/issues/1
	set rtp+=~/.fzf
endif

for element in values(g:plugin_dir)
	let pack_index = stridx(&packpath, element)
	if -1 == pack_index
		" set packpath^=element
		" let &packpath^=element
		" let &packpath=element.','.&packpath    " Double inserted
		" https://superuser.com/questions/806595/why-the-runtimepath-in-vim-cannot-be-set-as-a-variable
		exe 'set runtimepath^='. element
		exe 'set packpath^='. element
		" let &packpath = &runtimepath
		" let &packpath.=','. element
		" set packpath^=$HOME/.vim
	endif
endfor

exe 'set packpath^='. &runtimepath

if ! exists('g:loaded_boot')
	let boot_load_path = g:plugin_dir['vim'] . '/pack/'
		\ . g:package_manager['vim'] . '/start/boot'
	let boot_load_file = boot_load_path . '/autoload/boot.vim'
	exe 'set runtimepath+='. boot_load_path
	exe 'set packpath+='. boot_load_path
	execute "source " .   boot_load_file
	execute "runtime! " . 'autoload/boot.vim'
endif

let packager_path = g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim']
exe 'set runtimepath+='. packager_path
exe 'set packpath+='. packager_path

let vim_packager_path = g:plugin_dir['vim'] . '/pack/'
	\ . g:package_manager['vim'] . '/opt/vim-packager'
exe 'set runtimepath+='. vim_packager_path
exe 'set packpath+='. vim_packager_path
execute "runtime! OPT " . 'plugin/packager.vim'
" packadd vim-packager



" Garbage is spilled to terminal if statusline contains slow system() call #3197
" https://github.com/vim/vim/issues/3197
" https://stackoverflow.com/questions/51129631/vim-8-1-garbage-printing-on-screen
" set t_RB=^[]11;rgb:fb/^G
" set t_RF=^[]10;rgb:fb/^G

" set t_RB= t_RF= t_RV= t_u7= t_u7= t_8f= t_8b=
" :h terminal-output-codes

silent! execute('!printf "\n\n" >> ' . g:_log_address . ' 2>&1 & > /dev/null')

" :LogSilent g:config_dir "\n" ""

" call s:log_silent('\n', "", g:_environment) " "wrong character '\n'" just for testing typoes :)

" for [key, element] in items(g:plugin_dir)
"     call s:log_silent("g:plugin_dir['" . key . "']", element, g:_environment)
" endfor

call s:log_silent("argc()", argc(), g:_environment)
call s:log_silent("len(argv())", len(argv()), g:_environment)
call s:log_silent("len(v:argv)", len(v:argv), g:_environment)

if exists('s:_init_develop') && 1 == s:_init_develop
	let arg_count     = 0
	for av in argv()
		let arg_count   += 1
		if 10 > arg_count
			let header = "argv [ 0"
		else
			let header = "argv [ "
		endif
		call s:log_silent("" . header . arg_count . " ]", av, g:_environment)
	endfor
endif


if exists('s:_init_develop') && 1 == s:_init_develop
	let rt_list = split(&packpath, ',')
	let line_count = 0
	for path in rt_list
		if 10 > line_count
			let header = "packpath [ 0"
		else
			let header = "packpath [ "
		endif
		call s:log_silent("" . header . line_count . " ]", path, g:_environment)
		let line_count += 1
	endfor
else
	" call s:log_silent("packpath", &packpath, g:_environment)
endif

if exists('s:_init_develop') && 1 == s:_init_develop
	let rt_list = split(&runtimepath, ',')
	let line_count = 0
	for path in rt_list
		if 10 > line_count
			let header = "runtimepath [ 0"
		else
			let header = "runtimepath [ "
		endif
		call s:log_silent("" . header . line_count . " ]", path, g:_environment)
		let line_count += 1
	endfor
else
	" call s:log_silent("runtimepath", &runtimepath, g:_environment)
endif

" debug flag
" breakadd here

call s:log_silent("\n", "", g:_environment)

if filereadable('.vimrc.local')
	" Good one
	" source .test.txt
	" Good one
	" execute 'source .test.txt'

	" source '.vimrc.local'  " can't open file
	" source ".vimrc.local"  " infinitly run when re source the container file

	execute 'source .vimrc.local'
endif


" WhichKey move focused window from current to the right/next one"
" vim-which-key is vim port of emacs-which-key that displays available keybindings in popup.
" https://github.com/liuchengxu/vim-which-key
nnoremap <silent> <leader> :WhichKey '\' <cr>
nnoremap <silent> <esc> :noh<cr>
" By default timeoutlen is 1000 ms
set timeoutlen=500
" set timeoutlen=100


" "initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

" "Begin vim-packager Scripts vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
" "Begin vim-packager Scripts vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

function! s:lightline_disable()
	let runtime_index = stridx(&runtimepath, 'lightline')
	if -1 != runtime_index
		let rtp_list = maktaba#rtp#Split()
		exe 'set runtimepath-='. get(rtp_list, runtime_index)
		let runtime_index = stridx(&runtimepath, 'lightline')
		if -1 == runtime_index
			echom "Remove lightline succeed"
		else
			echom "Failed to remove lightline"
		endif
	endif
	if exists('g:lightline')
		" Error detected while processing function lightline#update_disable:
		" line    1:
		" E121: Undefined variable: s:lightline
		call lightline#disable()
	endif
	if exists('$TMUX')
		set laststatus=0
	else
		set laststatus=2 " Always display the statusline in all windows
	endif
endfunction

filetype off

" https://www.reddit.com/r/vim/comments/edcgkk/do_you_recommend_using_vim_8s_new_packpath_to/
" https://github.com/kristijanhusak/vim-packager
" git clone https://github.com/kristijanhusak/vim-packager ~/.vim/pack/packager/opt/vim-packager

let g:vim_packages_use = {}
let g:vim_packages_use['majutsushi/ctags']                                = { 'type' : 'opt' }
let g:vim_packages_use['kristijanhusak/vim-packager']                     = { 'type' : 'opt' }
let g:vim_packages_use['vimwiki/vimwiki']                                 = { 'type' : 'opt' }
let g:vim_packages_use['Shougo/unite-outline']                            = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-surround']                              = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-repeat']                                = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-scriptease']                            = { 'type' : 'opt' }
let g:vim_packages_use['junegunn/vader.vim']                              = { 'type' : 'opt' }
let g:vim_packages_use['drmingdrmer/xptemplate']                          = { 'type' : 'opt' }
" let g:vim_packages_use['rscarvalho/OpenProject.vim']                 = { 'type' : 'opt' }  " "cd" to that directory
let g:vim_packages_use['kasandell/Code-Pull']                             = { 'type' : 'opt' }
let g:vim_packages_use['vim-scripts/genutils']                            = { 'type' : 'opt' }
let g:vim_packages_use['benmills/vimux']                                  = { 'type' : 'opt' }
let g:vim_packages_use['itchyny/lightline.vim']                           = { 'type' : 'opt' }  " Status line
" Coflicts with buffergator
let g:vim_packages_use['tpope/vim-sleuth']                                = { 'type' : 'opt' }
" Insert condition here means telling manager to remove the plugin's local copy
" Using redir in execute triggers an error in vim
" if exists('g:_use_indent_guides')
let g:vim_packages_use['nathanaelkane/vim-indent-guides']                 = { 'type' : 'opt' }  " File format visible
" endif
" Just work on vim, not neovim
let g:vim_packages_use['janlazo/vim-bang-terminal']                       = { 'type' : 'opt' }
" can't deal with writable permission issues
" The sessions directory '$SHARE_PREFIX/init/editor/vim/pack/packager/start/' isn't writable!
" let g:vim_packages_use['xolox/vim-session']                          = { 'type' : 'opt' }

if has("cscope")
	let g:vim_packages_use['ronakg/quickr-cscope.vim']                       = { 'type' : 'opt' }
	let g:vim_packages_use['trailblazing/cscope_auto']                       = { 'type' : 'opt', 'requires' : { 'name' : 'trailblazing/session_auto',
		\ 'opts': { 'type' : 'start', 'requires' : {'name': 'trailblazing/boot', 'opts': {'type': 'start'} } } } }
endif

let g:vim_packages_use['airblade/vim-gitgutter']                          = { 'type' : 'opt' }
let g:vim_packages_use['lifepillar/vim-mucomplete']                       = { 'type' : 'opt' }  " Code completion
let g:vim_packages_use['Shougo/ddc.vim']                                  = { 'type' : 'opt' }
let g:vim_packages_use['vim-denops/denops.vim']                           = { 'type' : 'opt' }
let g:vim_packages_use['roman/golden-ratio']                              = { 'type' : 'opt' }  " File format
let g:vim_packages_use['marklcrns/vim-smartq']                            = { 'type' : 'opt' }

" Randerig not stable.
let g:vim_packages_use['plasticboy/vim-markdown']                         = { 'type' : 'opt' }
let g:vim_packages_use['mattolenik/vim-projectrc']                        = { 'type' : 'opt' }
let g:vim_packages_use['sheerun/vim-polyglot']                            = { 'type' : 'opt' }
" Tons of errors with something not found
let g:vim_packages_use['trailblazing/mkdx']                               = { 'type' : 'opt' }
let g:vim_packages_use['joshdick/onedark.vim']                            = { 'type' : 'opt' }
" Rust current vsersion doesn't support musl libc 1.2.4
" "tail --line=1" to "tail -n 1" in install.sh
let g:vim_packages_use['liuchengxu/vim-clap']                             = { 'type' : 'opt', 'do': ':Clap install-binary' }  " File format

" " https://github.com/christoomey/vim-tmux-navigator
" $SHARE_PREFIX/init/editor/vim/pack/packager/start/keys/after/plugin/keys.vim
" "     silent! execute(a:navigate[a:direction])
" $SHARE_PREFIX/tinit/tmux.conf
" set -g @plugin 'christoomey/vim-tmux-navigator'
" $SHARE_PREFIX/init/editor/nvim/init.vim
let g:vim_packages_use['trailblazing/session_auto']                       = { 'type' : 'opt', 'requires' : 'trailblazing/boot' }
let g:vim_packages_use['christoomey/vim-tmux-navigator']                  = { 'type' : 'opt' }
let g:vim_packages_use['prabirshrestha/vim-lsp']                          = { 'type' : 'opt' }

" let g:vim_packages_use['tmux-plugins/vim-tmux-focus-events']              = { 'type' : 'opt' }  " obsoleted


if exists('g:_use_fern')
	let g:vim_packages_use['lambdalisue/fern.vim']                        = { 'type' : 'opt' }
	let g:vim_packages_use['liquidz/vim-iced-fern-debugger']              = { 'type' : 'opt', 'for' : 'clojure' }
	let g:vim_packages_use['lambdalisue/fern-hijack.vim']                 = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-mapping-project-top.vim']    = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-git-status.vim']             = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-renderer-nerdfont.vim']      = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-ssh']                        = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-bookmark.vim']               = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-mapping-git.vim']            = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-mapping-mark-children.vim']  = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-mapping-quickfix.vim']       = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-comparator-lexical.vim']     = { 'type' : 'opt' }
	let g:vim_packages_use['lambdalisue/fern-renderer-devicons.vim']      = { 'type' : 'opt' }
	let g:vim_packages_use['hrsh7th/fern-mapping-call-function.vim']      = { 'type' : 'opt' }
	let g:vim_packages_use['hrsh7th/fern-mapping-collapse-or-leave.vim']  = { 'type' : 'opt' }
	let g:vim_packages_use['LumaKernel/fern-mapping-reload-all.vim']      = { 'type' : 'opt' }
	let g:vim_packages_use['LumaKernel/fern-mapping-fzf.vim']             = { 'type' : 'opt' }
	let g:vim_packages_use['liquidz/vim-iced-fern-debugger']              = { 'type' : 'opt' }
endif

" let g:vim_packages_use['autozimu/LanguageClient-neovim']             = { 'do'   : 'bash install.sh' }
" let g:vim_packages_use['sjbach/lusty']                               = { 'type' : 'opt' }  " LustyExplorer (ruby requires)
" let g:vim_packages_use['smintz/vim-sqlutil']                         = { 'type' : 'opt' }
" let g:vim_packages_use['ycm-core/YouCompleteMe']                     = { 'type' : 'opt' }
" let g:vim_packages_use['tomtom/tcalc_vim']                           = { 'type' : 'opt' }
" let g:vim_packages_use['tomtom/tcomment_vim']                        = { 'type' : 'opt' }
" let g:vim_packages_use['vim-scripts/gtags.vim']                      = { 'type' : 'opt' }
" let g:vim_packages_use['whatot/gtags-cscope.vim']                    = { 'type' : 'opt' }
" let g:vim_packages_use['inkarkat/vim-ingo-library']                  = { 'type' : 'opt' }
" let g:vim_packages_use['jlanzarotta/bufexplorer']                    = { 'type' : 'opt' }  " Will open in current window
" let g:vim_packages_use['vim-scripts/TabBar']                         = { 'type' : 'start' }  " minibufexplorer
" let g:vim_packages_use['fholgado/minibufexpl.vim']                   = { 'type' : 'start' }  " minibufexplorer
" let g:vim_packages_use['LucHermitte/local_vimrc']                    = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-vim-lib']                     = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-brackets']                    = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-dev']                         = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-tags']                        = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-cpp']                         = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/mu-template']                    = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/lh-style']                       = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/vim-refactor']                   = { 'type' : 'start' }
" let g:vim_packages_use['LucHermitte/vim-build-tools-wrapper']        = { 'type' : 'start' }
" let g:vim_packages_use['erig0/cscope_dynamic']                       = { 'type' : 'start' }
" let g:vim_packages_use['chrisbra/vim-autoread']                      = { 'type' : 'start' }  " Auto refresh changes by tail -f. duplicate buffers continually!
" let g:vim_packages_use['wikitopian/hardmode']                        = { 'type' : 'start' }  " Disable arrow key
" let g:vim_packages_use['yssl/QFEnter']                               = { 'type' : 'start' }  " Could not resolve host
" let g:vim_packages_use['ervandew/supertab']                          = { 'type' : 'start' }  " Could not resolve host
" let g:vim_packages_use['Yggdroot/LeaderF']                           = { 'type' : 'start' }
" let g:vim_packages_use['preservim/nerdtree']                         = { 'type' : 'start' }
" let g:vim_packages_use['scrooloose/nerdtree']                        = { 'type' : 'start' }
" let g:vim_packages_use['wesleyche/Trinity']                          = { 'type' : 'start' }
" let g:vim_packages_use['jistr/vim-nerdtree-tabs']                    = { 'type' : 'start' }  " No longer actively maintained
" let g:vim_packages_use['vim-scripts/taglist.vim']                    = { 'type' : 'start' }
" let g:vim_packages_use['andymass/vim-matchup']                       = { 'type' : 'start' }
" let g:vim_packages_use['edsono/vim-sessions']                        = { 'type' : 'start' }
" let g:vim_packages_use['wincent/command-t']                          = { 'type' : 'start' }
" let g:vim_packages_use['umaumax/vim-format']                         = { 'type' : 'start' }  " File format
" let g:vim_packages_use['rking/ag.vim']                               = { 'type' : 'start' }
" let g:vim_packages_use['romainl/vim-qf']                             = { 'type' : 'start' }
" let g:vim_packages_use['reedes/vim-colors-pencil']                   = { 'type' : 'start' }
" let g:vim_packages_use['dawikur/base16-vim-airline-themes']          = { 'type' : 'start' }
" let g:vim_packages_use['ludovicchabant/vim-gutentags']               = { 'type' : 'start' }
" let g:vim_packages_use['skywind3000/gutentags_plus']                 = { 'type' : 'start' }
" let g:vim_packages_use['jpaulogg/vim-flipdir']                       = { 'type' : 'start' }
" let g:vim_packages_use['preservim/nerdcommenter']                    = { 'type' : 'start' }
" let g:vim_packages_use['ctrlpvim/ctrlp.vim']                         = { 'type' : 'start' }
" let g:vim_packages_use['vim-airline/vim-airline']                    = { 'type' : 'start' }
" let g:vim_packages_use['vim-airline/vim-airline-themes']             = { 'type' : 'start' }
" let g:vim_packages_use['ajh17/VimCompletesMe']                       = { 'type' : 'start' }  " Code completion
" let g:vim_packages_use['Shougo/deoplete.nvim']                       = { 'type' : 'start' }  " Code completion
" let g:vim_packages_use['bfredl/nvim-miniyank']                       = { 'type' : 'start' }
" let g:vim_packages_use['google/vim-codefmt']                         = { 'type' : 'start' }
" let g:vim_packages_use['idbrii/AsyncCommand']                        = { 'type' : 'start' }
" let g:vim_packages_use['jacobdufault/cquery']                        = { 'type' : 'start' }  " Code completion
" " Run Java at background and do not declare it
" let g:vim_packages_use['mattn/vim-lsp-settings']                     = { 'type' : 'start' }
" let g:vim_packages_use['neovim/nvim-lspconfig']                      = { 'type' : 'start' }
" let g:vim_packages_use['nvim-lua/completion-nvim']                   = { 'type' : 'start' }
" let g:vim_packages_use['joe-skb7/cscope-maps']                       = { 'type' : 'start' }
" let g:vim_packages_use['jezcope/vim-align']                          = { 'type' : 'start' }  " File format. Inactive
" let g:vim_packages_use['tpope/vim-obsession']                        = { 'type' : 'start' }
" let g:vim_packages_use['moll/vim-bbye']                              = { 'type' : 'start' }
" let g:vim_packages_use['lambdalisue/suda.vim']                       = { 'type' : 'start' }

let g:vim_packages_use['Yggdroot/indentLine']                             = { 'type' : 'start' }    " File format
let g:vim_packages_use['morhetz/gruvbox']                                 = { 'type' : 'start' }
let g:vim_packages_use['moll/vim-bbye']                                   = { 'type' : 'start' }
let g:vim_packages_use['sbdchd/neoformat']                                = { 'type' : 'start' }

" Cutlass overrides the delete operations to actually just delete and not affect the current yank
let g:vim_packages_use['svermeulen/vim-cutlass']                          = { 'type' : 'start' }
let g:vim_packages_use['google/vim-maktaba']                              = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-dispatch']                              = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-commentary']                            = { 'type' : 'start' }
if exists("g:_use_wl_clipboard")
	" Replaced with on neovim
	" use { 'matveyt/neoclip' }
	" in g:lua_config_dir . "/plugins.lua"
	let g:vim_packages_use['jasonccox/vim-wayland-clipboard']                 = { 'type' : 'start' }
endif
let g:vim_packages_use['vim-scripts/RltvNmbr.vim']                        = { 'type' : 'start' }  " File format
let g:vim_packages_use['editorconfig/editorconfig-vim']                   = { 'type' : 'start' }  " File format
let g:vim_packages_use['vim-autoformat/vim-autoformat']                   = { 'type' : 'start' }  " File format
let g:vim_packages_use['junegunn/vim-easy-align']                         = { 'type' : 'start' }  " File format
let g:vim_packages_use['rhysd/vim-clang-format']                          = { 'type' : 'start' }  " File format

let g:vim_packages_use['godlygeek/tabular']                               = { 'type' : 'start' }  " File format
let g:vim_packages_use['drmingdrmer/vim-toggle-quickfix']                 = { 'type' : 'start' }
let g:vim_packages_use['itchyny/vim-qfedit']                              = { 'type' : 'start' }
let g:vim_packages_use['lervag/vimtex']                                   = { 'type' : 'start' }
let g:vim_packages_use['jesseleite/vim-agriculture']                      = { 'type' : 'start' }
let g:vim_packages_use['ggreer/the_silver_searcher']                      = { 'type' : 'start' }
let g:vim_packages_use['BurntSushi/ripgrep']                              = { 'type' : 'start' }
let g:vim_packages_use['preservim/vim-colors-pencil']                     = { 'type' : 'start' }
let g:vim_packages_use['chriskempson/base16-vim']                         = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/unsuck-flat']                        = { 'type' : 'start' }
" let g:vim_packages_use['skywind3000/asyncrun.vim']                   = { 'type' : 'start', 'do' : 'chmod -R a+r ./* && chown -R root:users ./'}
let g:vim_packages_use['tpope/vim-rhubarb']                               = { 'type' : 'start' }  " Gbrowse
let g:vim_packages_use['tpope/vim-fugitive']                              = { 'type' : 'start' }  " Gblame
let g:vim_packages_use['liuchengxu/vim-which-key']                        = { 'type' : 'start' }

let g:vim_packages_use['lambdalisue/nerdfont.vim']                        = { 'type' : 'start' }

" let g:vim_packages_use['terryma/vim-multiple-cursors']               = { 'type' : 'start' }  " obsoleted

let g:vim_packages_use['hashivim/vim-terraform']                          = { 'type' : 'start' }
let g:vim_packages_use['mg979/vim-visual-multi']                          = { 'type' : 'start' }

let g:vim_packages_use['tpope/vim-eunuch']                                = { 'type' : 'start' }
" let g:vim_packages_use['chrisbra/SudoEdit.vim']                      = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-surround']                              = { 'type' : 'start' }
let g:vim_packages_use['editorconfig/editorconfig-vim']                   = { 'type' : 'start' }
let g:vim_packages_use['mattn/emmet-vim']                                 = { 'type' : 'start' }

" let g:vim_packages_use['shemerey/vim-project']                       = { 'type' : 'start' }
" let g:vim_packages_use['xolox/vim-misc']                             = { 'type' : 'start' }  " Debug errors pop-uping
" let g:vim_packages_use['xolox/vim-reload']                           = { 'type' : 'start' }  " Debug errors pop-uping


" let g:vim_packages_use['majutsushi/tagbar']                          = { 'type' : 'start' }

let g:vim_packages_use['preservim/tagbar']                                = { 'type' : 'start' }
let g:vim_packages_use['vhdirk/vim-cmake']                                = { 'type' : 'start' }
let g:vim_packages_use['gilligan/vim-lldb']                               = { 'type' : 'start' }
let g:vim_packages_use['mileszs/ack.vim']                                 = { 'type' : 'start' }
let g:vim_packages_use['mhinz/vim-grepper']                               = { 'type' : 'start' }
let g:vim_packages_use['LucHermitte/vim-refactor']                        = { 'type' : 'start' }
let g:vim_packages_use['MarcWeber/vim-addon-background-cmd']              = { 'type' : 'start' }

let g:vim_packages_use['RyanMillerC/better-vim-tmux-resizer']             = { 'type' : 'start' }
let g:vim_packages_use['mhinz/vim-galore']                                = { 'type' : 'start' }
" let g:vim_packages_use['plasticboy/vim-markdown']                         = { 'type' : 'start' }
let g:vim_packages_use['jgdavey/tslime.vim']                              = { 'type' : 'start' }
let g:vim_packages_use['zdharma-continuum/zinit-vim-syntax']              = { 'type' : 'start' }
let g:vim_packages_use['leafgarland/typescript-vim']                      = { 'type' : 'start' }
let g:vim_packages_use['chrisbra/Recover.vim']                            = { 'type' : 'start' }
let g:vim_packages_use['preservim/vim-textobj-quote']                     = { 'type' : 'start' }
let g:vim_packages_use['kana/vim-textobj-user']                           = { 'type' : 'start' }

let g:vim_packages_use['trailblazing/boot']                               = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/keys']                               = { 'type' : 'opt' }
" let g:vim_packages_use['trailblazing/vim-buffergator']               = { 'type' : 'start' }  " minibufexplorer
let g:vim_packages_use['git@github.com:trailblazing/vim-buffergator.git'] = { 'type' : 'start', 'requires' : 'trailblazing/boot' }  " minibufexplorer
let g:vim_packages_use['kmonad/kmonad-vim']                               = { 'type' : 'start' }
let g:vim_packages_use['skywind3000/vim-quickui']                         = { 'type' : 'start' }
let g:vim_packages_use['itchyny/vim-gitbranch']                           = { 'type' : 'start' }
let g:vim_packages_use['mbbill/undotree']                                 = { 'type' : 'start',
	\ 'do' : 'find $(pwd) -type f -exec chmod g+r {} + -o -type d -exec chmod go+rx {} + && chgrp -R users $(pwd)' }
let g:vim_packages_use['inkarkat/vim-ShowTrailingWhitespace']             = { 'type' : 'start' }
let g:vim_packages_use['inkarkat/vim-ingo-library']                       = { 'type' : 'start' }
" let g:vim_packages_use['spindensity/vim-goldendict']                 = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-unimpaired']                            = { 'type' : 'start' }
let g:vim_packages_use['justinmk/vim-dirvish']                            = { 'type' : 'start' }
let g:vim_packages_use['vim-scripts/a.vim']                               = { 'type' : 'start' }
let g:vim_packages_use['rickhowe/diffchar.vim']                           = { 'type' : 'start' }
let g:vim_packages_use['rickhowe/spotdiff.vim']                           = { 'type' : 'start' }
let g:vim_packages_use['rafi/awesome-vim-colorschemes']                   = { 'type' : 'start' }
" Huge
" let g:vim_packages_use['neoclide/coc.nvim']                          = { 'type' : 'start', 'branch': 'release' }
" let g:vim_packages_use['elixir-lsp/coc-elixir']                      = { 'type' : 'start', 'do': 'yarn install && yarn prepack'}
let g:vim_packages_use['stefandtw/quickfix-reflector.vim']                = { 'type' : 'start' }
let g:vim_packages_use['rakr/vim-two-firewatch']                          = { 'type' : 'start' }
" let g:vim_packages_use['ms-jpq/chadtree']                            = { 'type' : 'start', 'branch': 'chad', 'do': 'python3 -m chadtree deps'}
let g:vim_packages_use['tmux-plugins/vim-tmux']                           = { 'type' : 'start' }


" " Provide full URL; useful if you want to clone from somewhere else than Github.
" let g:vim_packages_use['https://my.other.public.git/tpope/vim-fugitive.git'] = {}
" " Provide SSH-based URL; useful if you have write access to a repository and wish to push to it
" let g:vim_packages_use['git@github.com:mygithubid/myrepo.git']               = {}


" let g:vim_packages_use['fatih/vim-go']                                = { 'type' : 'opt', 'do' : ':GoInstallBinaries' }
" let g:vim_packages_use['neoclide/coc.nvim']                           = { 'do'   : function('InstallCoc') }  " code completion
" let g:vim_packages_use['weirongxu/coc-explorer']                      = { 'do'   : function('InstallCoc') }

let g:vim_packages_use['sonph/onehalf']                                   = { 'rtp'  : 'vim' }

" " have binarys
" " Loaded only for specific filetypes on demand. Requires autocommands below.
" let g:vim_packages_use['kristijanhusak/vim-js-file-import']           = { 'type' : 'opt', 'do' : 'npm install' }
"
" let g:vim_packages_use['thinca/vim-themis']                          = { 'type' : 'start' }
" let g:vim_packages_use['powerline/powerline']                        = { 'type' : 'opt' }
" let g:vim_packages_use['kana/vim-vspec']                             = { 'type' : 'opt' }
" let g:vim_packages_use['xavierd/clang_complete']                     = { 'type' : 'start' }
" let g:vim_packages_use['skywind3000/asynctasks.vim']                 = { 'type' : 'start' }
" let g:vim_packages_use['liquidz/vim-iced']                           = { 'type' : 'start', 'for' : 'clojure' }
" " let g:vim_packages_use['dense-analysis/ale']                         = { 'type' : 'start' }
" " Huge
" let g:vim_packages_use['prettier/prettier']                          = { 'type' : 'start' }
" fzf needs go and is not friendly to musl
if exists("g:_use_fzf")
	" let g:vim_packages_use['junegunn/fzf']                               = { 'type' : 'start', 'do' : './install --all && ln -s $(pwd) ~/.fzf' }
	let g:vim_packages_use['junegunn/fzf.vim']                           = { 'type' : 'start' }
endif

function! s:adjust_attributes(plugin_list, plugin_dir, package_manager, environment)
	let l:func_name = boot#function_name(expand('<SID>'), expand('<sfile>'))
	" silent! execute 'find $(pwd) -type f -exec chmod go+r {} + -o -type d -exec chmod go+rx {} + && chgrp -R users $(pwd)'
	let l:packages_prefix = a:plugin_dir . '/pack/' . a:package_manager
	echo "l:packages_prefix = " . l:packages_prefix
	let l:packages_path_list  = []
	let result = 1
	echohl WarningMsg
	try
		throw "oops"
	catch /^oo/
		for item in a:plugin_list
			echo "a:plugin_list::item = \"" item "\""
			call s:log_silent(l:func_name . '::' . "a:plugin_list::item", item, a:environment)
		endfor
	endtry
	echohl None
	if len(a:plugin_list) <= 0
		return result
	endif
	let l:packages_path = ""
	for item in a:plugin_list
		let domain_removed = split(item, '/')[-1]
		echohl WarningMsg
		echom "item = \"" . item . "\""
		call s:log_silent(l:func_name . '::' . "item", item, a:environment)
		echom "domain_removed = \"" . domain_removed . "\""
		call s:log_silent(l:func_name . '::' . "domain_removed", domain_removed, a:environment)
		echohl None
		let installation_dict = filter(deepcopy(g:vim_packages_use), {key -> split(key, '/')[-1] ==? item})
		for key in keys(installation_dict)
			call s:log_silent(l:func_name . '::installation_dict::' . "key", key, a:environment)
			let installation_type = installation_dict[key]['type']
			let path = l:packages_prefix . '/' . installation_type . '/' . domain_removed
			call s:log_silent(l:func_name . '::' . "path", path, a:environment)
			let l:packages_path = l:packages_path . '"' . path . '" '
			call s:log_silent(l:func_name . '::' . "l:packages_path", l:packages_path, a:environment)

			let l:packages_path_list +=  ["'" . path . "'"]
		endfor
	endfor
	" echo "l:packages_path = " l:packages_path
	" call s:log_silent(l:func_name . '::' . "l:packages_path", l:packages_path, a:environment)
	for item in l:packages_path_list
		call s:log_silent(l:func_name . '::l:packages_path_list::' . "item", item, a:environment)
	endfor

	" silent! execute '!find ' . l:packages_path . ' -type d -name ".git" -prune -o -type d -name ".github" -prune -o
	"             \ -type f -name "*" -print -exec chmod g+r {} + -o -type d -exec chmod go+rx {} +
	"             \ && chgrp -R users ' . l:packages_path . ' 2>&1 &'

	silent! execute '!(command doas \chmod --quiet go+rx ' . l:packages_path . ') >/dev/null 2>&1 &'

	silent! execute '!(find ' . l:packages_path . '
		\ -type d -exec doas \chmod --quiet go+rx {} >/dev/null 2>&1 + ) 2>&1 &'

	silent! execute '!(command doas \chgrp -R --quiet users ' . l:packages_path . ') >/dev/null 2>&1 &'

	" silent! execute '!find ' . l:packages_path . ' -type d -name ".git" -prune -o -type d -name ".github" -prune -o
	" " ps auxft | grep zsh
	" " will tell what is the exactly running
	" silent! execute "!(set -f; command doas find \"" . l:packages_path . "\"
	"             \ -type f -name '*' -exec sh -c ' [ \"x\" = \"$(expr substr $(stat -L -c " . shellescape("%A", 1) . " \"$1\") 4 1)\" ]
	"             \ && command doas \\chmod --quiet g+rx \"$1\" || command doas \\chmod --quiet g+r \"$1\" ' sh '{}' >/dev/null 2>&1 \\;
	"             \ -o -type d -print -exec doas \\chmod --quiet go+rx '{}' >/dev/null 2>&1 \\;) &"

	" silent! execute '!(find ' . l:packages_path . '
	"             \ -type f -name "*" -print -exec \chmod --quiet g+r {} >/dev/null 2>&1 +
	"             \ -o -type d -print -exec \chmod --quiet go+rx {} >/dev/null 2>&1 +
	"             \ && \chgrp -R --quiet users ' . l:packages_path . ') 2>&1 &' | redraw!

	" Space matters in shell scripts
	let command = '!(set -f; command doas find ' . l:packages_path
		\ . ' -type f -name ' . shellescape('*', 1)
		\ . ' -exec sh -c ' . shellescape('set -f; for file;
		\    do
		\        if [ -f "$file" ]; then
		\           perm="$(stat -L -c "%A" "$file")";
		\           needs_ra=""; [ "r" != "$(expr substr $perm 5 1)" ] && needs_ra="r";
		\           needs_ea=""; [ "$(expr substr $perm 4 1)" = "x" ] && [ "$(expr substr $perm 7 1)" != "x" ] && needs_ea="x";
		\           [ "r" = "$needs_ra" ] || [ "x" = "$needs_ea" ] && command doas chmod g+$needs_ra$needs_ea "$file" 2>&1 &
		\        else
		\            IFS{# echo "Error" "$file" > /dev/stderr};
		\            command doas rm -f "$file" &
		\        fi done', 1) . ' _ ' . shellescape('{}', 1) . ' 2>&1 + )  2>&1 &'

	call s:log_silent(l:func_name . "::command", command, a:environment)
	silent! execute command
	redraw!
	function! s:result(packages_path)
		if has('nvim')
			return boot#chomp(system(['stat', '-L -c "%A %a %U %G"', a:packages_path]))
		else
			return boot#chomp(system('stat -L -c "%A %a %U %G" '. a:packages_path))
		endif
	endfunction
	for item in l:packages_path_list
		call s:log_silent(l:func_name, s:result(item) . ' ' . item, a:environment)
	endfor
	let result = 0
	return result
endfunction

function! s:adjust_init_helper(arg_list)
	call { arg_list -> s:adjust_attributes(arg_list, g:plugin_dir['vim'],
		\ g:package_manager['vim'], g:_environment) }(arg_list)
endfunction

" let g:_use_setup_minpac    = 1
" let g:_use_setup_reference = 1
let g:_use_setup_packager  = 1

" syntax disable
" syntax off

if exists('g:_use_setup_minpac')

	function! s:pack_init(plugin_dir) abort
		" Try to load minpac.
		packadd minpac

		if !exists('g:loaded_minpac')

			" minpac is not available.
			" Settings for plugin-less environment.
		else
			" minpac is available.
			call minpac#init()
			" Additional plugins here.
			"
			for [key, value] in items(g:vim_packages_use)
				call minpac#add(key, value)
			endfor
			" call minpac#add('~/my_vim_plugins/my_awesome_plugin')
			" call minpac#add(a:plugin_dir['vim'].'/pack/minpac/start/utilities/scriptnames.vim',            { 'type' : 'start' })
			" call minpac#add(a:plugin_dir['vim'].'/pack/minpac/start/cscope_auto/plugin/cscope_auto.vim',   { 'type' : 'start' })
			" call minpac#add(a:plugin_dir['vim'].'/pack/minpac/start/session_auto/plugin/session_auto.vim', { 'type' : 'start' })


			" call minpac#add(a:plugin_dir['vim'].'/pack/packager/start/keys/plugin/keys.vim', { 'type' : 'start' })
			" call minpac#add($VIMRUNTIME.'/filetype.vim',         { 'type' : 'start' })
			" call minpac#add($VIMRUNTIME.'/syntax/syntax.vim',    { 'type' : 'start' })

			" Plugin settings here.
			"
		endif
	endfunction

	" minpac can not handle local repositories [Yes. It could delete them]
	" let cscope_auto_local = '/pack/minpac/start/cscope_auto/plugin/cscope_auto.vim'
	" execute "source " . g:plugin_dir['vim'] . cscope_auto_local
	" execute "runtime! " . g:plugin_dir['vim'] . cscope_auto_local
	" let session_auto_local = '/pack/minpac/start/session_auto/plugin/session_auto.vim'
	" execute "source " . g:plugin_dir['vim'] . session_auto_local
	" execute "runtime! " . g:plugin_dir['vim'] . session_auto_local

	command! PackUpdate source $MYVIMRC <bar>
		\ call s:pack_init(g:plugin_dir['vim'])  <bar> call minpac#update()
	command! PackClean  source $MYVIMRC <bar>
		\ call s:pack_init(g:plugin_dir['vim'])  <bar> call minpac#clean()
	command! PackStatus packadd minpac  <bar> call minpac#status()

	function! s:pack_list(...)
		call s:pack_init(g:plugin_dir['vim'])
		return join(sort(keys(minpac#getpluglist())), "\n")
	endfunction

	command! -nargs=1 -complete=custom,s:pack_list
		\ PackOpenDir call s:pack_init(g:plugin_dir['vim'])
		\ <bar> call term_start(&shell,
		\ {'cwd': minpac#getpluginfo(<q-args>).dir,
		\ 'term_finish': 'close'})

	command! -nargs=1 -complete=custom,s:pack_list
		\ PackOpenUrl call s:pack_init(g:plugin_dir['vim'])
		\ <bar> call openbrowser#open(
		\ minpac#getpluginfo(<q-args>).url)

	call s:pack_init(g:plugin_dir['vim'])

elseif exists('g:_use_setup_reference')

	function! s:packager_init_ref(packager) abort

		for [key, value] in items(g:vim_packages_use)
			call a:packager.add(key, value)
		endfor

	endfunction

	packadd vim-packager
	" The second parameter is to set the packages installation location: where to put /pack/*/start and /pack/*/opt
	call packager#setup(function('s:packager_init_ref'), g:plugin_dir['vim'])

elseif exists('g:_use_setup_packager')

	" function! s:packager_init(function_adjust_init_helper, plugin_dir, package_manager) abort
	function! s:packager_init(plugin_dir, package_manager) abort
		packadd vim-packager

		if exists('g:loaded_vim_packager')

			let opt = {}
			let opt.dir = a:plugin_dir
			" Set the packages installation location: where to put /pack/*/start and /pack/*/opt
			call packager#new(opt)

			for [key, value] in items(g:vim_packages_use)
				" function! s:stdout_handler(plugin, id, message, event) dict abort
				" only supports call function and commands
				" let domain_removed = split(key, '/')[-1]
				" if value->has_key('do')
				"     " let value['do'] = value['do'] . " && call <sid>adjust_init_helper(\"" . domain_removed . "\")"
				"     let value['do'] = { domain_removed -> exec value['do'] && a:function_adjust_init_helper(domain_removed) }
				"     " let value['do'] = value['do'] . " && call <sid>adjust_attributes(\"" . domain_removed . "\", \"" . a:plugin_dir . "\", \"" .
				"     "             \ a:package_manager . "\", \"" . g:_log_address . "\", " . g:_fixed_tips_width . ", " . g:log_verbose . ")"
				" else
				"     let value['do'] = a:function_adjust_init_helper
				"     " let value['do'] = "call <sid>adjust_attributes(\"" . domain_removed . "\", \"" . a:plugin_dir . "\", \"" . a:package_manager .
				"     "             \ "\", \"" . g:_log_address . "\", " . g:_fixed_tips_width . ", " . g:log_verbose . ")"
				" endif
				call packager#add(key, value)
			endfor


			" call packager#local('~/my_vim_plugins/my_awesome_plugin')

			" PackagerClean will remove a local package which stores it self in the manager's directory
			" call packager#local(a:plugin_dir . '/backup/pack/' . a:package_manager . '/start/utilities/scriptnames.vim',            { 'type' : 'start' })

			" call packager#local(a:plugin_dir . '/backup/pack/' . a:package_manager . '/start/cscope_auto/plugin/cscope_auto.vim',   { 'type' : 'start' })
			" call packager#local(a:plugin_dir . '/backup/pack/' . a:package_manager . '/start/session_auto/plugin/session_auto.vim', { 'type' : 'start' })

			" call packager#local(g:plugin_dir['vim'] . '/backup/pack/' . a:package_manager . '/start/keys/plugin/keys.vim', { 'type' : 'start' })

			" call packager#local($VIMRUNTIME . '/filetype.vim',         { 'type' : 'start' })
			" call packager#local($VIMRUNTIME . '/syntax/syntax.vim',    { 'type' : 'start' })
		else
			" vim-packager is not available.
			" Settings for plugin-less environment.
		endif
	endfunction

	" call s:packager_init(function('s:adjust_init_helper'), g:plugin_dir['vim'], g:package_manager['vim'])
	call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
	if has('nvim') || exists($TMUX)
		call s:lightline_disable()
	endif
endif


" run PackagerInstall or PackagerUpdate
" run :PackagerInstall to install all the plugins and it's hooks
" run packadd! package_name_00 package_name_01 to load optional packages
" Load packager only when you need it


function! InstallCoc(plugin) abort
	exe '!cd '.a:plugin.dir.' && yarn install'
	call coc#add_extension('coc-eslint', 'coc-tsserver', 'coc-pyls', 'coc-explorer')
endfunction



" function! s:adjust_hook_helper(operating_type, plugin_list, plugin_dir, package_manager, environment)
function! s:adjust_hook_helper(plugin_list, plugin_dir,
	\ package_manager, environment)
	let l:func_name = boot#function_name(expand('<SID>'), expand('<sfile>'))
	if ! exists('g:loaded_vim_packager')
		call s:log_silent(l:func_name . '::'
			\ . "! exists('g:loaded_vim_packager')",
			\ ! exists('g:loaded_vim_packager'), a:environment)
		return
	endif
	let l:plugins_explicit_to_be_processed = []
	let l:all_initialized_plugins = packager#plugins()
	let l:plugins_implicit_to_be_processed = []
	for item in l:all_initialized_plugins
		"for [key, value] in items(item)
		"    call s:log_silent(l:func_name . '::l:all_initialized_plugins::' . key, value, a:environment)
		"endfor
		" if item['installed'] ==? 0 && a:operating_type == 'install'
		if item['installed'] ==? 0
			call add(l:plugins_implicit_to_be_processed, item)
			" s:plugin.get_info() doesn't have 'frozen' option output
			" E716: Key not present in Dictionary: "frozen"
			" elseif item['frozen'] ==? 0 && a:operating_type == 'update' || item['installed'] !=? 0
			"     call add(l:plugins_implicit_to_be_processed, item)
		endif
	endfor
	" if a:operating_type == 'install'
	"     let l:plugins_implicit_to_be_processed = filter(values(l:all_initialized_plugins), 'v:val.installed ==? 0')
	" elseif a:operating_type == 'update'
	"     " s:plugin.get_info() doesn't have 'frozen' option output
	"     let l:plugins_implicit_to_be_processed = filter(values(l:all_initialized_plugins), 'v:val.frozen ==? 0')
	" endif
	if !empty(a:plugin_list)
		let l:plugins_explicit_to_be_processed
			\ = filter(l:all_initialized_plugins,
			\ 'index(a:plugin_list, v:val.name) > -1')
	endif
	let remaining_jobs = len(l:plugins_explicit_to_be_processed)

	" if remaining_jobs ==? 0
	"     call s:log_silent(l:func_name . '::'
	"     \ . "initial::len(l:plugins_explicit_to_be_processed)", remaining_jobs, a:environment)
	"     echo 'Nothing to update.'
	"     return
	" endif

	let l:explicit_item_name_list = []
	let l:implicit_item_name = ""
	for item in l:plugins_explicit_to_be_processed
		" echo "l:plugins_explicit_to_be_processed::item = \"" item "\""
		" call s:log_silent(l:func_name . '::'
		" \ . "initial::l:plugins_explicit_to_be_processed::item", item, a:environment)
		let domain_removed = split(item['name'], '/')[-1]
		echohl WarningMsg
		echo "item['name'] = \"" . item['name'] . "\""
		call s:log_silent(l:func_name . '::'
			\ . "l:plugins_explicit_to_be_processed::item['name']",
			\ shellescape(item['name'], 1), a:environment)
		echo "domain_removed = \"" . domain_removed . "\""
		call s:log_silent(l:func_name . '::'
			\ . "l:plugins_explicit_to_be_processed::domain_removed",
			\ shellescape(domain_removed, 1), a:environment)
		call add(l:explicit_item_name_list, domain_removed)
		let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
		echohl None
	endfor
	if len(l:plugins_explicit_to_be_processed) <= 0
		if len(l:plugins_implicit_to_be_processed) > 0
			for item in l:plugins_implicit_to_be_processed
				call s:log_silent(l:func_name . '::'
					\ . "l:plugins_implicit_to_be_processed::item['name']",
					\ shellescape(item['name'], 1), a:environment)
				let domain_removed = split(item['name'], '/')[-1]
				call s:log_silent(l:func_name . '::'
					\ . "l:plugins_implicit_to_be_processed::domain_removed",
					\ shellescape(domain_removed, 1), a:environment)
				let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
			endfor
		else
			for item in l:all_initialized_plugins
				call s:log_silent(l:func_name . '::'
					\ . "l:plugins_implicit_to_be_processed::item['name']",
					\ shellescape(item['name'], 1), a:environment)
				let domain_removed = split(item['name'], '/')[-1]
				call s:log_silent(l:func_name . '::'
					\ . "l:plugins_implicit_to_be_processed::domain_removed",
					\ shellescape(domain_removed, 1), a:environment)
				let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
			endfor
		endif
	endif
	command! -nargs=* AdjustAttributes
		\ :call s:adjust_attributes(<args>, g:plugin_dir['vim'],
		\ g:package_manager['vim'], g:_environment)
	for item in l:explicit_item_name_list
		call s:log_silent(l:func_name . '::' . "l:explicit_item_name_list::item",
			\ shellescape(item, 1), a:environment)
	endfor

	let result = {}
	let result['plugins'] = l:explicit_item_name_list

	call s:log_silent(l:func_name . '::'
		\ . "len(result['plugins'])", len(result['plugins']), a:environment)
	for item in result['plugins']
		call s:log_silent(l:func_name . '::' .
			\ "result['plugins']::item", shellescape(item, 1), a:environment)
	endfor
	let command_for_on_finish = ":AdjustAttributes [" . l:implicit_item_name . "]"
	call s:log_silent(l:func_name . '::' . "command_for_on_finish",
		\ shellescape(command_for_on_finish, 1), a:environment)
	let result['on_finish'] = command_for_on_finish

	" " E117: Unknown function: <SNR>18_adjust_attributes
	" let function_name = boot#get_snr('s:adjust_attributes')
	" let function_name = boot#get_snr('<sid>adjust_attributes')

	" let result['on_finish'] = "call " . a:function_name . "([" . l:item_path . "], \"" .  a:plugin_dir . "\", \"" .
	"             \ a:package_manager . "\", \"" . a:environment . ")"

	" let result['on_finish'] = { l:plugins_explicit_to_be_processed, plugin_dir,
	"             \ package_manager, a:environment -> s:adjust_attributesl(l:plugins_explicit_to_be_processed, plugin_dir,
	"             \ package_manager, a:environment) }
	return result
endfunction


if exists('g:_use_setup_packager')

	" command! PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#install()
	" command! -bang PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#update({ 'force_hooks': '<bang>' })
	" command! PackagerClean call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#clean()
	" command! PackagerStatus call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#status()

	" These commands are automatically added when using `packager#setup()`  " don't overload it again
	" :PackagerInstall ['vim-clang-format']
	" :PackagerInstall ['vim-dirvish', 'fzf']
	" command! -nargs=* -bar PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
	"             \ | call packager#install(<args>)


	" How to use
	" PackagerInstall ['vim-scripts/a.vim', 'morhetz/gruvbox', 'joshdick/onedark.vim']
	command! -nargs=* -bar PackagerInstall
		\ call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
		\ | call packager#install(s:adjust_hook_helper(<args>,
		\  g:plugin_dir['vim'], g:package_manager['vim'], g:_environment))

	" " How about <args> is empty? even not an []
	" command! -nargs=* -bar PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
	"             \ | call packager#install({'plugins' : <args>,
	"             \ 'on_finish' : "call <sid>adjust_attributes(" . <q-args> . ", \"" . g:plugin_dir['vim'] . "\", \"" . g:package_manager['vim'] . "\",
	"             \ \"" . g:_environment . ")"})

	" command! -nargs=* -bar PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
	"             \ | call packager#update(<args>)

	" How to use PackagerUpdate ['vim-scripts/a.vim']
	command! -nargs=* -bar PackagerUpdate
		\ call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
		\ | call packager#update(s:adjust_hook_helper(<args>,
		\  g:plugin_dir['vim'], g:package_manager['vim'], g:_environment))

	" " How about <args> is empty? even not an []
	" command! -nargs=* -bar PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
	"             \ | call packager#update({'plugins' : <args>,
	"             \ 'on_finish' : "call <sid>adjust_attributes(<args>, \"" . g:plugin_dir['vim'] . "\", \"" . g:package_manager['vim'] . "\",
	"             \ \"" . g:_environment . ")"})

	command! -bar PackagerClean
		\ call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
		\ | call packager#clean()
	command! -bar PackagerStatus
		\ call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
		\ | call packager#status()
endif

" Load plugins only for specific filetype
" Note that this should not be done for plugins that handle their loading using ftplugin file.
" More info in :help pack-add
augroup packager_filetype
	autocmd!
	autocmd FileType javascript packadd vim-js-file-import
	autocmd FileType go packadd vim-go
augroup END

" Lazy load plugins with a mapping
nnoremap <silent><leader>ww :unmap <leader>ww<BAR>packadd vimwiki<BAR>VimwikiIndex<cr>


filetype indent plugin on | syn on
" :set verbose=9    " debug pugins

" syntax enable
" syntax on

" Because using cursorcolumn, and then using colorcolumn, the interface is too cumbersome
" On a 320*90 screen, after dividing the screen into thirds in the horizontal directions,
" the natural width of each screen is about 100 characters. Maturally keep the appropriate
" width. In fact, I advocate not doing hard line breaks
set colorcolumn=

function! s:refresh_light()
	if &filetype !~? '\v(help|txt|log)'
		" " v:lua.require'plugins'.install()
		" set colorcolumn=0
		" let &colorcolumn="0,".join(range(0, 120),",")
		" let &colorcolumn="120,".join(range(120,999),",")


		" Without virtcol, indent line will be erased when navigated to long line
		" if &list == 0 || virtcol('.') > 70
		if exists('g:loaded_indent_blankline') && virtcol('.') > 70
			setlocal list
		" else
		" if exists('g:loaded_indent_blankline')
		"     " "setlocal list" is much lighter than IndentBlanklineRefresh
		"     :IndentBlanklineRefresh
		endif
			" :IndentBlanklineEnable!
		" endif
	else
		" if &list == 1
		"     setlocal nolist
		" else
			" :IndentBlanklineDisable!
		" endif
	endif
endfunction
" I happened put it under has('nvim') and vim complains it:)
" E117: Unknown function: <SNR>3_refresh
function! s:refresh()
	set colorcolumn=
	call s:refresh_light()
	" if &filetype !~? '\v(help|txt|log)'
	"     if &textwidth == 120
	"         set textwidth=120
	"     endif
	"     " if &colorcolumn == ( &textwidth + 1 )
	"     if &colorcolumn == 121
	"         let &colorcolumn = 121
	"     endif
	" else
	"     if &textwidth == 0
	"         set textwidth=0
	"     endif
	"     if &colorcolumn == ""
	"         let &colorcolumn=""
	"     endif
	" endif
	" redraw!

	" if &syntax != &filetype
	" Highly CPU usage
	" syntax on
	" endif
endfunction

augroup virc_autocmds | au!
	au BufEnter * highlight OverLength ctermbg=DarkBlue guibg=DarkBlue ctermfg=NONE guifg=NONE
		\ cterm=reverse gui=reverse term=reverse
	" au BufEnter * match OverLength /\%120v.*/
	au BufEnter,WinEnter * call matchadd('OverLength', '\%120v.\+', -1)
augroup end

if has('nvim')

	function! LuaFormat()
		if &filetype =~# '\v(lua)'
			call function(g:_environment._job_start)("!doas stylua
				\ --indent-type spaces --indent-width 4 %")
		endif
	endfunction


	" https://www.reddit.com/r/vim/comments/8mqs7t/how_to_really_turn_off_autoindent/
	augroup lua_no_indent
		au!
		autocmd FileType lua nnoremap <buffer> <F4> :normal! LuaFormat()<cr>
		" autocmd FileType lua nnoremap <buffer> <F4>
		"     \ silent! execute "!doas stylua --indent-type spaces %"<cr>

		" Crash and print TERM to lua file
		" autocmd BufWrite *.lua call LuaFormat()

		" autocmd BufWrite *.lua silent! execute "!doas stylua --indent-type spaces %"
		autocmd FileType lua setlocal nocindent nosmartindent noautoindent
	augroup end

	lua plugins = require('plugins')
	lua if vim.fn.empty(vim.inspect(plugins)) > 0 then plugins.install() end


	call s:lightline_disable()
	" lua require("slanted")
	" lua require('plugins'):requireRel("slanted-gaps")
	" lua require("slanted")

	" lua basic_line = require('evil_line')
	" lua basic_line = require('wlsample.basic')
	lua cool = require('cool')

	" lua lualine.setup{options = {icons_enabled = true, theme = 'slanted'}}

	" format will demage EOF from inserting spaces before it
	" lua << EOF
	" -- if vim.fn.empty(vim.inspect(vim.api.nvim_eval(plugins))) > 0 then
	" if vim.fn.empty(vim.inspect(plugins)) > 0 then
	"     plugins.install()
	"     -- lua plugins.startup()
	"     -- lua plugins.update()
	" end
	" EOF

	" lua cmp = require('nvim-cmp')

	lua navigator = require'navigator'
	lua if vim.fn.empty(vim.inspect(navigator)) > 0 then navigator.setup() end

	function! s:lua_update()
		" if $USER ==# 'root'
		lua require'plugins'.install()
		:PackerCompile
		" else
		"     lua require'plugins'.startup()
		" endif
	endfunction

	function! s:update_init()
		source <afile>
		" v:lua.require'plugins'.install()
		lua require'plugins'.install()
		:PackerCompile
		:KR
		redraw!
	endfunction

	" lua windline = require('cool')
	" call s:lua_update()

	nnoremap <leader>j :call <sid>lua_update()<cr>

	augroup packer_user_config
		autocmd!
		" autocmd BufWritePost plugins.lua source <afile> | v:lua.require'plugins'.install() | :PackerCompile
		autocmd BufWritePost ?.lua call s:update_init()
	augroup end

	" https://github.com/Olical/aniseed
	let g:aniseed#env = v:true

	" lua vim.opt.list = true
	" lua vim.opt.listchars:append("eol:↴")

	" lua require("indent_blankline").setup {
	"     char = "|",
	"     buftype_exclude = {"terminal"},
	"     show_end_of_line = true,
	"     }
	"
	" lua require("status-line")



	" https://www.reddit.com/r/vim/comments/oywg54/how_to_remap_tab_without_affecting_ctrli/
	nnoremap <c-i> i
	" Use <Tab> and <S-Tab> to navigate through popup menu
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	unmap <c-i>


	" https://github.com/nvim-lua/completion-nvim
	" completion.nvim is no longer maintained
	" augroup completion
	"     au!
	"     " Use completion-nvim in every buffer
	"     autocmd BufEnter * lua require'completion'.on_attach()
	" augroup END
	" " map <c-p> to manually trigger completion
	" imap <silent> <c-p> <Plug>(completion_trigger)
	" imap <tab> <Plug>(completion_smart_tab)
	" imap <s-tab> <Plug>(completion_smart_s_tab)

	" " possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
	" let g:completion_enable_snippet = 'UltiSnips'

	" let g:completion_confirm_key = "\<C-y>"
	" " let g:completion_confirm_key = ""
	" " imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
	" "             \ "\<Plug>(completion_confirm_completion)"
	" "             \  : "\<c-e>\<CR>" :  "\<CR>"

	" " possible value: "length", "alphabet", "none"
	" let g:completion_sorting = "alphabet"

	" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

	" let g:completion_trigger_character = ['.', '::']

	" augroup CompletionTriggerCharacter
	"     autocmd!
	"     autocmd BufEnter * let g:completion_trigger_character = ['.']
	"     autocmd BufEnter *.c,*.cpp,*.cxx,*.hxx,*.inl,*.impl,*.h,*.hpp
	"         \ let g:completion_trigger_character = ['.', '::']
	" augroup end

	" https://github.com/antoinemadec/FixCursorHold.nvim
	" in millisecond, used for both CursorHold and CursorHoldI,
	" use updatetime instead if not defined
	let g:cursorhold_updatetime = 100

	let g:lens#disabled = 1
	let g:lens#disabled_filetypes = ['nerdtree', 'fzf', 'tagbar', 'buffergator']
	" let g:lens#width_resize_max = 160
	let g:lens#width_resize_max = 120
	" let g:lens#width_resize_min = 20
	let g:lens#width_resize_min = 40
	" let g:lens#height_resize_max = 120
	let g:lens#height_resize_max = 20
	" let g:lens#height_resize_min = 5
	let g:lens#height_resize_min = 5

	let g:golden_ratio_exclude_nonmodifiable = 1

	nnoremap <Leader>f :lua require'telescope.builtin'.find_files(require(
		\'telescope.themes').get_dropdown({}))<cr>
	" Change an option
	nnoremap <Leader>f :lua require'telescope.builtin'.find_files(require(
		\'telescope.themes').get_dropdown({ winblend = 10 }))<cr>
endif " has('nvim')

" "End vim-packager Scripts ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
" "End vim-packager Scripts ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"



" "path settings _______________________________________________________________________________________________"

" " For opt plugins
" packadd vim-packager
" call packager#setup(function('s:packager_init'))
" packadd cscope_auto
" packadd session_auto
" packadd vim-easy-align
" packadd vim-colors-pencil
" packadd vim-mucomplete
" packadd base16-vim
if ! has('nvim')
	if empty($TMUX)
		" pack/*/opt/{name}/plugin/**/*.vim
		packadd lightline.vim
	endif
	if ! exists('g:_use_indent_guides')
		packadd! indentLine
	else
		packadd vim-indent-guides
	endif
endif

" packadd indentLine
" packadd vim-which-key
" packadd vim-autoformat
" packadd unsuck-flat
" packadd vim-misc
" packadd vim-reload
" packadd better-vim-tmux-resizer
" packadd vim-session
" packadd keys
" packadd vim-format
" packadd nvim-miniyank
" packadd vim-maktaba
" packadd vim-codefmt
" packadd vim-fugitive

" breakadd here


" "path settings _______________________________________________________________________________________________"

" "status line -------------------------------------------------------------------------------------------------"

" packadd vim-airline
" packadd vim-airline-themes

" https://github.com/vim-airline/vim-airline-themes/tree/master/autoload/airline/themes
" https://github.com/vim-airline/vim-airline/wiki/Screenshots
" let g:airline_theme = 'pencil'
" let g:airline_theme = 'base16-default-dark'
" let g:airline_theme = 'tomorrow'
" let g:airline_theme = 'fruit_punch'
" let g:airline_theme = 'badwolf'
" let g:airline_theme = 'hybridline'

" Airline can not highlight on split view switching
" augroup airline_focus
"     au!
"     au VimEnter,VimResized,FocusGained,FocusLost,WinLeave,TabEnter,TabLeave,ColorScheme,QuickFixCmdPost * :AirlineRefresh
"     au BufEnter,FocusGained,FocusLost,ColorScheme,QuickFixCmdPost <buffer> :AirlineRefresh
" augroup END

" verbose set statusline?
if ! has('nvim')
	if exists('g:loaded_minpac') || exists('g:loaded_vim_packager')

		" What I should do to change lightline's theme when changing different colorschemes?
		" https://gitmemory.com/issue/itchyny/lightline.vim/473/640329868
		" let g:lightline.colorscheme = g:colors_name ==# 'gruvbox' ? 'grubox' : 'minimal'

		let g:lightline =
			\ { 'colorscheme': 'wombat',
			\ 'active':
			\ { 'left':  [ [ 'mode', 'paste' ],
			\              [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
			\   'right': [ [ 'lineinfo' ],
			\              [ 'percent' ],
			\              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ],
			\ },
			\ 'mode_map':
			\ { 'n' : 'N',
			\   'i' : 'I',
			\   'R' : 'R',
			\   'v' : 'V',
			\   'V' : 'VL',
			\   "\<C-v>": 'VB',
			\   'c' : 'C',
			\   's' : 'S',
			\   'S' : 'SL',
			\   "\<C-s>": 'SB',
			\   't': 'T',
			\ },
			\ 'component':
			\ { 'lineinfo': '%3l:%-2v%<',
			\ },
			\ 'component_function':
			\ { 'mode': 'LightlineMode',
			\   'gitbranch': 'FugitiveHead',
			\   'readonly': 'LightlineReadonly',
			\   'fileformat': 'LightlineFileformat',
			\   'filetype': 'LightlineFiletype',
			\   'filename': 'LightlineFilename',
			\ },
			\ }


		function! LightlineMode()
			return expand('%:t') =~# '^__Tagbar__' ? 'Tagbar':
				\ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
				\ &filetype ==# 'unite' ? 'Unite' :
				\ &filetype ==# 'vimfiler' ? 'VimFiler' :
				\ &filetype ==# 'vimshell' ? 'VimShell' :
				\ lightline#mode()
		endfunction

		function! LightlineReadonly()
			return &readonly && &filetype !~# '\v(help|log|vimfiler|unite)' ? 'RO' : ''
		endfunction

		function! LightlineFileformat()
			return winwidth(0) > 70 ? &fileformat : ''
		endfunction

		function! LightlineFiletype()
			return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
		endfunction

		function! LightlineFilename()
			let filename = &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
				\ &filetype ==# 'unite' ? unite#get_status_string() :
				\ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
				\ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
			" let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
			let modified = &modified ? ' +' : ''

			return filename . modified
		endfunction

		if exists('g:loaded_lightline')
			call lightline#init()
			call lightline#colorscheme()
			call lightline#update()
		endif

		" merged to above
		" function! LightlineFilename()
		"     return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
		"                 \ &filetype ==# 'unite' ? unite#get_status_string() :
		"                 \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
		"                 \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
		" endfunction

		let g:unite_force_overwrite_statusline    = 1
		let g:vimfiler_force_overwrite_statusline = 1
		let g:vimshell_force_overwrite_statusline = 1

	endif
else
	call s:lightline_disable()
endif

let g:powerline_pycmd            = "py3"




" "status line -------------------------------------------------------------------------------------------------"

" "indent line *************************************************************************************************"
" This following statement will not be true when vim loading

if exists("g:indentLine_loaded")
	" https://github.com/Yggdroot/indentLine
	" For Yggdroot/indentLine
	let g:indentLine_setColors       = 0
	" let g:indentLine_defaultGroup  = 'SpecialKey'
	let g:indentLine_defaultGroup    = 'Comment'

	" GVim
	let g:indentLine_color_gui       = '#A4E57E'
	" let g:indentLine_color_gui       = 'DarkGray'
	" let g:indentLine_color_gui         = 'NONE'

	" none X terminal
	let g:indentLine_color_tty_light = 7 " (default: 4)
	let g:indentLine_color_dark      = 2 " (default: 2)

	" Background (Vim, GVim)
	" Vim
	let g:indentLine_color_term      = 239
	let g:indentLine_bgcolor_term    = 202
	" let g:indentLine_bgcolor_term  = 'NONE'

	let g:indentLine_color_gui       = '#4E4E4E'
	" let g:indentLine_bgcolor_gui     = '#4E4E4E'
	" let g:indentLine_bgcolor_gui   = 'NONE'
	let g:indentLine_bgcolor_gui     = '#FF5F00'

	set conceallevel                 =1
	let g:indentLine_conceallevel    = 1
	" let g:indentLine_conceallevel  = 2
	" https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
	let g:indentLine_fileTypeExclude = ['json']
	let g:indentLine_fileTypeExclude = ['markdown']

	let g:indentLine_setConceal      = 1
	" let g:indentLine_setConceal        = 2

	" default ''.
	" n for Normal mode
	" v for Visual mode
	" i for Insert mode
	" c for Command line editing, for 'incsearch'

	let g:indentLine_concealcursor   = 'inc'
	" let g:indentLine_concealcursor     = ""

	let g:indentLine_enabled         = 1

	" let g:indentLine_char            = '▏'
	" let g:indentLine_char            = '▏'
	" ctrl-k+vv
	let g:indentLine_char            = '│'
	" Does not wor in tty
	" let g:indentLine_char            = '▏'
	" let g:indentLine_char_list       = ['|', '¦', '┆', '┊']
endif

" " https://github.com/nathanaelkane/vim-indent-guides/issues/109
" " Guides not showing up the first time with colorscheme desert #109
" let g:indent_guides_color_name_guibg_pattern = "guibg='?\zs[0-9A-Za-z]+\ze'?"

if exists('g:loaded_indent_blankline')
	" let g:indent_blankline_char_highlight                 = "Whitespace"
	" High CPU usage?
	" let g:indent_blankline_show_current_context           = v:true
	let g:indent_blankline_disable_with_nolist            = v:true
	let g:indent_blankline_show_trailing_blankline_indent = v:false
	let g:indent_blankline_show_first_indent_level        = v:false
	let g:indent_blankline_filetype_exclude               = ['help', 'txt', 'log']
	let g:indent_blankline_buftype_exclude                = ['terminal']
	let g:indent_blankline_viewport_buffer                = 20
	let g:indent_blankline_show_current_context_start_on_current_line
		\ = v:false
endif

if has('nvim') && exists('g:_use_indent_guides')
	unlet g:_use_indent_guides
endif

if exists('g:_use_indent_guides')

	let g:indent_guides_auto_colors = 0
	let g:indent_guides_enable_on_vim_startup = 1
	let g:indent_guides_start_level = 2
	" let g:indent_guides_guide_size = 0

	" https://stackoverflow.com/questions/9912116/vimscript-programmatically-get-colors-from-colorscheme
	" let bgcolor=synIDattr(hlID('NonText'), 'bg#')

	if 'light' == &background
		hi IndentGuidesOdd  ctermbg=White
		hi IndentGuidesEven ctermbg=lightgrey
	elseif 'dark' == &background
		hi IndentGuidesOdd  ctermbg=black
		hi IndentGuidesEven ctermbg=darkgrey
	endif

	" hi IndentGuidesOdd  guibg=darkgrey ctermbg=3
	" hi IndentGuidesEven guibg=green    ctermbg=4

	" autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd  guibg=darkgrey ctermbg=3
	" autocmd VimEnter,ColorScheme * :hi IndentGuidesEven guibg=green    ctermbg=4

	let indent_even       = '#ecf2dd'
	let indent_odd        = '#767966'
	let indent_even       = '#494b40'
	let indent_color_odd  = 'hi IndentGuidesOdd guifg=NONE guibg='
		\ . indent_odd . '  gui=NONE ctermfg=black ctermbg=3 cterm=NONE term=NONE'
	" let indent_color_odd  = 'hi! IndentGuidesOdd  guifg=NONE guibg=#333333 gui=NONE ctermfg=8 ctermbg=3 cterm=NONE'
	let indent_color_even = 'hi IndentGuidesEven guifg=NONE guibg='
		\ . indent_even
		\ . ' gui=NONE ctermfg=black ctermbg=2 cterm=NONE term=NONE'
	" let indent_color_even = 'hi! IndentGuidesEven guifg=NONE guibg=#2b2b2b gui=NONE ctermfg=8 ctermbg=2 cterm=NONE'
	silent! execute indent_color_odd
	silent! execute indent_color_even

	augroup odd_even
		au!
		" https://githubmemory.com/repo/nathanaelkane/vim-indent-guides/issues?cursor=Y3Vyc29yOnYyOpK5MjAxNi0wNy0xNFQxODoyMDoyMyswODowMM4J3b-h&pagination=next&page=3
		" https://www.titanwolf.org/Network/q/ad9924f3-2db9-4eb0-885f-bc68bffe6e3c/ynonenone
		au VimEnter,WinEnter,BufEnter,BufWritePost,ColorScheme
			\ * silent! execute indent_color_odd
		au VimEnter,WinEnter,BufEnter,BufWritePost,ColorScheme
			\ * silent! execute indent_color_even
	augroup END

endif

" "indent line *************************************************************************************************"

" "color settings ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

function! s:set_color_scheme(colors_name)
	" CPU busy on busybox
	" let schemes = boot#chomp(system(shellescape("[$(awk -F'/' '{ a = length($NF) ? $NF : $(NF-1); print a }'
	"     \ <<<$(vpm query -f vim-colorschemes) | sed 's/.vim/,/g')]")))


	" https://github.com/preservim/vim-colors-pencil
	" https://github.com/chriskempson/base16
	" https://github.com/chriskempson/base16-vim/tree/master/colors

	" color_name
	" color_scheme/g:colors_name

	let g:colorscheme_load_path = g:plugin_dir['vim'] . '/pack/'
		\ . g:package_manager['vim'] . '/start/awesome-vim-colorschemes/colors'
	" for item in $(\ls -1 g:colorscheme_load_path); do echo "${item%.vim}"; done


	if "onedark" == a:colors_name
		let g:onedark_termcolors = 256
		let g:onedark_terminal_italics = 1

		" /mnt/init/editor/vim/pack/packager/start/awesome-vim-colorschemes/autoload/onedark.vim

		let g:onedark_color_overrides = {
			\ "red": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "black": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "green": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "yellow": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "dark_yellow": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "blue": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "cyan": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "white": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "fg": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "bg": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "comment_grey": { "gui": "#4B5263", "cterm": "238", "cterm16": "NONE" },
			\ "gutter_fg_grey": { "gui": "#4B5263", "cterm": "238", "cterm16": "NONE" },
			\ "cursor_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "NONE" },
			\ "visual_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "NONE" },
			\ "menu_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "NONE" },
			\ "special_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "NONE" },
			\ "vertsplit": { "gui": "#2C323C", "cterm": "236", "cterm16": "NONE" },
			\ "purple": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "dark_red": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "foreground": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\ "background": { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
			\}

		if has('nvim')
			if 'linux' == $TERM || $TERM =~? '256color'
				function! s:reset_color()
					let g:terminal_color_0  = g:onedark_color_overrides.black.cterm
					let g:terminal_color_1  = g:onedark_color_overrides.red.cterm
					let g:terminal_color_2  = g:onedark_color_overrides.green.cterm
					let g:terminal_color_3  = g:onedark_color_overrides.yellow.cterm
					let g:terminal_color_4  = g:onedark_color_overrides.blue.cterm
					let g:terminal_color_5  = g:onedark_color_overrides.purple.cterm
					let g:terminal_color_6  = g:onedark_color_overrides.cyan.cterm
					let g:terminal_color_7  = g:onedark_color_overrides.white.cterm
					let g:terminal_color_8  = g:onedark_color_overrides.black.cterm
					let g:terminal_color_9  = g:onedark_color_overrides.red.cterm
					let g:terminal_color_10 = g:onedark_color_overrides.green.cterm
					let g:terminal_color_11 = g:onedark_color_overrides.yellow.cterm
					let g:terminal_color_12 = g:onedark_color_overrides.blue.cterm
					let g:terminal_color_13 = g:onedark_color_overrides.purple.cterm
					let g:terminal_color_14 = g:onedark_color_overrides.cyan.cterm
					let g:terminal_color_15 = g:onedark_color_overrides.white.cterm
					let g:terminal_color_background = g:onedark_color_overrides.bg.cterm
					let g:terminal_color_foreground = g:onedark_color_overrides.fg.cterm

					" let g:terminal_color_0 = s:black.cterm
					" let g:terminal_color_1 = s:red.cterm
					" let g:terminal_color_2 = s:green.cterm
					" let g:terminal_color_3 = s:yellow.cterm
					" let g:terminal_color_4 = s:blue.cterm
					" let g:terminal_color_5 = s:purple.cterm
					" let g:terminal_color_6 = s:cyan.cterm
					" let g:terminal_color_7 = s:white.cterm
					" let g:terminal_color_8 = s:black.cterm
					" let g:terminal_color_9 = s:red.cterm
					" let g:terminal_color_10 = s:green.cterm
					" let g:terminal_color_11 = s:yellow.cterm
					" let g:terminal_color_12 = s:blue.cterm
					" let g:terminal_color_13 = s:purple.cterm
					" let g:terminal_color_14 = s:cyan.cterm
					" let g:terminal_color_15 = s:white.cterm
					" let g:terminal_color_background = s:bg.cterm
					" let g:terminal_color_foreground = s:fg.cterm

				endfunction
			else
				function! s:reset_color()
					let g:terminal_color_0  = g:onedark_color_overrides.black.gui
					let g:terminal_color_1  = g:onedark_color_overrides.red.gui
					let g:terminal_color_2  = g:onedark_color_overrides.green.gui
					let g:terminal_color_3  = g:onedark_color_overrides.yellow.gui
					let g:terminal_color_4  = g:onedark_color_overrides.blue.gui
					let g:terminal_color_5  = g:onedark_color_overrides.purple.gui
					let g:terminal_color_6  = g:onedark_color_overrides.cyan.gui
					let g:terminal_color_7  = g:onedark_color_overrides.white.gui
					let g:terminal_color_8  = g:onedark_color_overrides.black.gui
					let g:terminal_color_9  = g:onedark_color_overrides.red.gui
					let g:terminal_color_10 = g:onedark_color_overrides.green.gui
					let g:terminal_color_11 = g:onedark_color_overrides.yellow.gui
					let g:terminal_color_12 = g:onedark_color_overrides.blue.gui
					let g:terminal_color_13 = g:onedark_color_overrides.purple.gui
					let g:terminal_color_14 = g:onedark_color_overrides.cyan.gui
					let g:terminal_color_15 = g:onedark_color_overrides.white.gui
					let g:terminal_color_background = g:onedark_color_overrides.bg.gui
					let g:terminal_color_foreground = g:onedark_color_overrides.fg.gui

					" let g:terminal_color_0 = s:black.gui
					" let g:terminal_color_1 = s:red.gui
					" let g:terminal_color_2 = s:green.gui
					" let g:terminal_color_3 = s:yellow.gui
					" let g:terminal_color_4 = s:blue.gui
					" let g:terminal_color_5 = s:purple.gui
					" let g:terminal_color_6 = s:cyan.gui
					" let g:terminal_color_7 = s:white.gui
					" let g:terminal_color_8 = s:black.gui
					" let g:terminal_color_9 = s:red.gui
					" let g:terminal_color_10 = s:green.gui
					" let g:terminal_color_11 = s:yellow.gui
					" let g:terminal_color_12 = s:blue.gui
					" let g:terminal_color_13 = s:purple.gui
					" let g:terminal_color_14 = s:cyan.gui
					" let g:terminal_color_15 = s:white.gui
					" let g:terminal_color_background = s:bg.gui
					" let g:terminal_color_foreground = s:fg.gui
				endfunction
			endif
			augroup onehalfdark_color | au!
				au VimEnter * :call s:reset_color()
			augroup end

		endif
	endif


	if "pencil" == a:colors_name
		" https://www.iditect.com/how-to/53501604.html
		let g:pencil_termtrans          = 1
		let g:pencil_termcolors         = 256
		let g:pencil_terminal_italics   = 1
		let g:pencil_spell_undercurl    = 1     " 0=underline,  1=undercurl (def)
		let g:pencil_gutter_color       = 1     " 0=mono (def), 1=color
		let g:pencil_neutral_code_bg    = 1     " 0=gray (def), 1=normal
		let g:pencil_neutral_headings   = 1     " 0=blue (def), 1=normal
		let g:pencil_higher_contrast_ui = 0     " 0=low  (def), 1=high
	endif

	" function! s:sdjust_solarized()
	"     hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg
	" endfunction
	"
	" augroup sierra
	"     autocmd!
	"     autocmd ColorScheme sierra call s:sdjust_solarized()
	" augroup END


	" set background=light
	" set background=dark
	set background=dark
	highlight clear
	syntax reset
	silent! execute 'colorscheme ' . a:colors_name

endfunction

" let g:scheme_name = ""

" let g:scheme_name = "256_noir"
" No selection highlight
" let g:scheme_name = "OceanicNext"
" let g:scheme_name = "OceanicNextLight"
" let g:scheme_name = "PaperColor"
" No selection highlight
" let g:scheme_name = "abstract"
" No selection highlight
" let g:scheme_name = "afterglow"
" let g:scheme_name = "alduin"
" No selection highlight
" let g:scheme_name = "anderson"
" let g:scheme_name = "angr"
" let g:scheme_name = "apprentice"

" let g:scheme_name = "atom"
" No selection highlight
" let g:scheme_name = "ayu"
" let g:scheme_name = "carbonized-dark"
" let g:scheme_name = "carbonized-light"
" No selection highlight
" let g:scheme_name = "challenger_deep"
" Highlight variables
" let g:scheme_name = "deep-space"
" let g:scheme_name = "deus"
" No selection highlight
" let g:scheme_name = "dogrun"
" No selection highlight
" let g:scheme_name = "flattened_dark"
" let g:scheme_name = "flattened_light"
" let g:scheme_name = "focuspoint"
" let g:scheme_name = "fogbell"
" let g:scheme_name = "fogbell_light"
" let g:scheme_name = "fogbell_lite"
" let g:scheme_name = "github"
" No selection highlight
" let g:scheme_name = "gotham"
" No selection highlight
" let g:scheme_name = "gotham256"
" Thick indent line / Yellow quoted text
" let g:scheme_name = "gruvbox"
" let g:scheme_name = "happy_hacking"
" let g:scheme_name = "hybrid"
" let g:scheme_name = "hybrid_material"
" Highlight variables
" let g:scheme_name = "hybrid_reverse"
" No color
" let g:scheme_name = "iceberg"
" let g:scheme_name = "jellybeans"
" let g:scheme_name = "lightning"
" let g:scheme_name = "lucid"
" let g:scheme_name = "lucius"
" let g:scheme_name = "materialbox"
" let g:scheme_name = "meta5"
" let g:scheme_name = "minimalist"
" let g:scheme_name = "molokai"
" Highlight variables
" let g:scheme_name = "molokayo"
" No color reverse
" let g:scheme_name = "mountaineer-grey"
" let g:scheme_name = "mountaineer-light"
" let g:scheme_name = "mountaineer"
" let g:scheme_name = "nord"
" let g:scheme_name = "oceanic_material"
" let g:scheme_name = "oceanic_next"
" let g:scheme_name = "one-dark"
" let g:scheme_name = "one"
" let g:scheme_name = "onedark"

" Got grreen comments on $TERM == linux/tmux-256color in tmux
" Dark/thin/slime indent line
" Green comments on TERM == linux in tmux
" No selection highlight
let g:scheme_name = "onehalfdark"

" let g:scheme_name = "onehalflight"
" let g:scheme_name = "orange-moon"
" let g:scheme_name = "orbital"
" No color reverse
" let g:scheme_name = "paramount"
" Highlight variables
" let g:scheme_name = "parsec"
" let g:scheme_name = "pink-moon"
" Highlight variables
" let g:scheme_name = "purify"
" let g:scheme_name = "pyte"
" let g:scheme_name = "rakr"
" Highlight variables
" let g:scheme_name = "rdark-terminal2"
" Comments not distinguish
" let g:scheme_name = "scheakur"
" let g:scheme_name = "seoul256-light"
" No color reverse
" let g:scheme_name = "seoul256"
" Highlight variables
" let g:scheme_name = "sierra"
" No color reverse
" Comments not distinguish
" let g:scheme_name = "snow"
" Comments not distinguish
" let g:scheme_name = "solarized8"
" let g:scheme_name = "solarized8_flat"
" let g:scheme_name = "solarized8_high"
" let g:scheme_name = "solarized8_low"
" Yellow
" let g:scheme_name = "sonokai"
" Cyan
" Thick indent line
" let g:scheme_name = "space-vim-dark"
" Green
" let g:scheme_name = "spacecamp"
" Green
" let g:scheme_name = "spacecamp_lite"
" No selection highlight
" let g:scheme_name = "stellarized"
" Purple reverse
" let g:scheme_name = "sunbather"
" Yellow/green
" let g:scheme_name = "tender"
" Comments not distinguish
" Thick indent line
" let g:scheme_name = "termschool"

" ColorColumn right
" let g:scheme_name = "twilight256"

" Comments not distinguish
" let g:scheme_name = "two-firewatch"
" Yellow
" let g:scheme_name = "wombat256mod"
" Comments not distinguish
" let g:scheme_name = "yellow-moon"

" let g:scheme_name = "unsuck-flat"
" let g:scheme_name = "sierra"
" let g:scheme_name = "base16-default-dark"


" let g:scheme_name = "base16-flat"
" let g:scheme_name = "badwolf"

" let g:scheme_name = "tender"

" let g:scheme_name = "carbonized-dark"

" let g:scheme_name = "onehalfdark"
" let g:scheme_name = "onehalflight"
" let g:scheme_name = "tabula"


" let g:scheme_name = "mountaineer"

" let g:scheme_name = "hybrid_reverse"

" let g:scheme_name = "happy_hacking"
" Blue quotes/Cyan indent line
" let g:scheme_name = "orbital"

" let g:scheme_name = "parsec"
" let g:scheme_name = "termschool"


" let g:scheme_name = "minimalist"

" let g:scheme_name = "meta5"

" Clear style
" let g:scheme_name = "archery"

" let g:scheme_name = "afterglow"
" let g:scheme_name = "nord"
" let g:scheme_name = "jellybeans"

" Recommend (later is better)
" let g:scheme_name = "base16-tomorrow-night"
" let g:scheme_name = "sunbather"
" let g:scheme_name = "fogbell"
" Thick indent line
" let g:scheme_name = "pencil"

" Nice on tty && TERM == default
" Thick indent line
" let g:scheme_name = "two-firewatch"
" let g:two_firewatch_italics = 1

" Thick indent line
" let g:scheme_name = "lucid"

" http://www.pixelbeat.org/docs/terminal_colours/
" :h term-dependent-settings
" this variable must be enabled for colors to be applied properly
" set termguicolors
let base16colorspace = 256  " Access colors present in 256 colorspace

" https://www.reddit.com/r/vim/comments/f3v3lq/syntax_highlighting_changes_while_using_tmux/
if empty($TMUX)
	if has('nvim')
		let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
	endif
	if has('termguicolors')
		set termguicolors
	else
		set notermguicolors
	endif
else

	if ! has('gui_running') " && ! has('nvim')
		" https://github.com/tmux/tmux/issues/699
		set t_Co=256  " Note: Neovim ignores t_Co and other terminal codes.
	endif

	" Enable 24-bit true colors if your terminal supports it.
	if has('termguicolors')
		" https://github.com/vim/vim/issues/993#issuecomment-255651605
		if has('vim_starting') && ! has('gui_running') && ! has('nvim')
			let &t_8f = "\e[38;2;%lu;%lu;%lum"
			let &t_8b = "\e[48;2;%lu;%lu;%lum"
		endif
		set termguicolors
	else
		set notermguicolors
	endif
endif

" set guicursor+=a:Cursor/lCursor
set guicursor="disable"

augroup unfold
	au!
	au BufWinEnter * normal! zv
augroup END

if ! empty($TMUX)
	" silent! execute '!export TERM=xterm-256color'
	" silent! execute '!export TERM=tmux-256color'

	" let $TERM = "screen-256color"
	" silent! execute '!export TERM=screen-256color'
endif

function! s:delmarks()
	let l:m = join(filter(
		\ map(range(char2nr('a'), char2nr('z')), 'nr2char(v:val)'),
		\ 'line("''".v:val) == line(".")'))
	if !empty(l:m)
		exe 'delmarks' l:m
	endif
endfunction
nnoremap <silent> dm :<c-u>call <sid>delmarks()<cr>

" https://stackoverflow.com/questions/36813466/highlighting-arbitrary-lines-in-vim
" \L to highlight a line
" nnoremap <silent> <leader>l ml:execute 'match Search /\%'.line('.').'l/'<cr>
nnoremap <silent> <leader>L :call matchadd('Search', '\%'.line('.').'l')<CR>
" nnoremap <silent> <leader>c :execute 'match Search /\%'.virtcol('.').'v/'<cr>

" \l to remove highlighted line
nnoremap <silent> <leader>l :
	\for M in filter(getmatches(), { i, v -> has_key(l:v, 'pattern')
	\ && l:v.pattern is? '\%'.line('.').'l'} )
	\<BAR> :call matchdelete(M.id)
	\<BAR> :endfor<CR>

" au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%80v.\+', -1)

" cnoreabbrev <expr> help ((getcmdtype() is# ':' && getcmdline() is# 'help')?('vert help'):('help'))
" cnoreabbrev <expr> h ((getcmdtype()    is# ':' && getcmdline() is# 'h')?('vert help'):('h'))

augroup color_background
	au!
	" au BufEnter,WinEnter * if &filetype !~? '\v(help|txt|log)' |

	" au BufEnter,WinEnter * if &filetype !~? '\v(help|txt|log)' |
	"     \ let &colorcolumn = &textwidth + 1 |
	"     \ else |
	"     \ setlocal nolist | let &colorcolumn="" |
	"     \ endif
	"     " \ let &colorcolumn="120,".join(range(120,999),",") |
	"     " \ let &colorcolumn="0,".join(range(0, 120),",") |

	" \ set colorcolumn=120 | setlocal list |
	" \ | let &colorcolumn="80,".join(range(120,999),",") |
	" \ exe 'set colorcolumn="80,".join(range(120,999),",")' |

	" Will generate race condition and "help" will lost propper cursor position
	" autocmd FileType,WinNew txt,help,log wincmd L | set colorcolumn="" | setlocal nolist | redraw!

	" autocmd WinNew txt,help,log wincmd L | set colorcolumn="" | setlocal nolist | redraw!
	" au FileType,BufEnter,WinNew txt set colorcolumn="" && redraw!

	" https://stackoverflow.com/questions/7463555/how-to-get-the-help-window-to-always-open-in-the-same-position
	" autocmd FileType help :wincmd L

	autocmd FileType help set bufhidden=wipe

augroup END

" help W10
augroup read_only | au!
	au FileChangedRO * set noro
augroup end

" write/save/general
" Moved to boot.vim
" :cnoreabbrev w silent! call <sid>write_generic()
" :cnoreabbrev w silent! call boot#write_generic()

let g:sudo_no_gui = 1

" https://github.com/quanhengzhuang/vim-sudowriter/blob/master/plugin/sudowriter.vim
" " Will erase the current buffer completely!
" function! s:sudowrite()
"     let current = getpos('.')
"     execute '!sudo tee %'
"     edit
"     call setpos('.', current)
" endfunction

set autowriteall

" https://www.reddit.com/r/vim/comments/25g5mc/is_there_an_alternative_to_w_sudo_tee_devnull/
" sudo -e
" https://github.com/ncaq/auto-sudoedit
" auto-sudoedit in lisp

" https://vi.stackexchange.com/questions/3561/settings-and-plugins-when-root-sudo-vim
" command! -nargs=0 W silent! w !doas tee > /dev/null %  feedkeys("l", 't') :e
" command! -nargs=0 W silent! w !doas tee > /dev/null %
" command! -nargs=0 W :call <sid>sudowrite()<cr>
" command! -nargs=0 W :call <sid>save_file_via_doas()<cr>

" Won't work
" command! -nargs=0 W silent! :SudoWrite<CR>

" cmap w!! %!sudo tee > /dev/null %
" Allow saving of files as sudo when I forgot to start vim using sudo.
" Doesn't need comfirmation
" cmap w!! w !sudo tee > /dev/null %

" cnoremap w!! execute 'silent! write !sudo /usr/bin/tee "%" >/dev/null' <CR> <bar> call feedkeys('l', 't') <CR> <bar> :edit <CR>

" cnoremap w!! write !doas tee % > /dev/null <CR> :edit<CR>

" cnoremap w!! exec 'w !sudo dd of=' . shellescape(expand('%')) <CR> :edit<CR>
" cnoremap w!! exec 'w !doas dd of=' . shellescape(expand('%')) <CR> :edit<CR>

" cnoremap w!! w !sudo sh -c "cat > %" <CR> feedkeys('l', 't') <CR> :edit<CR>
" cnoremap w!! execute 'silent! write !SUDO_ASKPASS=`which ssh-askpass` sudo tee % >/dev/null' <bar> edit!
" cmap w!! let current = getpos('.') <bar> %!sudo tee > /dev/null %<CR>:edit!<CR> <bar> call setpos('.', current) <CR>

" cnoremap w!! :call <sid>sudowrite()<cr>

" cmap w!! w !doas tee > /dev/null %
" cmap w!! w !sudo sh -c "cat > %"
" cmap w!! w !sudo dd of=% > /dev/null
" Won't work
" cmap w!! silent! :SudoWrite<CR>

" https://github.com/tpope/vim-eunuch
" v +SudoEdit $SHARE_PREFIX/gentoo/root/test.cpp
" https://github.com/lambdalisue/suda.vim  " removed
" " Will erase buffers (not just current one) automatically if you don't have write permission
" let g:suda_smart_edit = 1  " for suda.vim
" For both vim-eunuch and suda.vim (change SudoWrite to SudaWrite)
" noremap  <silent> <C-s> :SudoWrite<CR>
" inoremap <silent> <C-s> <ESC>:SudoWrite<CR>i

if has('autocmd')
	" function! s:help_to_the_right()
	"     if !exists('w:help_is_moved') || w:help_is_moved != "right"
	"         wincmd L
	"         let w:help_is_moved = "right"
	"     endif
	" endfunction

	" augroup HelpPages | au!
	"     autocmd FileType help nested call s:help_to_the_right()
	" augroup END

	" Open help in most right current window
	" Usage: H topic
	command! -nargs=1 -complete=help H :wincmd l |
		\ :enew | :set buftype=help | :keepalt h <args>

	" https://stackoverflow.com/questions/630884/opening-vim-help-in-a-vertical-split-window
	" :cabbrev h vert h

endif


" https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" make window 80 + some for numbers wide

call s:set_color_scheme(g:scheme_name)

if exists("g:_use_terminal_transparent")
	let g:cterm_fg_insert  = 'NONE'
	let g:cterm_bg_insert  = '4'

	let g:nontext_fg_cterm = 'NONE'
	let g:nontext_fg_gui   = 'NONE'
else
	let g:cterm_fg_insert  = 'DarkYellow'
	" let g:cterm_bg_insert = 'Black'
	let g:cterm_bg_insert  = '107'

	" let g:nontext_fg_cterm = 241
	let g:nontext_fg_cterm = '94'
	let g:nontext_fg_gui   = 'Gray'
endif

" let g:_hl_attr_line = 'standout'
" let g:_hl_attr_line = 'nocombine,standout,underdashed'
" let g:_hl_attr_line = 'nocombine,standout,underdashed'
" let g:_hl_attr_line = 'underline'
" let g:_hl_attr_line = 'undercurl'
" let g:_hl_attr_line = 'italic'
let g:_hl_attr_line = 'NONE'
" let g:_hl_attr_line = 'reverse'

let g:_hl_attr_column = 'NONE'
" let g:_hl_attr_column = 'reverse'
" let g:_hl_attr_column = 'underline'
" let g:_hl_attr_column = 'strikethrough'
" let g:_hl_attr_column = 'standout'

if 'linux' == $TERM || $TERM =~? '256color'
	if exists("g:_use_terminal_transparent")
		" help *cterm-colors*/ctermbg for might be recognized color name
		" case-insensitive
		" Cursor line/column color
		" let g:gui_bg_normal   = 'Brown'
		" let g:gui_bg_normal   = 'Blue'
		" let g:gui_bg_normal   = 'Yellow'
		" let g:gui_bg_normal   = 'Cyan'
		" let g:gui_bg_normal   = 'SkyBlue2'
		" let g:gui_bg_normal   = 'Grey'
		" let g:gui_bg_normal   = 'White'
		" let g:gui_bg_normal   = "'salmon pink'"
		" let g:gui_bg_normal   = 'DarkGrey'
		" let g:gui_bg_normal   = 'LightYellow'
		" let g:gui_bg_normal   = 'LightMagenta'
		" let g:gui_bg_normal   = 'Magenta'
		" let g:gui_bg_normal   = 'Red'
		" let g:gui_bg_normal   = 'Purple'
		" let g:gui_bg_normal   = 'Orange'
		" let g:gui_bg_normal   = 'DarkBlue'
		" let g:gui_bg_normal   = 'LightRed'
		" let g:gui_bg_normal   = 'DarkGray'
		" let g:gui_bg_normal   = 'Violet'
		" let g:gui_bg_normal   = 'SkyBlue1'
		" let g:gui_bg_normal   = 'Lightblue'
		" let g:gui_bg_normal   = 'White'
		let g:gui_bg_normal   = 'NONE'
		" let g:gui_bg_normal   = 'Black'

		" let g:gui_fg_normal   = 'Chartreuse1'
		" let g:gui_fg_insert   = 'LightStateGrey'
		" let g:gui_fg_normal   = 'Chartreuse2'
		" let g:gui_fg_normal   = 'SkyBlue2'
		" let g:gui_fg_normal   = 'SteelBlue1'
		" let g:gui_fg_normal   = 'CornflowerBlue'
		" let g:gui_fg_normal   = 'Grey'
		" let g:gui_fg_normal   = '\e[0;34m'
		" let g:gui_fg_normal   = '\033[0;34m'
		" let g:gui_fg_normal   = 'Grey0'
		" let g:gui_fg_normal   = 'Grey93'
		" let g:gui_fg_normal   = 'Cyan'
		" let g:gui_fg_normal   = 'LightCyan'
		" let g:gui_fg_normal   = 'LightSteelBlue'
		" let g:gui_fg_normal   = 'LightSkylBlue1'
		" let g:gui_fg_normal   = 'Orange1'
		" let g:gui_fg_normal   = 'fg'
		" let g:gui_fg_normal   = 'bg'
		" let g:gui_fg_normal   = 'Red3'
		" let g:gui_fg_normal   = 'Plum2'
		" let g:gui_fg_normal   = 'DarkOliveGreen1'
		" let g:gui_fg_normal   = 'PaleTurquoise1'
		" let g:gui_fg_normal   = 'Yellow2'
		" let g:gui_fg_normal   = 'SkyBlue2'
		" let g:gui_fg_normal   = 'NONE'
		" let g:gui_fg_normal   = 'DarkGray'
		" let g:gui_fg_normal   = 'DarkGrey'
		" let g:gui_fg_normal   = 'DarkMagenta'
		" let g:gui_fg_normal   = '#ff00ff'
		" let g:gui_fg_normal   = 'LightSlateBlue'
		" let g:gui_fg_normal   = 'Fuchsia'
		let g:gui_fg_normal   = 'DarkBlue'
		" let g:gui_fg_normal   = 'DogerBlue2'
		" let g:gui_fg_normal   = 'Aqua'
		" let g:gui_fg_normal   = 'Teal'
		" let g:gui_fg_normal   = 'DarkTeal'
		" let g:gui_fg_normal   = 'Silver'
		" let g:gui_fg_normal   = 'Brown'
		" let g:gui_fg_normal   = 'DarkYellow'
		" let g:gui_fg_normal   = 'LightYellow'
		" let g:gui_fg_normal   = 'Lime'
		" let g:gui_fg_normal   = 'Maroon'
		" let g:gui_fg_normal   = 'DarkRed'
		" let g:gui_fg_normal   = 'DarkGray'
		" let g:gui_fg_normal   = 'White'
		" let g:gui_fg_normal   = 'GreenYellow'
		" let g:gui_fg_normal   = 'DarkGreen'
		" let g:gui_fg_normal   = 'Blue'
		" let g:gui_fg_normal   = 'Yellow'


		" let g:gui_bg_insert   = 'Chartreuse2'
		" let g:gui_bg_insert   = 'White'
		let g:gui_bg_insert   = 'NONE'

		" let g:gui_fg_insert   = 'SkyBlue2'
		" let g:gui_fg_insert   = 'Chartreuse1'
		let g:gui_fg_insert   = 'NONE'
		" let g:gui_fg_insert   = 'Yellow2'


		" Warning: Color name "Background" is not defined.
		" "NONE" is not a eligile argument for cterm colors
		" let g:cterm_bg_normal = 8
		" let g:cterm_bg_normal = '107'
		" let g:cterm_bg_normal = '104'
		" let g:cterm_bg_normal = '136'
		" let g:cterm_bg_normal = '237'
		let g:cterm_bg_normal = 'NONE'
		" let g:cterm_bg_normal = '255'

		" let g:cterm_fg_normal = '47'
		let g:cterm_fg_normal = 'NONE'
		" let g:cterm_fg_normal = '255'
	else
		let g:cterm_bg_normal = 'NONE'

		let g:gui_bg_normal   = 'NONE'
	endif
else
	if exists("g:_use_terminal_transparent")
		" $SHARE_PREFIX/init/editor/vim/pack/packager/start/awesome-vim-colorschemes/colors/lucid.vim
		" :let _rock        = '#181320'
		" let g:gui_bg_normal   = '#181320'
		" let g:gui_bg_normal   = '#82868a'
		let g:gui_bg_normal   = 'NONE'
		" let g:gui_fg_normal   = '#36323d'
		let g:gui_fg_normal   = 'NONE'

		let g:gui_bg_insert   = '#36323d'
		" let g:gui_bg_insert   = 'Chartreuse2'
		let g:gui_fg_insert   = 'NONE'

		let g:cterm_fg_normal = 'NONE'
		" let g:cterm_bg_normal = 4
		" let g:cterm_bg_normal = 8
		let g:cterm_bg_normal = '94'

	else
		let g:cterm_bg_normal = 'NONE'
		let g:gui_fg_normal   = 'DarkGray'
		let g:gui_bg_insert   = 'Black'
		" let g:gui_fg_insert   = 'DarkYellow'
		let g:gui_fg_insert   = '94'

		let g:gui_bg_normal   = 'NONE'
		" let g:cterm_fg_normal = '080808'
		let g:cterm_fg_normal = '104'
	endif
endif

" For CursorColumn
" Light/inverted colors (darkrock-cloud, rock-lightgrey switched)
" :let _gray        = '#82868a'
" :let _turquoise   = '#3fc997'
" :let _rock_medium = '#36323d'
let g:hl_normal =
	\ ' guifg=' . g:gui_fg_normal . ' guibg=' . g:gui_bg_normal
	\ . ' ctermfg=' . g:cterm_fg_normal . ' ctermbg=' . g:cterm_bg_normal
	\ . ' cterm=NONE gui=NONE term=NONE'

let g:hl_insert =
	\ ' guifg=' . g:gui_fg_insert . ' guibg=' . g:gui_bg_insert
	\ . ' ctermfg=' . g:cterm_fg_insert . ' ctermbg=' . g:cterm_bg_insert
	\ . ' cterm=NONE gui=NONE term=NONE'

" For CursorLine, ColorColumn
" $SHARE_PREFIX/init/editor/vim/pack/packager/start/awesome-vim-colorschemes/colors/lucid.vim
" :let _cloud       = '#e4e0ed'
let g:hl_normal_inverse =
	\ ' guifg=' . g:gui_bg_normal . ' guibg=' . g:gui_fg_normal
	\ . ' ctermfg=' . g:cterm_bg_normal . ' ctermbg=' . g:cterm_fg_normal
	\ . ' cterm=inverse gui=inverse term=inverse'

let g:hl_insert_inverse =
	\ ' guifg=' . g:gui_bg_normal . ' guibg=' . g:gui_fg_insert
	\ . ' ctermfg=' . g:cterm_bg_normal . ' ctermbg=' . g:cterm_fg_normal
	\ . ' cterm=inverse gui=inverse term=inverse'

let g:hl_normal_line =
	\ ' guifg=' . g:gui_bg_normal . ' guibg=' . g:gui_fg_normal
	\ . ' ctermfg=' . g:cterm_bg_normal . ' ctermbg=' . g:cterm_fg_normal
	\ . ' cterm=' . g:_hl_attr_line . ' gui=' . g:_hl_attr_line . ' term=' . g:_hl_attr_line
	\ . 'start=<Esc>[27h;<Esc>[<Space>r;'
	\ . "font='Monospace 10'"

" let g:hl_normal_column =
"     \ ' guifg=' . g:gui_bg_normal . ' guibg=' . g:gui_fg_normal
"     \ . ' ctermfg=' . g:cterm_bg_normal . ' ctermbg=' . g:cterm_fg_normal
"     \ . ' cterm=' . g:_hl_attr_column . ' gui=' . g:_hl_attr_column . ' term=' . g:_hl_attr_column

let g:hl_normal_column =
	\ ' guifg=' . g:gui_bg_normal . ' guibg=' . g:gui_fg_normal
	\ . ' ctermfg=' . g:cterm_bg_normal . ' ctermbg=' . g:cterm_fg_normal
	\ . ' cterm=' . g:_hl_attr_column . ' gui=' . g:_hl_attr_column . ' term=' . g:_hl_attr_column

" :highlight
if has('nvim')
	" a list of groups can be found at `:help nvim_tree_highlight`
	highlight NvimTreeFolderIcon guibg=blue
endif

hi SpellBad   cterm=underline ctermfg=9
hi SpellLocal cterm=underline ctermfg=9
hi SpellRare  cterm=underline ctermfg=9
hi SpellCap   cterm=underline

" for =bg =fg
" When Vim knows the normal foreground and background colors, "fg" and
" "bg" can be used as color names.  This only works after setting the
" colors for the Normal group and for the MS-Windows console.
highlight FileStyleIgnorePattern guibg=NONE ctermbg=0
" highlight StatusLine guifg=fg guibg=NONE ctermfg=fg ctermbg=NONE gui=NONE cterm=NONE term=NONE
" https://vi.stackexchange.com/questions/6100/remove-vim-status-bar-background-color
highlight clear StatusLine
augroup statusline_highlight | au!
	" au VimEnter,WinEnter,BufEnter,BufWritePost,ColorScheme,SourcePost *
	"     \ highlight StatusLine guifg=fg guibg=NONE ctermfg=fg ctermbg=NONE gui=NONE cterm=NONE term=NONE

	" au VimEnter,WinEnter,BufEnter,BufWritePost,ColorScheme,SourcePost * highlight clear StatusLine
	au WinEnter * highlight clear StatusLine
		\ highlight clear StatusLineNC
augroup END

" https://vi.stackexchange.com/questions/28752/vim-terminal-interferes-with-statusline
augroup statusline_highlight_term | au!
	autocmd ColorScheme * hi! link StatusLineTerm StatusLine
	autocmd ColorScheme * hi! link StatusLineTermNC StatusLineNC
augroup end


" https://vi.stackexchange.com/questions/6150/a-highlight-command-resets-previously-declared-highlights
hi NewLineWin ctermfg=248 guifg=#999999
match NewLineWin /\r\n/

" Break CursorColumn line
" hi WhiteSpaceChar ctermfg=252 guifg=#999999
" 2match WhiteSpaceChar / /

" https://stackoverflow.com/questions/24232354/vim-set-color-for-listchars-tabs-and-spaces

" Made indent line thick
" hi Whitespace ctermfg=DarkGray guifg=DarkGray
hi Whitespace ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE cterm=NONE gui=NONE term=NONE
match Whitespace /\s/

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" vim-ShowTrailingWhitespace. works under pure terminal emulator without window managers
" highlight ShowTrailingWhitespace ctermbg=Red guibg=Red
highlight ShowTrailingWhitespace ctermbg=Yellow guibg=Yellow

" https://stackoverflow.com/questions/60590376/what-is-the-difference-between-cterm-color-and-gui-color
" https://jonasjacek.github.io/colors/
hi Cursor  guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi Cursor2 guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
" hi Comment guifg=DarkGrey guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
" hi! Comment guifg=DarkGrey guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! Comment guifg=#444444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE

hi WinSeparator guifg=#222222 guibg=NONE cterm=NONE ctermbg=NONE ctermfg=DarkRed gui=NONE term=NONE

" "~" vertically under the line numbers

" https://newbedev.com/highlighting-the-current-line-number-in-vim
hi clear CursorLine
hi clear CursorColumn
hi clear lCursor

function! s:cursor_on()
	" https://vi.stackexchange.com/questions/666/how-to-add-indentation-guides-lines
	" set cursorline
	" set cursorcolumn

	" Make indent line thick
	" highlight clear
	" syntax reset
	" silent! execute 'colorscheme ' . g:scheme_name

	hi clear CursorLine
	hi clear CursorColumn
	hi clear lCursor

	" Wrong highlight it or clear it both make indent line thick
	" hi clear Whitespace
	" Wrong highlight it might break CursorColumn line
	hi clear WhiteSpaceChar

	" highlight ExtraWhitespace ctermbg=red guibg=red
	" match ExtraWhitespace /\s\+$/
	" hi clear ExtraWhitespace
	" highlight ShowTrailingWhitespace ctermbg=Yellow guibg=Yellow

	" silent! execute ':hi CursorColumn' . g:hl_normal
	silent! execute ':hi CursorColumn' . g:hl_normal_column
	" hi CursorColumn ctermbg=red  guibg=red
	" silent! execute ':hi CursorColumn' . g:hl_normal_inverse
	" silent! execute ':hi CursorColumn' . g:hl_normal_line

	silent! execute ':hi CursorLine'   . g:hl_normal_line
	" silent! execute ':hi CursorLine'   . g:hl_normal_column
	" silent! execute ':hi CursorLine'   . g:hl_normal_inverse

	silent! execute ':hi lCursor'      . g:hl_normal_inverse

	" https://vim.fandom.com/wiki/Highlight_current_line
	" nnoremap <leader>c :set cursorline! cursorcolumn!<cr>

	" Only show the cursor line in the active buffer.
	" setlocal cursorline
	setlocal cursorline | setlocal cursorcolumn

	" Copied from key.vim
	" If the following write_generic() doesn't have if statement, it will make
	" long latency when switching to other windows from init.vim
	" if "" == &buftype && 0 != &modified
	"     silent! call boot#write_generic()
	" endif
	" syntax on
	:call s:refresh()
endfunction

function! s:cursor_off()
	hi clear CursorLine
	hi clear CursorColumn
	hi clear lCursor
	" set nocursorline
	" set nocursorcolumn
	setlocal nocursorline | setlocal nocursorcolumn
	" syntax on
	:call s:refresh()
endfunction

if exists('g:_highlight_cursor_line_column')
	call s:cursor_on()
	" Heavy operations
	augroup cursor_line
		au!
		" au VimEnter,WinEnter,BufWinEnter * setlocal cursorline | setlocal cursorcolumn
		au WinEnter * setlocal cursorline | setlocal cursorcolumn
		au WinLeave * setlocal nocursorline | setlocal nocursorcolumn
	augroup END

else
	call s:cursor_off()
endif

" This operation will erase Visual settings, including selection highlight
hi clear Visual
" silent! execute ':hi Visual'. g:hl_normal_inverse

" silent! execute ':hi Visual ctermbg=Blue ctermfg=NONE guifg=NONE guibg=Blue
"     \ term=inverse cterm=inverse gui=inverse'

silent! execute ':hi Visual ctermbg=NONE ctermfg=NONE guifg=NONE guibg=#22aa77
	\ term=NONE cterm=NONE gui=NONE'
	" \ term=inverse cterm=inverse gui=inverse'

" hi Visual ctermbg=NONE ctermfg=NONE guifg=NONE guibg=#22aa77
" 	\ term=NONE cterm=NONE gui=NONE
" 	" \ term=inverse cterm=inverse gui=inverse

" silent! execute ':hi Visual ctermbg=4 ctermfg=NONE guifg=NONE guibg=Blue
"     \ term=bold cterm=bold gui=bold'

silent! execute ':hi ColorColumn ctermbg=' . g:gui_fg_normal . ' ctermfg=NONE guifg=NONE
	\ guibg=' . g:gui_fg_normal . " term=NONE cterm=NONE gui=NONE'


" hi VertSplit guibg=fg guifg=bg
" hi! VertSplit guifg=black guibg=black ctermfg=black ctermbg=black
" hi! VertSplit guifg=lightgrey guibg=lightgrey ctermfg=lightgrey ctermbg=lightgrey
highlight VertSplit ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

highlight SignColumn ctermbg=NONE guibg=NONE

" https://gitanswer.com/vim-allow-customization-of-endofbuffer-character-vim-script-400592109
" highlight EndOfBuffer ctermfg=0 ctermbg=NONE guifg=bg guibg=NONE
highlight EndOfBuffer ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=NONE


if exists("g:_use_terminal_transparent")

	" :help highlight-groups

	" :highlight Normal ctermfg=grey ctermbg=darkgrey guifg=#ffffff guibg=#000000
	" \ gui=NONE ctermfg=NONE ctermbg=black cterm=NONE term=NONE

	" :highlight Normal guifg=fg guibg=bg ctermfg=NONE ctermbg=2 gui=NONE
	" \ cterm=NONE term=NONE

	" highlight Normal guifg=fg guibg=NONE ctermfg=grey ctermbg=NONE gui=NONE
	"     \ cterm=NONE term=NONE
	highlight Identifier ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
	highlight Search ctermbg=NONE guibg=NONE guifg=NONE ctermfg=6 cterm=inverse term=inverse gui=inverse
	highlight IncSearch ctermbg=NONE guibg=NONE guifg=NONE ctermfg=6 cterm=inverse term=inverse gui=inverse
	highlight Keyword ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
	highlight Function ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
	highlight Normal ctermbg=0 guibg=NONE


let base16colorspace=256

let g:cterm_fg_insert  = 'NONE'
let g:cterm_bg_insert  = '4'
let g:nontext_fg_cterm = 'NONE'
let g:nontext_fg_gui   = 'NONE'

" That command should set the color of non text characters to be the same as the background color.
" hi NonText guifg=bg
" highlight NonText ctermfg=7 guifg=gray

silent! execute 'highlight NonText ctermfg=' . g:nontext_fg_cterm .
	\ ' ctermbg=NONE guifg=' . g:nontext_fg_gui  . ' guifg=NONE ' . 'guibg=NONE ' . 'term=NONE gui=NONE cterm=NONE'

hi SignColumn ctermbg=NONE guibg=NONE
hi Identifier ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi Search     ctermbg=NONE guibg=NONE guifg=NONE ctermfg=6 cterm=inverse term=inverse gui=inverse
hi IncSearch  ctermbg=NONE guibg=NONE guifg=NONE ctermfg=6 cterm=inverse term=inverse gui=inverse
hi Keyword    ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi Function   ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi Normal     ctermbg=0 guibg=NONE

highlight NvimTreeFolderIcon guibg=blue
hi SpellBad   cterm=underline ctermfg=9
hi SpellLocal cterm=underline ctermfg=9
hi SpellRare  cterm=underline ctermfg=9
hi SpellCap   cterm=underline

" PmenuSel           cterm=NONE ctermfg=9
" PmenuSel           cterm=NONE ctermfg=9 guifg=#282c34 guibg=#61afef
hi PmenuSel          cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#61afef guibg=NONE
" @symbol            cterm=italic gui=italic guifg=#56b6c2

" hi @symbol           cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE

" @variable.builtin  cterm=italic gui=italic guifg=#56b6c2

" hi @variable.builtin cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE

" @text.emphasis     cterm=italic gui=italic guifg=#61afef

" hi @text.emphasis    cterm=NONE gui=NONE guifg=#61afef guibg=NONE

" @constant          cterm=NONE ctermfg=9
" @constant          ctermfg=9 gui=NONE guifg=#56b6c2

" hi @constant         cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#56b6c2 guibg=NONE

highlight FileStyleIgnorePattern guibg=NONE ctermbg=0
hi NewLineWin ctermfg=248 guifg=#999999
match NewLineWin /\r\n/
highlight ExtraWhitespace ctermfg=NONE guifg=NONE ctermbg=red guibg=red cterm=NONE gui=NONE term=NONE
match ExtraWhitespace /\s\+$/
" hi clear Whitespace
hi ShowTrailingWhitespace ctermbg=Yellow guibg=Yellow
" hi SpecialKey ctermfg=NONE guifg=NONE
" hi SpecialKey ctermfg=NONE guifg=NONE
" hi SpecialKey ctermfg=grey guifg=grey70
" verbose hi SpecialKey
" NONE doesn't mean dark!
" hi SpecialKey ctermfg=DarkGray guifg=NONE guibg=NONE ctermbg=NONE term=NONE cterm=NONE gui=NONE
hi! link SpecialKey Comment
hi VertSplit    ctermfg=DarkGray ctermbg=NONE guibg=NONE guifg=NONE
hi! link VertSplit Comment

" hi SignColumn ctermbg=NONE guibg=NONE
hi! link SignColumn Comment
hi WinSeparator guifg=#222222 guibg=NONE cterm=NONE ctermbg=NONE ctermfg=DarkRed gui=NONE term=NONE

" hi LineNr guibg=fg
" highlight LineNr ctermbg=0 guibg=NONE ctermfg=7 guifg=gray
" silent! execute 'highlight LineNr ctermfg=' . '3' . ' ctermbg=NONE guifg=' .
"   \ 'Gray' . ' guibg=NONE' . ' cterm=NONE gui=NONE term=NONE'
" highlight CursorLineNr ctermbg=NONE ctermfg=15 guibg=NONE guifg=Gray
"   \ cterm=NONE gui=NONE term=NONE
hi! link LineNr Comment

highlight CursorLineNr ctermbg=NONE ctermfg=DarkGray guibg=NONE guifg=#ffffff
	\ cterm=NONE gui=NONE term=NONE


hi EndOfBuffer       ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=NONE
" NvimInternalError  ctermfg=237 ctermbg=13 guifg=Red guibg=Red
hi NvimInternalError ctermfg=237 ctermbg=13 guifg=#ffffff guibg=Brown
" @comment           cterm=italic gui=italic guifg=#5c6370

" hi @comment          cterm=NONE gui=NONE guifg=DarkGray

" ErrorMsg           cterm=reverse ctermfg=167 ctermbg=234 gui=reverse guifg=#d75f5f guibg=#1c1c1c
hi ErrorMsg          cterm=NONE ctermfg=167 ctermbg=234 gui=NONE guifg=#d75f5f guibg=#1c1c1c

hi Search                   ctermfg=237 ctermbg=13
hi MatchParen               cterm=underline
hi SyntasticWarning         ctermbg=yellow ctermfg=black
hi ALEWarning               ctermbg=yellow ctermfg=black
hi SyntasticError           ctermbg=red ctermfg=black
hi ALEError                 ctermbg=red ctermfg=black
hi CocUnderline             term=undercurl
hi DiagnosticError          ctermfg=red guifg=red term=undercurl cterm=undercurl
hi DiagnosticUnderlineError guisp=red
hi DiagnosticWarn           ctermfg=yellow guifg=yellow term=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn  guisp=yellow
hi CocInlayHint             guibg=NONE guifg=#6F7378 ctermbg=NONE ctermfg=DarkGray

hi CtrlSpaceSelected        term=reverse ctermfg=187  ctermbg=23  cterm=bold
hi CtrlSpaceNormal          term=NONE    ctermfg=244  ctermbg=232 cterm=NONE
hi CtrlSpaceSearch          ctermfg=220  ctermbg=NONE cterm=bold
hi CtrlSpaceStatus          ctermfg=230  ctermbg=234  cterm=NONE

	" Must be placed before the setting of your colorscheme? No
	if exists('g:_use_dynamic_color')
		augroup cursor_theme_common
			au!
			" https://stackoverflow.com/questions/37712730/set-vim-background-transparent
			" Workaround for creating transparent bg
			autocmd SourcePost *
				\ highlight Normal ctermbg=0 guibg=NONE
				\ | highlight SignColumn ctermbg=NONE guibg=NONE
				\ | highlight FoldColumn ctermbg=NONE guibg=NONE
				\ | hi! link LineNr Comment
				" \ | silent! execute 'highlight LineNr ctermfg=' . '3' .
				" \ ' ctermbg=NONE guifg=' . 'Gray' . ' guibg=NONE'

		augroup end

		augroup nosplit
			au!
			" autocmd ColorScheme,SourcePost * highlight VertSplit ctermbg=NONE
			autocmd ColorScheme,SourcePost * highlight WinSeparator ctermbg=NONE
				\ ctermfg=NONE guibg=NONE guifg=#222222 cterm=NONE term=NONE gui=NONE
				\ | highlight foldcolumn ctermbg=NONE guibg=NONE
		augroup END

		augroup nontext_eara
			au!
			autocmd ColorScheme,SourcePost *
				\ silent! execute 'highlight NonText ctermfg=' .
				\ g:nontext_fg_cterm . ' ctermbg=NONE guifg=' . g:nontext_fg_gui .
				\ ' guibg=NONE ' . 'guifg=NONE ' . 'term=NONE gui=NONE cterm=NONE'
		augroup end

		augroup CLNRSet
			au!
			autocmd ColorScheme * hi CursorLineNr ctermbg=NONE ctermfg=DarkGray
				\ guibg=NONE guifg=#ffffff cterm=NONE gui=NONE term=NONE
		augroup END

		if exists('g:_highlight_cursor_line_column')
			" Reference
			" augroup CLClear
			"     au!
			"     autocmd ColorScheme * highlight clear CursorLine
			"         \ silent! execute ':hi CursorLine' . g:hl_normal_inverse
			" augroup END

			" Can not highlight selection
			augroup cursor_theme
				au!

				" Change Color when entering Insert Mode
				" autocmd InsertEnter,VimEnter,WinEnter,BufEnter,BufWritePost,ColorScheme *
				autocmd InsertEnter * call s:cursor_off()
				autocmd ModeChanged * if mode() =~? '\v(v|V)'
					\ | call s:cursor_off() | endif

				" autocmd InsertEnter * if mode() =~? 'n'
				"     \ | highlight clear CursorColumn
				"     \ | silent! execute ':hi CursorColumn' . g:hl_insert_inverse
				"     \ | highlight clear Visual
				"     \ i silent! execute ':hi Visual'. g:hl_insert_inverse
				"     \ | highlight clear lCursor
				"     \ | silent! execute ':hi lCursor' . g:hl_insert_inverse
				"     \ | highlight clear CursorLine
				"     \ | silent! execute ':hi CursorLine' . g:hl_insert_inverse
				"     \ | endif

				" autocmd InsertLeave *
				" autocmd InsertLeave,VimEnter,WinEnter,BufEnter,SourcePost,ColorScheme *
				autocmd InsertLeave,WinEnter,SourcePost,ColorScheme,ModeChanged
					\ * if mode() =~? 'n' | call s:cursor_on() | endif

					" \ | set cursorline
					" \ | set cursorcolumn
					" \ | highlight clear CursorColumn
					" \ | silent! execute ':hi CursorColumn' . g:hl_normal_inverse
					" \ | highlight clear lCursor
					" \ | silent! execute ':hi lCursor' . g:hl_normal_inverse
					" \ | highlight clear CursorLine
					" \ | silent! execute ':hi CursorLine' . g:hl_normal_inverse
					" \ | endif
				" This operation will erase Visual settings, including selection highlight
					" \ | highlight clear Visual
					" \ i silent! execute ':hi Visual'. g:hl_normal_inverse

			augroup END
		else
			augroup cursor_theme
				au!
			augroup END

		endif

		augroup buffer_ending
			au!
			autocmd ColorScheme,SourcePost * highlight EndOfBuffer ctermfg=NONE
				\ ctermbg=NONE guifg=NONE guibg=NONE
		augroup end
	else
		augroup cursor_theme_common
			au!
		augroup end

		augroup nosplit
			au!
		augroup END

		augroup nontext_eara
			au!
		augroup END

		augroup CLNRSet
			au!
		augroup END

		augroup buffer_ending
			au!
		augroup end

	endif

endif


" https://stackoverflow.com/questions/2531904/how-do-i-increase-the-spacing-of-the-line-number-margin-in-vim
" numberwidth
set nuw        =7
set foldcolumn =0
set foldlevel  =1
set foldmethod =expr

augroup allways_show_line_number | au!
	au BufWinEnter * set number relativenumber | set foldcolumn=0
	" au BufWinEnter * set number | set foldcolumn=0
augroup END

" hi foldcolumn guibg=fg
highlight foldcolumn ctermbg=NONE guibg=NONE
set nofoldenable    " disable folding

" :set listchars=tab:>-,space:.
" helper for indent mistake
" set list listchars=tab:»·,trail:·
" set listchars=extends:>,precedes:<,nbsp:%,tab:>~,eol:↴
" set listchars=extends:>,precedes:<,nbsp:%,tab:>~
silent! execute 'set listchars=extends:>,precedes:<,nbsp:%,tab:\│\ '
" set list listchars=tab:\|\
" silent! execute 'set listchars+=tab:\▏\ '
" https://stackoverflow.com/questions/18676450/how-can-i-use-set-list-to-highlight-otherwise-invisible-characters-except-when
" Hiding tab chars
" silent! execute 'set listchars+=tab:\ \ '
" Vertical split style settings
" Can the split separator in vim be less than a full column wide?
" https://vi.stackexchange.com/questions/2938/can-the-split-separator-in-vim-be-less-than-a-full-column-wide/2941#2941
" https://vi.stackexchange.com/questions/22053/how-to-completely-hide-the-seperator-between-windows
" set fillchars=vert:\|
" set fillchars=vert:\│
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
" Set a space followed '\ ' to the fillchars->vert option
" From this following expressions, you do not neeed tralling spaces exposed to vim

" No horizontal separartor in vim?
" silent! execute 'set fillchars +=vert:\│'
" silent! execute 'set fillchars +=vert:│'

" let &fillchars = 'vert:\ '
" silent! execute 'set fillchars =vert:\▏,horiz:\_'
" silent! execute 'set fillchars +=vert:\│,horiz:\_'

" silent! execute 'set fillchars +=vert:\│,horiz:\_'
" let &fillchars ..=',vert:│,horiz:_'
" ,horiz:\_ is illegal
" :set fillchars=stl:^,stlnc:=,vert:\│,fold:-,diff:-
" :set fillchars=stl:^,stlnc:\_,vert:\│,fold:-,diff:-
:set fillchars -=stl:^
:set fillchars =stl:\_,vert:\│,fold:-,diff:-
silent! execute ':set fillchars +=,stl:\ '
let &fillchars ..=',eob: '

" set titlestring=%{expand(\"%:t\")}%{expand(\"%:p:~:.:h\")}
:set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
" https://vi.stackexchange.com/questions/28994/can-i-change-the-ugly-indicator-after-eol
" EndOfBuffer, ugly indicator after EOL tildes (~)
" making lines touch each other.
set linespace =0
let g:netrw_browse_split  = 2

" highlight clear
" syntax reset
" call s:set_color_scheme()
hi! link StatusLine Comment
hi! link StatusLineNC Comment






if exists('g:_use_gitgutter')
	" vim-gitgutter
	set signcolumn=yes
	if has('nvim')
		let g:gitgutter_git_executable = boot#chomp(system(['which', 'git']))
	else
		let g:gitgutter_git_executable = boot#chomp(system('which git'))
	endif
	let g:gitgutter_sign_allow_clobber   = 1
	let g:gitgutter_sign_allow_clobber   = 1
	let g:gitgutter_set_sign_backgrounds = 1

	highlight link GitGutterChangeLine DiffText
	highlight link GitGutterAddIntraLine DiffAdd
endif

" "color settings ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"



" "font settings &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

if has("gui_running")
	if has("gui_gtk2")
		set guifont=Courier\ New\ 13
		set guifontwide=DejaVu\ Sans\ Mono\ 13
	elseif has("gui_macvim")
		set guifont=Courier\ New:h13
		set guifontwide=Courier\ New:h13
	elseif has("gui_win32")
		" set guifont=Fixedsys:h18:cANSI:qDRAFT

		" set guifont=Noto_Sans_Mono_ExtraLight:h9:cANSI
		" set guifont=DejaVu_Serif:h9:cANSI
		" set guifont=Noto_Sans_Mono:h9:cANSI
		set guifont=Courier\ New:h13:cANSo

		" set gfw=Noto_Sans_Mono_ExtraLight:h10:cGB2312
		" set gfw=DejaVu_Serif:h10:cGB2312
		" set gfw=Noto_Sans_Mono:h10:cGB2312
		set guifontwide=Courier\ New:h13:cGB2312
	endif
endif


" "font settings &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"



" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

" " https://github.com/wikitopian/hardmode
" let g:HardMode_level = 'wannabe'
" let g:HardMode_hardmodeMsg = 'Don''t use this!'
" autocmd VimEnter,BufNewFile,BufReadPost * ++nested silent! call HardMode()
" https://vi.stackexchange.com/questions/5851/how-to-disable-arrow-keys-in-vim
" for key in ['<Up>', '<Down>', '<Left>', '<Right>']
"   exec 'noremap' key '<Nop>'
"   exec 'inoremap' key '<Nop>'
"   exec 'cnoremap' key '<Nop>'
" endfor

" https://vi.stackexchange.com/questions/5851/how-to-disable-arrow-keys-in-vim
" " Remove newbie crutches in Command Mode
" cnoremap <Down> <Nop>
" cnoremap <Left> <Nop>
" cnoremap <Right> <Nop>
" cnoremap <Up> <Nop>

" " Move around in insert
" cnoremap <C-k> <C-o>gk
" cnoremap <C-h> <Left>
" cnoremap <C-l> <Right>
" cnoremap <C-j> <C-o>gj

" " Remove newbie crutches in Insert Mode
" inoremap <Down> <Nop>
" inoremap <Left> <Nop>
" inoremap <Right> <Nop>
" inoremap <Up> <Nop>

" " Move around in insert
" inoremap <C-k> <C-o>gk
" inoremap <C-h> <Left>
" inoremap <C-l> <Right>
" inoremap <C-j> <C-o>gj

if exists('g:_disable_direction_key')
	" Remove newbie crutches in Normal Mode
	nnoremap <Down> <Nop>
	nnoremap <Left> <Nop>
	nnoremap <Right> <Nop>
	nnoremap <Up> <Nop>

	" Remove newbie crutches in Visual Mode
	vnoremap <Down> <Nop>
	vnoremap <Left> <Nop>
	vnoremap <Right> <Nop>
	vnoremap <Up> <Nop>

	nnoremap <silent> <Left>  :exe "vertical resize " . (winwidth(0) + 10)<cr>
	nnoremap <silent> <Right> :exe "vertical resize " . (winwidth(0) - 10)<cr>
	nnoremap <silent> <Up>    :exe "resize " . (winheight(0) + 5)<cr>
	nnoremap <silent> <Down>  :exe "resize " . (winheight(0) - 5)<cr>

	" One-hand page up and down
	" nnoremap <c-d> d

	" Will slow down 'undo'
	" nnoremap uu <c-u>
	nnoremap u <c-u>
	nnoremap <c-u> u

	" nnoremap d <c-d>
	" Easy to wrong touch . key
	nnoremap , <c-d>
	" nnoremap mm <c-d>
	" Mapping m key will cause the cursor to jump when switching windows
	" And xx keys will not work
	nnoremap m <c-d>

endif

" " Seamlessly treat visual lines as actual lines when moving around.
" noremap j gj
" noremap k gk

" noremap <Down> gj
" noremap <Up> gk
" inoremap <Down> <C-o>gj
" inoremap <Up> <C-o>gk


" " Navigate around splits with a single key combo.
" nnoremap <C-k> <C-w><C-k><cr>
" nnoremap <C-j> <C-w><C-j><cr>
" nnoremap <C-h> <C-w><C-h><cr>
" nnoremap <C-l> <C-w><C-l><cr>


" " https://stackoverflow.com/questions/6053301/easier-way-to-navigate-between-vim-split-panes
" " Use ctrl-[hjkl] to select the active split!
" noremap <silent> <C-K> :wincmd k<cr>
" noremap <silent> <C-J> :wincmd j<cr>
" noremap <silent> <C-H> :wincmd h<cr>
" noremap <silent> <C-L> :wincmd l<cr>


" Cycle through splits.
nnoremap <S-Tab> <C-w>w

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <leader>r  :%s///g<Left><Left><Left>
nnoremap <leader>rc :%s///gc<Left><Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <leader>r :s///g<Left><Left><Left>
xnoremap <leader>rc :s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<cr>cgn
xnoremap <silent> s* "sy:let @/=@s<cr>cgn

" Clear search highlights.
" map <leader><space> :let @/=''<cr>
map <leader>c :let @/=''<cr>

" " Format paragraph (selected or not) to 80 character lines.
" nnoremap <leader>g gqap
" xnoremap <leader>g gqa

command! -nargs=0 Q :noautocmd qa!
:cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Q' : 'q'

" Edit Vim config file in a new tab.
map <leader>ev :tabnew $MYVIMRC<cr>

" Source Vim config file.
map <leader>sv :source $MYVIMRC<cr>

" Toggle spell check.
map <F5> :setlocal spell!<cr>

" Toggle relative line numbers and regular line numbers.
nmap <F6> :set invrelativenumber<cr>

" Automatically fix the last misspelled word and jump back to where you were.
" Taken from this talk: https://www.youtube.com/watch?v=lwD8G1P52Sk
nnoremap <leader>sp :normal! mz[s1z=`z<cr>

set list
" Toggle visually showing all whitespace characters.
" noremap  <F7> :set list!<cr>
noremap  <F7> :set list<cr>
" noremap  <F7> :call <SID>refresh()<cr>
" inoremap <F7> <C-o>:call <SID>refresh()<cr>
inoremap <F7> <C-o>:set list<cr>
" cnoremap <F7> <C-c>:call <SID>refresh()<cr>
cnoremap <F7> <C-c>:set list<cr>

" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
cnoremap s!! let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" https://vim.fandom.com/wiki/Source_current_file_when_editing_a_script
noremap <silent><buffer> <F9> :exec 'source '. bufname('%')<CR>


" Toggle quickfix window.
function! s:quickfix_toggle()
	for i in range(1, winnr('$'))
		let bnum = winbufnr(i)
		if getbufvar(bnum, '&buftype') == 'quickfix'
			cclose
			return
		endif
	endfor

	copen

endfunction

" nnoremap <silent> <leader>c :call <sid>quickfix_toggle()<cr>
" nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
nnoremap <F10> :call <sid>quickfix_toggle()<cr>

" " https://github.com/nickjj/dotfiles/blob/master/.vimrc
" " Convert the selected text's title case using the external tcc script.
" " Requires: https://github.com/nickjj/title-case-converter
" vnoremap <leader>tc c<C-r>=system('tcc', getreg('"'))[:-2]<cr>
"
" " Navigate the complete menu items like CTRL+n / CTRL+p would.
" inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
" inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
"
" " Select the complete menu item like CTRL+y would.
" inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
" inoremap <expr> <cr> pumvisible() ? "<C-y>" :"<cr>"
"
" " Cancel the complete menu item like CTRL+e would.
" inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

if exists("g:_use_mkdx")

	if maparg('```', 'i', 'false') !~? '```<CR>```<C-o>k<C-o>A'
		" if maparg('```', 'i', 'false') !~? '```<Enter>```kA'
		" https://github.com/SidOfc/mkdx
		" :h mkdx-mapping-insert-fenced-code-block
		inoremap <buffer><silent><unique> ``` ```<Enter>```kA
	endif

	if maparg('~~~', 'i', 'false') !~? '\~\~\~<CR>\~\~\~<C-o>k<C-o>A'
		inoremap <buffer><silent><unique> ~~~ ~~~<Enter>~~~kA
	endif

	" :h mkdx-setting-tokens-fence
	let g:mkdx#settings = { 'tokens': { 'fence': '' } }
	let g:mkdx#settings = { 'highlight': { 'enable': 1 },
		\ 'enter': { 'shift': 1 },
		\ 'links': { 'external': { 'enable': 1 } },
		\ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
		\ 'fold': { 'enable': 1 } }

endif

" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

" breakadd here


" "basic autocommands ##########################################################################################"

function! s:set_numberwidth(default)
	if has('nvim')
		let l:lines =
			\ boot#chomp(system(['wc', '-l', resolve(expand('%')), '|',
			\ 'cut', '-f', '1', '-d', ' ']))
	else
		let l:lines =
			\ boot#chomp(system('wc -l ' . resolve(expand('%')) .
			\ ' | cut -f 1 -d " "'))
	endif

	let l:needs_width = strdisplaywidth(l:lines)
	let l:real_width = l:needs_width >= (a:default - 1) ?
		\ l:needs_width + 1 : a:default

	silent! execute 'setlocal numberwidth =' . l:real_width
endfunction

augroup guard
	au!
	" https://stackoverflow.com/questions/70283937/resize-splits-in-vim-automatically-across-tabs
	" Auto-resize splits when Vim gets resized.
	" Will resize tagbar?
	autocmd VimResized * wincmd =

	" Unset paste on InsertLeave.
	autocmd InsertLeave * silent! set nopaste
	" This following line will disable expandtab
	" autocmd InsertEnter * silent! set paste

	" Make sure all types of requirements.txt files get syntax highlighting.
	autocmd BufNewFile,BufRead requirements*.txt set syntax=python

	" Ensure tabs don't get converted to spaces in Makefiles.
	autocmd FileType make setlocal noexpandtab
	autocmd FileType python setlocal noexpandtab

	" au BufEnter,WinEnter,BufWinEnter * setlocal noexpandtab
	au BufReadPost * setlocal noexpandtab
	au BufReadPost * call s:set_numberwidth(5)
	" verbose setlocal ts? sts? et? sw?
augroup END

augroup stop_auto_indenting
	au!
	" https://vim.fandom.com/wiki/How_to_stop_auto_indenting
	autocmd FileType * if 1 == &modifiable
		\ | setlocal formatoptions-=c formatoptions-=r formatoptions-=o
		\ | endif
augroup END


" For vim-repeat
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

if has('nvim')
	" set shell=ash\ --login
	" silent! execute 'set shell=' . boot#chomp(system(['which', $SHELL])) . '\ --login'
	silent! execute 'set shell=' . $SHELL . '\ --login'
	tnoremap <esc> <C-\><C-N>
	augroup term_open
		au!
		autocmd TermOpen * setlocal nonumber norelativenumber
	augroup END

	" https://vi.stackexchange.com/questions/10292/how-to-close-and-and-delete-terminal-buffer-if-programs-exited
	" Get the exit status from a terminal buffer by looking for a line near the end
	" of the buffer with the format, '[Process exited ?]'.
	func! s:get_exit_status() abort
		let ln = line('$')
		" The terminal buffer includes several empty lines after the 'Process exited'
		" line that need to be skipped over.
		while ln >= 1
			let l = getline(ln)
			let ln -= 1
			let exit_code = substitute(l, '^\[Process exited \([0-9]\+\)\]$', '\1', '')
			if l != '' && l == exit_code
				" The pattern did not match, and the line was not empty. It looks like
				" there is no process exit message in this buffer.
				break
			elseif exit_code != ''
				return str2nr(exit_code)
			endif
		endwhile
		throw 'Could not determine exit status for buffer, ' . expand('%')
	endfunc

	func! s:after_term_close() abort
		let result = 1
		try
			let result = s:get_exit_status()
		catch /^Vim:Interrupt$/
			let result = 0
		catch /.*/
			let result = 0
		finally
			echomsg "cleanup"
			let result = 0
		endtry
		if result == 0
			bdelete!
		endif
	endfunc

	augroup neoterm_close
		autocmd!
		" The line '[Process exited ?]' is appended to the terminal buffer after the
		" `TermClose` event. So we use a timer to wait a few milliseconds to read the
		" exit status. Setting the timer to 0 or 1 ms is not sufficient; 20 ms seems
		" to work for me.
		autocmd TermClose * call timer_start(20, { -> s:after_term_close() })
	augroup END

endif

" "basic autocommands ##########################################################################################"

" "enter insert new line in normal mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


if 1 == g:navi_protect

	function! s:print_key(key)
		echom a:key
		call s:log_silent(a:key, " pressed", g:_environment)
	endfunction

	" Put a new line before or after to this line
	" nnoremap <S-CR> M`o<Esc>``
	" nnoremap <C-CR> M`O<Esc>``
	"
	" " reverse J command
	" nnoremap <C-J> vaW<Esc>Bi<cr><Esc>k:s/\s\+$//<cr>$
	" https://stackoverflow.com/questions/16134457/insert-a-newline-without-entering-in-insert-mode-vim
	" map <cr> o<Esc>
	" :nmap <NL> O<Esc>
	" :map <C-]> o<Esc>

	augroup return_shift
		au!
		" https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
		:autocmd! CmdwinEnter * nnoremap <CR> <CR>
		:autocmd! BufReadPost quickfix nnoremap <CR> <CR>
	augroup END

	" https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
	" m' or m`: Set the previous context mark. This mark could be retrieved with the "''" or "``" command
	" (does not move the cursor, this is not a motion command).
	" This map will break vim user mappings and restore to the default mappings of ^H/^J/^K/^L

	if has('nvim')
		nnoremap <S-CR> M`O<Esc>``
		nnoremap <leader>[ M`O<Esc>``
		nnoremap <C-CR> M`o<Esc>``
		nnoremap <leader>] M`o<Esc>``
	else
		" Could be enabled by 'tpope/vim-unimpaired'
		" Use [-space for shift-enter
		" And ]-space for ctrl-enter
		nnoremap <leader>[ M`O<Esc>``
		nnoremap <leader>] M`o<Esc>``
		" nnoremap [<Space> M`O<Esc>``
		" nnoremap ]<Space> M`o<Esc>``
	endif

	" nnoremap <S-CR> <NOP>
	" nnoremap <C-CR> <NOP>

	" nnoremap '\<cr\>2u' <NOP>
	" nnoremap '\<cr\>5u' <NOP>

	" Will break current line
	" nnoremap <C-J> ciW<CR><Esc>:if match( @", "^\\s*$") < 0<Bar>exec "norm P-$diw+"<Bar>endif<CR>

	" nnoremap <silent> <S-CR> :<c-u>put!=repeat([''],v:count)<bar>']+1<cr>
	" nnoremap <silent> <C-CR> :<c-u>put =repeat([''],v:count)<bar>'[-1<cr>

	" nnoremap <buffer> <S-CR> :call <SID>print_key("<S-CR\>")<CR>
	" nnoremap <buffer> <C-CR> :call <SID>print_key("<C-CR\>")<CR>
	" nnoremap <buffer> <M-CR> :call <SID>print_key("<M-CR\>")<CR>
	" nnoremap <buffer> <A-CR> :call <SID>print_key("<A-CR\>")<CR>
	" nnoremap <buffer> <CR>   :call <SID>print_key("<CR\>")<CR>

	" https://github.com/softmoth/zsh-vim-mode
	" Add to .vimrc
	" Use Control-D instead of Escape to switch to NORMAL mode
	" inoremap <C-d> <Esc>

	" nnoremap <CR> o<Esc>

	" nnoremap <S-CR> i<CR><Esc> " Needed for GVIm

	" Needed for CLI VIm (Note: ^[0M was created with Ctrl+V Shift+Enter, don't type it directly)
	" nnoremap ^[0M i<CR><Esc>

	" inoremap <CR>   ThisIsEnter
	" inoremap <C-CR> ThisIsCenter
	" inoremap <S-CR> ThisIsSenter

" Paired with tmux.conf bind-key -n \{
inoremap [<Space> {
" Paired with tmux.conf bind-key -n \}
inoremap ]<Space> }

" inoremap "<leader>[" {
" inoremap "<leader>]" }























endif | " g:navi_protect

" "enter insert new line in normal mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

" "don't flush clipboard register ______________________________________________________________________________"
" "don't flush clipboard register ______________________________________________________________________________"
" On neovim, current toolchain is : wayclip [uninstalled wl-clipboard system-wide], neoclip.lua, tmux clipboard
" run :checkhealth provider to look into it
if exists("g:_use_wl_clipboard")
	" https://github.com/noocsharp/wayclip
	" waycopy/waypaste can not across different users
	" https://www.reddit.com/r/vim/comments/hge0qw/for_those_who_are_still_struggling_with_waylands/
	if ! empty($WAYLAND_DISPLAY)
		if has('nvim')
			function! s:paste_list_plus()
				let l:result_list = []
				let l:list_src = systemlist(['wl-paste', '--no-newline'])
				for item in l:list_src
					" https://stackoverflow.com/questions/42326732/get-rid-of-in-vim-output-from-system
					" let l:tr_item = strtrans(substitute(item, "\n\\+$", "", ""))
					" let l:tr_item = system(['tr', '-d', '"\r"', '<', '<(', 'echo', '"'. item . '"', ')'])
					let l:tr_item = boot#chomp(item)
					call add(l:result_list, l:tr_item)
				endfor
				return l:result_list
			endfunction
			function! s:paste_list_asterisk()
				let l:result_list = []
				let l:list_src = systemlist(['wl-paste', '--no-newline', '--primary'])
				for item in l:list_src
					" let l:tr_item = system(['tr', '-d', '"\r"', '<', '<(', 'echo', '"' . item . '"', ')'])
					let l:tr_item = boot#chomp(item)
					call add(l:result_list, l:tr_item)
				endfor
				return l:result_list
			endfunction
			" let g:clipboard =
			"     \ { 'name': 'wayland-strip-carriage',
			"     \   'copy':
			"     \ {     '+': 'wl-copy --foreground --type text/plain',
			"     \       '*': 'wl-copy --foreground --type text/plain --primary',
			"     \ },
			"     \   'paste':
			"     \ {     '+': {-> system('tr -d "\r"', systemlist(['wl-paste', '--no-newline']))},
			"     \       '*': {-> system('tr -d "\r"', systemlist(['wl-paste', '--no-newline', '--primary']))},
			"     \ },
			"     \   'cache_enabled': 1,
			"     \ }
			let g:clipboard =
				\ { 'name': 'wayland-strip-carriage',
				\   'copy':
				\ {     '+': 'wl-copy --foreground --type text/plain',
				\       '*': 'wl-copy --foreground --type text/plain --primary',
				\ },
				\   'paste':
				\ {     '+': {-> s:paste_list_plus()},
				\       '*': {-> s:paste_list_asterisk()},
				\ },
				\   'cache_enabled': 1,
				\ }
		else
			let g:clipboard =
				\ { 'name': 'wayland-strip-carriage',
				\   'copy':
				\ {     '+': 'wl-copy --foreground --type text/plain',
				\       '*': 'wl-copy --foreground --type text/plain --primary',
				\ },
				\   'paste':
				\ {     '+': {-> systemlist('wl-paste --no-newline \| tr -d "\r"')},
				\       '*': {-> systemlist('wl-paste --no-newline --primary \| tr -d "\r"')},
				\ },
				\   'cache_enabled': 1,
				\ }
		endif
	endif
endif

" https://stackoverflow.com/questions/14635295/vim-takes-a-very-long-time-to-start-up
" nvim posts error on this:
" set clipboard=exclude:.*

" set clipboard+=unnamed
set clipboard+=unnamedplus

" " https://alex.dzyoba.com/blog/vim-revamp/
" " C-c and C-v - Copy/Paste to global clipboard
" vmap <C-c> "+yi
" imap <C-v> <esc>"+gpi

if exists("g:_use_wl_clipboard")
	if has('nvim')
		xnoremap "+y y:call system(['wl-copy', '@"'])<cr>
		nnoremap "+p :let @"=substitute(system(['wl-paste',
			\ '--no-newline']), '<C-v><C-m>', '', 'g')<cr>p
		nnoremap "*p :let @"=substitute(system(['wl-paste',
			\ '--no-newline', '--primary']), '<C-v><C-m>', '', 'g')<cr>p
	else
		" https://www.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/
		xnoremap "+y y:call system("wl-copy", @")<cr>
		nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"),
			\ '<C-v><C-m>', '', 'g')<cr>p
		nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"),
			\ '<C-v><C-m>', '', 'g')<cr>p
	endif
endif

" https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118
" :r!cat
" **Ctrl-V to paste from the OS clipboard**
" ^D


" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Keep cursor at the bottom of the visual selection after you yank it.
vmap y ygv<Esc>

" How do I replace-paste yanked text in vim without yanking the deleted lines?
" https://superuser.com/questions/321547/how-do-i-replace-paste-yanked-text-in-vim-without-yanking-the-deleted-lines
" delete without yanking

nnoremap <leader>d "_d
vnoremap <leader>d "_d
" https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim
xnoremap <leader>d "_d


" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP
xnoremap <leader>p "_dP

" https://github.com/svermeulen/vim-cutlass
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

" "don't flush clipboard register ______________________________________________________________________________"
" "don't flush clipboard register ______________________________________________________________________________"



" "auto update content when changed elsewhere $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
" https://www.generacodice.com/en/articolo/465677/How+does+Vim%27s+autoread+work%3F

set autoread   " doesn't work
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "Buffer changed!" | echohl None
"
"
" " Triger `autoread` when files changes on disk
" " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
"     \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
"
" " Notification after file change
" " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" autocmd! VimEnter * AutoRead

augroup auto_read
	au!
	" Update a buffer's contents on focus if it changed outside of Vim.
	" https://vi.stackexchange.com/questions/14315/how-can-i-tell-if-im-in-the-command-window
	" :checktime
	au FocusGained,BufEnter *
		\ if mode() == 'n' && getcmdwintype() == '' | checktime | endif

	au FocusGained,BufEnter * :silent! !
augroup END

" augroup auto_read
"     autocmd!
"     autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
"                 \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
" augroup END


if 0 == g:navi_protect
	" https://stackoverflow.com/questions/2490227/how-does-vims-autoread-work/20418591
	function! s:check_update(timer)
		silent! checktime
		" call timer_start(1000, function('<SID>check_update'))
		call timer_start(1000, function('s:check_update'))
	endfunction

	if ! exists("g:check_update_started")
		let g:check_update_started  = 1
		call timer_start(1, function('s:check_update'))
	endif
endif


" "auto update content when changed elsewhere $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"


" "resizing windows ********************************************************************************************"

" Shrink window width to given size
noremap <Leader>w :let @w=float2nr(log10(line("$")))+82\|:vertical resize <c-r>w<cr>

" noremap <silent> <C-S-Up>    :resize +1<cr>
" noremap <silent> <C-S-Down>  :resize -1<cr>
" noremap <silent> <C-S-Left>  :vertical resize +1<cr>
" noremap <silent> <C-S-Right> :vertical resize -1<cr>

if exists('$TMUX')
	nnoremap <silent> <m-k> :TmuxResizeUp<CR>
	nnoremap <silent> <m-j> :TmuxResizeDown<CR>
	nnoremap <silent> <m-h> :TmuxResizeLeft<CR>
	nnoremap <silent> <m-l> :TmuxResizeRight<CR>
else
	noremap  <silent> <m-k> :resize +1<cr>
	noremap  <silent> <m-j> :resize -1<cr>
	noremap  <silent> <m-h> :vertical resize +1<cr>
	noremap  <silent> <m-l> :vertical resize -1<cr>
endif
" noremap  <silent> <m-k> :resize +1 <bar> :TmuxResizeUp<cr>
" noremap  <silent> <m-j> :resize -1 <bar> :TmuxResizeDown<cr>
" noremap  <silent> <m-h> :vertical resize +1 <bar> :TmuxResizeLeft<cr>
" noremap  <silent> <m-l> :vertical resize -1 <bar> :TmuxResizeRight<cr>

" https://vim.fandom.com/wiki/Resize_splits_more_quickly
" nnoremap <silent> <leader>= :exe "resize " . (winheight(0) * 3/2)<cr>
" nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<cr>

" https://www.reddit.com/r/vim/comments/oi1okw/question_how_to_stop_horizontal_windows_resizing/
set eadirection=ver
set noequalalways

" "resizing windows ********************************************************************************************"



" "editor environment ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

" breakadd here

" " https://github.com/nickjj/dotfiles/blob/0c8abec8c433f7e7394cc2de4a060f3e8e00beb9/.vimrc#L444-L499
" function! s:statusline_expr()
"   let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
"   let ro  = "%{&readonly ? '[RO] ' : ''}"
"   let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
"   let fug = "%{exists('g:loaded_fugitive') ? fugitivn#statusline() : ''}"
"   let sep = ' %= '
"   let pos = ' %-12(%l : %c%V%) '
"   let pct = ' %P'
"
"   return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
" endfunction
"
" let &statusline = s:statusline_expr()

" https://github.com/spf13/spf13-vim/issues/540
" set syntax=on
" syntax on

set nomore

" https://unix.stackexchange.com/questions/250770/press-enter-or-type-command-to-continue-why-am-i-seeing-this
" set cmdheight=2
set cmdheight=1
" " Give more space for displaying messages.

" "Press ENTER or type command to continue"
" Append the folowing line
" call feedkeys("\<CR>")
" set shortmess+=O
" set shortmess=a
" https://vim.fandom.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
set shortmess=atWAOFS
" Avoid showing message extra message when using completion
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set shortmess+=F

set noruler

if exists('$TMUX')
	set laststatus=0
else
	set laststatus=2 " Always display the statusline in all windows
endif

" set showtabline=2 " Always display the tabline, even if there is only one tab
set showtabline=0   " Always display the tabline, even if there is only one tab
set noshowmode      " Hide the default mode text (e.g. -- INSERT -- below the statusline)


" https://github.com/nickjj/dotfiles/blob/0c8abec8c433f7e7394cc2de4a060f3e8e00beb9/.vimrc#L444-L499
set complete+=kspell


if ! has('nvim')
	set cryptmethod=blowfish2
endif
set encoding=utf-8
if 1 == &modifiable
	set fileencoding=utf-8
endif
set termencoding=utf-8
" h scriptencoding
" If you set the 'encoding' option in your |.vimrc|, `:scriptencoding` must be placed after that. E.g.: >
" set encoding=utf-8
" scriptencoding utf-8
scriptencoding utf-8
set matchpairs+=<:> " Use % to jump between pairs
set mmp=5000 " maxmempattern'
set modeline
set modelines=2
" https://vim.fandom.com/wiki/Modeline_magic
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
		\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

set noerrorbells novisualbell t_vb=
set noshiftround
set nospell
set nostartofline
" set number
" set nonumber
set number relativenumber
" set number invrelativenumber
" set invrelativenumber " rnu
" set nornu  " turn off rnu


" set scrolloff=3
" https://stackoverflow.com/questions/43915661/how-to-move-screen-left-right-or-center-it-horizontally-without-moving-cursor-in?noredirect=1&lq=1
set scrolloff=20       " keep 20 lines visible above and below cursor at all times
set sidescrolloff=30   " keep 30 columns visible left and right of the cursor at all times

set scrollopt-=ver
" https://vi.stackexchange.com/questions/6730/how-to-get-rid-of-the-command-line-bar
set noshowcmd
set showmatch
set spelllang=en_us
set splitbelow
set splitright
set ttimeout
set ttimeoutlen=1
set ttyfast
" weird behavior: automatically moving cursor one character left/backward when shfit+a in neovim
" set virtualedit=block
set virtualedit=onemore
set whichwrap=b,s,<,>
set whichwrap+=<,>,h,l,[,]
set wildmenu
set wildmode=full


set nopaste
" set paste
set title


" " Vim: How to switch back from tabview to vertical split
" " https://stackoverflow.com/questions/58357914/vim-how-to-switch-back-from-tabview-to-vertical-split
" nnoremap <silent><C-W>U :hide -tabonly <bar> unhide<cr>

" https://dmitryfrank.com/articles/indent_with_tabs_align_with_spaces
" copy indent from previous line: useful when using tabs for indentation and spaces for alignment
" set copyindent

" https://stackoverflow.com/questions/7281459/matchit-not-working
packadd! matchit
" runtime! macros/matchit.vim


if has("autocmd")
	" nvim sets it by default, but
	" vim.api.nvim_command('filetype plugin indent on')
	" It's also possible to use vim.cmd(), which is actually an alias for vim.api.nvim_exec(),
	" but that's similar enough to vim.api.nvim_command() and also works well in this case.
	" vim.cmd('filetype plugin indent on')

	filetype plugin indent on " indents corresponding to specific file format
	augroup vimrcEx
		au!
		" autocmd FileType text setlocal textwidth=78
		" autocmd FileType text setlocal textwidth=120 | set colorcolumn=""
		" autocmd FileType text setlocal textwidth=120 | let &colorcolumn = &textwidth + 1
		" jumps to the last known position in a file
		autocmd BufReadPost * ++nested
			\ if line("'\"") > 1 && line("'\"") <= line("$") |
			\ silent! exe "normal! g`\"" |
			\ endif
	augroup END
else
	" always set autoindenting on
	set autoindent
endif " has("autocmd")

" set nomore " When on, listings pause when the whole screen is filled.  You will get the |more-prompt|.
set more " When on, listings pause when the whole screen is filled.  You will get the |more-prompt|.


set hidden        " You need this otherwise you cannot switch modified buffer

" https://vim.fandom.com/wiki/Indenting_source_code
" https://developpaper.com/vim-technique-explain-the-difference-between-tabstop-softtabstop-and-expandtab/
" set tabstop    =4   shiftwidth  =4 expandtab
set tabstop    =4 " show existing tab with 4 spaces width
" "When auto indenting, the indent length is 4
set shiftwidth =4 " when indenting with '>', use 4 spaces width
" "The value of softtabstop is negative, and the value of shiftwidth will be used.
" The two values are consistent, which is convenient for unified indentation
set softtabstop=-1
" set softtabstop=4

" On pressing tab, insert 4 spaces
" "When you enter the tab character, it is automatically replaced with a space
set noexpandtab
set smarttab

" https://vim.works/2019/03/16/wrapping-text-in-vim/
" https://vi.stackexchange.com/questions/18798/automatic-wraping-to-new-line
set nowrap
" set linebreak
" set textwidth=0
set textwidth=120
" set wrapmargin=1
set wrapmargin=0
set formatoptions=tcqrn1
" set formatoptions=cqrn1
" set formatoptions=tcqrn

" https://vi.stackexchange.com/questions/10572/why-is-line-continuation-is-indented-with-12-spaces-in-vimscript
let g:vim_indent_cont = &sw
" https://vi.stackexchange.com/questions/26184/is-it-possible-to-configure-vim-to-indent-line-continuation-differently-from-ind
setl cino=e-2

" https://stackoverflow.com/questions/69339050/how-to-stop-vim-pane-from-blinking-in-tmux
" set vb t_vb=

set hlsearch   " highlight research result
" set ignorecase " search pattern
set smartcase
set incsearch  " incrementally match search result
set backspace=indent,eol,start whichwrap+=<,>,[,] " enable backspace key

" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" https://vimways.org/2019/vim-and-the-working-directory/
" set autochdir "  Note: When this option is on some plugins may not work.
" " autocmd BufEnter * lcd %:p:h

" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
nnoremap <leader>cd :lcd %:h<cr>

" Open files located in the same dir in with the current file is edited
nnoremap <leader>ew :e <C-R>=expand("%:.:h") . "/"<cr>

" Forget abut this. It's not the vi way to use buffer list
" nnoremap <C-h> :bnext<cr>
" nnoremap <C-l> :bprev<cr>




" https://sunaku.github.io/vim-256color-bce.html
" https://vi.stackexchange.com/questions/238/tmux-is-changing-part-of-the-background-in-vim
" if &term =~ '256color'
if exists("$TMUX")
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
endif



" ~/.vimrc
" Make Vim recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
	" Page keys https://github.com/tmux/tmux/wiki/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"

	" Arrow keys http://unix.stackexchange.com/a/34723
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif


" "editor environment ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

" "mouse settings ______________________________________________________________________________________________"
" "mouse settings ______________________________________________________________________________________________"

if 1 == g:_is_windows
	" prevent from cann't copy content in linux terminal
	if has('mouse')
		set mouse=a
	endif
	au GUIEnter * simalt ~x
endif

" https://github.com/alacritty/alacritty/issues/2931
" https://github.com/alacritty/alacritty/issues/1142
" [O was printed to current buffer when vim lost focus
if ! has('nvim')
	if has("mouse_sgr")
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	endif
endif

" if ! has('nvim')
"     set term=xterm-256color
"     " set term=alacritty
" endif

" if exists("$TMUX")
"     " E518: Unknown option: term=screen-256color
"     set term=screen-256color
" endif

if has('mouse')
	" set mouse=n
	set mouse=a
endif

" [O issue
" let g:TerminusFocusReporting = 0

" https://vi.stackexchange.com/questions/12140/how-to-disable-moving-the-cursor-with-the-mouse
nnoremap <LeftMouse> M`<LeftMouse>``
nnoremap <LeftRelease> M`<LeftRelease>``

" Change original cursor position when switch windows?
" augroup cursor_hold
"     autocmd!
"     " autocmd FocusLost * set mouse=
"     autocmd WinLeave * normal M`
"     " au FocusGained * normal 
"     " au FocusGained * normal ``
"     " autocmd FocusGained * call timer_start(200, 's:reenablemouse')
"     autocmd WinEnter * normal ``
" augroup END

" augroup NO_CURSOR_MOVE_ON_FOCUS
"     au!
"     au FocusLost * let g:oldmouse=&mouse | set mouse=
"     au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
" augroup END

" function s:reenablemouse(timer_id)
"     set mouse=a
" endfunction

" " Make thing simple?
" set mouse=
" set mouse-=a

" DISABLE MOUSE IN VIM SYSTEM-WIDE
" https://interpip.es/linux/disable-mouse-in-vim-system-wide/

" No. Do not do this "Preserve". It will remember your left windows cursor position,
" and when you switch to another view of the same buffer, it will jump back to the
" memory position, this operation will demage yuur opened view status.
" https://stackoverflow.com/questions/40984988/preserve-cursor-position-when-switching-between-buffers-with-bn
" " Preserve cursor position when switching between buffers"

" autocmd BufEnter * silent! normal! g`"

" function! s:last_modified()
"     if &modified
"         let save_cursor = getpos(".")
"         let n = min([250, line("$")])
"         :silent keepjumps exe '1,' . n
"             \ . 's/^\(.*L\)ast.modified.*:.*/\1ast modified: '
"             \ . strftime('%Y-%m-%d %H:%M:%S %z (PST)') . '/e'
"         call histdel('search', -1)
"         call setpos('.', save_cursor)
"     endif
" endfun
" autocmd BufWritePre * call s:last_modified()

" " Save current view settings on a per-window, per-buffer basis.
" function! s:auto_save_win_view()
"     if !exists("w:saved_buf_view")
"         let w:saved_buf_view = {}
"     endif
"     let w:saved_buf_view[bufnr("%")] = winsaveview()
"     echom w:saved_buf_view[bufnr("%")]
" endfunction
"
" " Restore current view settings.
" function! s:auto_restore_win_view()
"     let buf = bufnr("%")
"     if exists("w:saved_buf_view") && has_key(w:saved_buf_view, buf)
"         let v = winsaveview()
"         let at_start_of_file = v.lnum == 1 && v.col == 0
"         " if at_start_of_file && !&diff
"         if !&diff
"             call winrestview(w:saved_buf_view[buf])
"         endif
"         unlet w:saved_buf_view[buf]
"     endif
" endfunction
"
" " When switching buffers, preserve window view.
" if v:version >= 700
"     augroup view_hold | au!
"         autocmd WinLeave * call s:auto_save_win_view()
"         autocmd WinEnter * call s:auto_restore_win_view()
"     augroup END
" endif

" "Preserve cursor position when switching between buffers"


" "mouse settings ______________________________________________________________________________________________"
" "mouse settings ______________________________________________________________________________________________"



" "cursor shape and blinking |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

" https://vim.fandom.com/wiki/Configuring_the_cursor
" if &term =~ "xterm\\|rxvt\\|alacritty\\|foot"
"     " use an orange cursor in insert mode
"     let &t_SI="\<Esc>]12;orange\x7"
"     " use a red cursor otherwise
"     let &t_EI="\<Esc>]12;red\x7"
"     silent !echo -ne "\033]12;red\007"
"     " reset cursor when vim exits
"     autocmd VimLeave * silent !echo -ne "\033]112\007"
"     " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
" endif

" Check shell info
" infocmp
" https://vimrcfu.com/snippet/15
" Change cursor style when entering INSERT mode (works in tmux && gui !)
" >>>>>>>>> Will ruin cursor display in tty <<<<<<<<
" if exists('$TMUX')
"     let &t_SI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"     let &t_SR="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
"     let &t_EI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"     " https://github.com/vimpostor/vim-tpipeline
"
"     " [O was printed to current buffer when vim lost focus
"     " let &t_fe="\<Esc>[?1004h"
"     " let &t_fd="\<Esc>[?1004l"
"     " let &t_fe=
"     " let &t_fd=
" else
"     let &t_SI="\<Esc>]50;CursorShape=1\x7"
"     let &t_SR="\<Esc>]50;CursorShape=2\x7"
"     let &t_EI="\<Esc>]50;CursorShape=0\x7"
" endif
"
" " if ! has('nvim')
"     " let &t_ve="\e[?25h"
"     " let &t_ve="\e[?25h\e[?16;143;255c"
"     let &t_ve="\e[?6c"
"     let &t_vi="\e[?25l"
"     let &t_SI="\e[?0c"
"     let &t_EI="\e[?16;143;255c"
"
"     " if ! has('nvim')
"     "     let &t_SI="\<esc>[5 q"
"     "     let &t_SR="\<esc>[5 q"
"     "     let &t_EI="\<esc>[2 q"
"     "     " let &t_EI="\<esc>[1 q"
"     " endif
"
"     if $TERM == "linux"
"         set t_ab=[4%p1%dm
"         set t_af=[3%p1%dm
"     endif
" " endif

if ! has('nvim')
	" [O was printed to current buffer when vim lost focus
	set t_fe=
	set t_fd=
endif

" Heavy settings testing
" syntime on
" syntime report

" Insert event made neovim/vim heavy -- highly CPU usage
" if has('nvim')
"     " set guicursor=n-v-c:bar-Cursor/lCursor,i-ci-ve:ver25-CUrsuor2/lCursor,r-cr:hor50,o:hor50
"     " nvim: help guicursor
"
"     set guicursor=n-v-c-sm:bar,i-ci-ve:ver25-Cursor,r-cr-o:hor20
" "     set guicursor=n-v-c:bar,i-ci-ve:ver25,r-cr:hor20,o:hor50
" " \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
" " \,sm:bar-blinkwait175-blinkoff150-blinkon175
"
"     " set guicursor=
"     let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
"     let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
"
"     augroup blink_cursor
"         au!
"         autocmd InsertEnter,CmdlineEnter *
"             \ set guicursor=i-ci:ver100-iCursor-blinkwait300-blinkon200-blinkoff150
"         autocmd WinEnter,InsertLeave,CmdlineLeave *
"             \ set guicursor=n-v-c-sm:bar,i-ci-ve:ver25-Cursor,r-cr-o:hor20
"
"         " 1/2 block 3/4 uderscore 5/6 pipe bar
"         " blinky block
"         " autocmd VimEnter * silent! execute "! echo -ne '\e[1 q'"
"         " autocmd VimEnter * silent! execute(! echo -ne '\033[ q')
"         " autocmd VimEnter * silent! execute(! echo -ne '\033[34l')
"         " autocmd VimLeave * silent! execute "! echo -ne '\e[3 q'"
"         " autocmd VimLeave * silent! execute(! echo -ne '\033[ q')
"         " autocmd VimLeave * silent! execute(! echo -ne '\033[34l')
"
"         " following code will mess your vim
"         " https://vi.stackexchange.com/questions/9131/i-cant-switch-to-cursor-in-insert-mode
"         " autocmd InsertEnter * silent! execute "! echo -en \<esc>[5 q"
"         " autocmd InsertEnter * silent! execute "! echo -en \\033[ q"
"         " autocmd InsertEnter * silent! execute "! echo -en \\033[34l"
"         " autocmd InsertLeave * silent! execute "! echo -en \<esc>[2 q"
"         " autocmd InsertLeave * silent! execute "! echo -en \\033[ q"
"         " autocmd InsertLeave * silent! execute "! echo -en \\033[34l"
"
"         au VimEnter,VimResume *
"             \ set guicursor=n-v-c-sm:bar,i-ci-ve:ver25-Cursor,r-cr-o:hor20
" "             \ set guicursor=n-v-c:bar,i-ci-ve:ver25,r-cr:hor20,o:hor50
" " \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
" " \,sm:bar-blinkwait175-blinkoff150-blinkon175
"
"         " au VimLeave,VimSuspend * set guicursor=a:bar-blinkon0
"         " au VimLeave,VimSuspend * set guicursor=
"         au VimLeave,VimSuspend * set guicursor=a:hor20
"         " au VimLeave,VimSuspend * set guicursor=n:bar-Cursor
"         " au VimLeave,VimSuspend * set guicursor="disable"
"
"     augroup END
"
" endif

" without this code, vim will not show cursor
if ! has('nvim')
	" https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
	augroup blink_cursor
		au!
		" vim needs this
		" half height cursor blink
		" autocmd InsertEnter * let &t_ve= "\e[?25h\e[?c"
		autocmd InsertEnter,CmdlineEnter * let &t_ve="\e[?25h\e[?6c"
		autocmd WinEnter,InsertLeave,CmdlineLeave * let &t_ve="\e[?25h\e[?16;143;255c"

		" 1/2 block 3/4 uderscore 5/6 pipe bar
		" blinky block
		" autocmd VimEnter * silent! execute "! echo -ne '\e[1 q'"
		" autocmd VimLeave * silent! execute "! echo -ne '\e[3 q'"

		" following code will mess your vim
		" https://vi.stackexchange.com/questions/9131/i-cant-switch-to-cursor-in-insert-mode
		" autocmd InsertEnter * silent! execute "! echo -en \<esc>[5 q"
		" autocmd InsertLeave * silent! execute "! echo -en \<esc>[2 q"

	augroup END

endif

" https://stackoverflow.com/questions/31595411/how-to-clear-the-screen-after-exit-vim
" Do cursor shape job in shell terminfo
" augroup clear_terminal | au!
	" if has('nvim')
	"     " au VimLeave * !clear | :call system(['printf "$cursor_code" > $(tty)'])
	"     " au VimLeave * call nvim_cursor_set_shape("vertical-bar")
	"     "     \ | call system(['clear;', 'printf "$cursor_code" > $(tty)'])
	"     " au VimLeave * all system(['clear', ';', 'printf %s "$cursor_code" > $(tty)'])

	"     " au VimLeave * all system(['printf %s "$cursor_code" > $(tty)', 'reset'])
	"     au VimLeave * !clear | !reset
	"     " au VimLeave * !eval 'printf "$cursor_code" > $(tty)'
	" else
	"     " au VimLeave * all system('printf %s "$cursor_code" > $(tty); reset')
	"     au VimLeave * !clear | !reset
	" endif
	" Change to underline cursor
	" au VimLeave * !reset
	" au VimLeave * !reset; . ${HOME}/.profile
	" au VimLeave * !printf '\033[34l' | !. ${HOME}/.ashrc
	" au VimLeave * !printf '\033[34l'
	" au VimLeave * !printf '\033[ q'
	" au VimLeave * !printf '\033[34l'
" augroup END


" "cursor shape and blinking ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"



" "tags generation _____________________________________________________________________________________________"
" "tags generation _____________________________________________________________________________________________"

" "cscope ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

" https://alex.dzyoba.com/blog/vim-revamp/
" cscope - "find usages"
if has("fzf")
	function! s:cscope(option, query) range
		let color = '{ x = $1; $1 = ""; z = $3; $3 = "";
			\ printf
			\ "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n",
			\ x,z,$0; }'
		let opts = {
			\ 'source':  "cscope -dL" . a:option . " "
			\ . a:query . " | awk '" . color . "'",
			\ 'options': ['--ansi', '--prompt', '> ',
			\             '--multi', '--bind',
			\ 'alt-a:select-all,alt-d:deselect-all',
			\             '--color',
			\ 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
			\ 'down': '40%'
			\ }
		function! opts.sink(lines)
			let data = split(a:lines)
			let file = split(data[0], ":")
			execute 'e ' . '+' . file[1] . ' ' . file[0]
		endfunction
		call fzf#run(opts)
	endfunction

	" Invoke command. 'g' is for call graph, kinda.
	nnoremap <silent> <leader>g :call <SID>cscope('3', expand('<cword>'))<cr>
endif

if has("cscope")
	let g:qquickruickr_cscope_use_qf_g = 1
	let g:quickr_cscope_db_file = "cscope_quickr.out"
endif


" let g:statusline_cscope_flag = ""
" set statusline=[%n]%<%f\ %h%m%r\ %=\
" set statusline+=%(\ [%{g:statusline_cscope_flag}]\ \ \ %)
" set statusline+=%-14.(%l,%c%V%)\ %P
function! s:cscope_state(updating)
	if a:updating
		let g:statusline_cscope_flag = "C"
	else
		let g:statusline_cscope_flag = ""
	endif
	execute "redrawstatus!"
endfunction


if exists('g:use_ale')
	" ALE
	let g:ale_lint_on_save             = 1
	let g:ale_lint_on_enter            = 0
	let g:ale_lint_on_text_changed     = 'never'
	let g:ale_sign_column_always       = 1
	let g:ale_sign_warning             = 'W'
	let g:ale_sign_error               = 'E'
	let g:ale_python_flake8_args
		\  = '--ignore=C,E111,E114,E22,E201,E241,E265,E272,E3,E501,E731'
	let g:ale_python_pylint_executable = ''


	fun! ALEClearBuffer(buffer)
		if get(g:, 'ale_enabled')
			\ && has_key(get(g:, 'ale_buffer_info', {}), a:buffer)
			call ale#engine#SetResults(a:buffer, [])
			call ale#engine#Cleanup(a:buffer)
		endif
	endfun

	augroup UnALE
		autocmd!
		autocmd TextChanged,TextChangedI,InsertEnter,InsertLeave
			\ * call ALEClearBuffer(bufnr('%'))
	augroup END
endif

" "cscope ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

" " https://github.com/skywind3000/gutentags_plus
" " :GscopeFind {querytype} {name}
" " enable gtags module
" let g:gutentags_modules = ['ctags', 'gtags_cscope']
"
" " config project root markers.
" let g:gutentags_project_root = ['.root']
"
" " generate datebases in my cache directory, prevent gtags files polluting my project
" let g:gutentags_cache_dir = expand('~/.cache/tags')
"
" " change focus to quickfix window after search (optional).
" let g:gutentags_plus_switch = 1
"
" let g:gutentags_define_advanced_commands = 1

" noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
" noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
" noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
" noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
" noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
" noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
" noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
" noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
" noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
" noremap <silent> <leader>gz :GscopeFind z <C-R><C-W><cr>

" A reference
" function! s:generate_cstag()
"     let dir = getcwd()
"     if filereadable("tags")
"         if(g:iswindows==1)
"             let tagsdeleted=delete(dir."\\"."tags")
"         else
"             let tagsdeleted=delete("./"."tags")
"         endif
"         if(tagsdeleted!=0)
"             echohl WarningMsg
"             \ | echo "Fail to do tags! I cannot delete the tags" | echohl None
"             return
"         endif
"     endif
"     if has("cscope")
"         silent! execute "cs kill -1"
"     endif
"     if filereadable("cscope.files")
"         if(g:iswindows==1)
"             let csfilesdeleted=delete(dir."\\"."cscope.files")
"         else
"             let csfilesdeleted=delete("./"."cscope.files")
"         endif
"         if(csfilesdeleted!=0)
"             echohl WarningMsg
"             \ | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
"             return
"         endif
"     endif
"     if filereadable("cscope.out")
"         if(g:iswindows==1)
"             let csoutdeleted=delete(dir."\\"."cscope.out")
"         else
"             let csoutdeleted=delete("./"."cscope.out")
"         endif
"         if(csoutdeleted!=0)
"             echohl WarningMsg
"             \ | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
"             return
"         endif
"     endif
"     if(executable('ctags'))
"         "silent! execute "!ctags -R --c-types=+p --fields=+S *"
"         silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
"     endif
"     if(executable('cscope') && has("cscope") )
"         if(g:iswindows!=1)
"             silent! execute "!find . -name '*.h' -o -name '*.c'
"             \ -o -name '*.cpp' -o -name '*.hpp' -o -name '*.H'
"             \ -o -name '*.C' -o -name '*.cxx' -o -name '*.hxx' >> cscope.files"
"         else
"             silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
"         endif
"         silent! execute "!cscope -b"
"         execute "normal :"
"         if filereadable("cscope.out")
"             execute "cs add cscope.out"
"         endif
"     endif
" endfunction


" map <F12> :call <SID>generate_cstag()<cr>
" map <F12> :AsyncRun -silent -mode=terminal -hidden=1 -pos=hide <SID>generate_cstag()<cr>
" map <F12> :call job_start("<SID>generate_cstag()")<cr>

" 0 or s: Find this C symbol
" 1 or g: Find this definition
" 2 or d: Find functions called by this function
" 3 or c: Find functions calling this function
" 4 or t: Find this text string
" 6 or e: Find this egrep pattern
" 7 or f: Find this file
" 8 or i: Find files #including this file
" 9 or a: Find places where this symbol is assigned a value

" nmap <C-\>s :cs find s <C-R>=expand("<cword>")<cr><cr>:copen<cr>
nmap <silent> <c-\>s :cs find s <C-R>=expand("<cword>")<cr><cr>
nmap <silent> <c-\>g :cs find g <C-R>=expand("<cword>")<cr><cr>
nmap <silent> <c-\>c :cs find c <C-R>=expand("<cword>")<cr><cr>
nmap <silent> <c-\>t :cs find t <C-R>=expand("<cword>")<cr><cr>
nmap <silent> <c-\>e :cs find e <C-R>=expand("<cword>")<cr><cr>
nmap <silent> <c-\>f :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <silent> <c-\>i :cs find i ^<C-R>=expand("<cfile>")<cr>$<cr>
nmap <silent> <c-\>d :cs find d <C-R>=expand("<cword>")<cr><cr>

" nmap <C-\>c :cs find c <C-R>=expand("<cword>")<cr><cr>:copen<cr>
" nmap <C-\>t :cs find t <C-R>=expand("<cword>")<cr><cr>:copen<cr>
" nmap <C-\>e :cs find e <C-R>=expand("<cword>")<cr><cr>:copen<cr>
" nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<cr><cr>:copen<cr>
" nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<cr>$<cr>:copen<cr>
" nmap <C-\>d :cs find d <C-R>=expand("<cword>")<cr><cr>:copen<cr>

if has("cscope")
	set cscopetag
	set cscoperelative
	set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

" cscope error: Assertion failed: invcntl-aram.sizeblk == sizeof(t_logicalblk) (invlib.c: invopen: 593)
" https://bugzilla.redhat.com/show_bug.cgi?id=877955
" refer to cscopr_auto


let g:qf_modifiable    = 1
let g:qf_join_changes  = 1
let g:qf_write_changes = 1

augroup quickfix_reflector | au!
	autocmd User QfReplacementBufWritePost doautocmd BufWritePost
augroup END

" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup


" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100


" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif

if exists('g:use_coc')

	" https://github.com/neoclide/coc.nvim
	" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
	" https://subvisual.com/blog/posts/vim-elixir-ide
	nnoremap <silent> <leader>co  :<C-u>CocList outline<CR>
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" :
		\ <SID>check_back_space() ? "\<TAB>" :
		\ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" " Make <CR> auto-select the first completion item and notify coc.nvim to
	" " format on enter, <cr> could be remapped by other vim plugin
	" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	"     \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	" autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup coc
		autocmd!
		" Setup formatexpr specified filetype(s).
		autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
		" Update signature help on jump placeholder.
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Run the Code Lens action on the current line.
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f>
			\ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b>
			\ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f>
			\ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b>
			\ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f>
			\ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b>
			\ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call CocActionAsync('runCommand',
		\ 'editor.action.organizeImport')

	" " Add (Neo)Vim's native statusline support.
	" " NOTE: Please see `:h coc-status` for integrations with external plugins that
	" " provide custom statusline: lightline.vim, vim-airline.
	" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

	" coc explorer
	" nnoremap <leader>e <Cmd>CocCommand explorer<CR>

endif

" "tags generation _____________________________________________________________________________________________"
" "tags generation _____________________________________________________________________________________________"


" "tagbar (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((("


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
let g:vim_tags_cache_dir                   = g:cache_root
let g:tagbar_left                          = 1
let g:tagbar_expand                        = 1

" https://stackoverflow.com/questions/11975316/vim-ctags-tag-not-found
" set tags=./tags,tags
set tags=./tags,tags;$HOME
" set tags=tags
" H current-directory
" set autochdir
" set switchbuf=useopen,split " make quickfix open in a new split buffer
set switchbuf=uselast " make quickfix open in a new split buffer
let g:qf_bufname_or_text = 1


" Retrieve previous/next window number
function! s:windows_jump_retrieve(dir)
	let c = 0
	let wincount = winnr('$')
	" Find a writable buffer
	while !empty(getbufvar(winbufnr(c + 1), "&buftype"))
		\ && c < wincount && &buftype != ''
		let c = c + 1
	endwhile
	" set c as default buffer number
	let buf_num = c
	let jl = getjumplist()
	let jumplist = jl[0]
	let curjump  = jl[1]
	let searchrange = a:dir > 0 ? range(curjump + 1, len(jumplist))
		\ : range(curjump - 1, 0, -1)
	for i in searchrange
		if jumplist[i]["bufnr"] != bufnr('%')
			let buf_num = jumplist[i]["bufnr"]
			break
		endif
	endfor
	let result = bufwinnr(buf_num)
	if -1 == result
		let result = bufwinnr(bufnr('%'))
	endif
	return result
endfunction

" https://superuser.com/questions/575910/how-do-i-use-the-jumplist-to-jump-once-per-file
function! JumpToNextBufferInJumplist(dir) " 1=forward, -1=backward
	let jl = getjumplist() | let jumplist = jl[0] | let curjump = jl[1]
	let jumpcmdstr = a:dir > 0 ? '<C-O>' : '<C-I>'
	" let jumpcmdchr = a:dir > 0 ? '' : ' '    " <C-I> or <C-O>
	let searchrange = a:dir > 0 ? range(curjump + 1, len(jumplist))
		\ : range(curjump - 1, 0, -1)
	for i in searchrange
		if jumplist[i]["bufnr"] != bufnr('%')
			let n = (i - curjump) * a:dir
			echo "Executing " . jumpcmdstr . " " . n . " times."
			" execute "silent normal! " . n . jumpcmdchr
			echo "jumplist[" . i . "][\"bufnr\"] = " . jumplist[i]["bufnr"]
			echo "window number = " . bufwinnr(jumplist[i]["bufnr"])
			break
		endif
	endfor
endfunction
nnoremap <leader><C-O> :call JumpToNextBufferInJumplist(-1)<CR>
nnoremap <leader><C-I> :call JumpToNextBufferInJumplist( 1)<CR>

" "tagbar (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((("


" "taglist \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"

" " TlistUpdate will upate the tags
" " map <F2> :silent! Tlist<cr>
" " map <F2> :call NERDTreeTlist() <cr>
" nnoremap <silent> <F2> :TlistToggle<cr>
" let Tlist_Ctags_Cmd            = 'ctags'
" let Tlist_Use_Right_Window     = 0
" let Tlist_Show_One_File        = 0
" let Tlist_File_Fold_Auto_Close = 1
" let Tlist_Exit_OnlyWindow      = 1
" let Tlist_Process_File_Always  = 0
" let Tlist_Inc_Winwidth         = 0
" let Tlist_Auto_Open            = 1

" "taglist \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"

" "minibuffer **************************************************************************************************"
" let g:miniBufExplMapCTabSwitchBufs  = 1
" let g:miniBufExplMapWindowNavVim    = 1
" let g:miniBufExplMapWindowNavArrows = 1
"
" " multi files switch. double click support
" let g:miniBufExplMapWindowNavVim    = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBufs  = 1
" let g:miniBufExplModSelTarget       = 1
" " FileExplorer windows shrink?
" let g:miniBufExplForceSyntaxEnable = 1
" let g:miniBufExplorerMoreThanOne   = 2
" let g:miniBufExplCycleArround      = 1
" " let g:miniBufExplVSplit = <width>
" let g:miniBufExplVSplit = 40
" let g:miniBufExplVSplit = 30
" " setlocal bufhidden=delete
" map <C-Tab> :MBEbn<cr>
" map <C-S-Tab> :MBEbp<cr>

" "minibuffer **************************************************************************************************"





" "project drawer //////////////////////////////////////////////////////////////////////////////////////////////"


" " Open and close all the three plugins on the same time
" nmap <F8>  :TrinityToggleAll<cr>
" " Open and close the Source Explorer separately
" nmap <F9>  :TrinityToggleSourceExplorer<cr>
" " Open and close the Taglist separately
" nmap <F10> :TrinityToggleTagList<cr>
" " Open and close the NERD Tree separately
" nmap <F11> :TrinityToggleNERDTree<cr>

let g:tslime_always_current_session = 1
let g:tslime_always_current_window  = 1
let g:tslime_autoset_pane           = 1


" [Redir.vim](https://gist.github.com/intuited/362802)
" :Redir map
command! -nargs=+ -complete=command Redir let s:reg = @@  <bar> redir @">
	\  <bar> silent execute <q-args>
	\  <bar> redir END  <bar> new  <bar> pu  <bar> 1,2d_  <bar> let @@ = s:reg

if exists('$TMUX')

	vmap <C-c><C-c> <Plug>SendSelectionToTmux
	nmap <C-c><C-c> <Plug>NormalModeSendToTmux
	nmap <C-c>r <Plug>SetTmuxVars

	let g:tmux_navigator_no_mappings    = 1
	" Readonly buffers will prompt errors
	" Write all buffers before navigating from Vim to tmux pane
	" Does not act as expected. See write_generic
	" let g:tmux_navigator_save_on_switch = 2

	" function! s:tmux_move(direction)
	"     let wnr = winnr()
	"     silent! execute 'wincmd ' . a:direction
	"     " If the winnr is still the same after we moved, it is the last pane
	"     if wnr == winnr()
	"         call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
	"     end
	" endfunction
	"
	" nnoremap <unique> <silent> <c-h> :call <sid>tmux_move('h')<cr>
	" nnoremap <unique> <silent> <c-j> :call <sid>tmux_move('j')<cr>
	" nnoremap <unique> <silent> <c-k> :call <sid>tmux_move('k')<cr>
	" nnoremap <unique> <silent> <c-l> :call <sid>tmux_move('l')<cr>


	" nnoremap <unique> <silent> <c-h> :call keys#tmux_move('h')<cr>
	" nnoremap <unique> <silent> <c-j> :call keys#tmux_move('j')<cr>
	" nnoremap <unique> <silent> <c-k> :call keys#tmux_move('k')<cr>
	" nnoremap <unique> <silent> <c-l> :call keys#tmux_move('l')<cr>
	" nnoremap <unique> <silent> <c-w><c-h> :call keys#tmux_move('h')<cr>

	" nnoremap <unique> <silent> <c-w><c-j> :call keys#tmux_move('j')<cr>
	" nnoremap <unique> <silent> <c-w><c-k> :call keys#tmux_move('k')<cr>
	" nnoremap <unique> <silent> <c-w><c-l> :call keys#tmux_move('l')<cr>

	" nnoremap <silent> <c-<> :TmuxNavigateUp<cr>
	" nnoremap <silent> <c->> :TmuxNavigateDown<cr>
	" nnoremap <silent> <c-,> :TmuxNavigateLeft<cr>
	" nnoremap <silent> <c-.> :TmuxNavigateRight<cr>
	" nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

	" nnoremap <silent> <c-k> :call keys#tmux_move('k', g:navigate)<cr>
	" nnoremap <silent> <c-j> :call keys#tmux_move('j', g:navigate)<cr>
	" nnoremap <silent> <c-h> :call keys#tmux_move('h', g:navigate)<cr>
	" nnoremap <silent> <c-l> :call keys#tmux_move('l', g:navigate)<cr>


	" Disable tmux navigator when zooming the Vim pane
	let g:tmux_navigator_disable_when_zoomed = 1

	" https://github.com/RyanMillerC/better-vim-tmux-resizer
	let g:tmux_resizer_no_mappings = 1

	let g:tpipeline_autoembed = 0
	let g:tpipeline_cursormoved = 1
	" tpipeline comes bundled with its own custom minimal statusline seen above
	" let g:tpipeline_statusline = '%!tpipeline#stl#line()'
	" set stl=%!tpipeline#stl#line()
	" You can also use standard statusline syntax, see :help stl
	" let g:tpipeline_statusline = '%f'

	" https://superuser.com/questions/1158269/use-tmux-pane-border-format-with-vim-to-set-pane-titles
	augroup tmux-pane-border-format
		au!
		" https://github.com/tmux/tmux/issues/1852
		" autocmd BufWinLeave * call system('tmux set-window-option
		"     \ -g pane-border-format "#{pane_index}
		"     \ #(%!v:lua.WindLine.show(' . bufnr('#') . ','
		"     \ . win_getid(bufwinnr(bufnr('#'))) . '))" && tmux refresh -S')
		" autocmd VimEnter,BufNewFile,BufReadPost,BufEnter,BufWinEnter
		"     \,BufNew,WinEnter,CursorHoldI,CursorHold *
		"     \ call system('tmux set-window-option
		"     \ -g pane-border-format "#{pane_index} #(%!v:lua.WindLine.show(' . bufnr('%') .
		"     \ ',' . win_getid(bufwinnr(bufnr('%'))) . '))" && tmux refresh -S')
		"     " \ -g pane-border-format "#{pane_index} vim-' . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1] . '"')
		" " autocmd VimLeave * call system('tmux pane-border-format
		" "     \ "#{pane_index} ' . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1] '"')



		" autocmd BufWinLeave,WinLeave *
		"     \ silent! execute 'lua vim.g["tpipeline_statusline"] =
		"     \ "%!v:lua.WindLine.show(' . bufnr('#') . ','
		"     \ . win_getid(bufwinnr(bufnr('#'))) . ')"'

		" " https://superuser.com/questions/517402/force-update-for-tmux-status-bar
		" autocmd VimEnter,BufNewFile,BufReadPost,BufEnter,BufWinEnter
		"     \,BufNew,WinEnter,CursorHoldI,CursorHold,FocusGained *
		"     \ let &stl=&stl
		"     \ | silent! execute 'lua vim.g["tpipeline_statusline"]=
		"     \ "%!v:lua.WindLine.show(' . bufnr('%') . ','
		"     \ . win_getid(bufwinnr(bufnr('%'))) . ')"'
		"     \ | redrawstatus!
		"     \ | silent! exec '!tmux refresh-client -S'
		" " \ | silent! exec '!tmux refresh -S'

		" autocmd VimLeave * call system('tmux rename-window '
		"     \ . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1])
		" autocmd VimEnter,BufNewFile,BufReadPost *
		"     \ call system('tmux rename-window "vim-'
		"     \ . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1] . '"')
	augroup END

endif | " exists('$TMUX')

" To init.lua
if has('nvim')
	" https://github.com/kyazdani42/nvim-tree.lua
	" vimrc
	let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
	let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
	let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
	let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
	let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
	let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
	let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
	let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
	let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
	let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
	let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
	let g:nvim_tree_window_picker_exclude = {
		\   'filetype': [
		\     'notify',
		\     'packer',
		\     'qf'
		\   ],
		\   'buftype': [
		\     'terminal'
		\   ]
		\ }
	" Dictionary of buffer option names mapped to a list of option values that
	" indicates to the window picker that the buffer's window should not be
	" selectable.
	" List of filenames that gets highlighted with NvimTreeSpecialFile
	let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 }
	let g:nvim_tree_show_icons = {
		\ 'git': 1,
		\ 'folders': 0,
		\ 'files': 0,
		\ 'folder_arrows': 0,
		\ }
	"If 0, do not show the icons for one of 'git' 'folder' and 'files'
	"1 by default, notice that if 'files' is 1, it will only display
	"if nvim-web-devicons is installed and on your runtimepath.
	"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
	"but this will not work when you set indent_markers (because of UI conflict)

	" default will show icon by default if no icon is provided
	" default shows no icon by default
	let g:nvim_tree_icons = {
		\ 'default': '',
		\ 'symlink': '',
		\ 'git': {
		\   'unstaged': "✗",
		\   'staged': "✓",
		\   'unmerged': "",
		\   'renamed': "➜",
		\   'untracked': "★",
		\   'deleted': "",
		\   'ignored': "◌"
		\   },
		\ 'folder': {
		\   'arrow_open': "",
		\   'arrow_closed': "",
		\   'default': "",
		\   'open': "",
		\   'empty': "",
		\   'empty_open': "",
		\   'symlink': "",
		\   'symlink_open': "",
		\   }
		\ }

	" nnoremap <C-n> :NvimTreeToggle<CR>
	nnoremap <leader>n :NvimTreeToggle<CR>
	nnoremap <leader>r :NvimTreeRefresh<CR>
	" nnoremap <leader>n :NvimTreeFindFile<CR>
	" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them
endif



" chadtree
" nnoremap <leader>v <cmd>CHADopen<cr>

" coc explorer
" nnoremap <leader>e <Cmd>CocCommand explorer<CR>

if exists('g:_use_fern')

	" https://github.com/lambdalisue/fern-renderer-devicons.vim
	let g:fern#renderer = "devicons"

	" https://github.com/lambdalisue/fern.vim/wiki/Plugins
	let g:fern_renderer_devicons_disable_warning = 1
	let g:fern#disable_default_mappings          = 1
	" let g:fern#disable_drawer_auto_quit          = 1
	let g:fern#disable_drawer_smart_quit         = 1
	" let g:fern#disable_viewer_hide_cursor        = 1

	" https://github.com/lambdalisue/fern-git-status.vim
	" Disable the following options one by one if you encounter performance issues.
	" Disable listing ignored files/directories
	let g:fern_git_status#disable_ignored     = 1
	" Disable listing untracked files
	let g:fern_git_status#disable_untracked   = 1
	" Disable listing status of submodules
	let g:fern_git_status#disable_submodules  = 1
	" Disable listing status of directories
	let g:fern_git_status#disable_directories = 1

	" https://github.com/lambdalisue/fern-renderer-nerdfont.vim
	let g:fern#renderer = "nerdfont"

	let g:fern#renderer#default#leading          = "│"
	let g:fern#renderer#default#root_symbol      = "┬ "
	let g:fern#renderer#default#leaf_symbol      = "├─ "
	let g:fern#renderer#default#collapsed_symbol = "├─ "
	let g:fern#renderer#default#expanded_symbol  = "├┬ "

	let g:fern#mark_symbol                       = '●'
	let g:fern#renderer#default#collapsed_symbol = '▷ '
	let g:fern#renderer#default#expanded_symbol  = '▼ '
	let g:fern#renderer#default#leading          = ' '
	let g:fern#renderer#default#leaf_symbol      = ' '
	let g:fern#renderer#default#root_symbol      = '~ '

	" https://www.reddit.com/r/vim/comments/i1p3s9/fernvim_a_modern_asynchronous_file_manager_for_vim/
	" autocmd VimEnter * ++nested Fern . -drawer -stay
	" https://github.com/Allaman/dotfiles/blob/master/vimrc
	noremap <silent> <Leader>p :Fern . -drawer -width=35 -toggle<CR><C-w>=
	noremap <silent> <leader>d :Fern . -drawer -width=35 -toggle<cr><C-w>=
	noremap <silent> <leader>f :Fern . -drawer -reveal=% -width=35<cr><C-w>=
	noremap <silent> <leader>. :Fern %:h -drawer -width=35<cr><C-w>=

	" https://github.com/lambdalisue/fern.vim
	function! s:init_fern() abort
		echo "This function is called ON a fern buffer WHEN initialized"

		function! s:init_fern_mapping_reload_all()
			nmap <buffer> R <Plug>(fern-action-reload:all)
		endfunction
		augroup action-fern-mapping-reload-all
			autocmd! *
			autocmd FileType fern call s:init_fern_mapping_reload_all()
		augroup END

		" augroup FernTypeGroup
		"     autocmd! * <buffer>
		"     autocmd BufEnter <buffer> silent execute "normal \<Plug>(fern-action-reload)"
		" augroup END


		" Use 'select' instead of 'edit' for default 'open' action
		nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)

		if 0 == g:navi_protect
			" Open node with 'o'
			nmap <buffer> o <Plug>(fern-action-open)

			" Add any code to customize fern buffer
			" Define NERDTree like mappings
			nmap <buffer> o  <Plug>(fern-action-open:edit)
		endif

		nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
		nmap <buffer> n <Plug>(fern-action-new-path)
		" nmap <buffer> ma <Plug>(fern-action-new-path)
		nmap <buffer> D <Plug>(fern-action-trash)
		" nmap <buffer> m <Plug>(fern-action-move)
		nmap <buffer> M <Plug>(fern-action-rename)
		nmap <buffer> c <Plug>(fern-action-copy)
		nmap <buffer> r <Plug>(fern-action-reload)
		nmap <buffer> t <Plug>(fern-action-mark:toggle)
		nmap <buffer> s <Plug>(fern-action-open:split)
		" nmap <buffer> i  <Plug>(fern-action-open:split)
		" nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
		nmap <buffer> v <Plug>(fern-action-open:vsplit)
		" nmap <buffer> s  <Plug>(fern-action-open:vsplit)
		" nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
		nmap <buffer><nowait> i <Plug>(fern-action-hidden:toggle)
		" nmap <buffer> I <Plug>(fern-action-hide-toggle)
		nmap <buffer><nowait> u <Plug>(fern-action-leave)
		nmap <buffer><nowait> e <Plug>(fern-action-enter)
		nmap <buffer> q :<C-u>quit<CR>


		nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
		" nmap <buffer> t  <Plug>(fern-action-open:tabedit)
		" nmap <buffer> T  <Plug>(fern-action-open:tabedit)gT
		nmap <buffer> gv <Plug>(fern-action-open:vsplit)<C-w>p
		nmap <buffer> P gg

		nmap <buffer> C  <Plug>(fern-action-enter)
		nmap <buffer> cd <Plug>(fern-action-cd)
		nmap <buffer> R  gg<Plug>(fern-action-reload)<C-o>
		nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>



		nmap <buffer><expr>
			\ <Plug>(fern-action-expand-or-collapse)
			\ fern#smart#leaf(
			\   "\<Plug>(fern-action-collapse)",
			\   "\<Plug>(fern-action-expand)",
			\   "\<Plug>(fern-action-collapse)",
			\ )

		nmap <buffer><nowait> l <Plug>(fern-action-expand-or-collapse)

		nmap <buffer><expr>
			\ <Plug>(fern-action-expand-or-enter)
			\ fern#smart#drawer(
			\   "\<Plug>(fern-open-or-expand)",
			\   "\<Plug>(fern-open-or-enter)",
			\ )
		nmap <buffer><expr>
			\ <Plug>(fern-action-collapse-or-leave)
			\ fern#smart#drawer(
			\   "\<Plug>(fern-action-collapse)",
			\   "\<Plug>(fern-action-leave)",
			\ )

		nmap <buffer><nowait> l <Plug>(fern-action-expand-or-enter)
		nmap <buffer><nowait> h <Plug>(fern-action-collapse-or-leave)

		nmap <buffer> <Plug>(fern-action-enter-and-tcd)
			\ <Plug>(fern-action-enter)
			\ <Plug>(fern-wait)
			\ <Plug>(fern-action-tcd:root)

		nmap <buffer> <Plug>(fern-action-leave-and-tcd)
			\ <Plug>(fern-action-leave)
			\ <Plug>(fern-wait)
			\ <Plug>(fern-action-tcd:root)

		augroup action_fern_tcd
			autocmd! * <buffer>
			autocmd BufEnter <buffer> call feedkeys("\<Plug>(fern-action-tcd:root)")
		augroup END

		" Find and enter project root
		nnoremap <buffer><silent>
			\ <Plug>(fern-action-enter-project-root)
			\ :<C-u>call fern#helper#call(funcref('<SID>map_enter_project_root'))<cr>
		nmap <buffer><expr><silent>
			\ ^
			\ fern#smart#scheme(
			\   "^",
			\   {
			\     'file': "\<Plug>(fern-action-enter-project-root)",
			\   }
			\ )

		" Open bookmark:///
		nnoremap <buffer><silent>
			\ <Plug>(fern-action-enter-bookmark)
			\ :<C-u>Fern bookmark:///<cr>
		nmap <buffer><expr><silent>
			\ <C-^>
			\ fern#smart#scheme(
			\   "\<Plug>(fern-action-enter-bookmark)",
			\   {
			\     'bookmark': "\<C-^>",
			\   },
			\ )

		" Use <C-w><C-p> like
		nmap <buffer> <Plug>(my-fern-open-and-stay) <Plug>(fern-action-open)<C-w><C-p>

		" Use :FernDo to execute close command after open. Note that <Plug>(fer-close-drawer) is a global mapping.
		nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<cr>
		nmap <buffer><silent> <Plug>(fern-action-open-and-close)
			\ <Plug>(fern-action-open)
			\ <Plug>(fern-close-drawer)

		" https://github.com/LumaKernel/fern-mapping-fzf.vim
		function! Fern_mapping_fzf_customize_option(spec)
			let a:spec.options .= ' --multi'
			" Note that fzf#vim#with_preview comes from fzf.vim
			if exists('*fzf#vim#with_preview')
				return fzf#vim#with_preview(a:spec)
			else
				return a:spec
			endif
		endfunction

		function! Fern_mapping_fzf_before_all(dict)
			if !len(a:dict.lines)
				return
			endif
			return a:dict.fern_helper.async.update_marks([])
		endfunction

		function! s:reveal(dict)
			execute "FernReveal -wait" a:dict.relative_path
			execute "normal \<Plug>(fern-action-mark:set)"
		endfunction

		let g:Fern_mapping_fzf_file_sink = function('s:reveal')
		let g:Fern_mapping_fzf_dir_sink = function('s:reveal')

		nnoremap <c-i> i
		" Map to your custom function.
		nmap <silent><buffer><Tab> <Plug>(fern-action-call-function:project_top)
		unmap <c-i>

		" call fern#mapping#call_function#add('project_top', function('s:fern_project_top'))

	endfunction

	augroup fern-custom
		autocmd! *
		autocmd FileType fern call s:init_fern()
	augroup END

	nnoremap <silent> <leader>ee :<C-u>Fern <C-r>=<SID>smart_path()<cr><cr>

	" Return a parent directory of the current buffer when the buffer is a file.
	" Otherwise it returns a current working directory.
	function! s:smart_path() abort
		if !empty(&buftype) || bufname('%') =~# '^[^:]\+://'
			return fnamemodify('.', ':p')
		endif
		return fnamemodify(expand('%'), ':p:h')
	endfunction

	" https://github.com/hrsh7th/fern-mapping-call-function.vim
	" Add your custom function to mapping.
	function! s:fern_project_top(helper) abort
		let l:node = a:helper.sync.get_current_node()
		let l:proj = s:detect_project_root(l:node._path)
		execute printf('Fern %s', fnameescape(l:proj))
	endfunction

	function! s:map_enter_project_root(helper) abort
		" NOTE: require 'file' scheme
		let root = a:helper.get_root_node()
		let path = root._path
		let path = finddir('.git/..', path . ';')
		execute printf('Fern %s', fnameescape(path))
	endfunction

	function! s:fern_preview_init() abort
		nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
		nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
		nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
		nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)

		nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview)
			\ fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
		nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)

		nmap <buffer><expr>
			\ <Plug>(fern-action-preview-or-nop)
			\ fern#smart#leaf(
			\   "\<Plug>(fern-action-open:edit)\<C-w>p",
			\   "",
			\ )
		nmap <buffer><expr> j
			\ fern#smart#drawer(
			\   "j\<Plug>(fern-action-preview-or-nop)",
			\   "j",
			\ )
		nmap <buffer><expr> k
			\ fern#smart#drawer(
			\   "k\<Plug>(fern-action-preview-or-nop)",
			\   "k",
			\ )
	endfunction

	augroup fern_preview
		autocmd! *
		autocmd FileType fern call s:fern_preview_init()
	augroup END

endif | " exists('g:_use_fern')

" CtrlP
" Disable default mapping since we are overriding it with our command let g:ctrlp_map = ''





" "project drawer //////////////////////////////////////////////////////////////////////////////////////////////"

" "Terminal 🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀"

if has('nvim')
	" https://www.reddit.com/r/vim/comments/nvr94o/i_need_to_tweak_a_vim_script_to_hide_and_show_a/
	augroup toggle_term
		autocmd!
		autocmd TermOpen * let t:toggle_term = +expand('<abuf>')
	augroup END
endif

function! s:toggle_term() abort
	let buf = get(t:, 'toggle_term', -1)
	let wnr = bufwinnr(buf)
	if wnr != -1
		execute wnr . 'hide'
	elseif bufexists(buf)
		execute 'rightbelow sbuffer ' . buf
	endif
endfunction
nnoremap <F4> <Cmd>call <sid>toggle_term()<cr>
tnoremap <F4> <Cmd>call <sid>toggle_term()<cr>

" "Terminal 🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀🭦🭀"


" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

let g:tex_flavor = "latex"

if exists('g:_use_neoformat')
	let g:neoformat_try_formatprg = 1
	" Enable alignment
	let g:neoformat_basic_format_align = 1

	" Enable tab to spaces conversion
	let g:neoformat_basic_format_retab = 1

	" Enable trimmming of trailing whitespace
	let g:neoformat_basic_format_trim = 1
	let g:shfmt_opt  = "-ci"
	augroup fmt
		autocmd!
		autocmd BufWritePre * undojoin | Neoformat
	augroup END
endif

" https://github.com/andymass/vim-matchup
" Disable mathcit
" let g:loaded_matchit = 1

" augroup cxx_auto_format | au!
"     " Won't read .clang-format
"     autocmd FileType c,cxx,cpp ClangFormatAutoEnable
" augroup END

" call packager#add('Chiel92/vim-autoformat', { 'type' : 'start' })
" noremap <F3> :Autoformat<cr>
" noremap <F3> :call easy_align#align()<cr>

" https://github.com/junegunn/vim-easy-align
nmap ea <Plug>(EasyAlign)
xmap ea <Plug>(EasyAlign)
" noremap <F4> :EasyAlign<cr>

" https://github.com/vim-autoformat/vim-autoformat
let g:autoformat_autoindent             = 0
let g:autoformat_retab                  = 0
let g:autoformat_remove_trailing_spaces = 0

" augroup auto_format
"     au!
"     au BufWrite * silent! :Autoformat<cr>
" augroup end

" https://github.com/umaumax/vim-format
" "  call packager#add('umaumax/vim-format', { 'type' : 'start' })
"
" " auto format
" let g:vim_format_fmt_on_save = 1
"
" " manual
" let g:format_flag   = 1
"
" augroup json_group
"     autocmd!
"     autocmd FileType json autocmd BufWinEnter *.json command! -bar Format :JsonFormat
"     autocmd FileType json autocmd BufWritePre *.json if g:format_flag | :JsonFormat | endif
"     autocmd FileType json autocmd! json_group FileType
" augroup END

augroup filetypes | au!
	" https://lorenzod8n.wordpress.com/2007/05/14/quick-vim-tip-getting-vim-to-know-zsh-files/
	autocmd BufNewFile,BufRead *.zsh setlocal filetype=zsh
	autocmd BufNewFile,BufRead vimoutlinerrc setlocal filetype=vim
augroup END

" " for original command
" let g:vim_format_list   = {
"   \ 'jenkins':{'autocmd':['*.groovy'],'cmds':[{'requirements'
"   \:['goenkins-format'],'shell':'cat {input_file} | goenkins-format'}]},
"   \ }
"
" To init.lua
if exists(":Tabularize")
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
	let p = '^\s*|\s.*\s|\s*$'
	if exists(':Tabularize') && getline('.') =~# '^\s*|'
		\ && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
		let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
		let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
		Tabularize/|/l1
		normal! 0
		call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
	endif
endfunction

augroup markdown
	autocmd!
	" Include dash in 'word'
	autocmd FileType markdown setlocal iskeyword+=-
augroup END

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

fun! s:MkdxGoToHeader(header)
	" given a line: '  84: # Header'
	" this will match the number 84 and move the cursor to the start of that line
	call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
	let text = get(a:val, 'text', '')
	let lnum = get(a:val, 'lnum', '')

	" if the text is empty or no lnum is present, return the empty string
	if (empty(text) || empty(lnum)) | return text | endif

	" We can't jump to it if we dont know the line number so that must be present in the outpt line.
	" We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
	return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

if has("fzf")
	fun! s:MkdxFzfQuickfixHeaders()
		" passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
		" this allows you to create a 'source' for fzf.
		" first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
		" then, we strip out any remaining empty headers.
		let headers = filter(map(mkdx#QuickfixHeaders(0),
			\ function('<SID>MkdxFormatHeader')), 'v:val != ""')

		" run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
		" supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
		call fzf#run(fzf#wrap(
			\ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
			\ ))
	endfun

	" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
	nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>
endif


" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


" "search functions ********************************************************************************************"
" "search functions ********************************************************************************************"


" https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
if executable('ag')
	let g:ackprg = 'ag --vimgrep --smart-case'
endif
" cnoreabbrev ag Ack
" cnoreabbrev aG Ack
" cnoreabbrev Ag Ack
" cnoreabbrev AG Ack
" You need to install ack from package manager for ack.vim
cnoreabbrev Ack Ack!
" Will generate huge file!
nnoremap <leader>a :Ack!<space>


set wildmenu


" if !has("python") && !has("python3")
"     let g:leaderf_loaded = 1
" endif
" " don't show the help in normal mode
" let g:Lf_HideHelp = 1
" let g:Lf_UseCache = 0
" let g:Lf_UseVersionControlTool = 0
" let g:Lf_IgnoreCurrentBufferName = 1
" " popup mode
" let g:Lf_WindowPosition = 'popup'
" let g:Lf_PreviewInPopup = 1
" " let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
" let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "Noto Sans Mono ExtraLight" }
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
"
" let g:Lf_ShortcutF = "<leader>ff"
" noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<cr><cr>
" noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<cr><cr>
" noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<cr><cr>
" noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<cr><cr>
"
" noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<cr>
" noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<cr>
" " search visually selected text literally
" xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<cr>
" noremap go :<C-U>Leaderf! rg --recall<cr>
"
" " should use `Leaderf gtags --update` first
" let g:Lf_GtagsAutoGenerate = 0
" let g:Lf_Gtagslabel = 'native-pygments'
" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<cr><cr>
" noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<cr><cr>
" noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<cr><cr>
" noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<cr><cr>
" noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<cr><cr>

if has("fzf")
	" https://github.com/junegunn/fzf/issues/453
	function! s:fzf_open(command_str)
		if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
			exe "normal! \<c-w>\<c-w>"
		endif
		exe 'normal! ' . a:command_str . "\<cr>"
	endfunction

	nnoremap <silent> <C-b>  :call <sid>fzf_open(':Buffers')<cr>
	nnoremap <silent> <C-g>g :call <sid>fzf_open(':Ag')<cr>
	nnoremap <silent> <C-g>c :call <sid>fzf_open(':Commands')<cr>
	nnoremap <silent> <C-g>l :call <sid>fzf_open(':BLines')<cr>
	nnoremap <silent> <C-p>  :call <sid>fzf_open(':Files')<cr>
endif

" "search functions ********************************************************************************************"
" "search functions ********************************************************************************************"


" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"
" Set completeopt to have a better completion experience
" set completeopt=menu,menuone,longest
set completeopt=menu,menuone
set completeopt+=noinsert,noselect
set completeopt-=preview

set belloff+=ctrlg " Add only if Vim beeps during completion

if has('nvim')
	let mucomplete#no_mappings = 1
	let g:mucomplete#enable_auto_at_startup = 1
	let g:mucomplete#completion_delay = 1


	let g:jedi#popup_on_dot = 0  " It may be 1 as well
	let g:mucomplete#user_mappings = { 'sqla' : "\<c-c>a" }
	let g:mucomplete#chains = { 'sql' : ['file', 'sqla', 'keyn'] }
	set noinfercase

endif
" Installing clangd
" https://clangd.llvm.org/installation.html
" let g:clang_library_path = '/usr/lib'
if has('nvim')
	let g:clang_library_path = boot#chomp(system(['llvm-config', '--libdir']))
else
	let g:clang_library_path = boot#chomp(system('llvm-config --libdir'))
endif
let g:clang_user_options = '-std=c++2a'
let g:clang_complete_auto = 1
imap <expr> <down> mucomplete#extend_fwd("\<down>")

" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" In ~/.vim/vimrc, or somewhere similar.
let g:ale_fixers = {
	\   '*': ['remove_trailing_lines', 'trim_whitespace'],
	\   'javascript': ['eslint'],
	\}

if exists("g:_use_ddc.vim")
	" Customize global settings
	" Use around source.
	" https://github.com/Shougo/ddc-around
	call ddc#custom#patch_global('sources', ['around'])

	" Use matcher_head and sorter_rank.
	" https://github.com/Shougo/ddc-matcher_head
	" https://github.com/Shougo/ddc-sorter_rank
	call ddc#custom#patch_global('sourceOptions', {
		\ '_': {
		\   'matchers': ['matcher_head'],
		\   'sorters': ['sorter_rank']},
		\ })

	" Change source options
	call ddc#custom#patch_global('sourceOptions', {
		\ 'around': {'mark': 'A'},
		\ })
	call ddc#custom#patch_global('sourceParams', {
		\ 'around': {'maxSize': 500},
		\ })

	" Customize settings on a filetype
	call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
	call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
		\ 'clangd': {'mark': 'C'},
		\ })
	call ddc#custom#patch_filetype('markdown', 'sourceParams', {
		\ 'around': {'maxSize': 100},
		\ })

	" Mappings

	" <TAB>: completion.
	inoremap <silent><expr> <TAB>
		\ ddc#map#pum_visible() ? '<C-n>' :
		\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
		\ '<TAB>' : ddc#map#manual_complete()

	" <S-TAB>: completion back.
	inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

	" Use ddc.
	call ddc#enable()
endif

" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


" "tab management ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))"
" :set modifiable

" " ~/.vim/vim-addons/lh-brackets/doc/lh-map-tools.txt
" :let g:marker_define_jump_mappings = 0
"
" imap <C-J>      <Plug>MarkersJumpF
"  map <C-J>      <Plug>MarkersJumpF
" imap <C-K>      <Plug>MarkersJumpB
"  map <C-K>      <Plug>MarkersJumpB
" imap <C-<>      <Plug>MarkersMark
" nmap <C-<>      <Plug>MarkersMark
" xmap <C-<>      <Plug>MarkersMark

" https://www.hillelwayne.com/post/intermediate-vim/
" set tabline=%{strftime('%c')}

" https://github.com/erig0/cscope_dynamic
" nmap <F11> <Plug>CscopeDBInit

" Fx do not work in tty?
" for x in {1..12}; do echo -n "F$x "; tput kf$x | cat -A; echo; done
" infocmp -1 | grep "kf[1-4]"
" /usr/include/linux/input-event-codes.h
" evtest

nmap <F2> :TagbarToggle<cr>
nmap <F3> :BuffergatorToggle<cr>

" " Go to buffer. Conflict with buffergator
" nnoremap gb :ls<cr>:b<space>

" Multiple Neovim instances leads high CPU usage
nnoremap <silent> <leader>l :BuffergatorToggle<cr>
nnoremap <silent> <leader>o :TagbarToggle<cr>

let g:buffergator_autodismiss_on_select = 1
" How to open buffergator itself
let g:buffergator_viewport_split_policy = "L"
let g:buffergator_use_new_keymap = 1
let g:buffergator_mru_cycle_local_to_window = 0
let g:buffergator_split_size=100

" "tab management ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))"

if exists('g:smartq_loaded')
	" Default Settings
	" -----

	" Default mappings:
	" Remaps normal mode macro record q to Q
	" nnoremap Q q
	" nmap q        <Plug>(smartq_this)
	" nmap <C-q>    <Plug>(smartq_this_force)
	let g:smartq_default_mappings = 1

	" Excluded buffers to disable SmartQ and to preserve windows when closing splits
	" on excluded buffers. Non-modifiable buffers are preserved by default.
	let g:smartq_exclude_filetypes = [
		\ 'fugitive'
		\ ]
	let g:smartq_exclude_buftypes= [
		\ ''
		\ ]

	" Quit buffers using :q command. Non-modifiable and readonly file uses :q
	let g:smartq_q_filetypes = [
		\ 'diff', 'git', 'gina-status', 'gina-commit', 'snippets',
		\ 'floaterm'
		\ ]
	let g:smartq_q_buftypes = [
		\ 'quickfix', 'nofile'
		\ ]

	" Wipe buffers using :bw command. Wiped buffers are removed from jumplist
	" Default :bd
	let g:smartq_bw_filetypes = [
		\ ''
		\ ]
	let g:smartq_bw_buftypes = [
		\ ''
		\ ]
endif

" "session operation @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

" High CPU usage when starting neovim with no parameters
" Troubleshooting: move session_auto.vim from folder plugin to folder after
if ! exists("g:loaded_session_auto")    " && &readonly == 0
	" Doesn't work?
	" packadd session_auto

	let session_auto_load_path = g:plugin_dir['vim'] . '/pack/'
		\ . g:package_manager['vim'] . '/opt/session_auto'
	let session_auto_load_file = session_auto_load_path . '/after/plugin/session_auto.vim'
	exe 'set runtimepath+='. session_auto_load_path
	exe 'set packpath+='. session_auto_load_path
	execute "source " .   session_auto_load_file
	execute "runtime! " . 'after/session_auto.vim'

endif

" if exists('g:loaded_session')
"     " https://github.com/xolox/vim-session
"     let g:session_autoload         = 'yes'
"     let g:session_autosave         = 'yes'
"     " Will generate .default.vim
"     let g:session_autosave_to      = '.default'
"     let g:session_verbose_messages = 0
"     let g:session_directory        = getcwd()
" endif
function! s:session_state(updating)
	if a:updating
		" packadd cscope_auto
		" augroup cscope_auto | au!
		"     autocmd BufEnter * :call cscope_auto#setup(function("s:cscope_state"))
		" augroup END
		let g:statusline_session_flag = "S"
	else
		" augroup cscope_auto | au!
		" augroup END
		let g:statusline_session_flag = ""
	endif
	execute "redrawstatus!"
endfunction

augroup session_auto_setup
	au!
	" Error detected while processing VimEnter Autocommands for "*":
	" E117: Unknown function: session_auto#setup
	" "packadd session_auto" hasn't work
	autocmd VimEnter * :call session_auto#setup(function("s:session_state"))

	" autocmd BufReadPre * :call session_auto#setup(function("s:session_state"))
	" autocmd WinNew * :call session_auto#setup(function("s:session_state"))
	" autocmd BufNew * :call session_auto#setup(function("s:session_state"))
augroup END

" " https://github.com/xolox/vim-notes/issues/80
" augroup reset_xolox
"     au! PluginXoloxMisc CursorHold
" augroup END

" https://github.com/vim/vim/issues/2790
" :set redrawtime=10000
set redrawtime=1000
set lazyredraw
" e. It selects the default regular expression engine.
" https://www.reddit.com/r/vim/comments/8ggdqn/undocumented_tips_make_your_vim_1020x_times_faster/
" vim hangs when I open a typescript file
" https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file
" :set re=1

nmap <leader>m <Plug>(SessionAuto)

" Will insert lhs to current position and command line
" command! -nargs=0 S silent! execute "normal \<Plug>SessionAuto<cr>"

command! -nargs=0 L silent! :call lens#run()


" https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window
" Don't resize automatically.
let g:golden_ratio_autocommand = 1
" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <c-w>- <Plug>(golden_ratio_resize)
nmap <c-w>_ <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <c-w>+ <C-w><Bar><C-w>_
nnoremap <c-w>= <C-w><Bar><C-w>_

let g:loaded_matchparen = 1

" Obsess    " start record session"
" Obsess!   " delete current session"



" Unknown function: airline#extensions#branch#init
" https://github.com/vim-airline/vim-airline/issues/999
set sessionoptions=blank,buffers,curdir,help,tabpages,winsize,terminal
set sessionoptions-=options
set sessionoptions-=tabpages
set sessionoptions-=help
set sessionoptions+=buffers

set viewoptions=folds,cursor,unix,slash " better unix/windows compatibility

" *'viminfo'*        Deprecated alias to 'shada' option.
" *'viminfofile'*    Deprecated alias to 'shadafile' option.
if has('nvim')
	" Buffer changes won't save until you have following settings in your .vimrc/init.vim
	" https://stackoverflow.com/questions/2902048/vim-save-a-list-of-open-files-and-later-open-all-files/2902082
	" set viminfo='5,f1,\"50,:20,%,n~/.vim/viminfo
	silent! execute "set viminfo='5,f1,\"50,:20,%,n'" . stdpath('data')
		\ . "/viminfo"
	let &viminfofile = expand('$XDG_DATA_HOME/nvim/shada/main.shada')
else
	" set viminfo='5,f1,\"50,:20,%,n~/.vim/viminfo
	silent! execute "set viminfo='5,f1,\"50,:20,%,n'" . g:plugin_dir['vim']
		\ . "/viminfo"

endif

augroup bw
	au!
	" https://stackoverflow.com/questions/5238251/deleting-buffer-from-vim-session
	" command! -nargs=? -bang BW :silent! argd % <bar> bw<bang><args>
	command! -nargs=? -bang BW :silent! bprevious <bar> bdelete<bang> #
	nnoremap <silent> <Leader>d :<C-U>bprevious <bar> bdelete #<cr>
	nnoremap <silent> <Leader>q :Bdelete<CR>
augroup END

" https://vim.fandom.com/wiki/Make_views_automatic
let g:skipview_files = [
	\ '[EXAMPLE PLUGIN BUFFER]'
	\ ]



" :se backup? backupdir? backupext?
if has('nvim')
	let s:backupdir = expand(stdpath('cache') . '/backup')
else
	let s:backupdir = expand($HOME . '/.cache/vim/backup')
	" set backupdir=$HOME/tmp//,.
endif
if filewritable(s:backupdir) != 2
	silent! exe '!mkdir -p ' s:backupdir
endif
silent! execute 'set backupdir=' . s:backupdir . '//,.'

" " $XDG_DATA_HOME/nvim == stdpath('data')
" " Because stdpath('data') was shared between root and ordinary users
" iF has('nvim')
"     let s:undodir = expand(stdpath('cache') . '/undo')
" else
"     let s:undodir = expand($HOME . '/.cache/vim/undo')
" endif
" if filewritable(s:undodir) != 2
"     silent! exe '!mkdir -p ' s:undodir
" endif
" silent! execute 'set undodir=' . s:undodir . '//'
" set undofile

" Meta <F8> show git version

" https://github.com/mbbill/undotree
nnoremap <F8> :UndotreeToggle<CR>
if has("persistent_undo")
	" $XDG_DATA_HOME/nvim == stdpath('data')
	" Because stdpath('data') was shared between root and ordinary users
	if has('nvim')
		let s:undodir = expand(stdpath('cache') . '/undo')
	else
		let s:undodir = expand($HOME . '/.cache/vim' . '/undo')
	endif

	" create the directory and any parent directories
	" if the location does not exist.
	if !isdirectory(s:undodir)
		call mkdir(s:undodir, "p", 0700)
	endif
	if &undodir != s:undodir
		" let &undodir = s:undodir
		" help undodir
		silent! execute 'set undodir=' . s:undodir . '//'
	endif
	set undofile
endif
" debug undotree
" tail -F ~/undotree_debug.log

" https://www.reddit.com/r/neovim/comments/j4jhmm/external_commands_in_vim_vs_neovim/
command! -nargs=+ -complete=file T
	\ tab new | setlocal nonumber nolist noswapfile bufhidden=wipe |
	\ call termopen([<f-args>]) |
	\ startinsert

" https://unix.stackexchange.com/questions/62191/how-can-i-open-a-file-in-vim-in-readonly-mode-if-it-already-has-a-swapfile
augroup existing | au!
	autocmd SwapExists * let v:swapchoice = "o"
augroup END

" " https://vim.fandom.com/wiki/Open_same_file_read-only_in_second_Vim
" func! s:checkswap()
"     swapname
"     if v:statusmsg =~ '\.sw[^p]$'
"         set ro
"     endif
" endfunc
"
" if &swf
"     set shm+=A
"     au BufReadPre * call s:checkswap()
" endif


" https://vi.stackexchange.com/questions/26050/how-to-set-read-only-for-only-one-buffer
augroup readonly
	autocmd!
	autocmd BufReadPost g:_log_address setlocal readonly
		\ | setlocal buftype=nofile | setlocal filetype=log
augroup END

" "session operation @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

" "dict ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

" " For fun (doesn't work: 16928 segmentation fault  goldendict). Actally sdcv works in console
" if 1 == g:_is_windows
"     let g:goldendict_path = 'C:\Program Files\GoldenDict\GoldenDict.exe'
" else
"     let g:goldendict_path = boot#chomped_system('which goldendict')
" endif
"
" imap <F1> <C-\><C-O><Plug>(goldendict-lookup-cursor)<cr>
" nmap <F1> <Plug>(goldendict-lookup-cursor)<cr>
" vmap <F1> <C-G><Plug>(goldendict-lookup-visual)<C-G><cr>

augroup github | au!
	au BufEnter github.com_*.txt set filetype=markdown
augroup END

" if ! exists("g:_firenvim_write")
"
"     if exists('g:started_by_firenvim')
"
"         set laststatus=0
"     else
"         set laststatus=2
"     endif
"
"     function! OnUIEnter(event) abort
"         if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
"             set laststatus=0
"         endif
"     endfunction
"
"
"     " let g:firenvim_config = {
"     "             \ 'localSettings': {
"     "                 \ '.*': {,
"     "                 \ 'filename': '/tmp/{hostname}_{pathname%10}.{extension}',
"     "                 \ }
"     "                 \ }
"
"     " Broken Websites - glacambre/firenvim Wiki
"     " \ 'localSettings': {
"     "     \ '.*': {
"     "         \ 'cmdline': 'firenvim',
"     "         \ 'priority': 0,
"     "         \ 'selector': 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
"     "         \ 'takeover': 'always',
"     "     \ },
"     "     \ '.*notion\.so.*': { 'priority': 9, 'takeover': 'never', },
"     "     \ '.*docs\.google\.com.*': { 'priority': 9, 'takeover': 'never', },
"     " \ }
"     let g:firenvim_config =
"         \ { 'globalSettings':
"         \ { 'cmdlineTimeout': 3000,
"         \ '<C-w>': 'noop',
"         \ '<C-n>': 'default',
"         \ 'alt': 'all',
"         \  },
"         \ 'localSettings':
"         \ { '.*':
"         \ { 'cmdline': 'neovim',
"         \ 'content': 'text',
"         \ 'priority': 0,
"         \ 'selector': 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
"         \ 'takeover': 'always',
"         \ },
"         \ '.*notion\.so.*': { 'priority': 9, 'takeover': 'never', },
"         \ '.*docs\.google\.com.*': { 'priority': 9, 'takeover': 'never', },
"         \ }
"         \ }
"
"     let fc = g:firenvim_config['localSettings']
"     let fc['https?://[^/]+\.co\.uk/'] = { 'takeover': 'never', 'priority': 1 }
"
"     let fc['.*'] = { 'selector': 'textarea:not([readonly]), div[role="textbox"]' }
"
"
"
"     let g:dont_write = v:false
"
"     function! s:firenvim_write(timer) abort
"         unlet g:dont_write
"         let g:dont_write = v:false
"         if filewritable(bufname('%'))
"             write
"         endif
"     endfunction
"
"     function! s:delay_firenvim_write() abort
"         if g:dont_write
"             return
"         end
"         let g:dont_write = v:true
"         let timer = 10000
"         " https://vi.stackexchange.com/questions/27035/vim-script-how-to-pass-varargs-to-a-lambda-in-timer-start
"         call timer_start(timer, { -> execute ("call s:firenvim_write('" . timer . "')", "") })
"     endfunction
"
"     augroup firenvim_write_group
"         au!
"         if has("gui_running")
"             autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
"         endif
"         " au TextChanged * ++nested write
"         " au TextChangedI * ++nested write
"         au TextChanged  * ++nested call s:delay_firenvim_write()
"         au TextChangedI * ++nested call s:delay_firenvim_write()
"     augroup END
"
"     let g:_firenvim_write = 1
"
" endif

" "dict ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

" "build tools ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"



" " https://www.quora.com/How-do-I-compile-a-program-C++-or-Java-in-Vim-like-Sublime-Text-Ctrl+B/answer/Lin-Wei-31
" " open quickfix window automatically when AsyncRun is executed
" " set the quickfix window 6 lines height.
" let g:asyncrun_open = 6
"
" " ring the bell to notify you job finished
" let g:asyncrun_bell = 1
"
"
" " F10 to toggle quickfix window
" " nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
" nmap <C-g><C-o> <Plug>window:quickfix:loop
"
" let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
"
" " https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
" :packadd cfilter
" " :Cfilter DPUST
"
"
" " if has('win32') || has('win64')
" "     noremap <silent><F2> :AsyncRun! -cwd=<root> findstr /n /s /C:"<C-R><C-W>" "\%CD\%\*.h*" --include='*.i*' "\%cd\%\*.c*" <cr>
" " else
" "     noremap <silent><F2> :AsyncRun! -cwd=<root> grep -n -s -R <C-R><C-W> --include='*.h*' --include='*.i*' --include='*.c*' '<root>' <cr>
" " endif

if exists('s:_init_develop') && 1 == s:_init_develop
	function! s:log() abort
		call s:log_silent("scriptnames", "", g:_environment)
		silent! execute 'redir >> ' . g:_log_address . ' | silent scriptnames |
			\ redir END | call s:log_silent("\n")'
		silent! execute 'redir >> ' . g:_log_address . ' | silent verbose map |
			\ redir END | call s:log_silent("\n")'
	endfunction

	augroup reload_scriptnames
		autocmd!
		autocmd! BufReadPost $MYVIMRC ++nested :call s:log()
	augroup END
endif

augroup disable_trailing_white_space_warning
	autocmd!
	autocmd! BufReadPost $MYVIMRC ++nested
		\ if ShowTrailingWhitespace#IsSet() | call ShowTrailingWhitespace#Set(0,0) | endif
augroup END

let g:reload_on_write = 1

" "build tools ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"


" if 0 == g:debug_keys

" "auto reload .vimrc __________________________________________________________________________________________"

" auto reload vimrc once changed
" if has("autocmd")
"     autocmd! BufWritePost .vimrc source $MYVIMRC
"
"     " This fixes the color changes and things not working :D
"     autocmd! BufWritePost .vimrc filetype plugin indent on
" endif
" autocmd BufWritePost *vimrc,*exrc :call feedkeys(":source %\<cr>")

" autocmd! BufEnter * ++nested syntax sync fromstart

augroup reload_vimrc
	autocmd!
	" The following comand will shut off syntax and enable it again!!!
	" autocmd BufEnter * ++nested syntax sync fromstart

	" if has('nvim')
	" autocmd BufWritePost $MYVIMRC source $MYVIMRC | setlocal filetype=vim
	"     \ | call s:refresh()
	" else
	" | won't work. <bar> and \| neither
	" :vert h :\bar
	" autocmd BufWritePost $MYVIMRC source $MYVIMRC <bar> setlocal filetype=vim
	"     \ <bar> redraw!

	" autocmd BufWritePost $MYVIMRC
	"     \ execute 'source ' . $MYVIMRC .
	"     \ ' | setlocal filetype=vim' .
	"     \ ' | syntax enable'


	" autocmd BufWritePost $MYVIMRC if expand('%') == $MYVIMRC | :call
	"     \ feedkeys(":source $MYVIMRC\<cr>") | endif | setlocal filetype=vim | redraw!
	autocmd BufWritePre $MYVIMRC if expand('%') == $MYVIMRC && 0 != &modified
		\ | :call feedkeys(":source $MYVIMRC\<cr>") | endif
		" \ | setlocal filetype=vim | call s:refresh()
	" endif
augroup END

" "auto reload .vimrc __________________________________________________________________________________________"

" endif   " g:debug_keys

" "keep following code at the end of the file __________________________________________________________________"

" https://stackoverflow.com/questions/14779299/syntax-highlighting-randomly-disappears-during-file-saving
" augroup reset_syntax
"     au!
"     " The following comand will shut off syntax and enable it again!!!
"     autocmd SourcePost,BufReadPost,BufWritePost *
"         \ doautocmd filetypedetect BufRead "%" <bar> ++nested syntax enable
"
" augroup END

" redrawtime exceeded, "syntax highlighting" disabled
" set regexpengine=2
set regexpengine=1
" set regexpengine=0
" Search for the keyword "conflicted" to find setting conflictions of
" "syntax on" /  "syntax highlighting"
" syntax after colorscheme setting will load colorscheme twice

" If colorscheme doesn't work, look into "cursor_line". It was moved out from
" s:cursor_off() and s:cursor_on()

" syntax enable
" syntax on

augroup color_scheme_refresh | au!
	" https://stackoverflow.com/questions/51129631/vim-8-1-garbage-printing-on-screen
	" autocmd VimEnter *
	"     \ if ! exists('g:colors_name') || g:colors_name !=# g:scheme_name |
	"     \ silent! execute 'colorscheme ' . g:scheme_name |
	"     \ endif

	" E492: Not an editor command: ++nested colorscheme lucid
	" autocmd VimEnter * silent! execute '++nested colorscheme ' . g:scheme_name
	" "conflicted" with "syntax on"?
	" -- Yes. It will override dynamic color settings
	" Furthermore, it can seriously slow down your editor!!!
	" autocmd VimEnter * silent! execute 'colorscheme ' . g:scheme_name
augroup END

" "keep above code block at the end of the file ________________________________________________________________"



" "keep following code block at the very end of the file _______________________________________________________"


if ! has('nvim') && empty($TMUX) " && (exists('g:loaded_minpac') || exists('g:loaded_vim_packager'))
	" https://github.com/itchyny/lightline.vim/issues/512
	hi LightlineLeft_active_0 guibg=darkgrey

	augroup lightline_hl
		au!
		" https://vi.stackexchange.com/questions/31491/why-does-my-lightline-status-line-not-show-up-right-away

		" autocmd WinEnter,BufEnter,BufDelete,SessionLoadPost,
		"     \FileChangedShellPost,BufWinEnter,
		"     \BufReadPost,BufWritePost * ++nested call lightline#update()

		" autocmd VimEnter * ++nested call lightline#update()

		" au VimEnter,ColorScheme * call lightline#disable() |
		"     \ call lightline#enable()

		" autocmd VimEnter,WinEnter,BufEnter,BufDelete,
		"     \SessionLoadPost,FileChangedShellPost,BufWinEnter,
		"     \BufReadPost,BufWritePost,ColorScheme * ++nested call
		"     \ lightline#highlight() | redraw!

	augroup END
else
	augroup lightline_hl
		au!

		" lua require("slanted")
		" lua require('plugins'):requireRel("slanted-gaps")

		" lua lualine =  require('lualine')

	augroup END

endif

" if has('nvim')
"     augroup resized
"         au!
"
"         " The following comand will shut off syntax and enable it again!!!
"
"         " autocmd WinResized,CursorMoved * :call s:cursor_off() | :call s:cursor_on() | syntax on | setlocal list
"         " autocmd WinEnter,WinResized * :call s:cursor_off() | syntax on | setlocal list
"         autocmd WinResized * ++nested call s:refresh()
"     augroup END
" else
"     augroup indent_blankline_hl
"         au!
"         autocmd WinScrolled * ++nested call s:refresh()
"     augroup END
" endif

" Highly CPU usage
" augroup indent_blankline_hl
"     au!
"     " Leave event trigering refresh will highlight cursor line/column
"     " autocmd VimEnter,WinEnter,BufEnter,BufDelete,BufLeave,WinLeave,BufWinLeave,ModeChanged,
"     autocmd VimEnter,WinEnter,BufEnter,ModeChanged,
"         \SessionLoadPost,FileChangedShellPost,BufWinEnter,
"         \BufReadPost,BufWritePost,ColorScheme * ++nested
"         \ call s:refresh()
"
"     " Heavy CPU usage if both enabled cursorcolumn/cursorline and indent-blankline
"     " Already defined in:
"     " /mnt/init/editor/nvim/site/pack/packer/start/indent-blankline.nvim/lua/indent_blankline/init.lua
"     " autocmd CursorMoved * ++nested call s:refresh_light()
"
"     " Event list
"     " :autocmd CursorMoved
"     " autocmd CursorMoved * ++nested if exists('g:loaded_indent_blankline')
"     "     \ && virtcol('.') > 70
"     "     \ | setlocal list
"     "     \ | endif
"
"         " "setlocal list" is much lighter than IndentBlanklineRefresh
"         " \ | normal :IndentBlanklineRefresh<cr>
"
"     " \BufReadPost,BufWritePost,ColorScheme * ++nested syntax enable | redraw!
" augroup END


if exists('g:_use_indent_guides')
	augroup indent_guides_enable
		au!
		" au BufEnter,BufWritePost,VimEnter * silent execute ":normal!
		" \ \<Plug>IndentGuidesEnable"
		" autocmd BufEnter <buffer> call feedkeys("\<Plug>IndentGuidesEnable", x)
		autocmd VimEnter,WinEnter,BufEnter,BufDelete,
			\SessionLoadPost,FileChangedShellPost,BufWinEnter,BufWinLeave,
			\BufReadPost,BufWritePost,ColorScheme
			\ * ++nested :IndentGuidesEnable
	augroup END
endif

" autocmd ColorScheme,SessionLoadPost * call lightline#highlight()

" "keep above code block at the very end of the file ___________________________________________________________"

" https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively
let regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
for r in regs
	call setreg(r, [])
endfor

let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'
	\ | let i = 0
	\ | while (i < strlen(regs)) | exec 'let @' . regs[i] . ' = ""'
	\ | let i = i + 1 | endwhile | unlet regs


" set exrc
set secure

if exists('s:_init_develop') && 1 == s:_init_develop && bufnr(g:_log_address) < 0
	silent! execute 'argadd ' . g:_log_address
	" https://stackoverflow.com/questions/4043650/open-a-file-in-a-tab-in-vim-in-readonly-mode
	" :tabedit +set\ noma|set\ ro FILE
endif

" Replace shada
" time nvim -i NONE -c 'q'
" Replace config
" time nvim -u NORC -c 'q'
" : > ~/.startup.log
" nvim --startuptime ~/.startup.log ~/.startup.log
" sort -k 2 ~/.startup.log
" vim:  set ts=4 sw=4 tw=0 noet :
" nvim: set ts=4 sw=4 tw=0 noet :

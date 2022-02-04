" "initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
" put this line first in ~/.vimrc
" if &compatible
if exists('+compatible') && &compatible
    set nocompatible " don't simulate vi
endif


" set nocompatible | filetype indent plugin on | syn on
filetype indent plugin on | syn on
syntax enable
syntax on   " enable highlight



" Disable search highlight
" :noh
" Open terminal inside vim
" :topleft terminal
" Debug
" breakadd here


let g:log_address   = $HOME . '/.vim.log'
" https://stackoverflow.com/questions/25341062/vim-let-mapleader-space-annoying-cursor-movement
" https://stackoverflow.com/questions/446269/can-i-use-space-as-mapleader-in-vim
noremap <Space> <Nop>
map     <Space> <Leader>
" let mapleader       = ','
let g:log_verbose   = 1
let g:debug         = 1
let g:debug_verbose = 1
let g:debug_keys    = 1
let g:navi_protect  = 1

let g:fixed_tips_width = 40

let g:polyglot_disabled = ['markdown']

" Initialization of the plugin directory of vim
if ! exists("g:config_dir") || ! exists("g:plugin_dir") || 1 == g:debug

    " truncate the log file
    silent! execute '!printf "\n\n"' . ' >> ' . g:log_address . ' 2>&1 &'
    silent! execute '!printf "\n\n"' . ' > ' . g:log_address . ' 2>&1 &'

    " > /dev/null will hang up the process on vim-huge musl
    " vim-huge --version
    " VIM - Vi IMproved 8.2 (2019 Dec 12, compiled Oct 29 2021 14:03:34)
    " Included patches: 1-3565
    " Compiled by void-buildslave@a-hel-fi
    " silent! execute '!(printf "date                                    : '
    "             \ . strftime("%c") . '\n")' . ' >> ' . g:log_address . ' 2>&1 & > /dev/null'

    silent! execute '!(printf ' . '"\%-"'. g:fixed_tips_width . '"s: \%s\n"' . ' date "'
                \ . strftime("%c") . '")' . ' >> ' . g:log_address . ' 2>&1 &'
    if has("nvim")
        let g:init_file = resolve(stdpath('config') . '/init.vim')
    else
        " let g:init_file = boot#chomped_system("sudo realpath $MYVIMRC")
        " let g:init_file_raw = substitute(call('system', "realpath $MYVIMRC"), '\n\+$', '', '')

        " let g:init_file = substitute(system("realpath $MYVIMRC"), '\n\+$', '', '')
        " let g:init_file = resolve(expand($MYVIMRC))
        let g:init_file = expand($MYVIMRC)

        " let g:init_file_raw = boot#chomped_system("realpath $MYVIMRC")
        " if g:init_file != g:init_file_raw
        "     echom "Error! Wrong using fuction call"
        " endif
    endif
    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . ' g:init_file "'
                \ . g:init_file . '")' . ' >> ' . g:log_address . ' 2>&1 &'
    " silent! execute '!printf "g:init_file_raw: ' . g:init_file_raw .'\n"' . ' >> ' . g:log_address . ' 2>&1 &'
    " call boot#chomped_system("printf \"\ng:init_file\t\t: \"" . g:init_file . " >> " . g:log_address)

    if has("nvim")
        let g:config_dir = resolve(stdpath('config'))
    else
        " let vimrc_base = boot#chomped_system("basename \"". g:init_file . "\"")
        " let g:config_dir  = substitute(g:init_file, "\/" . vimrc_base, '', 'g')

        " let g:config_dir = substitute(system("dirname \"". g:init_file ."\" | cat - | xargs realpath"), '\n\+$', '', '')
        let g:config_dir = fnamemodify(g:init_file, ':p:h')
        "
        " let vimrc_dir_raw = boot#chomped_system("dirname \"". g:init_file ."\" | cat - | xargs realpath")
        " silent! execute '!(printf "vimrc_dir_raw: ' . vimrc_dir_raw .'\n")' . ' >> ' . g:log_address . ' 2>&1 &'

    endif
    " echom 'g:config_dir  =' . g:config_dir
    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . ' g:config_dir "'
                \ . g:config_dir . '")' . ' >> ' . g:log_address . ' 2>&1 &'

    let g:plugin_dir = {}
    let g:package_manager = {}

    if has('nvim')
        " let g:whoami     = substitute(system("whoami"), '\n\+$', '', '')
        " let g:home_dir   = '/home/' . g:whoami
        " let g:lua_plugin_dir = resolve(expand(g:home_dir . '/.local/share/nvim/site'))

        " let g:lua_plugin_dir     = resolve(expand($HOME . '/.local/share/nvim/site'))
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
        " if has('lua')
        "     let g:plugin_dir['lua'] = $XDG_DATA_HOME . "/nvim/site"
        "     let g:package_manager['lua']  = 'packer'

        "     let runtime_index = stridx(&runtimepath, g:plugin_dir['lua'])
        "     if -1 == runtime_index
        "         exe 'set runtimepath^='. g:plugin_dir['lua']
        "     endif

        "     let g:lua_config_dir = $XDG_DATA_HOME . "/nvim/lua"

        "     let runtime_index = stridx(&runtimepath, g:lua_config_dir)
        "     if -1 == runtime_index
        "         exe 'set runtimepath^='. g:lua_config_dir
        "     endif
        " else
            let g:plugin_dir['lua'] = ''
            let g:package_manager['lua']  = ''
        " endif
    endif

    let g:config_root = fnamemodify(g:plugin_dir['vim'], ':h')

    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . ' g:config_root "'
                \ . g:config_root . '")' . ' >> ' . g:log_address . ' 2>&1 &'

    let g:package_manager['vim'] = 'packager'

    " if g:package_manager['vim'] != ''
    "     exe 'set runtimepath^='. g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim']
    "     exe 'set runtimepath^='. g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim'] . '/opt'
    "     exe 'set runtimepath^='. g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim'] . '/start'
    " endif
    " if g:package_manager['lua']  != ''
    "     exe 'set runtimepath^='. g:plugin_dir['lua'] . '/pack/' . g:package_manager['lua']
    "     exe 'set runtimepath^='. g:plugin_dir['lua'] . '/pack/' . g:package_manager['lua']  . '/opt'
    "     exe 'set runtimepath^='. g:plugin_dir['lua'] . '/pack/' . g:package_manager['lua']  . '/start'
    " endif

    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . ' ' . shellescape("g:plugin_dir['vim']") . ' "'
                \ . g:plugin_dir['vim'] . '")' . ' >> ' . g:log_address . ' 2>&1 &'
    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . ' ' . shellescape("g:plugin_dir['lua']") . ' "'
                \ . g:plugin_dir['lua'] . '")' . ' >> ' . g:log_address . ' 2>&1 &'
    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . " \"g:package_manager['vim']\" \""
                \ . g:package_manager['vim'] . '")' . ' >> ' . g:log_address . ' 2>&1 &'
    silent! execute '!(printf ' . '"\%-"' . g:fixed_tips_width . '"s: \%s\n"' . " \"g:package_manager['lua'] \" \""
                \ . g:package_manager['lua']  . '")' . ' >> ' . g:log_address . ' 2>&1 &'

endif

" help nvim
" set runtimepath^=g:plugin_dir['vim'] runtimepath+=g:plugin_dir['vim']/after
" let &packpath = &runtimepath


if has("win32") || has("win95") || has("win64") || has("win16") " check operating system
    let g:is_windows  = 1
else
    let g:is_windows  = 0
endif

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

if ! exists('g:boot_loaded')
    let boot_load_path = g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim'] . '/start/boot'
    let boot_load_file = boot_load_path . '/autoload/boot.vim'
    exe 'set runtimepath+='. boot_load_path
    exe 'set packpath+='. boot_load_path
    execute "source " .   boot_load_file
    execute "runtime! " . boot_load_file
endif

let packager_path = g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim']
exe 'set runtimepath+='. packager_path
exe 'set packpath+='. packager_path

let vim_packager_path = g:plugin_dir['vim'] . '/pack/' . g:package_manager['vim'] . '/opt/vim-packager'
exe 'set runtimepath+='. vim_packager_path
exe 'set packpath+='. vim_packager_path
runtime! OPT vim_packager_path
" packadd vim-packager



" Garbage is spilled to terminal if statusline contains slow system() call #3197
" https://github.com/vim/vim/issues/3197
" https://stackoverflow.com/questions/51129631/vim-8-1-garbage-printing-on-screen
" set t_RB=^[]11;rgb:fb/^G
" set t_RF=^[]10;rgb:fb/^G

" set t_RB= t_RF= t_RV= t_u7= t_u7= t_8f= t_8b=
" :h terminal-output-codes

call boot#chomped_system('(printf "\n\n") >> ' . g:log_address . ' 2>&1 & > /dev/null')


" :echo "date: ". date
" call boot#chomped_system("echo \"date: \"". date)
" silent! execute '!printf "date: ' . date . '" >> '. g:log_address . ' 2>&1 &'
" silent! execute '!(printf "date: "' . date . ' > ' . g:log_address . ' 2>&1 &) > /dev/null'
" :LogSilent g:config_dir "\n" ""

" silent! execute '!(printf "' . '\n' . '" ' . > . ' ' . g:log_address . ' 2>&1 &) > /dev/null'
" call boot#log_silent(g:log_address, '\n', "", g:fixed_tips_width, g:log_verbose) " "wrong character '\n'" just for testing typoes :)
" call boot#log_silent(g:log_address, "date", date, g:fixed_tips_width, g:log_verbose)

" call boot#log_silent(g:log_address, "g:config_dir", g:config_dir, g:fixed_tips_width, g:log_verbose)
"
" for [key, element] in items(g:plugin_dir)
"     call boot#log_silent(g:log_address, "g:plugin_dir['" . key . "']", element, g:fixed_tips_width, g:log_verbose)
" endfor

call boot#log_silent(g:log_address, "argc()", argc(), g:fixed_tips_width, g:log_verbose)
call boot#log_silent(g:log_address, "len(argv())", len(argv()), g:fixed_tips_width, g:log_verbose)
call boot#log_silent(g:log_address, "len(v:argv)", len(v:argv), g:fixed_tips_width, g:log_verbose)

if 1 == g:debug_verbose
    " :message
    " silent! execute '!printf "v:argv: '.v:argv.'" >> '. g:log_address . ' 2>&1 &'
    let arg_count     = 0
    for av in argv()
        let arg_count   += 1
        if 10 > arg_count
            let header = "argv [ 0"
        else
            let header = "argv [ "
        endif
        call boot#log_silent(g:log_address, "" . header . arg_count." ]", av, g:fixed_tips_width, g:log_verbose)
    endfor
endif


if 1 == g:debug_verbose
    let rt_list = split(&packpath, ',')
    let line_count = 0
    for path in rt_list
        if 10 > line_count
            let header = "packpath [ 0"
        else
            let header = "packpath [ "
        endif
        call boot#log_silent(g:log_address, "" . header . line_count ." ]", path, g:fixed_tips_width, g:log_verbose)
        let line_count += 1
    endfor
else
    " " :echo "packpath\t: ".&packpath
    " " call boot#chomped_system("echo \"packpath: \"".&packpath)
    " call boot#log_silent(g:log_address, "packpath", &packpath, g:fixed_tips_width, g:log_verbose)

endif

if 1 == g:debug_verbose
    let rt_list = split(&runtimepath, ',')
    let line_count = 0
    for path in rt_list
        if 10 > line_count
            let header = "runtimepath [ 0"
        else
            let header = "runtimepath [ "
        endif
        call boot#log_silent(g:log_address, "" . header . line_count ." ]", path, g:fixed_tips_width, g:log_verbose)
        let line_count += 1
    endfor
else
    " " :echo "runtimepath\t: ".&runtimepath
    " " call boot#chomped_system("echo \"runtimepath: \"".&runtimepath)
    " call boot#log_silent(g:log_address, "runtimepath", &runtimepath, g:fixed_tips_width, g:log_verbose)
    " " silent! execute '!printf "runtimepath: '.&runtimepath.'" >> '. g:log_address . ' 2>&1 &'
endif

" debug flag
" breakadd here

call boot#log_silent(g:log_address, "\n", "", g:fixed_tips_width, g:log_verbose)

if filereadable('.vimrc.local')
    " Good one
    " source .test.txt
    " Good one
    " execute 'source .test.txt'

    " source '.vimrc.localfile'  " can't open file
    " source ".vimrc.localfile"  " infinitly run when re source the container file

    execute 'source .vimrc.local'
endif


" " WhichKey move focused window from current to the right/next one"
" " vim-which-key is vim port of emacs-which-key that displays available keybindings in popup.
" " https://github.com/liuchengxu/vim-which-key
" nnoremap <silent> <leader> :WhichKey '\' <cr>
" " By default timeoutlen is 1000 ms
" set timeoutlen=500

" User defined key maps
function! s:keys_reload()
    " packadd keys
    " Don't do this manually before all plugins loaded, keys.vim will not notice vim-tmux-navigator correctly -- even you put it after vim-tmux-navigator
    " if ! exists('g:keys_loaded')
    "     let keys_load_path = g:plugin_dir['vim'] . '/after/plugin/keys.vim'
    "     execute "source " .   keys_load_path
    "     execute "runtime! " . keys_load_path
    " endif

    if exists('g:keys_loaded')
        unlet g:keys_loaded
    endif
    " let g:debug_keys    = 1
    let keys_load_path  = g:plugin_dir['vim'] . '/after/plugin/keys.vim'
    silent! execute "source " . keys_load_path
    silent! execute "runtime! " . keys_load_path
endfunction

command! -nargs=0 KL :call s:keys_reload()




" "initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"




" "Begin vim-packager Scripts vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
" "Begin vim-packager Scripts vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

function! s:lightline_disable()
    let runtime_index = stridx(&runtimepath, 'lightline')
    if -1 != runtime_index
        let rtp_list = maktaba#rtp#split()
        exe 'set runtimepath-='. rtp_list[runtime_index]
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
    set laststatus =2

endfunction

filetype off




" https://www.reddit.com/r/vim/comments/edcgkk/do_you_recommend_using_vim_8s_new_packpath_to/
" https://github.com/kristijanhusak/vim-packager
" git clone https://github.com/kristijanhusak/vim-packager ~/.vim/pack/packager/opt/vim-packager


let g:vim_packages_use = {}
let g:vim_packages_use['morhetz/gruvbox']                            = {}
let g:vim_packages_use['kristijanhusak/vim-packager']                = { 'type' : 'opt' }
let g:vim_packages_use['vimwiki/vimwiki']                            = { 'type' : 'opt' }
let g:vim_packages_use['Shougo/unite-outline']                       = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-surround']                         = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-repeat']                           = { 'type' : 'opt' }
let g:vim_packages_use['tpope/vim-scriptease']                       = { 'type' : 'opt' }
let g:vim_packages_use['junegunn/vader.vim']                         = { 'type' : 'opt' }
let g:vim_packages_use['kana/vim-vspec']                             = { 'type' : 'opt' }
let g:vim_packages_use['drmingdrmer/xptemplate']                     = { 'type' : 'opt' }
let g:vim_packages_use['rscarvalho/OpenProject.vim']                 = { 'type' : 'opt' }
let g:vim_packages_use['kasandell/Code-Pull']                        = { 'type' : 'opt' }
let g:vim_packages_use['vim-scripts/genutils']                       = { 'type' : 'opt' }
let g:vim_packages_use['benmills/vimux']                             = { 'type' : 'opt' }
let g:vim_packages_use['powerline/powerline']                        = { 'type' : 'opt' }
let g:vim_packages_use['itchyny/lightline.vim']                      = { 'type' : 'opt' }  " Status line
let g:vim_packages_use['Yggdroot/indentLine']                        = { 'type' : 'opt' }  " File format

" Insert condition here means telling manager to remove the plugin's local copy
" Using redir in execute triggers an error in vim
" if exists('g:use_indent_guides')
let g:vim_packages_use['nathanaelkane/vim-indent-guides']            = { 'type' : 'opt' }  " File format visible
" endif

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

let g:vim_packages_use['svermeulen/vim-cutlass']                     = { 'type' : 'start' }  " Cutlass overrides the delete operations to actually just delete and not affect the current yank
let g:vim_packages_use['google/vim-maktaba']                         = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/vim-buffergator']               = { 'type' : 'start' }  " minibufexplorer
let g:vim_packages_use['ronakg/quickr-cscope.vim']                   = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-dispatch']                         = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-commentary']                       = { 'type' : 'start' }
let g:vim_packages_use['jasonccox/vim-wayland-clipboard']            = { 'type' : 'start' }
let g:vim_packages_use['vim-scripts/RltvNmbr.vim']                   = { 'type' : 'start' }  " File format
let g:vim_packages_use['editorconfig/editorconfig-vim']              = { 'type' : 'start' }  " File format
let g:vim_packages_use['vim-autoformat/vim-autoformat']              = { 'type' : 'start' }  " File format
let g:vim_packages_use['junegunn/vim-easy-align']                    = { 'type' : 'start' }  " File format
let g:vim_packages_use['rhysd/vim-clang-format']                     = { 'type' : 'start' }  " File format
let g:vim_packages_use['roman/golden-ratio']                         = { 'type' : 'start' }  " File format
let g:vim_packages_use['godlygeek/tabular']                          = { 'type' : 'start' }  " File format
let g:vim_packages_use['drmingdrmer/vim-toggle-quickfix']            = { 'type' : 'start' }
let g:vim_packages_use['itchyny/vim-qfedit']                         = { 'type' : 'start' }
let g:vim_packages_use['lervag/vimtex']                              = { 'type' : 'start' }
let g:vim_packages_use['jesseleite/vim-agriculture']                 = { 'type' : 'start' }
let g:vim_packages_use['ggreer/the_silver_searcher']                 = { 'type' : 'start' }
let g:vim_packages_use['BurntSushi/ripgrep']                         = { 'type' : 'start' }
let g:vim_packages_use['preservim/vim-colors-pencil']                = { 'type' : 'start' }
let g:vim_packages_use['chriskempson/base16-vim']                    = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/unsuck-flat']                   = { 'type' : 'start' }
let g:vim_packages_use['skywind3000/asyncrun.vim']                   = { 'type' : 'start', 'do' : 'chmod -R a+r ./* && chown -R root:users ./'}
let g:vim_packages_use['skywind3000/asynctasks.vim']                 = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-rhubarb']                          = { 'type' : 'start' }  " Gbrowse
let g:vim_packages_use['tpope/vim-fugitive']                         = { 'type' : 'start' }  " Gblame
let g:vim_packages_use['liuchengxu/vim-which-key']                   = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern.vim']                       = { 'type' : 'start' }
let g:vim_packages_use['liquidz/vim-iced']                           = { 'type' : 'start', 'for' : 'clojure' }
let g:vim_packages_use['liquidz/vim-iced-fern-debugger']             = { 'type' : 'start', 'for' : 'clojure' }
let g:vim_packages_use['lambdalisue/fern-hijack.vim']                = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-mapping-project-top.vim']   = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-git-status.vim']            = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-renderer-nerdfont.vim']     = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-ssh']                       = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-bookmark.vim']              = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-mapping-git.vim']           = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-mapping-mark-children.vim'] = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-mapping-quickfix.vim']      = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-comparator-lexical.vim']    = { 'type' : 'start' }
let g:vim_packages_use['lambdalisue/fern-renderer-devicons.vim']     = { 'type' : 'start' }
let g:vim_packages_use['hrsh7th/fern-mapping-call-function.vim']     = { 'type' : 'start' }
let g:vim_packages_use['hrsh7th/fern-mapping-collapse-or-leave.vim'] = { 'type' : 'start' }
let g:vim_packages_use['LumaKernel/fern-mapping-reload-all.vim']     = { 'type' : 'start' }
let g:vim_packages_use['LumaKernel/fern-mapping-fzf.vim']            = { 'type' : 'start' }
let g:vim_packages_use['liquidz/vim-iced-fern-debugger']             = { 'type' : 'start' }
let g:vim_packages_use['hashivim/vim-terraform']                     = { 'type' : 'start' }
let g:vim_packages_use['terryma/vim-multiple-cursors']               = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-eunuch']                           = { 'type' : 'start' }
let g:vim_packages_use['chrisbra/SudoEdit.vim']                      = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-surround']                         = { 'type' : 'start' }
let g:vim_packages_use['editorconfig/editorconfig-vim']              = { 'type' : 'start' }
let g:vim_packages_use['mattn/emmet-vim']                            = { 'type' : 'start' }
let g:vim_packages_use['w0rp/ale']                                   = { 'type' : 'start' }
let g:vim_packages_use['airblade/vim-gitgutter']                     = { 'type' : 'start' }
let g:vim_packages_use['shemerey/vim-project']                       = { 'type' : 'start' }
let g:vim_packages_use['xolox/vim-misc']                             = { 'type' : 'start' }  " Debug errors pop-uping
let g:vim_packages_use['xolox/vim-reload']                           = { 'type' : 'start' }  " Debug errors pop-uping
let g:vim_packages_use['xolox/vim-session']                          = { 'type' : 'start' }
let g:vim_packages_use['mattolenik/vim-projectrc']                   = { 'type' : 'start' }
let g:vim_packages_use['majutsushi/ctags']                           = { 'type' : 'start' }
let g:vim_packages_use['majutsushi/tagbar']                          = { 'type' : 'start' }
let g:vim_packages_use['vhdirk/vim-cmake']                           = { 'type' : 'start' }
let g:vim_packages_use['gilligan/vim-lldb']                          = { 'type' : 'start' }
let g:vim_packages_use['mileszs/ack.vim']                            = { 'type' : 'start' }
let g:vim_packages_use['mhinz/vim-grepper']                          = { 'type' : 'start' }
let g:vim_packages_use['LucHermitte/vim-refactor']                   = { 'type' : 'start' }
let g:vim_packages_use['MarcWeber/vim-addon-background-cmd']         = { 'type' : 'start' }
let g:vim_packages_use['lifepillar/vim-mucomplete']                  = { 'type' : 'start' }  " Code completion
let g:vim_packages_use['junegunn/fzf']                               = { 'type' : 'start', 'do' : './install --all && ln -s $(pwd) ~/.fzf' }
let g:vim_packages_use['junegunn/fzf.vim']                           = { 'type' : 'start' }
let g:vim_packages_use['xavierd/clang_complete']                     = { 'type' : 'start' }
let g:vim_packages_use['christoomey/vim-tmux-navigator']             = { 'type' : 'start' }
let g:vim_packages_use['tmux-plugins/vim-tmux-focus-events']         = { 'type' : 'start' }
let g:vim_packages_use['RyanMillerC/better-vim-tmux-resizer']        = { 'type' : 'start' }
let g:vim_packages_use['thinca/vim-themis']                          = { 'type' : 'start' }
let g:vim_packages_use['mhinz/vim-galore']                           = { 'type' : 'start' }
let g:vim_packages_use['plasticboy/vim-markdown']                    = { 'type' : 'start' }
let g:vim_packages_use['jgdavey/tslime.vim']                         = { 'type' : 'start' }
let g:vim_packages_use['zdharma-continuum/zinit-vim-syntax']         = { 'type' : 'start' }
let g:vim_packages_use['leafgarland/typescript-vim']                 = { 'type' : 'start' }
let g:vim_packages_use['chrisbra/Recover.vim']                       = { 'type' : 'start' }
let g:vim_packages_use['preservim/vim-textobj-quote']                = { 'type' : 'start' }
let g:vim_packages_use['kana/vim-textobj-user']                      = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/mkdx']                          = { 'type' : 'start' }
let g:vim_packages_use['trailblazing/cscope_auto']                   = { 'type' : 'start', 'requires' : 'trailblazing/boot' }
let g:vim_packages_use['trailblazing/session_auto']                  = { 'type' : 'start', 'requires' : 'trailblazing/boot' }
let g:vim_packages_use['trailblazing/boot']                          = { 'type' : 'start' }
let g:vim_packages_use['kmonad/kmonad-vim']                          = { 'type' : 'start' }
let g:vim_packages_use['skywind3000/vim-quickui']                    = { 'type' : 'start' }
let g:vim_packages_use['itchyny/vim-gitbranch']                      = { 'type' : 'start' }
let g:vim_packages_use['mbbill/undotree']                            = { 'type' : 'start', 'do' : 'find $(pwd) -type f -exec chmod g+r {} + -o -type d -exec chmod go+rx {} + && chgrp -R users $(pwd)' }
let g:vim_packages_use['prabirshrestha/vim-lsp']                     = { 'type' : 'start' }
let g:vim_packages_use['sheerun/vim-polyglot']                       = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-sleuth']                           = { 'type' : 'start' }
let g:vim_packages_use['inkarkat/vim-ShowTrailingWhitespace']        = { 'type' : 'start' }
let g:vim_packages_use['inkarkat/vim-ingo-library']                  = { 'type' : 'start' }
let g:vim_packages_use['marklcrns/vim-smartq']                       = { 'type' : 'start' }
let g:vim_packages_use['sbdchd/neoformat']                           = { 'type' : 'start' }
let g:vim_packages_use['spindensity/vim-goldendict']                 = { 'type' : 'start' }
let g:vim_packages_use['tpope/vim-unimpaired']                       = { 'type' : 'start' }
let g:vim_packages_use['justinmk/vim-dirvish']                       = { 'type' : 'start' }
let g:vim_packages_use['vim-scripts/a.vim']                          = { 'type' : 'start' }
let g:vim_packages_use['janlazo/vim-bang-terminal']                  = { 'type' : 'start' }
let g:vim_packages_use['rickhowe/diffchar.vim']                      = { 'type' : 'start' }
let g:vim_packages_use['rickhowe/spotdiff.vim']                      = { 'type' : 'start' }

" " Provide full URL; useful if you want to clone from somewhere else than Github.
" let g:vim_packages_use['https://my.other.public.git/tpope/vim-fugitive.git'] = {}
" " Provide SSH-based URL; useful if you have write access to a repository and wish to push to it
" let g:vim_packages_use['git@github.com:mygithubid/myrepo.git']               = {}

" Loaded only for specific filetypes on demand. Requires autocommands below.
let g:vim_packages_use['kristijanhusak/vim-js-file-import']                  = { 'type' : 'opt', 'do' : 'npm install' }

" let g:vim_packages_use['fatih/vim-go']                                       = { 'type' : 'opt', 'do' : ':GoInstallBinaries' }
" let g:vim_packages_use['neoclide/coc.nvim']                                  = { 'do'   : function('InstallCoc') }  " code completion
" let g:vim_packages_use['weirongxu/coc-explorer']                             = { 'do'   : function('InstallCoc') }

let g:vim_packages_use['sonph/onehalf']                                      = { 'rtp'  : 'vim' }

function! s:adjust_attributes(plugin_list, plugin_dir, package_manager, log_address, fixed_tips_width, log_verbose)
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
            call boot#log_silent(a:log_address, l:func_name . '::' . "a:plugin_list::item", item, a:fixed_tips_width, a:log_verbose)
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
        echo "item = \"" . item . "\""
        call boot#log_silent(a:log_address, l:func_name . '::' . "item", item, a:fixed_tips_width, a:log_verbose)
        echo "domain_removed = \"" . domain_removed . "\""
        call boot#log_silent(a:log_address, l:func_name . '::' . "domain_removed", domain_removed, a:fixed_tips_width, a:log_verbose)
        echohl None
        let installation_dict = filter(deepcopy(g:vim_packages_use), {key -> split(key, '/')[-1] ==? item})
        for key in keys(installation_dict)
            call boot#log_silent(a:log_address, l:func_name . '::installation_dict::' . "key", key, a:fixed_tips_width, a:log_verbose)
            let installation_type = installation_dict[key]['type']
            let path = l:packages_prefix . '/' . installation_type . '/' . domain_removed
            call boot#log_silent(a:log_address, l:func_name . '::' . "path", path, a:fixed_tips_width, a:log_verbose)
            let l:packages_path = l:packages_path . '"' . path . '" '
            call boot#log_silent(a:log_address, l:func_name . '::' . "l:packages_path", l:packages_path, a:fixed_tips_width, a:log_verbose)

            let l:packages_path_list +=  ["'" . path . "'"]
        endfor
    endfor
    " echo "l:packages_path = " l:packages_path
    " call boot#log_silent(a:log_address, l:func_name . '::' . "l:packages_path", l:packages_path, a:fixed_tips_width, a:log_verbose)
    for item in l:packages_path_list
        call boot#log_silent(a:log_address, l:func_name . '::l:packages_path_list::' . "item", item, a:fixed_tips_width, a:log_verbose)
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
    let command = '!(set -f; command doas find ' . l:packages_path . ' -type f -name ' . shellescape('*', 1) . ' -exec sh -c ' . shellescape('
                \set -f; for file;
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

    call boot#log_silent(a:log_address, l:func_name . "::command", command, a:fixed_tips_width, a:log_verbose)
    silent! execute command
    redraw!
    function! s:result(packages_path)
        return boot#chomped_system('stat -L -c "%A %a %U %G" ' . a:packages_path)
    endfunction
    for item in l:packages_path_list
        call boot#log_silent(a:log_address, l:func_name, s:result(item) . ' ' . item, a:fixed_tips_width, a:log_verbose)
    endfor
    let result = 0
    return result
endfunction

function! s:adjust_init_helper(arg_list)
    return { g:plugin_dir['vim'], g:package_manager['vim'], g:log_address, g:fixed_tips_width, g:log_verbose ->
                \ return s:adjust_attributes(arg_list, plugin_dir, package_manager, log_address, fixed_tips_width, log_verbose) }
endfunction

" let g:use_setup_minpac = 1
" let g:use_setup_reference = 1
let g:use_setup_packager = 1

if exists('g:use_setup_minpac')

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

    command! PackUpdate source $MYVIMRC <bar> call s:pack_init(g:plugin_dir['vim'])  <bar> call minpac#update()
    command! PackClean  source $MYVIMRC <bar> call s:pack_init(g:plugin_dir['vim'])  <bar> call minpac#clean()
    command! PackStatus packadd minpac  <bar> call minpac#status()

    function! s:pack_list(...)
        call s:pack_init(g:plugin_dir['vim'])
        return join(sort(keys(minpac#getpluglist())), "\n")
    endfunction

    command! -nargs=1 -complete=custom,s:pack_list
                \ PackOpenDir call s:pack_init(g:plugin_dir['vim'])  <bar> call term_start(&shell,
                \    {'cwd': minpac#getpluginfo(<q-args>).dir,
                \     'term_finish': 'close'})

    command! -nargs=1 -complete=custom,s:pack_list
                \ PackOpenUrl call s:pack_init(g:plugin_dir['vim'])  <bar> call openbrowser#open(
                \    minpac#getpluginfo(<q-args>).url)

    call s:pack_init(g:plugin_dir['vim'])

elseif exists('g:use_setup_reference')

    function! s:packager_init_ref(packager) abort

        for [key, value] in items(g:vim_packages_use)
            call a:packager.add(key, value)
        endfor

        " call a:packager.local('~/my_vim_plugins/my_awesome_plugin')
        " call a:packager.local(g:plugin_dir['vim'] . '/backup/pack/' . g:package_manager['vim'] . '/start/utilities/scriptnames.vim',            { 'type' : 'start' })

        " call a:packager.local(g:plugin_dir['vim'] . '/backup/pack/' . g:package_manager['vim'] . '/start/cscope_auto/plugin/cscope_auto.vim',   { 'type' : 'start' })
        " call a:packager.local(g:plugin_dir['vim'] . '/backup/pack/' . g:package_manager['vim'] . '/start/session_auto/plugin/session_auto.vim', { 'type' : 'start' })

        " call a:packager.local(g:plugin_dir['vim'] . '/backup/pack/' . g:package_manager['vim'] . '/start/keys/plugin/keys.vim', { 'type' : 'start' })

        " call a:packager.local($VIMRUNTIME.'/filetype.vim',         { 'type' : 'start' })
        " call a:packager.local($VIMRUNTIME.'/syntax/syntax.vim',    { 'type' : 'start' })
    endfunction

    packadd vim-packager
    " The second parameter is to set the packages installation location: where to put /pack/*/start and /pack/*/opt
    call packager#setup(function('s:packager_init_ref'), g:plugin_dir['vim'])

elseif exists('g:use_setup_packager')

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
                "     "             \ a:package_manager . "\", \"" . g:log_address . "\", " . g:fixed_tips_width . ", " . g:log_verbose . ")"
                " else
                "     let value['do'] = a:function_adjust_init_helper
                "     " let value['do'] = "call <sid>adjust_attributes(\"" . domain_removed . "\", \"" . a:plugin_dir . "\", \"" . a:package_manager .
                "     "             \ "\", \"" . g:log_address . "\", " . g:fixed_tips_width . ", " . g:log_verbose . ")"
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
    if ! has('nvim')
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



function! s:adjust_hook_helper(operating_type, plugin_list, plugin_dir, package_manager, log_address, fixed_tips_width, log_verbose)
    let l:func_name = boot#function_name(expand('<SID>'), expand('<sfile>'))
    if ! exists('g:loaded_vim_packager')
        call boot#log_silent(a:log_address, l:func_name . '::' . "! exists('g:loaded_vim_packager')", ! exists('g:loaded_vim_packager'), a:fixed_tips_width, a:log_verbose)
        return
    endif
    let l:plugins_explicit_to_be_processed = []
    let l:all_initialized_plugins = packager#plugins()
    let l:plugins_implicit_to_be_processed = []
    for item in l:all_initialized_plugins
        "for [key, value] in items(item)
        "    call boot#log_silent(a:log_address, l:func_name . '::l:all_initialized_plugins::' . key, value, a:fixed_tips_width, a:log_verbose)
        "endfor
        if item['installed'] ==? 0 && a:operating_type == 'install'
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
        let l:plugins_explicit_to_be_processed = filter(l:all_initialized_plugins, 'index(a:plugin_list, v:val.name) > -1')
    endif
    let remaining_jobs = len(l:plugins_explicit_to_be_processed)

    " if remaining_jobs ==? 0
    "     call boot#log_silent(a:log_address, l:func_name . '::' . "initial::len(l:plugins_explicit_to_be_processed)", remaining_jobs, a:fixed_tips_width, a:log_verbose)
    "     echo 'Nothing to update.'
    "     return
    " endif

    let l:explicit_item_name_list = []
    let l:implicit_item_name = ""
    for item in l:plugins_explicit_to_be_processed
        " echo "l:plugins_explicit_to_be_processed::item = \"" item "\""
        " call boot#log_silent(a:log_address, l:func_name . '::' . "initial::l:plugins_explicit_to_be_processed::item", item, a:fixed_tips_width, a:log_verbose)
        let domain_removed = split(item['name'], '/')[-1]
        echohl WarningMsg
        echo "item['name'] = \"" . item['name'] . "\""
        call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_explicit_to_be_processed::item['name']",
                    \ shellescape(item['name'], 1), a:fixed_tips_width, a:log_verbose)
        echo "domain_removed = \"" . domain_removed . "\""
        call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_explicit_to_be_processed::domain_removed",
                    \ shellescape(domain_removed, 1), a:fixed_tips_width, a:log_verbose)
        call add(l:explicit_item_name_list, domain_removed)
        let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
        echohl None
    endfor
    if len(l:plugins_explicit_to_be_processed) <= 0
        if len(l:plugins_implicit_to_be_processed) > 0
            for item in l:plugins_implicit_to_be_processed
                call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_implicit_to_be_processed::item['name']",
                            \ shellescape(item['name'], 1), a:fixed_tips_width, a:log_verbose)
                let domain_removed = split(item['name'], '/')[-1]
                call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_implicit_to_be_processed::domain_removed",
                            \ shellescape(domain_removed, 1), a:fixed_tips_width, a:log_verbose)
                let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
            endfor
        else
            for item in l:all_initialized_plugins
                call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_implicit_to_be_processed::item['name']",
                            \ shellescape(item['name'], 1), a:fixed_tips_width, a:log_verbose)
                let domain_removed = split(item['name'], '/')[-1]
                call boot#log_silent(a:log_address, l:func_name . '::' . "l:plugins_implicit_to_be_processed::domain_removed",
                            \ shellescape(domain_removed, 1), a:fixed_tips_width, a:log_verbose)
                let l:implicit_item_name = l:implicit_item_name . "'" . domain_removed . "', "
            endfor
        endif
    endif
    command! -nargs=* AdjustAttributes :call s:adjust_attributes(<args>, g:plugin_dir['vim'],
                \ g:package_manager['vim'], g:log_address, g:fixed_tips_width, g:log_verbose)
    for item in l:explicit_item_name_list
        call boot#log_silent(a:log_address, l:func_name . '::' . "l:explicit_item_name_list::item",
                    \ shellescape(item, 1), a:fixed_tips_width, a:log_verbose)
    endfor

    let result = {}
    let result['plugins'] = l:explicit_item_name_list

    call boot#log_silent(a:log_address, l:func_name . '::' . "len(result['plugins'])", len(result['plugins']),
                \ a:fixed_tips_width, a:log_verbose)
    for item in result['plugins']
        call boot#log_silent(a:log_address, l:func_name . '::' . "result['plugins']::item",
                    \ shellescape(item, 1), a:fixed_tips_width, a:log_verbose)
    endfor
    let command_for_on_finish = ":AdjustAttributes [" . l:implicit_item_name . "]"
    call boot#log_silent(a:log_address, l:func_name . '::' . "command_for_on_finish",
                \ shellescape(command_for_on_finish, 1), a:fixed_tips_width, a:log_verbose)
    let result['on_finish'] = command_for_on_finish

    " " E117: Unknown function: <SNR>18_adjust_attributes
    " let function_name = boot#get_snr('s:adjust_attributes')
    " let function_name = boot#get_snr('<sid>adjust_attributes')

    " let result['on_finish'] = "call " . a:function_name . "([" . l:item_path . "], \"" .  a:plugin_dir . "\", \"" .
    "             \ a:package_manager . "\", \"" . a:log_address . "\", " . a:fixed_tips_width . ", " . a:log_verbose . ")"

    " let result['on_finish'] = { l:plugins_explicit_to_be_processed, plugin_dir,
    "             \ package_manager, log_address, fixed_tips_width, log_verbose -> s:adjust_attributesl(l:plugins_explicit_to_be_processed, plugin_dir,
    "             \ package_manager, log_address, fixed_tips_width, log_verbose) }
    return result
endfunction


if exists('g:use_setup_packager')

    " command! PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#install()
    " command! -bang PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#update({ 'force_hooks': '<bang>' })
    " command! PackagerClean call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#clean()
    " command! PackagerStatus call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#status()

    " These commands are automatically added when using `packager#setup()`  " don't overload it again
    " :PackagerInstall "rhysd/vim-clang-format"
    " :PackagerInstall "[\"rhysd/vim-clang-format\", \"justinmk/vim-dirvish\"]"
    " :PackagerInstall ['vim-dirvish', 'fzf']
    " command! -nargs=* -bar PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
    "             \ | call packager#install(<args>)

    command! -nargs=* -bar PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
                \ | call packager#install(s:adjust_hook_helper('install', <args>,
                \  g:plugin_dir['vim'], g:package_manager['vim'],
                \  g:log_address, g:fixed_tips_width, g:log_verbose))

    " " How about <args> is empty? even not an []
    " command! -nargs=* -bar PackagerInstall call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
    "             \ | call packager#install({'plugins' : <args>,
    "             \ 'on_finish' : "call <sid>adjust_attributes(" . <q-args> . ", \"" . g:plugin_dir['vim'] . "\", \"" . g:package_manager['vim'] . "\",
    "             \ \"" . g:log_address . "\", " . g:fixed_tips_width . ", " . g:log_verbose . ")"})

    " command! -nargs=* -bar PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
    "             \ | call packager#update(<args>)
    command! -nargs=* -bar PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
                \ | call packager#update(s:adjust_hook_helper('update', <args>,
                \  g:plugin_dir['vim'], g:package_manager['vim'],
                \  g:log_address, g:fixed_tips_width, g:log_verbose))

    " " How about <args> is empty? even not an []
    " command! -nargs=* -bar PackagerUpdate call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim'])
    "             \ | call packager#update({'plugins' : <args>,
    "             \ 'on_finish' : "call <sid>adjust_attributes(<args>, \"" . g:plugin_dir['vim'] . "\", \"" . g:package_manager['vim'] . "\",
    "             \ \"" . g:log_address . "\", " . g:fixed_tips_width . ", " . g:log_verbose . ")"})

    command! -bar PackagerClean  call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#clean()
    command! -bar PackagerStatus call s:packager_init(g:plugin_dir['vim'], g:package_manager['vim']) | call packager#status()
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

if has('nvim')

    " https://www.reddit.com/r/vim/comments/8mqs7t/how_to_really_turn_off_autoindent/
    augroup lua_no_indent
        au!
        autocmd FileType lua setlocal nocindent nosmartindent noautoindent
    augroup end

    lua plugins = require('plugins')
    lua if vim.fn.empty(vim.inspect(plugins)) > 0 then plugins.install() end


    call s:lightline_disable()
    " lua require("slanted")
    " lua require('plugins'):requireRel("slanted-gaps")
    " lua require("slanted")
    lua lualine = require('lualine')
    lua lualine.setup{options = {icons_enabled = true, theme = 'slanted'}}

    " format will demage EOF from inserting spaces before it
    " lua << EOF
    " -- if vim.fn.empty(vim.inspect(vim.api.nvim_eval(plugins))) > 0 then
    " if vim.fn.empty(vim.inspect(plugins)) > 0 then
    "     plugins.install()
    "     -- lua plugins.startup()
    "     -- lua plugins.update()
    " end
    " EOF


    function! s:refresh()
        " call s:lightline_disable()
        if &filetype !~# '\v(help|txt|log)'
            " " v:lua.require'plugins'.install()
            setlocal list
            :IndentBlanklineEnable!
            " lua require'plugins'.install()
            " " :PackerCompile
            " redraw!
        else
            set colorcolumn=""
            setlocal nolist
            :IndentBlanklineDisable!
            redraw!
        endif
    endfunction

    function! s:lua_update()
        if $USER ==# 'root'
            lua require'plugins'.install()
            :PackerCompile
        else
            lua require'plugins'.startup()
        endif
    endfunction

    function! s:update_init()
        source <afile>
        " v:lua.require'plugins'.install()
        lua require'plugins'.install()
        :PackerCompile
        call keys_reload()
        redraw!
    endfunction

    call s:lua_update()

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


    let mucomplete#no_mappings = 1

    " https://www.reddit.com/r/vim/comments/oywg54/how_to_remap_tab_without_affecting_ctrli/
    nnoremap <c-i> i
    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    unmap <c-i>

    " Avoid showing message extra message when using completion
    set shortmess+=c

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
    " "             \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"

    " " possible value: "length", "alphabet", "none"
    " let g:completion_sorting = "alphabet"

    " let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

    " let g:completion_trigger_character = ['.', '::']

    " augroup CompletionTriggerCharacter
    "     autocmd!
    "     autocmd BufEnter * let g:completion_trigger_character = ['.']
    "     autocmd BufEnter *.c,*.cpp,*.cxx,*.hxx,*.inl,*.impl,*.h,*.hpp let g:completion_trigger_character = ['.', '::']
    " augroup end

    " https://github.com/antoinemadec/FixCursorHold.nvim
    " in millisecond, used for both CursorHold and CursorHoldI,
    " use updatetime instead if not defined
    let g:cursorhold_updatetime = 100

    let g:lens#width_resize_max = 160
    let g:lens#width_resize_min = 20
    let g:lens#height_resize_max = 120
    let g:lens#height_resize_min = 5

    let g:golden_ratio_exclude_nonmodifiable = 1

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
    packadd lightline.vim
    packadd indentLine
    " packadd vim-indent-guides
endif
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




" "color settings ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

" h term-dependent-settings
set termguicolors
let base16colorspace=256  " Access colors present in 256 colorspace

" https://www.reddit.com/r/vim/comments/f3v3lq/syntax_highlighting_changes_while_using_tmux/
if empty($TMUX)
    if has('nvim')
        let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    endif
    if has('termguicolors')
        set termguicolors
    endif
endif

" Enable 24-bit true colors if your terminal supports it.
if has('termguicolors')
    " https://github.com/vim/vim/issues/993#issuecomment-255651605
    if has('vim_starting') && ! has('gui_running') && ! has('nvim')
        let &t_8f = "\e[38;2;%lu;%lu;%lum"
        let &t_8b = "\e[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
endif




" " https://github.com/nathanaelkane/vim-indent-guides/issues/109
" " Guides not showing up the first time with colorscheme desert #109
" let g:indent_guides_color_name_guibg_pattern = "guibg='?\zs[0-9A-Za-z]+\ze'?"


augroup unfold
    au!
    au BufWinEnter * normal! zv
augroup END

set background=dark
" set background=light

silent! execute '!export TERM=xterm-256color'

if ! has('gui_running')
    " https://github.com/tmux/tmux/issues/699
    set t_Co=256  " Note: Neovim ignores t_Co and other terminal codes.
endif



" packadd vim-airline
" packadd vim-airline-themes


" https://github.com/preservim/vim-colors-pencil
" https://github.com/chriskempson/base16
" https://github.com/chriskempson/base16-vim/tree/master/colors
" let g:theme_name = "unsuck-flat"
" let g:theme_name = "sierra"
" let g:theme_name = "base16-default-dark"
" let g:theme_name = "base16-tomorrow-night"
" let g:theme_name = "base16-flat"
" let g:theme_name = "pencil"
let g:theme_name = "pencil"

" https://github.com/vim-airline/vim-airline-themes/tree/master/autoload/airline/themes
" https://github.com/vim-airline/vim-airline/wiki/Screenshots
" let g:airline_theme             = 'pencil'
" let g:airline_theme             = 'base16-default-dark'
" let g:airline_theme             = 'tomorrow'
" let g:airline_theme             = 'fruit_punch'
" let g:airline_theme             = 'badwolf'
" let g:airline_theme             = 'hybridline'

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

        let g:unite_force_overwrite_statusline    = 0
        let g:vimfiler_force_overwrite_statusline = 0
        let g:vimshell_force_overwrite_statusline = 0

    endif
else
    call s:lightline_disable()
endif

silent! exe 'colorscheme ' . g:theme_name
augroup color_scheme | au!
    " https://stackoverflow.com/questions/51129631/vim-8-1-garbage-printing-on-screen
    autocmd VimEnter *
                \ if ! exists('g:colors_name') || g:colors_name !=# g:theme_name |
                \ silent! exe '++nested colorscheme ' . g:theme_name |
                \ endif
    " autocmd VimEnter * silent! exe '++nested colorscheme ' . g:theme_name
augroup END

" function! s:sdjust_solarized()
"     hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg
" endfunction
"
" augroup sierra
"     autocmd!
"     " autocmd ColorScheme sierra call s:sdjust_solarized()
"     autocmd ColorScheme pencil call s:sdjust_solarized()
" augroup END


" :set background=light
" https://www.iditect.com/how-to/53501604.html
let g:pencil_termtrans          = 1
let g:pencil_termcolors         = 256
let g:pencil_terminal_italics   = 1
let g:pencil_spell_undercurl    = 1     " 0=underline,  1=undercurl (def)
let g:pencil_gutter_color       = 1     " 0=mono (def), 1=color
let g:pencil_neutral_code_bg    = 1     " 0=gray (def), 1=normal
let g:pencil_neutral_headings   = 1     " 0=blue (def), 1=normal
let g:pencil_higher_contrast_ui = 0     " 0=low  (def), 1=high


let g:powerline_pycmd            = "py3"


function! s:delmarks()
    let l:m = join(filter(
                \ map(range(char2nr('a'), char2nr('z')), 'nr2char(v:val)'),
                \ 'line("''".v:val) == line(".")'))
    if !empty(l:m)
        exe 'delmarks' l:m
    endif
endfunction
nnoremap <silent> dm :<c-u>call <sid>delmarks()<cr>

if exists("g:indentLine_loaded")
    " https://github.com/Yggdroot/indentLine
    " For Yggdroot/indentLine
    let g:indentLine_setColors       = 0
    " let g:indentLine_defaultGroup    = 'SpecialKey'

    " GVim
    let g:indentLine_color_gui       = '#A4E57E'

    " none X terminal
    let g:indentLine_color_tty_light = 1 " (default: 4)
    let g:indentLine_color_dark      = 1 " (default: 2)

    " Background (Vim, GVim)
    " Vim
    " let g:indentLine_color_term      = 239
    " " let g:indentLine_bgcolor_term    = 202
    " let g:indentLine_bgcolor_gui     = '#4E4E4E'
    " " let g:indentLine_bgcolor_gui     = '#FF5F00'
    let g:indentLine_conceallevel    = 2
    " https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
    let g:indentLine_fileTypeExclude = ['json']
    let g:indentLine_fileTypeExclude = ['markdown']

    " let g:indentLine_setConceal      = 0
    let g:indentLine_setConceal      = 2

    " default ''.
    " n for Normal mode
    " v for Visual mode
    " i for Insert mode
    " c for Command line editing, for 'incsearch'

    " let g:indentLine_concealcursor   = 'inc'
    let g:indentLine_concealcursor   = ""

    let g:indentLine_enabled         = 1

    " let g:indentLine_char            = '▏'
    " let g:indentLine_char            = '▏'
    let g:indentLine_char            = '│' " ctrl-k+vv
    " let g:indentLine_char_list       = ['|', '¦', '┆', '┊']
endif

" https://vi.stackexchange.com/questions/666/how-to-add-indentation-guides-lines
set cursorline
set nocursorcolumn

let g:indent_blankline_disable_with_nolist = v:true
let g:indent_blankline_show_trailing_blankline_indent = v:false
let g:indent_blankline_show_first_indent_level = v:false
let g:indent_blankline_filetype_exclude = ['help', 'txt'. 'log']
let g:indent_blankline_buftype_exclude = ['terminal']
let g:indent_blankline_show_current_context_start_on_current_line = v:false
let g:indent_blankline_viewport_buffer = 20

" cnoreabbrev <expr> help ((getcmdtype() is# ':' && getcmdline() is# 'help')?('vert help'):('help'))
" cnoreabbrev <expr> h ((getcmdtype()    is# ':' && getcmdline() is# 'h')?('vert help'):('h'))
augroup backgroung_color
    au!
    au BufEnter,WinEnter * if &filetype !~# '\v(help|txt|log)'  |
                \ set colorcolumn=120  |
                \ else  |
                \ wincmd L | set colorcolumn="" | setlocal nolist | :IndentBlanklineDisable! | redraw! |
                \ endif
    " \ | " let &colorcolumn="80,".join(range(120,999),",") | " \ exe 'set colorcolumn="80,".join(range(120,999),",")' |
    autocmd FileType,WinNew txt,help,log set colorcolumn="" | setlocal nolist | :IndentBlanklineDisable! | redraw!
    autocmd WinNew txt,help,log wincmd L | set colorcolumn="" | setlocal nolist | :IndentBlanklineDisable! | redraw!
    " au FileType,BufEnter,WinNew txt set colorcolumn="" && redraw!
augroup END

" https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" make window 80 + some for numbers wide

" Shrink window width to given size
noremap <Leader>w :let @w=float2nr(log10(line("$")))+82\|:vertical resize <c-r>w<cr>

" au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%80v.\+', -1)





" :nnoremap <leader>c :set cursorline! cursorcolumn!<cr>
nnoremap <silent> <leader>l ml:execute 'match Search /\%'.line('.').'l/'<cr>
" :nnoremap <silent> <leader>c :execute 'match Search /\%'.virtcol('.').'v/'<cr>

" http://www.pixelbeat.org/docs/terminal_colours/

let g:cursor_guifg_insertenter   = 'DarkYellow'
let g:cursor_guibg_insertenter   = 'Black'

let g:cursor_guifg_insertleave   = 'NONE'
if 'linux' == $TERM
    " let g:cursor_guibg_insertleave = 'Brown'
    let g:cursor_guibg_insertleave = 'NONE'
else
    " let g:cursor_guibg_insertleave = '#000000'
    let g:cursor_guibg_insertleave = 'NONE'
endif

let g:cursor_ctermfg_insertenter = 'DarkYellow'
let g:cursor_ctermbg_insertenter = 'Black'

" Warning: Color name "Background" is not defined. "NONE" is not a eligile argument for cterm colors
let g:cursor_ctermfg_insertleave = 'NONE'
if 'linux' == $TERM
    " let g:cursor_ctermbg_insertleave = 8
    let g:cursor_ctermbg_insertleave = 'NONE'
else
    " let g:cursor_ctermbg_insertleave = 8
    let g:cursor_ctermbg_insertleave = 'NONE'
endif

let g:nontext_fg_cterm = 241
let g:nontext_fg_gui = 'gray'

" :highlight Normal ctermfg=grey ctermbg=darkgrey guifg=white guibg=#000000 gui=NONE ctermfg=NONE ctermbg=black cterm=NONE term=NONE
" :highlight Normal guifg=fg guibg=bg ctermfg=NONE ctermbg=2 gui=NONE cterm=NONE term=NONE

highlight Normal guifg=fg guibg=NONE ctermfg=fg ctermbg=0 gui=NONE cterm=NONE term=NONE
highlight FileStyleIgnorePattern guibg=bg ctermbg=0

" https://vi.stackexchange.com/questions/6150/a-highlight-command-resets-previously-declared-highlights
hi NewLineWin ctermfg=248 guifg=#999999
match NewLineWin /\r\n/
hi WhiteSpaceChar ctermfg=252 guifg=#999999
2match WhiteSpaceChar / /
" https://stackoverflow.com/questions/24232354/vim-set-color-for-listchars-tabs-and-spaces
hi Whitespace ctermfg=DarkGray guifg=DarkGray
match Whitespace /\s/
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

highlight SpecialKey ctermfg=bg guifg=bg

" vim-ShowTrailingWhitespace. works under pure terminal emulator without window managers
highlight ShowTrailingWhitespace ctermbg=Red guibg=Red


" "~" vertically under the line numbers
" That command should set the color of non text characters to be the same as the background color.
" hi NonText guifg=bg
" highlight NonText ctermfg=7 guifg=gray
silent! execute 'highlight NonText ctermfg=' . g:nontext_fg_cterm . ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

" hi LineNr guibg=fg
" highlight LineNr ctermbg=0 guibg=NONE ctermfg=7 guifg=gray
silent! execute 'highlight LineNr ctermfg=' . g:nontext_fg_cterm . ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

" https://newbedev.com/highlighting-the-current-line-number-in-vim
hi clear CursorLine
augroup CLClear
    au!
    autocmd ColorScheme * hi clear CursorLine
    autocmd ColorScheme * highlight CursorLine ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE cterm=NONE gui=NONE term=NONE
augroup END
augroup CLNRSet
    au!
    autocmd ColorScheme * hi CursorLineNR ctermbg=NONE ctermfg=15 guibg=NONE guifg=white cterm=NONE gui=NONE term=NONE
augroup END
highlight CursorLineNR ctermbg=NONE ctermfg=15 guibg=NONE guifg=white cterm=NONE gui=NONE term=NONE

" https://gitanswer.com/vim-allow-customization-of-endofbuffer-character-vim-script-400592109
" highlight EndOfBuffer ctermfg=0 ctermbg=NONE guifg=bg guibg=NONE
highlight EndOfBuffer ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
augroup end_of_buffer
    au!
    autocmd ColorScheme,SourcePost * highlight EndOfBuffer ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
                \ | silent! execute 'highlight NonText ctermfg=' . g:nontext_fg_cterm . ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'
augroup end

set foldlevel=1
" https://stackoverflow.com/questions/2531904/how-do-i-increase-the-spacing-of-the-line-number-margin-in-vim
set nuw        =7
set foldcolumn =0
augroup allways_show_line_number | au!
    au BufWinEnter * set number relativenumber | set foldcolumn=0
    " au BufWinEnter * set number | set foldcolumn=0
augroup END
" hi foldcolumn guibg=fg
highlight foldcolumn ctermbg=NONE guibg=NONE
set nofoldenable    " disable folding

" Vertical split style settings
" Can the split separator in vim be less than a full column wide?
" https://vi.stackexchange.com/questions/2938/can-the-split-separator-in-vim-be-less-than-a-full-column-wide/2941#2941
" https://vi.stackexchange.com/questions/22053/how-to-completely-hide-the-seperator-between-windows
" set fillchars=vert:\|
" set fillchars=vert:\│
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
" Set a space followed '\ ' to the fillchars->vert option
" From this following expressions, you do not neeed tralling spaces exposed to vim
silent! execute 'set fillchars =vert:\ '
" let &fillchars = 'vert:\ '

" https://vi.stackexchange.com/questions/28994/can-i-change-the-ugly-indicator-after-eol
" EndOfBuffer, ugly indicator after EOL tildes (~)
let &fillchars ..=',eob: '
" making lines touch each other.
set linespace =0

" hi VertSplit guibg=fg guifg=bg
highlight VertSplit ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

" hi! VertSplit guifg=black guibg=black ctermfg=black ctermbg=black
" hi! VertSplit guifg=lightgrey guibg=lightgrey ctermfg=lightgrey ctermbg=lightgrey
" must be before setting your colorscheme
augroup nosplit
    au!
    autocmd ColorScheme,SourcePost * highlight VertSplit ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
                \ | highlight foldcolumn ctermbg=NONE guibg=NONE
augroup END

" vim-gitgutter
set signcolumn=yes
let g:gitgutter_sign_allow_clobber   = 1
let g:gitgutter_sign_allow_clobber   = 1
let g:gitgutter_set_sign_backgrounds = 1
highlight link GitGutterChangeLine DiffText
highlight link GitGutterAddIntraLine DiffAdd
highlight SignColumn ctermbg=NONE guibg=NONE

" https://stackoverflow.com/questions/60590376/what-is-the-difference-between-cterm-color-and-gui-color
" https://jonasjacek.github.io/colors/
hi Cursor guifg=bg guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE

silent! execute ':hi ColorColumn guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
            \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'

" silent! execute ':hi CursorLine   guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
"             \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'
" silent! execute ':hi CursorColumn guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
"             \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'

augroup cursor_theme
    au!
    " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
    " Workaround for creating transparent bg
    autocmd SourcePost * highlight Normal ctermbg=0 guibg=NONE
                \ | silent! execute 'highlight LineNr ctermfg=' . g:nontext_fg_cterm . ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'
                \ | highlight SignColumn ctermbg=NONE guibg=NONE
                \ | highlight foldcolumn ctermbg=NONE guibg=NONE

    " " Change Color when entering Insert Mode
    autocmd InsertEnter,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
                \ silent! execute ':hi ColorColumn guifg=' . g:cursor_guifg_insertenter . ' guibg=' . g:cursor_guibg_insertleave
                \ . ' ctermfg=' . g:cursor_ctermfg_insertenter . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'
    autocmd InsertLeave,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
                \ silent! execute ':hi ColorColumn guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
                \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'

    " autocmd InsertEnter,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
    "             \ silent! execute ':hi CursorLine guifg=' . g:cursor_guifg_insertenter . ' guibg=' . g:cursor_guibg_insertenter
    "             \ . ' ctermfg=' . g:cursor_ctermfg_insertenter . ' ctermbg=' . g:cursor_ctermbg_insertenter . ' cterm=NONE gui=NONE term=NONE'
    " autocmd InsertLeave,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
    "             \ silent! execute ':hi CursorLine guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
    "             \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'

    " autocmd InsertEnter,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
    "             \ silent! execute ':hi CursorColumn guifg=' . g:cursor_guifg_insertenter . ' guibg=' . g:cursor_guibg_insertenter
    "             \ . ' ctermfg=' . g:cursor_ctermfg_insertenter . ' ctermbg=' . g:cursor_ctermbg_insertenter . ' cterm=NONE gui=NONE term=NONE'
    " autocmd InsertLeave,VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme *
    "             \ silent! execute ':hi CursorColumn guifg=' . g:cursor_guifg_insertleave . ' guibg=' . g:cursor_guibg_insertleave
    "             \ . ' ctermfg=' . g:cursor_ctermfg_insertleave . ' ctermbg=' . g:cursor_ctermbg_insertleave . ' cterm=NONE gui=NONE term=NONE'
augroup END

if has('nvim')
    if exists('g:use_indent_guides')
        unlet g:use_indent_guides
    endif
else
    " let g:use_indent_guides = 1
endif

if exists('g:use_indent_guides')

    let g:indent_guides_auto_colors = 0
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_start_level = 2
    " let g:indent_guides_guide_size = 0

    " https://stackoverflow.com/questions/9912116/vimscript-programmatically-get-colors-from-colorscheme
    " let bgcolor=synIDattr(hlID('NonText'), 'bg#')
    " " if light == background
    " hi IndentGuidesOdd  ctermbg=white
    " hi IndentGuidesEven ctermbg=lightgrey
    " " endif
    " if dark == background
    " hi IndentGuidesOdd  ctermbg=black
    " hi IndentGuidesEven ctermbg=darkgrey

    " hi IndentGuidesOdd  ctermbg=black
    " hi IndentGuidesEven ctermbg=darkgrey

    " hi IndentGuidesOdd  guibg=darkgrey ctermbg=3
    " hi IndentGuidesEven guibg=green ctermbg=4

    " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=darkgrey ctermbg=3
    " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

    " hi IndentGuidesOdd  guibg=darkgrey ctermbg=3
    " hi IndentGuidesEven guibg=green ctermbg=4
    let indent_even = '#ecf2dd'
    let indent_odd  = '#767966'
    let indent_even  = '#494b40'
    let indent_color_odd = 'hi IndentGuidesOdd guifg=NONE guibg=' . indent_odd . ' gui=NONE ctermfg=black ctermbg=3 cterm=NONE term=NONE'
    let indent_color_even = 'hi IndentGuidesEven guifg=NONE guibg=' . indent_even . ' gui=NONE ctermfg=black ctermbg=2 cterm=NONE term=NONE'
    silent! execute indent_color_odd
    silent! execute indent_color_even

    augroup odd_even
        au!
        " " https://githubmemory.com/repo/nathanaelkane/vim-indent-guides/issues?cursor=Y3Vyc29yOnYyOpK5MjAxNi0wNy0xNFQxODoyMDoyMyswODowMM4J3b-h&pagination=next&page=3
        " au VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme * hi! IndentGuidesOdd  guifg=NONE guibg=#333333 gui=NONE ctermfg=8 ctermbg=3 cterm=NONE
        " au VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme * hi! IndentGuidesEven guifg=NONE guibg=#2b2b2b gui=NONE ctermfg=8 ctermbg=2 cterm=NONE
        " " https://www.titanwolf.org/Network/q/ad9924f3-2db9-4eb0-885f-bc68bffe6e3c/ynonenone
        au VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme * silent! execute indent_color_odd
        au VimEnter,WinEnter,BufEnter,BufWritePost,Colorscheme * silent! execute indent_color_even
    augroup END

endif
" endif



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
" :set listchars=tab:>-,space:.
" helper for indent mistake
" set list listchars=tab:»·,trail:·
set lcs=extends:>,precedes:<,nbsp:%,tab:>~,eol:↴
" set list lcs=tab:\|\

" Toggle visually showing all whitespace characters.
noremap <F7> :set list!<cr>
inoremap <F7> <C-o>:set list!<cr>
cnoremap <F7> <C-c>:set list!<cr>
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" https://vim.fandom.com/wiki/Source_current_file_when_editing_a_script
noremap <silent><buffer> <F9> :exec 'source '.bufname('%')<CR>


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

" Convert the selected text's title case using the external tcc script.
" Requires: https://github.com/nickjj/title-case-converter
vnoremap <leader>tc c<C-r>=system('tcc', getreg('"'))[:-2]<cr>

" Navigate the complete menu items like CTRL+n / CTRL+p would.
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"

" Select the complete menu item like CTRL+y would.
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <cr> pumvisible() ? "<C-y>" :"<cr>"

" Cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

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

" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "disable arrows key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

" breakadd here


" "basic autocommands ##########################################################################################"

augroup guard
    au!
    " Auto-resize splits when Vim gets resized.
    autocmd VimResized * wincmd =

    " Unset paste on InsertLeave.
    autocmd InsertLeave * silent! set nopaste
    autocmd InsertEnter * silent! set paste

    " Make sure all types of requirements.txt files get syntax highlighting.
    autocmd BufNewFile,BufRead requirements*.txt set syntax=python

    " Ensure tabs don't get converted to spaces in Makefiles.
    autocmd FileType make setlocal noexpandtab
    autocmd FileType python setlocal noexpandtab

    au VimEnter,WinEnter,BufWinEnter * setlocal expandtab
augroup END

" Only show the cursor line in the active buffer.
augroup cursor_line
    au!
    " au VimEnter,WinEnter,BufWinEnter * setlocal cursorline | setlocal cursorcolumn
    " au WinEnter * setlocal cursorline | setlocal cursorcolumn
    au WinLeave * setlocal cursorline | setlocal nocursorcolumn
augroup END

augroup stop_auto_indenting
    au!
    " https://vim.fandom.com/wiki/How_to_stop_auto_indenting
    autocmd FileType * if 1 == &modifiable | setlocal formatoptions-=c formatoptions-=r formatoptions-=o | endif
augroup END


" For vim-repeat
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

if has('nvim')
    set shell=zsh\ --login
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
        call boot#log_silent(g:log_address, a:key, " pressed", g:fixed_tips_width, g:log_verbose)
    endfunction

    " " put a new line before or after to this line
    " nnoremap <S-CR> m`o<Esc>``
    " nnoremap <C-CR> m`O<Esc>``
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

    " " # https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
    " " m' or m`: Set the previous context mark. This can be jumped to with the "''" or "``" command (does not move the cursor, this is not a motion command).
    " This map will break vim user mappings and restore to the default mappings of ^H/^J/^K/^L
    if has('nvim')
        nnoremap <S-CR> m`O<Esc>``
        nnoremap <C-CR> m`o<Esc>``
    else
        " Could be enabled by 'tpope/vim-unimpaired'
        " Use [-space for shift-enter
        " And ]-space for ctrl-enter
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

    " nnoremap ^[0M i<CR><Esc>   " Needed for CLI VIm (Note: ^[0M was created with Ctrl+V Shift+Enter, don't type it directly)

    " inoremap <CR>   ThisIsEnter
    " inoremap <C-CR> ThisIsCenter
    " inoremap <S-CR> ThisIsSenter
























endif " g:navi_protect

" "enter insert new line in normal mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

" "don't flush clipboard register ______________________________________________________________________________"
" "don't flush clipboard register ______________________________________________________________________________"

" https://www.reddit.com/r/vim/comments/hge0qw/for_those_who_are_still_struggling_with_waylands/
if !empty($WAYLAND_DISPLAY)
    let g:clipboard =
                \ { 'name': 'wayland-strip-carriage',
                \   'copy':
                \ {     '+': 'wl-copy --foreground --type text/plain',
                \       '*': 'wl-copy --foreground --type text/plain --primary',
                \ },
                \   'paste':
                \ {     '+': {-> systemlist('wl-paste --no-newline | tr -d "\r"')},
                \       '*': {-> systemlist('wl-paste --no-newline --primary | tr -d "\r"')},
                \ },
                \   'cache_enabled': 1,
                \ }
endif
" set clipboard+=unnamed
set clipboard+=unnamedplus

" " https://alex.dzyoba.com/blog/vim-revamp/
" " C-c and C-v - Copy/Paste to global clipboard
" vmap <C-c> "+yi
" imap <C-v> <esc>"+gpi

" https://www.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p


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

:set autoread   " doesn't work
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "Buffer changed!" | echohl None
"
"
" " Triger `autoread` when files changes on disk
" " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
"   autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
"           \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
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
    au FocusGained,BufEnter * " :checktime
                \ if mode() == 'n' && getcmdwintype() == '' <bar> checktime <bar> endif
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

noremap <silent> <C-S-Up>    :resize +1<cr>
noremap <silent> <C-S-Down>  :resize -1<cr>
noremap <silent> <C-S-Left>  :vertical resize +1<cr>
noremap <silent> <C-S-Right> :vertical resize -1<cr>

" noremap  <silent> <m-k> :resize +1<cr>
" noremap  <silent> <m-j> :resize -1<cr>
" noremap  <silent> <m-h> :vertical resize +1<cr>
" noremap  <silent> <m-l> :vertical resize -1<cr>

" nnoremap <silent> <m-k> :TmuxResizeUp<CR>
" nnoremap <silent> <m-j> :TmuxResizeDown<CR>
" nnoremap <silent> <m-h> :TmuxResizeLeft<CR>
" nnoremap <silent> <m-l> :TmuxResizeRight<CR>

noremap  <silent> <m-k> :exe "resize +1 && :TmuxResizeUp"<cr>
noremap  <silent> <m-j> :exe "resize -1 && :TmuxResizeDown"<cr>
noremap  <silent> <m-h> :exe "vertical resize +1 && :TmuxResizeLeft"<cr>
noremap  <silent> <m-l> :exe "vertical resize -1 && :TmuxResizeRight"<cr>

" https://vim.fandom.com/wiki/Resize_splits_more_quickly
nnoremap <silent> <leader>= :exe "resize " . (winheight(0) * 3/2)<cr>
nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<cr>

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
set syntax=on
set shortmess=a

set nomore
set cmdheight=1
" set shortmess+=O
set shortmess=at
set shm+=F

set noruler
set laststatus=2 " Always display the statusline in all windows
" set showtabline=2 " Always display the tabline, even if there is only one tab
set showtabline=0 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)


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
set modelines=2
set noerrorbells visualbell t_vb=
set noshiftround
set nospell
set nostartofline
" set number
" set nonumber
set number relativenumber
" set number invrelativenumber
" set invrelativenumber " rnu
" set nornu  " turn off rnu


" set regexpengine=1
set regexpengine=0

" set scrolloff=3
" https://stackoverflow.com/questions/43915661/how-to-move-screen-left-right-or-center-it-horizontally-without-moving-cursor-in?noredirect=1&lq=1
set scrolloff=20       " keep 20 lines visible above and below cursor at all times
set sidescrolloff=30   " keep 30 columns visible left and right of the cursor at all times

set scrollopt-=ver
set showcmd
set showmatch
set shortmess+=c
set spelllang=en_us
set splitbelow
set splitright
set textwidth=0
set ttimeout
set ttyfast
set virtualedit=block
set whichwrap=b,s,<,>
set wildmenu
set wildmode=full


set nopaste
" set paste



" " Vim: How to switch back from tabview to vertical split
" " https://stackoverflow.com/questions/58357914/vim-how-to-switch-back-from-tabview-to-vertical-split
" nnoremap <silent><C-W>U :hide -tabonly <bar> unhide<cr>

" https://dmitryfrank.com/articles/indent_with_tabs_align_with_spaces
" copy indent from previous line: useful when using tabs for indentation and spaces for alignment
" set copyindent


runtime! macros/matchit.vim

hi SpellBad   cterm=underline ctermfg=9
hi SpellLocal cterm=underline ctermfg=9
hi SpellRare  cterm=underline ctermfg=9
hi SpellCap   cterm=underline

if has("autocmd")
    filetype plugin indent on " indents corresponding to specific file format
    augroup vimrcEx
        au!
        " autocmd FileType text setlocal textwidth=78
        autocmd FileType text setlocal textwidth=120 | set colorcolumn=""
        " jumps to the last known position in a file
        autocmd BufReadPost * ++nested
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \ silent! exe "normal! g`\"" |
                    \ endif
    augroup END
else
    set autoindent " always set autoindenting on
endif " has("autocmd")

" set nomore " When on, listings pause when the whole screen is filled.  You will get the |more-prompt|.
set more " When on, listings pause when the whole screen is filled.  You will get the |more-prompt|.


set hidden        " You need this otherwise you cannot switch modified buffer


" https://developpaper.com/vim-technique-explain-the-difference-between-tabstop-softtabstop-and-expandtab/
" set tabstop    =4   shiftwidth  =4 expandtab
set tabstop    =4 " show existing tab with 4 spaces width
" "When auto indenting, the indent length is 4
set shiftwidth =4 " when indenting with '>', use 4 spaces width
" set expandtab       " On pressing tab, insert 4 spaces
" "The value of softtabstop is negative, and the value of shiftwidth will be used. The two values are consistent, which is convenient for unified indentation
set softtabstop=-1
" "When you enter the tab character, it is automatically replaced with a space
set expandtab
" set smarttab

set formatoptions=tcqrn1

set vb t_vb=
set nowrap

set hlsearch   " highlight research result
set ignorecase " search patter
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
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

set ttyfast


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

if 1 == g:is_windows
    " prevent from cann't copy content in linux terminal
    if has('mouse')
        set mouse=a
    endif
    au GUIEnter * simalt ~x
endif

" https://github.com/alacritty/alacritty/issues/2931
" https://github.com/alacritty/alacritty/issues/1142
if ! has('nvim')
    if has("mouse_sgr")
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    end
endif
if ! has('nvim')
    :set term=xterm-256color    " :set term=alacritty
endif

if has('mouse')
    " :set mouse=n
    set mouse=a
endif

" https://vi.stackexchange.com/questions/12140/how-to-disable-moving-the-cursor-with-the-mouse
nnoremap <LeftMouse> m`<LeftMouse>``
nnoremap <LeftRelease> m`<LeftRelease>``


augroup cursor_hold
    autocmd!
    " autocmd FocusLost * set mouse=
    autocmd WinLeave * normal m`
    " au FocusGained * normal 
    " au FocusGained * normal ``
    " autocmd FocusGained * call timer_start(200, 's:reenablemouse')
    autocmd WinEnter * normal ``
augroup END

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

" "Preserve cursor position when switching between buffers"
" https://stackoverflow.com/questions/40984988/preserve-cursor-position-when-switching-between-buffers-with-bn
autocmd BufEnter * silent! normal! g`"

function! s:lastmodified()
    if &modified
        let save_cursor = getpos(".")
        let n = min([250, line("$")])
        :silent keepjumps exe '1,' . n . 's/^\(.*L\)ast.modified.*:.*/\1ast modified: ' . strftime('%Y-%m-%d %H:%M:%S %z (PST)') . '/e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre * call s:lastmodified()

" Save current view settings on a per-window, per-buffer basis.
function! s:autosavewinview()
    if !exists("w:savedbufview")
        let w:savedbufview = {}
    endif
    let w:savedbufview[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! s:autorestorewinview()
    let buf = bufnr("%")
    if exists("w:savedbufview") && has_key(w:savedbufview, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:savedbufview[buf])
        endif
        unlet w:savedbufview[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call s:autosavewinview()
    autocmd BufEnter * call s:autorestorewinview()
endif
" "Preserve cursor position when switching between buffers"


" "mouse settings ______________________________________________________________________________________________"
" "mouse settings ______________________________________________________________________________________________"



" "cursor shape and blinking |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

" " https://vim.fandom.com/wiki/Configuring_the_cursor
" if &term =~ "xterm\\|rxvt\\|alacritty"
"     " use an orange cursor in insert mode
"     let &t_SI = "\<Esc>]12;orange\x7"
"     " use a red cursor otherwise
"     let &t_EI = "\<Esc>]12;red\x7"
"     silent !echo -ne "\033]12;red\007"
"     " reset cursor when vim exits
"     autocmd VimLeave * silent !echo -ne "\033]112\007"
"     " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
" endif

" https://vimrcfu.com/snippet/15
" Change cursor style when entering INSERT mode (works in tmux!)
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" following code will mess your vim
" https://vi.stackexchange.com/questions/9131/i-cant-switch-to-cursor-in-insert-mode
" au InsertEnter * silent! execute "! echo -en \<esc>[5 q"
" au InsertLeave * silent! execute "! echo -en \<esc>[2 q"

" https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
augroup blink_cursor
    au!
    autocmd VimEnter * silent! exec "! echo -ne '\e[1 q'"
    autocmd VimLeave * silent! exec "! echo -ne '\e[3 q'"
augroup END


" "cursor hape and blinking ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"



" "tags generation _____________________________________________________________________________________________"
" "tags generation _____________________________________________________________________________________________"

" "cscope ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

" https://alex.dzyoba.com/blog/vim-revamp/
" cscope - "find usages"
function! s:cscope(option, query) range
    let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
    let opts = {
                \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
                \ 'options': ['--ansi', '--prompt', '> ',
                \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
                \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
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

let g:qquickruickr_cscope_use_qf_g = 1
let g:quickr_cscope_db_file = "cscope_quickr.out"

" https://github.com/erig0/cscope_dynamic
" nmap <F11> <Plug>CscopeDBInit
nmap <F3> :BuffergatorToggle<cr>


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
augroup cscope_auto
    au!
    autocmd VimEnter * :call cscope_auto#setup(function("s:cscope_state"))
augroup END

" ALE
let g:ale_lint_on_save             = 1
let g:ale_lint_on_enter            = 0
let g:ale_lint_on_text_changed     = 'never'
let g:ale_sign_column_always       = 1
let g:ale_sign_warning             = 'W'
let g:ale_sign_error               = 'E'
let g:ale_python_flake8_args       = '--ignore=C,E111,E114,E22,E201,E241,E265,E272,E3,E501,E731'
let g:ale_python_pylint_executable = ''


fun! ALEClearBuffer(buffer)
    if get(g:, 'ale_enabled') && has_key(get(g:, 'ale_buffer_info', {}), a:buffer)
        call ale#engine#SetResults(a:buffer, [])
        call ale#engine#Cleanup(a:buffer)
    endif
endfun

augroup UnALE
    autocmd!
    autocmd TextChanged,TextChangedI,InsertEnter,InsertLeave * call ALEClearBuffer(bufnr('%'))
augroup END

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
"             echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
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
"             echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
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
"             echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
"             return
"         endif
"     endif
"     if(executable('ctags'))
"         "silent! execute "!ctags -R --c-types=+p --fields=+S *"
"         silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
"     endif
"     if(executable('cscope') && has("cscope") )
"         if(g:iswindows!=1)
"             silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.H' -o -name '*.C' -o -name '*.cxx' -o -name '*.hxx' >> cscope.files"
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

set cscopetag
set cscoperelative
set cscopequickfix=s-,c-,d-,i-,t-,e-

" cscope error: Assertion failed: invcntl-aram.sizeblk == sizeof(t_logicalblk) (invlib.c: invopen: 593)
" https://bugzilla.redhat.com/show_bug.cgi?id=877955
" refer to cscopr_auto

" "tags generation _____________________________________________________________________________________________"
" "tags generation _____________________________________________________________________________________________"


" "tagbar (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((("


let g:vim_tags_auto_generate               = 1
let g:vim_tags_ctags_binary                = system("${which ctags}")
let g:vim_tags_project_tags_command        = "{CTAGS} -R {OPTIONS} {DIRECTORY} 2>/dev/null"
let g:vim_tags_gems_tags_command           = "{CTAGS} -R {OPTIONS} `bundle show --paths` 2>/dev/null"
let g:vim_tags_use_vim_dispatch            = 0
let g:vim_tags_use_language_field          = 1
let g:vim_tags_ignore_files                = ['.gitignore', '.svnignore', '.cvsignore']
let g:vim_tags_ignore_file_comment_pattern = '^[#"]'
let g:vim_tags_directories                 = [".git", ".hg", ".svn", ".bzr", "_darcs", "CVS"]
let g:vim_tags_main_file                   = 'tags'
let g:vim_tags_extension                   = '.tags'
" let g:vim_tags_cache_dir                   = expand($HOME)
let g:vim_tags_cache_dir                   = g:config_root
let g:tagbar_left                          = 1
let g:tagbar_expand                        = 1
nmap <F2> :TagbarToggle<cr>
set tags=./tags,tags
" set autochdir
" set switchbuf=useopen,split " make quickfix open in a new split buffer
set switchbuf=uselast " make quickfix open in a new split buffer
let g:qf_bufname_or_text = 1

" " map <F2> :call s:execute_on_writable(':call NERDTreeTlist()') <cr>
" Use this function to prevent CtrlP opening files inside non-writable buffers, e.g. NERDTree
function! s:execute_on_writable(command)

    " if bufname('#') =~ 'NERD_tree_' && bufname('%') !~ 'NERD_tree_'
    " \ && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr
    " \ && &buftype == '' && !exists('g:launching_fzf')
    "     let bufnum = bufnr('%')
    "     close
    "     exe ":NERDTreeClose"
    "     exe 'b ' . bufnum
    "     " NERDTree
    " endif
    " " if bufname('#') =~ '__Tag_List__' && bufname('%') !~ '__Tag_List__' && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr && &buftype == '' && !exists('g:launching_fzf')
    " if bufname('#') =~ '__Tag_List__' && bufname('%') !~ '__Tag_List__'  && exists('t:taglist_winnr') && bufwinnr('%') == t:taglist_winnr && &buftype == '' && !exists('g:launching_fzf')
    "     let bufnum = bufnr('%')
    "     close
    "     exe ":TlistClose"
    "     exe 'b ' . bufnum
    "     " TlistToggle
    " endif

    call s:switch_to_writable_buffer()

    exec a:command

endfunction

function! s:switch_to_writable_buffer()
    let avalible_win_nr = 0
    let c = 0
    let win_count = winnr('$')
    " Don't open it here if current buffer is not writable (e.g. NERDTree)
    " while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c < win_count && &buftype != ''
    while winbufnr(c) != -1 && !empty(getbufvar(winbufnr(c), "&buftype")) && c < win_count
        let c = c + 1
    endwhile
    exec c . 'wincmd w'
    " let i = 1
    " while i <= winnr("$")
    "     let bnum = winbufnr(i)
    "     if bnum != -1 && getbufvar(bnum, '&buftype') ==# ''
    "                 \ && !getwinvar(i, '&previewwindow')
    "                 \ && (!getbufvar(bnum, '&modified') || &hidden)
    "         " return i
    "         let avalible_win_nr = i
    "     endif

    "     let i += 1
    " endwhile
    " echo "avalible_win_nr = " . avalible_win_nr
    " exec avalible_win_nr . 'wincmd w'
endfunction

" Retrieve previous/next window number
function! s:windows_jump_retrieve(dir)
    let c = 0
    let wincount = winnr('$')
    " Find a writable buffer
    while !empty(getbufvar(winbufnr(c + 1), "&buftype")) && c < wincount && &buftype != ''
        let c = c + 1
    endwhile
    " set c as default buffer number
    let buf_num = c
    let jl = getjumplist()
    let jumplist = jl[0]
    let curjump  = jl[1]
    let searchrange = a:dir > 0 ? range(curjump + 1, len(jumplist)) : range(curjump - 1, 0, -1)
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
    " let jumpcmdchr = a:dir > 0 ? '' : '	'    " <C-I> or <C-O>
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

vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" [Redir.vim](https://gist.github.com/intuited/362802)
" :Redir map
command! -nargs=+ -complete=command Redir let s:reg = @@  <bar> redir @">  <bar> silent execute <q-args>  <bar> redir END  <bar> new  <bar> pu  <bar> 1,2d_  <bar> let @@ = s:reg

let g:tmux_navigator_no_mappings    = 1
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

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

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" https://github.com/RyanMillerC/better-vim-tmux-resizer
let g:tmux_resizer_no_mappings = 1

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

" cnoremap w!! write !doas tee > /dev/null % <CR> :edit<CR>

" cnoremap w!! exec 'w !sudo dd of=' . shellescape(expand('%')) <CR> :edit<CR>

" https://unix.stackexchange.com/questions/249221/vim-sudo-hack-auto-reload
cnoremap w!! call <sid>save_file_via_sudo()<cr>

function! s:save_file_via_sudo() abort
    " https://askubuntu.com/questions/454649/how-can-i-change-the-default-editor-of-the-sudoedit-command-to-be-vim
    " https://unix.stackexchange.com/questions/90866/sudoedit-vim-force-write-update-without-quit/635704#635704
    " inotifywait
    " https://github.com/lambdalisue/suda.vim
    " echo executable('sudo')
    " https://github.com/vim-scripts/sudo.vim
    "     (command line): vim sudo:/etc/passwd
    "     (within vim):   :e sudo:/etc/passwd
    execute (has('gui_running') ? '' : 'silent') 'write !env SUDO_EDITOR=tee sudo -e ' . shellescape(expand('%')) . ' >/dev/null'
    " execute (has('gui_running') ? '' : 'silent') 'write !env DOAS_EDITOR=tee doas -e ' . shellescape(expand('%')) . ' >/dev/null'
    let &modified = v:shell_error
endfunction


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
" v +SudoEdit /mnt/gentoo/root/test.cpp
" https://github.com/lambdalisue/suda.vim  " removed
" " Will erase buffers (not just current one) automatically if you don't have write permission
" let g:suda_smart_edit = 1  " for suda.vim
" For both vim-eunuch and suda.vim (change SudoWrite to SudaWrite)
" noremap  <silent> <C-s> :SudoWrite<CR>
" inoremap <silent> <C-s> <ESC>:SudoWrite<CR>i

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

let g:fern#renderer#default#leading = "│"
let g:fern#renderer#default#root_symbol = "┬ "
let g:fern#renderer#default#leaf_symbol = "├─ "
let g:fern#renderer#default#collapsed_symbol = "├─ "
let g:fern#renderer#default#expanded_symbol = "├┬ "

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
    nmap <buffer> m <Plug>(fern-action-move)
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

    call fern#mapping#call_function#add('project_top', function('s:fern_project_top'))

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

    nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
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


" CtrlP
" Disable default mapping since we are overriding it with our command let g:ctrlp_map = ''





" "project drawer //////////////////////////////////////////////////////////////////////////////////////////////"



" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "code format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

let g:tex_flavor = "latex"


" https://github.com/andymass/vim-matchup
let g:loaded_matchit = 1

augroup cxx_auto_format | au!
    autocmd FileType c,cxx,cpp ClangFormatAutoEnable
augroup END

" call packager#add('Chiel92/vim-autoformat', { 'type' : 'start' })
" noremap <F3> :Autoformat<cr>
" noremap <F3> :call easy_align#align()<cr>

" https://github.com/junegunn/vim-easy-align
nmap ea <Plug>(EasyAlign)
xmap ea <Plug>(EasyAlign)
" noremap <F4> :EasyAlign<cr>

" let g:autoformat_autoindent             = 0
" let g:autoformat_retab                  = 0
" let g:autoformat_remove_trailing_spaces = 0

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
"
" https://lorenzod8n.wordpress.com/2007/05/14/quick-vim-tip-getting-vim-to-know-zsh-files/
autocmd BufNewFile,BufRead *.zsh setlocal filetype=zsh
autocmd BufNewFile,BufRead vimoutlinerrc setlocal filetype=vim

" " for original command
" let g:vim_format_list   = {
"   \ 'jenkins':{'autocmd':['*.groovy'],'cmds':[{'requirements':['goenkins-format'],'shell':'cat {input_file} | goenkins-format'}]},
"   \ }

if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction

let g:mkdx#settings = { 'highlight': { 'enable': 1 },
            \ 'enter': { 'shift': 1 },
            \ 'links': { 'external': { 'enable': 1 } },
            \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
            \ 'fold': { 'enable': 1 } }
let g:polyglot_disabled = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
" plugin which unfortunately interferes with mkdx list indentation.

augroup markdown
    autocmd!
    " Include dash in 'word'
    autocmd FileType markdown setlocal iskeyword+=-
augroup END

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

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
                \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
                \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>



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


" "search functions ********************************************************************************************"
" "search functions ********************************************************************************************"


" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" "complition functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

" Set completeopt to have a better completion experience
set completeopt=menuone,longest
set completeopt+=noinsert,noselect
set completeopt-=preview

set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " Add only if Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 1


let g:jedi#popup_on_dot = 0  " It may be 1 as well
let g:mucomplete#user_mappings = { 'sqla' : "\<c-c>a" }
let g:mucomplete#chains = { 'sql' : ['file', 'sqla', 'keyn'] }
set noinfercase

" Installing clangd
" https://clangd.llvm.org/installation.html
" let g:clang_library_path = '/usr/lib'
let g:clang_library_path = boot#chomped_system("echo $(llvm-config --libdir)")
let g:clang_user_options = '-std=c++2a'
let g:clang_complete_auto = 1
imap <expr> <down> mucomplete#extend_fwd("\<down>")


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

" " Go to buffer. Conflict with buffergator
" nnoremap gb :ls<cr>:b<space>

let g:buffergator_autodismiss_on_select = 1
let g:buffergator_viewport_split_policy = "L"
let g:buffergator_use_new_keymap = 1
let g:buffergator_mru_cycle_local_to_window = 0
" let g:buffergator_split_size=100

" "tab management ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))"



" "session operation @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

" https://github.com/xolox/vim-session
let g:session_autoload         = 'yes'
let g:session_autosave         = 'yes'
let g:session_autosave_to      = '.default'
let g:session_verbose_messages = 0
let g:session_directory        = getcwd()

" " https://github.com/xolox/vim-notes/issues/80
" augroup reset_xolox
"     au! PluginXoloxMisc CursorHold
" augroup END

" https://github.com/vim/vim/issues/2790
:set redrawtime=10000
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
let g:golden_ratio_autocommand = 0
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
    silent! execute "set viminfo='5,f1,\"50,:20,%,n'" . stdpath('data') . "/viminfo"
    let &viminfofile = expand('$XDG_DATA_HOME/nvim/shada/main.shada')
else
    " set viminfo='5,f1,\"50,:20,%,n~/.vim/viminfo
    silent! execute "set viminfo='5,f1,\"50,:20,%,n'" . g:plugin_dir['vim'] . "/viminfo"

endif

augroup bw
    au!
    " https://stackoverflow.com/questions/5238251/deleting-buffer-from-vim-session
    " command! -nargs=? -bang BW :silent! argd % | bw<bang><args>
    command! -nargs=? -bang BW :silent! argd % <bar> bw<bang><args>
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
" if has('nvim')
"     let s:undodir = expand(stdpath('cache') . '/undo')
" else
"     let s:undodir = expand($HOME . '/.cache/vim/undo')
" endif
" if filewritable(s:undodir) != 2
"     silent! exe '!mkdir -p ' s:undodir
" endif
" silent! execute 'set undodir=' . s:undodir . '//'
" set undofile

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


" "session operation @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

" "dict ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

" For fun (doesn't work: 16928 segmentation fault  goldendict). Actally sdcv works in console
if 1 == g:is_windows
    let g:goldendict_path = 'C:\Program Files\GoldenDict\GoldenDict.exe'
else
    let g:goldendict_path = boot#chomped_system('which goldendict')
endif

imap <F1> <C-\><C-O><Plug>(goldendict-lookup-cursor)
nmap <F1> <Plug>(goldendict-lookup-cursor)
vmap <F1> <C-G><Plug>(goldendict-lookup-visual)<C-G>

if exists('g:started_by_firenvim')
    set laststatus=0
else
    set laststatus=2
endif

function! OnUIEnter(event) abort
    if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
        set laststatus=0
    endif
endfunction

au BufEnter github.com_*.txt set filetype=markdown
" let g:firenvim_config = {
"             \ 'localSettings': {
"                 \ '.*': {,
"                 \ 'filename': '/tmp/{hostname}_{pathname%10}.{extension}',
"                 \ }
"                 \ }

" Broken Websites - glacambre/firenvim Wiki
    " \ 'localSettings': {
    "     \ '.*': {
    "         \ 'cmdline': 'firenvim',
    "         \ 'priority': 0,
    "         \ 'selector': 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
    "         \ 'takeover': 'always',
    "     \ },
    "     \ '.*notion\.so.*': { 'priority': 9, 'takeover': 'never', },
    "     \ '.*docs\.google\.com.*': { 'priority': 9, 'takeover': 'never', },
    " \ }
let g:firenvim_config = {
            \ 'globalSettings': {
                \ 'cmdlineTimeout': 3000,
                \ '<C-w>': 'noop',
                \ '<C-n>': 'default',
                \ 'alt': 'all',
                \  },
                \ 'localSettings': {
                    \ '.*': {
                        \ 'cmdline': 'neovim',
                        \ 'content': 'text',
                        \ 'priority': 0,
                        \ 'selector': 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
                        \ 'takeover': 'always',
                        \ },
                        \ '.*notion\.so.*': { 'priority': 9, 'takeover': 'never', },
                        \ '.*docs\.google\.com.*': { 'priority': 9, 'takeover': 'never', },
                        \ }
                        \ }

let fc = g:firenvim_config['localSettings']
let fc['https?://[^/]+\.co\.uk/'] = { 'takeover': 'never', 'priority': 1 }

let fc['.*'] = { 'selector': 'textarea:not([readonly]), div[role="textbox"]' }


let g:dont_write = v:false
function! s:firenvim_write(timer) abort
    let g:dont_write = v:false
    if filewritable(bufname('%'))
        write
    endif
endfunction

function! s:delay_firenvim_write() abort
    if g:dont_write
        return
    end
    let g:dont_write = v:true
    let timer = 10000
    " https://vi.stackexchange.com/questions/27035/vim-script-how-to-pass-varargs-to-a-lambda-in-timer-start
    call timer_start(timer, { -> execute ("call s:firenvim_write('" . timer . "')", "") })
endfunction

augroup firenvim_write
    au!
    if has("gui_running")
        autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
    endif
    " au TextChanged * ++nested write
    " au TextChangedI * ++nested write
    au TextChanged  * ++nested call s:delay_firenvim_write()
    au TextChangedI * ++nested call s:delay_firenvim_write()
augroup END


" "dict ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

" "build tools ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

" " https://github.com/Shougo/deoplete.nvim
" let g:deoplete#enable_at_startup = 1


" https://www.quora.com/How-do-I-compile-a-program-C++-or-Java-in-Vim-like-Sublime-Text-Ctrl+B/answer/Lin-Wei-31
" open quickfix window automatically when AsyncRun is executed
" set the quickfix window 6 lines height.
let g:asyncrun_open = 6

" ring the bell to notify you job finished
let g:asyncrun_bell = 1


" F10 to toggle quickfix window
" nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
nmap <C-g><C-o> <Plug>window:quickfix:loop

let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']

" https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
:packadd cfilter
" :Cfilter DPUST


" if has('win32') || has('win64')
"     noremap <silent><F2> :AsyncRun! -cwd=<root> findstr /n /s /C:"<C-R><C-W>" "\%CD\%\*.h*" --include='*.i*' "\%cd\%\*.c*" <cr>
" else
"     noremap <silent><F2> :AsyncRun! -cwd=<root> grep -n -s -R <C-R><C-W> --include='*.h*' --include='*.i*' --include='*.c*' '<root>' <cr>
" endif

if 1 == g:debug_verbose
    function! s:log() abort
        " silent! execute '!(printf "scriptnames\t\t: ">> '. g:log_address . ' 2>&1 &) > /dev/null'
        call boot#log_silent(g:log_address, "scriptnames", "", g:fixed_tips_width, g:log_verbose)
        " silent! execute 'redir >> ' . g:log_address . ' | silent scriptnames | call boot#log_silent("' . g:log_address . '", \'\n\', ' .  g:fixed_tips_width . ', ' . g:log_verbose . ') | redir END'
        silent! execute 'redir >> ' . g:log_address . ' | silent scriptnames | redir END | call boot#log_silent("' . g:log_address . '", "\n", "", ' . g:fixed_tips_width . ', ' . g:log_verbose . ')'
        silent! execute 'redir! > ' . g:log_address . ' | silent verbose map | redir END | call boot#log_silent("' . g:log_address . '", "\n", "", ' . g:fixed_tips_width . ', ' . g:log_verbose . ')'
        " silent! execute 'redir! > ' . g:log_address . ' | silent map | redir END | call boot#log_silent("' . g:log_address . '", "\n", "", ' . g:fixed_tips_width . ', ' . g:log_verbose . ')'
        " silent! execute '!(printf \'\n\'>> '. g:log_address . ' 2>&1 &) > /dev/null'
        " call boot#log_silent(g:log_address, "\n", "", g:fixed_tips_width, g:log_verbose)
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

" autocmd BufEnter * ++nested syntax sync fromstart

augroup reload_vimrc
    autocmd!
    autocmd BufEnter * ++nested syntax sync fromstart
    " autocmd! BufWritePost $MYVIMRC ++nested source $MYVIMRC | setlocal filetype=vim
    " autocmd! BufWritePost $MYVIMRC ++nested source $MYVIMRC

    if has('nvim')
        autocmd! BufWritePost $MYVIMRC source $MYVIMRC | setlocal filetype=vim | call s:refresh()
    else
        autocmd! BufWritePost $MYVIMRC source $MYVIMRC | setlocal filetype=vim | redraw!
    endif
augroup END

" "auto reload .vimrc __________________________________________________________________________________________"

" endif   " g:debug_keys

" "keep following code at the end of the file __________________________________________________________________"

" https://stackoverflow.com/questions/14779299/syntax-highlighting-randomly-disappears-during-file-saving
augroup reset_syntax
    au!
    autocmd BufWritePost * ++nested syntax enable <bar> doautocmd filetypedetect BufRead "%"
    " syntax enable
augroup END

" "keep above code block at the end of the file ________________________________________________________________"



" "keep above code block at the very end of the file ___________________________________________________________"


if ! has('nvim') " && (exists('g:loaded_minpac') || exists('g:loaded_vim_packager'))
    " https://github.com/itchyny/lightline.vim/issues/512
    hi LightlineLeft_active_0 guibg=darkgrey

    augroup lightline_hl
        au!
        " https://vi.stackexchange.com/questions/31491/why-does-my-lightline-status-line-not-show-up-right-away
        " autocmd WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufReadPost,BufWritePost * ++nested call lightline#update()
        " autocmd VimEnter * ++nested call lightline#update()
        " au VimEnter,Colorscheme * call lightline#disable() | call lightline#enable()
        autocmd VimEnter,WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufReadPost,BufWritePost,ColorScheme * ++nested call lightline#highlight() | redraw!
    augroup END
else
    augroup lightline_hl
        au!
    augroup END


    " lua require("slanted")
    " lua require('plugins'):requireRel("slanted-gaps")
    " lua require("slanted")
    lua lualine =  require('lualine')
    augroup indent_blankline_hl
        au!
        " autocmd VimEnter,WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufReadPost,BufWritePost,ColorScheme * ++nested lua require('plugins').install() | :PackerCompile
        autocmd VimEnter,WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufWinLeave,BufReadPost,BufWritePost,ColorScheme * ++nested call s:refresh()
    augroup END
endif


if exists('g:use_indent_guides')
    augroup indent_guides_enable
        au!
        " au BufEnter,BufWritePost,VimEnter * silent execute ":normal! \<Plug>IndentGuidesEnable"
        " autocmd BufEnter <buffer> call feedkeys("\<Plug>IndentGuidesEnable", x)
        autocmd VimEnter,WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufWinLeave,BufReadPost,BufWritePost,ColorScheme * ++nested :IndentGuidesEnable
    augroup END
endif

" autocmd ColorScheme,SessionLoadPost * call lightline#highlight()

" let g:map_keys_plugin = "" . g:plugin_dir['vim'] . "/after/plugin/keys.vim"
" execute "source " . g:map_keys_plugin
" execute "runtime! " . g:map_keys_plugin

" augroup reset_map_keys
"     au!
"     " autocmd BufWritePost g:map_keys_plugin ++nested silent execute "source " . g:map_keys_plugin | execute "runtime! " . g:map_keys_plugin
"     autocmd BufWritePost * ++nested silent execute "source " . g:map_keys_plugin | execute "runtime! " . g:map_keys_plugin
"     autocmd BufWritePost * ++nested call keys#map_key_ad_hoc('k') | call keys#map_key_ad_hoc('j') | call keys#map_key_ad_hoc('h') | call keys#map_key_ad_hoc('l')
"     au! VimEnter,WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost,BufWinEnter,BufReadPost,BufWritePost,ColorScheme * call keys#map_key_ad_hoc('k') | call keys#map_key_ad_hoc('j') | call keys#map_key_ad_hoc('h') | call keys#map_key_ad_hoc('l')
" augroup END

" execute ":ReloadScript " . g:map_keys_plugin

" "keep above code block at the very end of the file ___________________________________________________________"

" https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively
let regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
for r in regs
    call setreg(r, [])
endfor

let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"' | let i = 0 | while (i < strlen(regs)) | exec 'let @' . regs[i] . ' = ""' | let i = i + 1 | endwhile | unlet regs


" set exrc
set secure

if 1 == g:debug_verbose && bufnr(g:log_address) < 0
    silent! execute 'argadd ' . g:log_address
endif



























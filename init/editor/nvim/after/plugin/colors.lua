vim.cmd([[
" colorscheme onehalf-lua
" colorscheme onehalf-lush
" colorscheme onehalf-lush-dark
let base16colorspace=256

let g:cterm_fg_insert  = 'NONE'
let g:cterm_bg_insert  = '4'
let g:nontext_fg_cterm = 'NONE'
" let g:nontext_fg_gui   = 'NONE'
let g:nontext_fg_gui   = '#222222'

" Inspect check highlight group of current cursor

hi Visual ctermbg=NONE ctermfg=NONE guifg=Teal guibg=NONE term=inverse cterm=inverse gui=inverse

silent! execute 'highlight! NonText ctermfg=' . g:nontext_fg_cterm .
	\ ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

hi! SignColumn  ctermbg=NONE guibg=NONE
hi! Identifier  ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi! Search      ctermbg=NONE guibg=NONE guifg=Teal ctermfg=45 cterm=inverse term=inverse gui=inverse
hi! IncSearch   ctermbg=NONE guibg=NONE guifg=Teal ctermfg=45 cterm=inverse term=inverse gui=inverse
hi! rstEmphasis ctermbg=NONE guibg=NONE guifg=Teal ctermfg=45
hi! manItalic   ctermbg=NONE guibg=NONE guifg=Teal ctermfg=45
hi! Keyword     ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi! Function    ctermbg=NONE guibg=NONE guifg=Teal ctermfg=6
hi! Normal      ctermbg=0 guibg=NONE

silent! execute 'highlight NonText ctermfg=' . g:nontext_fg_cterm .
	\ ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

hi NvimTreeFolderIcon guibg=blue
hi! Define cterm=NONE gui=NONE guifg=#00ff00 guibg=NONE
hi! link Type Define
hi! link Tag  Define

hi! Character  cterm=NONE gui=NONE guifg=#00ff00 guibg=#ff00ff ctermfg=45 ctermbg=NONE

hi SpellBad   cterm=underline ctermfg=9
hi SpellLocal cterm=underline ctermfg=9
hi SpellRare  cterm=underline ctermfg=9
hi SpellCap   cterm=underline

" PmenuSel           cterm=NONE ctermfg=9
" PmenuSel           cterm=NONE ctermfg=9 guifg=#282c34 guibg=#61afef
hi PmenuSel          cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#61afef guibg=NONE
" @symbol            cterm=italic gui=italic guifg=#56b6c2
hi @symbol           cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE
" @variable.builtin  cterm=italic gui=italic guifg=#56b6c2
hi @variable.builtin cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE
" @text.emphasis     cterm=italic gui=italic guifg=#61afef
hi @text.emphasis    cterm=NONE gui=NONE guifg=#61afef guibg=NONE
" @constant          cterm=NONE ctermfg=9
" @constant          ctermfg=9 gui=NONE guifg=#56b6c2
hi @constant         cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#56b6c2 guibg=NONE

" hi Comment         guifg=DarkGrey guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
" hi @comment        cterm=italic gui=italic guifg=#5c6370
" hi @comment        cterm=NONE gui=NONE guifg=DarkGray
hi! Cursor         guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! TermCursor     guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! lCursor        guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! Cursor2        guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! Comment        guifg=#444444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
hi! SpecialComment guifg=#ff4444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
hi! @comment       cterm=NONE gui=NONE guifg=#333344 guibg=NONE ctermfg=45 ctermbg=NONE
hi! @string        guifg=#99aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
hi! @parameter     guifg=#22aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
hi! @function.call guifg=#00aa99 guibg=NONE ctermfg=NONE ctermbg=NONE cterm=NONE gui=NONE term=NONE

highlight FileStyleIgnorePattern guibg=NONE ctermbg=0
hi NewLineWin ctermfg=248 guifg=#999999
match NewLineWin /\r\n/
hi! ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

hi! ShowTrailingWhitespace ctermbg=Yellow guibg=Yellow
" hi SpecialKey   ctermfg=DarkGray guifg=NONE
" hi! link SpecialKey Comment
hi! VertSplit    guifg=#222222 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
" hi! link SpecialKey VertSplit
hi! WinSeparator guifg=#222222 guibg=NONE ctermfg=DarkRed  ctermbg=NONE cterm=NONE gui=NONE term=NONE
" hi! SignColumn     ctermbg=NONE guibg=NONE
hi! link SignColumn WinSeparator
hi! link SpecialKey WinSeparator

silent! execute 'highlight LineNr ctermfg=' . '3' . ' ctermbg=NONE guifg=' .
	\ 'Gray' . ' guibg=NONE' . ' cterm=NONE term=NONE gui=NONE'

hi! CursorLineNr ctermbg=NONE ctermfg=15 guibg=#444444 guifg=#ffffff
	\ cterm=inverse term=inverse gui=inverse

silent! execute 'set fillchars =vert:\│,horiz:\_'
let &fillchars ..=',eob: '

hi EndOfBuffer       ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=NONE
" NvimInternalError  ctermfg=237 ctermbg=13 guifg=Red guibg=Red
hi NvimInternalError ctermfg=237 ctermbg=13 guifg=#ffffff guibg=Brown
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
" hi DiagnosticUnderlineError guisp=red
hi! link DiagnosticUnderlineError DiagnosticError
hi DiagnosticWarn           ctermfg=Yellow guifg=yellow term=undercurl cterm=undercurl
" hi! DiagnosticUnderlineWarn  guisp=yellow
hi! link DiagnosticUnderlineWarn DiagnosticWarn
hi CocInlayHint             guibg=NONE guifg=#6F7378 ctermbg=NONE ctermfg=DarkGray

hi CtrlSpaceSelected        term=reverse ctermfg=187  ctermbg=23  cterm=bold
hi CtrlSpaceNormal          term=NONE    ctermfg=244  ctermbg=232 cterm=NONE
hi CtrlSpaceSearch          ctermfg=220  ctermbg=NONE cterm=bold
hi CtrlSpaceStatus          ctermfg=230  ctermbg=234  cterm=NONE

]])

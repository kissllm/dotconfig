
local hl = vim.api.nvim_set_hl

-- Inspect check highlight group of current cursor

-- " hi! Search      ctermfg=237  ctermbg=13
-- " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=#22aa77 ctermfg=45 cterm=inverse term=inverse gui=inverse
-- " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45 cterm=inverse term=inverse gui=inverse
-- " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45
-- " hi! IncSearch   ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45 cterm=inverse term=inverse gui=inverse
-- hl(0, 'Search',    { fg = 'NONE', bg = '#56b6c2', reverse = true })
-- hl(0, 'Search',    { fg = 'Black', bg = '#56b6c2' })
hl(0, 'Search',    { fg = '#ffffff', bg = 'Brown' })
-- shVariable links to Identifier
-- " hi! Identifier  ctermbg=NONE guibg=#56b6c2 guifg=Teal ctermfg=6
-- hi! Identifier  ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=6
-- hl(0, 'Identifier',    { fg = '#56b6c2', bg = 'Brown' })
hl(0, 'Identifier',    { fg = 'Teal', bg = 'NONE' })


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

" hi Visual ctermbg=NONE ctermfg=NONE guifg=Teal guibg=NONE term=inverse cterm=inverse gui=inverse
hi! Visual ctermbg=NONE ctermfg=NONE guifg=NONE guibg=#22aa77 term=NONE cterm=NONE gui=NONE

silent! execute 'highlight! NonText ctermfg=' . g:nontext_fg_cterm .
	\ ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

" indent_blankline
hi! SignColumn  ctermbg=NONE guibg=NONE
hi! IncSearch   ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45
hi! rstEmphasis ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=45
hi! manItalic   ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=45
hi! Keyword     ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=6
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
" @text.emphasis     cterm=italic gui=italic guifg=#61afef
hi @text.emphasis    cterm=NONE gui=NONE guifg=#61afef guibg=NONE
" @constant          cterm=NONE ctermfg=9
" @constant          ctermfg=9 gui=NONE guifg=#56b6c2
hi @constant         cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#56b6c2 guibg=NONE

" hi Comment         guifg=DarkGrey guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
" hi! Comment        guifg=#444444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
" hi @comment        cterm=italic gui=italic guifg=#5c6370
" hi @comment        cterm=NONE gui=NONE guifg=DarkGray
" hi! @comment       cterm=NONE gui=NONE guifg=#333344 guibg=NONE ctermfg=45 ctermbg=NONE

:highlight! Cursor gui=reverse guifg=NONE guibg=NONE
" :highlight! Cursor gui=NONE guifg=bg guibg=fg
" hi! Cursor         guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! TermCursor     guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! lCursor        guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! Cursor2        guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hi! SpecialComment guifg=#ff4444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
" hi! Comment        guifg=#ffffff guibg=#000000 ctermfg=DarkGray ctermbg=NONE cterm=inverse term=inverse gui=inverse
" hi! @comment       guifg=#ffffff guibg=#000000 ctermfg=45 ctermbg=NONE cterm=inverse term=inverse gui=inverse
hi! @parameter     guifg=#22aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE

highlight FileStyleIgnorePattern guibg=NONE ctermbg=0
hi NewLineWin ctermfg=248 guifg=#999999
match NewLineWin /\r\n/
" hi! ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" hi! ShowTrailingWhitespace ctermbg=Yellow guibg=#22aa77
" hi SpecialKey   ctermfg=DarkGray guifg=NONE
" hi! link SpecialKey Comment
hi! VertSplit    guifg=#222222 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
" hi! link SpecialKey VertSplit
hi! WinSeparator guifg=#222222 guibg=NONE ctermfg=DarkRed  ctermbg=NONE cterm=NONE gui=NONE term=NONE

" indent_blankline
" hi! SignColumn     ctermbg=NONE guibg=NONE
" hi! link SignColumn WinSeparator
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
hi CtrlSpaceSearch          ctermfg=220  ctermbg=NONE cterm=bold  guibg=#56b6c2
hi CtrlSpaceStatus          ctermfg=230  ctermbg=234  cterm=NONE

" https://vi.stackexchange.com/questions/6803/poor-syntax-highlighting-in-vimwiki-command-prompt
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
" https://vi.stackexchange.com/questions/38840/vimwiki-overriding-normal-md-highlighting
let g:vimwiki_ext2syntax = {}

]])

-- TSCurrentScope use CursorLine
-- hl(0, 'CursorLine',    { cterm=underline, guibg=#282736, })
hl(0, 'CursorLine', { bg = 'NONE' })
-- hl(0, 'CursorLine', { fg = 'NONE' })
--

-- indent_blankline::highlight_guides
-- hl(0, 'Comment',    { fg = 'DarkGray', bg = 'NONE', reverse = true })
-- hl(0, 'Comment',    { fg = 'DarkGray', bg = 'Black', reverse = true })
-- hl(0, 'Comment',    { fg = 'Black', bg='DarkGrey' })
hl(0, 'Comment',    { bg = 'Blue', fg='DarkGrey' })
-- hl(0, 'Comment',    { fg = 'White', bg='#c0c0c0' })
-- hl(0, '@comment',   { fg = 'DarkGray', bg = 'NONE', reverse = true })
-- hl(0, '@comment',   { fg = 'DarkGray', bg = 'Black', reverse = true })
-- hl(0, '@comment',   { fg = 'Black', bg='DarkGrey' })
hl(0, '@comment',   { bg = 'Blue', fg='DarkGrey' })
-- hl(0, '@comment',   { fg = 'White', bg='#c0c0c0' })

--
-- Control the highlight guides
-- CursorColumn   xxx guibg=#313640
hl(0, 'WinSeparator', { fg = '#444444', bg = 'NONE', })
-- indent_blankline::highlight_guides
-- hl(0, 'SignColumn',   { bg = '#ffd7af', fg = 'NONE', })
hl(0, 'SignColumn',   { bg = '#008080', fg = 'NONE', })
-- SpecialComment xxx ctermfg=242 guifg=#ff4444
hl(0, 'SpecialComment',   { bg = '#008080', fg = 'NONE', })
--
-- SignColumn     xxx guifg=#dcdfe4
--                    links to WinSeparator
-- hl(0, 'CursorColumn',   { bg = '#202020', fg = 'NONE', italic = true })
-- hl(0, 'CursorColumn',   { bg = '#606090', fg = 'NONE', })
-- hl(0, 'CursorColumn',   { fg = 'DarkGray', bg = 'NONE', reverse = true })
-- indent_blankline
-- hl(0, 'CursorColumn', { fg = 'NONE', reverse = true })
hl(0, 'CursorColumn', { bg = 'NONE', fg = 'Blue' })
-- hl(0, 'CursorColumn',   { fg = 'DarkBlue', bg = 'NONE', italic = true })
-- hl(0, 'CursorColumn',   { fg = 'Gray', bg = 'NONE', italic = true })
-- vim_lsp_references


hl(0, 'LspReferenceText', { bg = 'NONE' })

-- " @variable.builtin  cterm=italic gui=italic guifg=#56b6c2
-- hi @variable.builtin cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE
-- @variable      xxx guifg=#dcdfe4
-- hl(0, '@variable', { fg = 'Orange', bg = 'NONE' })
hl(0, '@variable',         { fg = '#ff4444', bg = 'NONE' })
hl(0, '@variable.builtin', { fg = '#cbbf66', bg = 'NONE' })

-- " hi! @string        guifg=#99aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
-- " hi! @string        guifg=Magenta guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
-- " hi! @string        guifg=Orange guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
-- " hi! @string        guifg=#cbbf66 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
hl(0, '@string', { fg = '#cbbf66', bg = 'NONE' })
hl(0, 'String',  { fg = '#8787af', bg = 'NONE' })

-- " hi! @function.call guifg=#00aa99 guibg=NONE ctermfg=NONE ctermbg=NONE cterm=NONE gui=NONE term=NONE
-- " @function      xxx guifg=#61afef
-- " hi! @function.call guifg=#56b6c2 guibg=NONE ctermfg=NONE ctermbg=NONE cterm=NONE gui=NONE term=NONE
hl(0, '@function',      { fg = 'Teal', bg = 'NONE' })
hl(0, '@function.call', { fg = 'Teal', bg = 'NONE' })

-- hi! Function    ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=6
hl(0, 'Function',       { fg = '#56b6c2', bg = 'NONE' })
--
-- shIf
-- shDoubleQuote links to String
-- shDerefSimple links to PreProc
hl(0, 'PreProc',        { fg = 'Cyan', bg = 'NONE' })
-- hl(0, 'shDerefSimple', { bg = '#eeaa77', fg = 'NONE' })
-- hl(0, 'shDerefSimple', { fg = 'Magenta', bg = 'NONE' })
-- hl(0, 'shDerefSimple', { bg = '#808000', fg = 'NONE' })
-- hl(0, 'shDerefSimple', { fg = '#ffd7af', bg = '#ffff00' })
-- hl(0, 'shDerefSimple',   { fg = 'Teal', bg = 'NONE', bold = true })
hl(0, 'shDerefSimple',   { fg = '#008080', bg = 'NONE' })
hl(0, 'shDerefSimpleNE', { fg = 'Cyan', bg = 'NONE' })
hl(0, 'shColon', { bg = '#ffd7af', fg = 'NONE', link='shDerefSimple' })

hl(0, 'shDerefVar',    { fg = 'Teal', bg = 'NONE' })
hl(0, 'shFor',         { fg = 'Teal', bg = 'NONE' })
-- The spaces between expressions
-- indent_blankline ?
hl(0, 'shDo',          { fg = '#808000', bg = 'NONE' })
hl(0, 'shExpr',        { fg = '#808000', bg = 'NONE' })
hl(0, 'shFunctionOne', { fg = '#808000', bg = 'NONE' })
hl(0, 'Statement',     { fg = '#808000', bg = 'NONE' })
-- htmlItalic
-- htmlItalic     xxx cterm=italic gui=italic
-- wiki uses it
hl(0, 'htmlItalic', { fg = 'Blue', bg = 'NONE' })

-- :highlight! Cursor gui=reverse guifg=NONE guibg=NONE
-- hl(0, 'Cursor', { fg = 'NONE', bg = 'NONE', reverse = true, blend = 0, nocombine = true })
hl(0, 'Cursor',     { fg = 'White', bg = '#c0c0c0', blend = 10, nocombine = true })

-- hi! TermCursor     guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
-- hi! lCursor        guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
-- hi! Cursor2        guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
hl(0, 'TermCursor', { fg = 'NONE', bg = 'NONE', reverse = true, blend = 10, nocombine = true })
hl(0, 'lCursor',    { fg = 'NONE', bg = 'NONE', reverse = true, blend = 10, nocombine = true })
hl(0, 'Cursor2',    { fg = 'NONE', bg = 'NONE', reverse = true, blend = 10, nocombine = true })
-- indent_blankline::highlight_empty
-- Whitespace     xxx guifg=#615e5e
-- hl(0, 'Whitespace', { fg = 'NONE', })
hl(0, 'Whitespace',             { bg = 'NONE', fg = '#808000' })
hl(0, 'ShowTrailingWhitespace', { fg = 'Blue', bg = 'red' })
hl(0, 'ExtraWhitespace',        { bg = 'red',  fg = 'NONE' })
hl(0, 'diffLine',               { bg = '#808000',  fg = 'NONE' })
hl(0, 'diffAdded',              { bg = 'Teal',  fg = 'NONE' })














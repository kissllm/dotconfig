
local hl           = vim.api.nvim_set_hl
local set          = vim.opt
local set_local    = vim.opt_local
--  default_background = 'light'
    default_background = 'dark'

--  python /mnt/local/bin/colortrans.py
--  Inspect check highlight group of current cursor
--  :TSHighlightCapturesUnderCursor --  nvim-treesitter/playground
--  :TSNodeUnderCursor
--  :Telescope highlights
--  TSCurrentScope nvim-treesitter-current-scope
--
vim.cmd[[

" colorscheme onehalf-lua
" colorscheme onehalf-lush
" colorscheme onehalf-lush-dark
let base16colorspace    = 256

let g:cterm_fg_insert   = 'NONE'
let g:cterm_bg_insert   = '4'

let g:nontext_fg_cterm  = 'NONE'

" let g:nontext_fg_gui  = 'NONE'
let g:nontext_fg_gui    = '#222222'

match NewLineWin /\r\n/
" hi! ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

silent! execute 'set fillchars =vert:\│,horiz:\_'
let &fillchars ..=',eob: '

" hi DiagnosticUnderlineError guisp=red
hi! link DiagnosticUnderlineError DiagnosticError
" hi! DiagnosticUnderlineWarn  guisp=yellow
hi! link DiagnosticUnderlineWarn DiagnosticWarn

" https://vi.stackexchange.com/questions/6803/poor-syntax-highlighting-in-vimwiki-command-prompt
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
" https://vi.stackexchange.com/questions/38840/vimwiki-overriding-normal-md-highlighting
let g:vimwiki_ext2syntax = {}
" https://vi.stackexchange.com/questions/39078/wrong-colors-in-of-telescope-window
hi! link NormalFloat Normal
" https://github.com/vimwiki/vimwiki/issues/116
" hi def link VimwikiCode Search
]]


local function dark()


--  " hi! Search      ctermfg=237  ctermbg=13
--  " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=#22aa77 ctermfg=45 cterm=inverse term=inverse gui=inverse
--  " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45 cterm=inverse term=inverse gui=inverse
--  " hi! Search      ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45
--  " hi! IncSearch   ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45 cterm=inverse term=inverse gui=inverse
--  Must could be reverse and still visible
--  "Visual" and "Search" are a pair unless nocombine == true
--  hl(0, 'Search',              { fg = 'NONE',     bg = '#56b6c2', reverse = true })
--  hl(0, 'Search',              { fg = 'Black',    bg = '#56b6c2' })
--  hl(0, 'Search',              { fg = '#ffffff',  bg = '#ff00ff' })
--  hl(0, 'Search',              { fg = 'White',    bg = 'Brown' })
    hl(0, 'Search',              { bg = '#ff4444',  fg='White',     nocombine = true, bold = true })
--  hl(0, 'IncSearch',           { bg = 'NONE',     fg='NONE',      reverse = true })
--  hl(0, 'IncSearch',           { bg = 'NONE',     fg='NONE' })
--  hl(0, 'IncSearch',           { bg = '#ffffff',  fg='NONE',      nocombine = true, bold = true })
    hl(0, 'IncSearch',           { bg = '#ff00ff',  fg='White',     nocombine = true, bold = true })
--  shVariable links to Identifier
--  " hi! Identifier  ctermbg=NONE guibg=#56b6c2 guifg=Teal ctermfg=6
--  hi! Identifier    ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=6
--  hl(0, 'Identifier',          { fg = '#56b6c2',  bg = 'Brown' })
--  hl(0, 'Identifier',          { fg = 'Teal',     bg = '#ff00ff', nocombine = true, bold = true })
--  hl(0, 'Identifier',          { fg = 'Teal',     bg = 'White',   nocombine = true, bold = true })
    hl(0, 'Identifier',          { fg = 'Teal',     bg = 'NONE',    nocombine = true, bold = true })

--  if vim.opt_local.background == 'dark' then
--  " hi! Normal      ctermbg=0 guibg=NONE
    hl(0, 'Normal',              { fg = 'NONE',  bg = 'NONE' })
    hl(0, 'ActiveWindow',        { fg = 'NONE',  bg = 'NONE', link = 'Normal', })
--  hl(0, 'InactiveWindow',      { bg = 'DarkGrey', })
--  hl(0, 'InactiveWindow',      { bg = 'Teal', })
    hl(0, 'NormalNC',            { fg = 'NONE',  bg = 'Blue', })
    hl(0, 'InactiveWindow',      { fg = 'NONE',  bg = 'Blue', link = 'NormalNC', })
--  else
--      hl(0, 'Normal',              { fg = 'NONE',  bg = 'DarkGrey' })
--  end
--
--  When cursor is on a word, other similar word highlight by "Visual"
--  "Visual" and "Search" are a pair unless nocombine == true
--  " hi Visual       ctermbg=NONE ctermfg=NONE guifg=Teal guibg=NONE term=inverse cterm=inverse gui=inverse
--  hi! Visual        ctermbg=NONE ctermfg=NONE guifg=NONE guibg=#22aa77 term=NONE cterm=NONE gui=NONE
--  hl(0, 'Visual',              { bg = '#22aa77',  fg='Teal' })
--  hl(0, 'Visual',              { bg = 'Black',    fg='Teal',      reverse = true })
--  hl(0, 'Visual',              { bg = 'NONE',     fg='#ff00ff' })
--  hl(0, 'Visual',              { bg = 'White',    fg='#56b6c2',   reverse = true })
--  hl(0, 'Visual',              { fg = 'White',    bg='Cyan',      nocombine = true })
--  hl(0, 'Visual',              { fg = 'Black',    bg='Cyan',      nocombine = true })
--  hl(0, 'Visual',              { fg = 'Black',    bg='NONE',      nocombine = true, reverse = true })
--  hl(0, 'Visual',              { bg = 'NONE',     fg='NONE',      nocombine = true, bold = true, reverse = true })
    hl(0, 'Visual',              { fg = 'Teal',     bg = 'White',   nocombine = true, bold = true })
    hl(0, 'StatusLine',          { fg = 'White',    bg='Blue',      nocombine = true })
--  hl(0, 'StatusLine',          { fg = '#ff4444',  bg = 'NONE' })


    hl(0, 'FileStyleIgnorePattern',  { bg  = 'NONE', })
    hl(0, 'NewLineWin',              { fg  = '#999999', })

    hl(0, 'NonText',                 { fg  = 'NONE',     bg = 'NONE', })
    hl(0, 'rstEmphasis',             { fg  = '#22aa77',  bg = 'NONE', })
    hl(0, 'manItalic',               { fg  = '#22aa77',  bg = 'NONE', })
    hl(0, 'Keyword',                 { fg  = '#22aa77',  bg = 'NONE', })
    hl(0, 'NvimTreeFolderIcon',      { fg  = 'NONE',     bg = 'gray', })
    hl(0, 'SpellBad',                { fg  = '#02aa77',  bg = 'NONE', })
    hl(0, 'SpellLocal',              { fg  = '#02aa77',  bg = 'NONE', })
    hl(0, 'SpellRare',               { fg  = '#02aa77',  bg = 'NONE', })
    hl(0, 'SpellCap',                { fg  = '#02aa77',  bg = 'NONE', })

    hl(0, 'VertSplit',               { fg  = 'DarkGray', bg = 'NONE',    nocombine = true, })
    hl(0, 'EndOfBuffer',             { fg  = 'NONE',     bg = 'NONE', })
    hl(0, 'NvimInternalError',       { fg  = 'White',    bg = 'Brown', })
    hl(0, 'ErrorMsg',                { fg  = 'NONE',     bg = '#aa0000', })
    hl(0, 'SyntasticWarning',        { fg  = 'Black',    bg = 'NONE', })
    hl(0, 'ALEWarning',              { fg  = 'Black',    bg = 'NONE', })
    hl(0, 'SyntasticError',          { fg  = 'NONE',     bg = '#aa0000', })
    hl(0, 'ALEError',                { fg  = 'NONE',     bg = '#aa0000', })
    hl(0, 'CocUnderline',            { fg  = 'NONE',     bg = 'NONE',    undercurl = true })
    hl(0, 'DiagnosticError',         { fg  = 'NONE',     bg = '#aa0000', })
    hl(0, 'DiagnosticWarn',          { fg  = 'NONE',     bg = 'Brown', })
    hl(0, 'CocInlayHint',            { fg  = 'NONE',     bg = 'Blue', })
    hl(0, 'VimwikiCode',             { fg  = 'Teal',     bg = 'Gray', })
    hl(0, 'VimwikiPre',              { fg  = 'NONE',     bg = 'NONE', })
    hl(0, 'VimwikiBold',             { fg  = 'NONE',     bg = 'NONE',    bold      = true })
    hl(0, 'VimwikiItalic',           { fg  = 'NONE',     bg = '#cc0000', italic      = true })
--  hl(0, 'NonText',             { fg           = 'NONE',    bg     = 'NONE', })
--  hl(0, 'NonText',             { fg           = 'NONE',    bg     = 'NONE', })

vim.cmd[[
" indent_blankline
" hi! IncSearch      ctermbg=NONE guibg=#56b6c2 guifg=NONE ctermfg=45
" hi! rstEmphasis      ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=45
" hi! manItalic        ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=45
" hi! Keyword          ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=6
" help TUI
" hi NonText cterm=NONE ctermfg=NONE

" silent! execute 'highlight! NonText ctermfg=' . g:nontext_fg_cterm .
"   \ ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'
" silent! execute 'highlight NonText ctermfg=' . g:nontext_fg_cterm .
"   \ ' ctermbg=NONE guifg=' . g:nontext_fg_gui . ' guibg=NONE'

" hi NvimTreeFolderIcon guibg=blue
" hi NvimTreeFolderIcon guibg=gray


" hi SpellBad          cterm=underline ctermfg=9
" hi SpellLocal        cterm=underline ctermfg=9
" hi SpellRare         cterm=underline ctermfg=9
" hi SpellCap          cterm=underline


" hi FileStyleIgnorePattern guibg=NONE ctermbg=0
" hi NewLineWin        ctermfg=248 guifg=#999999

" hi! ShowTrailingWhitespace ctermbg=Yellow guibg=#22aa77
" hi! VertSplit        guifg=#222222 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE

" hi EndOfBuffer       ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=NONE
" NvimInternalError  ctermfg=237 ctermbg=13 guifg=Red guibg=Red
" hi NvimInternalError ctermfg=237 ctermbg=13 guifg=#ffffff guibg=Brown
" ErrorMsg           cterm=reverse ctermfg=167 ctermbg=234 gui=reverse guifg=#d75f5f guibg=#1c1c1c
" hi ErrorMsg          cterm=NONE ctermfg=167 ctermbg=234 gui=NONE guifg=#d75f5f guibg=#1c1c1c

" hi SyntasticWarning  ctermbg=yellow ctermfg=black
" hi ALEWarning        ctermbg=yellow ctermfg=black
" hi SyntasticError    ctermbg=red ctermfg=black
" hi ALEError          ctermbg=red ctermfg=black
" hi CocUnderline      term=undercurl
" hi DiagnosticError   ctermfg=red guifg=red term=undercurl cterm=undercurl
" hi DiagnosticWarn    ctermfg=Yellow guifg=yellow term=undercurl cterm=undercurl
" hi CocInlayHint      guibg=NONE guifg=#6F7378 ctermbg=NONE ctermfg=DarkGray
" hi VimwikiCode       term=bold   ctermfg=Cyan guifg=#80a0ff gui=bold
" hi VimwikiPre        term=bold   ctermfg=Cyan guifg=#80a0ff gui=bold
" hi VimwikiBold       term=bold   ctermfg=Cyan guifg=#80a0ff gui=bold
" hi VimwikiItalic     term=italic ctermfg=Red  guifg=#cc0000 gui=italic
]]

--  hi CtrlSpaceSelected         term=reverse ctermfg=187  ctermbg=23  cterm=bold
--  hi CtrlSpaceNormal           term=NONE    ctermfg=244  ctermbg=232 cterm=NONE
--  hi CtrlSpaceSearch           ctermfg=220  ctermbg=NONE cterm=bold  guibg=#56b6c2
--  hi CtrlSpaceStatus           ctermfg=230  ctermbg=234  cterm=NONE
    hl(0, 'CtrlSpaceSelected',   { fg = 'NONE',     bg='Blue', reverse = true })
    hl(0, 'CtrlSpaceNormal',     { fg = 'NONE',     bg='Blue', reverse = true })
    hl(0, 'CtrlSpaceSearch',     { fg = 'NONE',     bg='Blue', reverse = true })
    hl(0, 'CtrlSpaceStatus',     { fg = 'NONE',     bg='Blue', reverse = true })


--  indent_blankline::highlight_guides
--  " hi! Comment        guifg=DarkGrey guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
--  " hi! Comment        guifg=#444444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  " hi! Comment        guifg=#ffffff guibg=#000000 ctermfg=DarkGray ctermbg=NONE cterm=inverse term=inverse gui=inverse
--  " hi   @comment        cterm=italic gui=italic guifg=#5c6370
--  " hi   @comment        cterm=NONE gui=NONE guifg=DarkGray
--  " hi!  @comment       cterm=NONE gui=NONE guifg=#333344 guibg=NONE ctermfg=45 ctermbg=NONE
--  " hi!  @comment       guifg=#ffffff guibg=#000000 ctermfg=45 ctermbg=NONE cterm=inverse term=inverse gui=inverse
--  hl(0, 'Comment',             { fg = 'DarkGray', bg = 'NONE', reverse = true })
--  hl(0, 'Comment',             { fg = 'DarkGray', bg = 'Black', reverse = true })
--  hl(0, 'Comment',             { fg = 'NONE',     bg = 'Blue' })
    hl(0, 'Comment',             { fg = 'DarkGrey', bg = 'Blue',    })
--  hl(0, 'Comment',             { fg = 'Black',    bg = 'DarkGrey' })
--  hl(0, 'Comment',             { bg = 'Black',    fg = 'DarkGrey' })
--  hl(0, 'Comment',             { fg = 'White',    bg = '#c0c0c0' })
--  hl(0, '@comment',            { fg = 'DarkGray', bg = 'NONE', reverse = true })
--  hl(0, '@comment',            { fg = 'DarkGray', bg = 'Black', reverse = true })
--  hl(0, '@comment',            { fg = 'Black',    bg = 'DarkGrey' })
    hl(0, '@comment',            { fg = 'DarkGrey', bg = 'Blue',     })
--  hl(0, '@comment',            { fg = 'Black',    bg = 'DarkGrey' })
--  hl(0, '@comment',            { fg = 'White',    bg = '#c0c0c0'  })
--  hi! SpecialComment    guifg=#ff4444 guibg=NONE ctermfg=DarkGray ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  SpecialComment xxx    ctermfg=242 guifg=#ff4444
    hl(0, 'SpecialComment',      { bg = '#008080',  fg = 'NONE',  })

    hl(0, 'WhiteSpace',          { bg = 'Blue',     fg='DarkGrey' })

--
--  Control the highlight guides
--  CursorColumn   xxx    guibg=#313640
--  hi! WinSeparator      guifg=#222222 guibg=NONE ctermfg=DarkRed  ctermbg=NONE cterm=NONE gui=NONE term=NONE
    hl(0, 'WinSeparator',        { fg = '#444444',  bg = 'NONE', })
--  " hi SpecialKey       ctermfg=DarkGray guifg=NONE
--  " hi! link SpecialKey Comment
--  " hi! link SpecialKey VertSplit
--  hi! link SpecialKey WinSeparator
    hl(0, 'SpecialKey',          { fg = '#444444',  bg = 'NONE', })
--  indent_blankline::highlight_guides
--  " indent_blankline
--  " hi! SignColumn      ctermbg=NONE guibg=NONE
--  " hi! link SignColumn WinSeparator
--  " hi! SignColumn      ctermbg=NONE guibg=NONE
--  hl(0, 'SignColumn',          { bg = '#ffd7af',  fg = 'NONE', })
--  hl(0, 'SignColumn',          { bg = '#008080',  fg = 'NONE', })
    hl(0, 'SignColumn',          { fg = '#008080',  bg = 'NONE', })
--
--  SignColumn     xxx    guifg=#dcdfe4
--                     links to WinSeparator

--  hl(0, 'LineNr',              { bg = 'Black',    fg = '#606090' })
    hl(0, 'LineNr',              { bg = 'NONE',     fg = '#444444' })
--  silent! execute 'highlight LineNr ctermfg=' . '3' . ' ctermbg=NONE guifg=' .
--   \ 'Gray' . ' guibg=NONE' . ' cterm=NONE term=NONE gui=NONE'
--
--

--  vim.api.nvim_create_autocmd({ "VimEnter",  "BufEnter",  "BufWinEnter",  "InsertLeave", "CmdlineLeave" }, {
--      desc = 'Color Dynamic',
--      group = vim.api.nvim_create_augroup('color_leave', { clear = true }),
--      pattern = "*",
--  vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
--      desc = 'Color Dynamic',
--      group = vim.api.nvim_create_augroup('color_enter', { clear = true }),
--      pattern = "*",
--      callback = function(args)

--    :highlight! Cursor gui=reverse guifg=NONE guibg=NONE
--  " :highlight! Cursor gui=NONE guifg=bg guibg=fg
--  "  hi!        Cursor guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
--  hi! TermCursor       guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=reverse gui=reverse term=reverse
--  lCursor --  language cursor
--  hi! lCursor          guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=reverse gui=reverse term=reverse
--  hi! Cursor2          guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=reverse gui=reverse term=reverse

--  :highlight! Cursor   gui=reverse guifg=NONE guibg=NONE
--  hl(0, 'Cursor',              { fg = 'NONE',     bg = 'NONE', reverse = true, blend = 0, nocombine = true })
--  hl(0, 'Cursor',              { fg = 'White',    bg = '#c0c0c0', blend = 10, nocombine = true })
--  hl(0, 'Cursor',              { fg = 'NONE',     bg = '#c0c0c0', blend = 10, nocombine = true })
--  hl(0, 'Cursor',              { fg = 'NONE',     bg = 'NONE',    reverse = true, blend = 80, nocombine = true })
    hl(0, 'Cursor',              { fg = 'NONE',     bg = 'NONE',    reverse = true, blend = 80, nocombine = true })
--  hl(0, 'Cursor',              { fg = 'White',    bg = 'NONE',    blend = 10, nocombine = true })

--  hi! TermCursor       guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
--  hi! lCursor          guifg=NONE guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
--  hi! Cursor2          guifg=red  guibg=NONE ctermfg=2 ctermbg=0 cterm=NONE gui=NONE term=NONE
    hl(0, 'TermCursor',          { fg = 'NONE',     bg = 'NONE',    reverse = true, blend = 80, nocombine = true })
    hl(0, 'lCursor',             { fg = 'NONE',     bg = 'NONE',    reverse = true, blend = 80, nocombine = true })
    hl(0, 'Cursor2',             { fg = 'NONE',     bg = 'NONE',    reverse = true, blend = 80, nocombine = true })

--
--  https://www.reddit.com/r/vim/comments/ocp8xv/cursorline_and_cursorcolumn_highlight_behavior/
--  Very slow. Refresh background on every cursor movement
--  Highlight workzone will affect this behavior
--  hl(0, 'CursorColumn',        { bg = '#202020',  fg = 'NONE', italic = true })
--  hl(0, 'CursorColumn',        { bg = '#606090',  fg = 'NONE', })
--  hl(0, 'CursorColumn',        { fg = 'DarkGray', bg = 'NONE', reverse = true })

--  hl(0, 'CursorColumn',        { fg = 'NONE', reverse = true })
--  hl(0, 'CursorColumn',        { fg = 'NONE',     bg = 'Blue' })
--  hl(0, 'CursorColumn',        { fg = 'NONE',     bg = '#606090', blend = 10, nocombine = true })
--  hl(0, 'CursorColumn',        { fg = 'NONE',     bg = '#606090', blend = 10, nocombine = true })
--  hl(0, 'CursorColumn',        { fg = 'NONE',     bg = 'Orange',  nocombine = true })
--  hl(0, 'CursorColumn',        { fg = 'NONE',     bg = 'White',   nocombine = true })
    hl(0, 'CursorColumn',        { fg = 'White',    bg = 'Blue',    nocombine = true })
--  hl(0, 'CursorColumn',        { fg = 'DarkBlue', bg = 'NONE',    italic = true })
--  hl(0, 'CursorColumn',        { fg = 'Gray',     bg = 'NONE',    italic = true })

--      end,
--  })


--
--
--  hl(0, 'CursorLineNr',        { bg = 'Black',    fg = '#606090', bold = true })
--  hl(0, 'CursorLineNr',        { bg = 'NONE',     fg = '#606090', bold = true })
    hl(0, 'CursorLineNr',        { fg = 'White',    bg = 'Teal', bold = true })
--  hi! CursorLineNr      ctermbg=NONE ctermfg=15 guibg=#444444 guifg=#ffffff
--   \ cterm=inverse term=inverse gui=inverse

--  hl(0, 'CursorLine',          { cterm=underline, guibg=#282736, })
--  hl(0, 'CursorLine',          { bg = 'NONE' })
--  hl(0, 'CursorLine',          { fg = 'NONE',     bg = '#606090' })
--  hl(0, 'CursorLine',          { bg = 'NONE',     fg = '#282736' })
--  if vim.opt_local.background == 'dark' then
--  hl(0, 'CursorLine',          { bg = 'NONE',     fg = 'NONE',    bold = true, reverse = true })
--  hl(0, 'CursorLine',          { bg = 'Black',    fg = 'NONE',    bold = true, nocombine = true })
--  hl(0, 'CursorLine',          { bg = 'White',    fg = 'Black',   blend = 10, bold = true, nocombine = true, reverse = true })
--  hl(0, 'CursorLine',          { bg = 'White',    fg = 'Black',   blend = 10, bold = true, nocombine = true, reverse = true })
--  hl(0, 'CursorLine',          { fg = 'White',    bg = 'Black',   bold = true, nocombine = true })
--  hl(0, 'CursorLine',          { fg = 'NONE',     bg = 'Black',   blend = 80, nocombine = true })
--  hl(0, 'CursorLine',          { fg = 'NONE',     bg = 'NONE',   blend = 90, reverse = true, nocombine = true })

--  hl(0, 'CursorLine',          { fg = 'NONE',     bg = 'Black',    blend = 10, nocombine = true })

--  hl(0, 'CursorLine',          { fg = 'NONE',     bg = 'NONE',    blend = 80, nocombine = true, reverse = true })
--  hl(0, 'CursorLine',          { bg = 'NONE',     fg = 'NONE',    blend = 10, bold = true, nocombine = true })
--  hl(0, 'CursorLine',          { fg = 'NONE' })
--
--  end
--  TSCurrentScope default links to CursorLine, which is really annoying
    hl(0, 'TSCurrentScope',      { bg = 'NONE',     fg = 'NONE',    nocombine = true })
--  hl(0, 'TSCurrentScope',      { fg = 'White',    bg = 'NONE', nocombine = true, })

--
--   Moved to indent-blankline.lua
--   indent_blankline

--  vim_lsp_references

--  No such highlight group
    hl(0, 'LspReferenceText',    { bg = 'NONE' })

--  " hi! @string        guifg=#99aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  " hi! @string        guifg=Magenta guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  " hi! @string        guifg=Orange  guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  " hi! @string        guifg=#cbbf66 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  hl(0, '@string',             { fg = '#cbbf66',  bg = 'NONE' })
    hl(0, '@string',             { fg = '#458588',  bg = 'NONE' })
--  hl(0, 'String',              { fg = '#8787af',  bg = 'NONE' })
    hl(0, 'String',              { fg = 'Magenta',  bg = 'NONE' })

--  " hi! @function.call guifg=#00aa99 guibg=NONE ctermfg=NONE ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  " @function      xxx guifg=#61afef
--  " hi! @function.call guifg=#56b6c2 guibg=NONE ctermfg=NONE ctermbg=NONE cterm=NONE gui=NONE term=NONE
--  hl(0, '@function',           { fg = 'White',    bg = 'Magenta', bold = true })
    hl(0, '@function',           { fg = 'Magenta',  bg = 'NONE', bold = true })
    hl(0, '@function.call',      { fg = 'Teal',     bg = 'NONE' })
--  hl(0, '@function.builtin',   { fg = 'Teal',     bg = 'NONE' })
--  Will mix with "function" group
    hl(0, '@function.builtin',   { fg = 'Red',      bg = 'NONE',   nocombine = true, blend = 10 })

--  hi! Function    ctermbg=NONE guibg=NONE guifg=#22aa77 ctermfg=6
    hl(0, 'Function',            { fg = 'Teal',     bg = 'NONE' })
--
--  shIf
--  shDoubleQuote links to String
--  shDerefSimple links to PreProc
    hl(0, 'PreProc',             { fg = 'Cyan',     bg = 'NONE' })
--  hl(0, 'shDerefSimple',       { bg = '#eeaa77',  fg = 'NONE' })
--  hl(0, 'shDerefSimple',       { fg = 'Magenta',  bg = 'NONE' })
--  hl(0, 'shDerefSimple',       { bg = '#808000',  fg = 'NONE' })
--  hl(0, 'shDerefSimple',       { fg = '#ffd7af',  bg = '#ffff00' })
--  hl(0, 'shDerefSimple',       { fg = 'Teal',     bg = 'NONE', bold = true })
    hl(0, 'shDerefSimple',       { fg = '#008080',  bg = 'NONE' })
    hl(0, 'shDerefSimpleNE',     { fg = 'Cyan',     bg = 'NONE' })
    hl(0, 'shColon',             { bg = '#ffd7af',  fg = 'NONE', link='shDerefSimple' })

    hl(0, 'shDerefVar',          { fg = 'Teal',     bg = 'NONE' })
    hl(0, 'shFor',               { fg = 'Teal',     bg = 'NONE' })
--  The spaces between expressions
--  indent_blankline ?
    hl(0, 'shDo',                { fg = '#6f7378',  bg = 'NONE' })
    hl(0, 'shExpr',              { fg = '#6f7378',  bg = 'NONE' })
    hl(0, 'shFunctionOne',       { fg = '#6f7378',  bg = 'NONE' })
    hl(0, 'Statement',           { fg = '#6f7378',  bg = 'NONE' })
--  htmlItalic
--  htmlItalic     xxx   cterm=italic gui=italic
--  vimwiki uses it
--  hl(0, 'htmlItalic',          { fg = 'Blue', bg = 'NONE' })
    hl(0, 'htmlItalic',          { fg = 'Orange',   bg = 'NONE' })

--  indent_blankline::highlight_empty
--  Whitespace     xxx   guifg=#615e5e
--  hl(0, 'Whitespace',          { fg = 'NONE', })

    hl(0, 'Whitespace',          { fg = 'NONE',     bg = 'NONE' })
--  hl(0, 'Whitespace',          { fg = 'Magenta',  bg = 'NONE' })
--
--  CtrlSpaceSelected    xxx cterm=reverse gui=reverse guibg=Blue
--  CtrlSpaceNormal      xxx cterm=reverse gui=reverse guibg=Blue
--  CtrlSpaceSearch      xxx cterm=reverse gui=reverse guibg=Blue
--  CtrlSpaceStatus      xxx cterm=reverse gui=reverse guibg=Blue
--
    hl(0, 'CtrlSpaceSelected',   { fg = 'White',    bg = 'Magenta' })
    hl(0, 'CtrlSpaceNormal',     { fg = 'White',    bg = 'Magenta' })
    hl(0, 'CtrlSpaceSearch',     { fg = 'White',    bg = 'Magenta' })
    hl(0, 'CtrlSpaceStatus',     { fg = 'White',    bg = 'Magenta' })
    hl(0, 'NeotestNamespace',    { fg = 'White',    bg = 'Magenta' })
    hl(0, 'DevIconBazelWorkspace',
                                 { fg = 'White',    bg = 'Magenta' })
    hl(0, 'htmlLeadingSpace',    { fg = 'White',    bg = 'Magenta' })
    hl(0, 'xmlNamespace',        { fg = 'White',    bg = 'Magenta' })
    hl(0, 'pythonSpaceError',    { fg = 'White',    bg = 'Magenta' })

    hl(0, 'IndentBlanklineSpaceChar',
                                 { fg = 'White',    bg = 'Magenta' })
    hl(0, 'IndentBlanklineSpaceCharBlankline',
                                 { fg = 'White',    bg = 'Magenta' })
    hl(0, 'ShowTrailingWhitespace',
                                 { fg = 'White',    bg = 'Magenta' })
    hl(0, 'ExtraWhitespace',     { fg = 'White',    bg = 'Magenta' })

--  '#6f7378' won't show in tty
--  hl(0, 'diffLine',            { bg = '#6f7378',  fg = 'White' })
    hl(0, 'diffLine',            { fg = 'White',    bg = 'Brown' })
--  hl(0, 'diffAdded',           { fg = 'White',    bg = 'Teal'  })
    hl(0, 'diffAdded',           { fg = 'Black',    bg = 'Cyan'  })
--  g=#80a0ff gui=bold
--  Extmarksf gui=bold
    hl(0, 'Extmarksf',           { bg = 'Teal',     fg = 'White' })
--  @variable
--  " @variable.builtin  cterm=italic gui=italic guifg=#56b6c2
--  hi @variable.builtin cterm=NONE gui=NONE guifg=#56b6c2 guibg=NONE
--  @variable      xxx   guifg=#dcdfe4
--  hl(0, '@variable',           { fg = 'White',    bg = 'NONE' })
    hl(0, '@variable',           { fg = 'White',    bg = 'NONE' })
    hl(0, '@variable.builtin',   { fg = 'White',    bg = 'NONE' })
    hl(0, '@variable.lua',       { fg = 'White',    bg = 'NONE' })
--  hl(0, '@variable',           { fg = '#56b6c2',  bg = 'White' })
--  " PmenuSel           cterm=NONE ctermfg=9
--  " PmenuSel           cterm=NONE ctermfg=9 guifg=#282c34 guibg=#61afef
--  " hi PmenuSel        cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#61afef guibg=NONE
    hl(0, 'PmenuSel',            { fg = '#ff4444',  bg = 'NONE' })
--  " hi @constant               cterm=NONE ctermfg=9
--  " hi @constant               ctermfg=9 gui=NONE guifg=#56b6c2
--  " hi @constant               cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#22aa77 guibg=NONE
    hl(0, 'Constant',            { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'PreProc',             { fg = '#ff4444',  bg = 'NONE' })
--  hi! Define           cterm=NONE gui=NONE guifg=#00ff00 guibg=NONE
--  hi! link Type Define
--  hi! link Tag  Define
    hl(0, 'Define',              { fg = '#22aa77',  bg = 'NONE' })
--  hl(0, 'Type',                { fg = 'Black',    bg = 'Cyan' })
    hl(0, 'Type',                { fg = 'Cyan',     bg = 'NONE' })
    hl(0, 'cmakeArguments',      { fg = 'Grey',     bg = 'NONE' })
    hl(0, 'Tag',                 { fg = '#22aa77',  bg = 'NONE' })
--  hi! Character        cterm=NONE gui=NONE guifg=#00ff00 guibg=#ff00ff ctermfg=45 ctermbg=NONE
    hl(0, 'Character',           { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconFsi',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconNi',           { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconBash',         { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconWav',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconRmd',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@textReference',      { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@constant',           { fg = '#808080',  bg = 'NONE' })
    hl(0, '@constructor',        { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DiffText',            { fg = '#ff4444',  bg = 'NONE' })
--  hi MatchParen                cterm=underline
    hl(0, 'MatchParen',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@attriute',           { fg = '#ff4444',  bg = 'NONE' })
--  hi! @parameter       guifg=#22aa77 guibg=NONE ctermfg=45   ctermbg=NONE cterm=NONE gui=NONE term=NONE
    hl(0, '@parameter',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@type.builtin',       { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'NoiceAttr120',        { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'LspReferenceWrite',   { fg = '#ff4444',  bg = 'NONE' })

--  " hi @symbol         cterm=italic gui=italic guifg=#56b6c2
--    hi @symbol         cterm=NONE gui=NONE guifg=#22aa77 guibg=NONE
    hl(0, '@symbol',             { fg = '#22aa77',  bg = 'NONE' })
--  " @text.emphasis     cterm=italic gui=italic guifg=#61afef
--  hi @text.emphasis    cterm=NONE gui=NONE guifg=#22aa77 guibg=NONE
    hl(0, '@text.emphasis',      { fg = '#22aa77',  bg = 'NONE' })
--  hl(0, '@spell',              { fg = '#22aa77',  bg = 'NONE' })
--  Will change comment foreground color
    hl(0, '@spell',              { fg = 'NONE',     bg = 'NONE' })
--  vimwiki/vimwiki#116
    hl(0, 'VimwikiCode',         { fg = 'NONE',     bg = 'NONE' })
    hl(0, 'VimwikiPre',          { fg = 'NONE',     bg = 'NONE' })
    hl(0, '@label',              { fg = '#c18401',    bg = 'NONE' })
--  DiagnosticInfo xxx guifg=#61afef --  noice border highlight ?
--  hi NoiceCmdlinePopupBorder NoiceCmdlinePopupBorderxxx links to DiagnosticSignInfo
--  hi DiagnosticSignInfo DiagnosticSignInfoxxx links to DiagnosticInfo
    hl(0, 'DiagnosticInfo',      { fg = 'NONE',     bg = 'NONE', nocombine = true,  })
--  hi FloatBorder FloatBorder   xxx links to NormalFloat -> link to Normal
    hl(0, 'FloatBorder',         { fg = 'NONE',     bg = 'NONE', nocombine = true,  })
--  hi DiagnosticSignWarn DiagnosticSignWarnxxx links to DiagnosticWarn
--  hi DiagnosticWarn DiagnosticWarn xxx guibg=Brown
--  hi Delimiter Delimiter     xxx guifg=#dcdfe4
--  hi NoiceCmdlinePopupTitle NoiceCmdlinePopupTitlexxx links to DiagnosticSignInfo
--  hi NoiceCmdlinePopup NoiceCmdlinePopupxxx links to Normal
end

local function light()

--  hl(0, 'Normal',              { fg = 'Black',    bg = 'Grey' })
    hl(0, 'Normal',              { fg = '#c18401',  bg = '#8a8a8a',  nocombine = true})
    hl(0, 'ActiveWindow',        { fg = '#c18401',  bg = 'DarkGrey', link = 'Normal', })
    hl(0, 'NormalNC',            { fg = 'White',    bg = 'Blue',     nocombine = true})
    hl(0, 'InactiveWindow',      { fg = 'White',    bg = 'Blue',     link = 'NormalNC', })
    hl(0, 'Identifier',          { fg = '#00afd7',  bg = 'NONE',     nocombine = true, bold = true })
    hl(0, 'Search',              { fg = '#ffffff',  bg = '#ff00ff',  nocombine = true, bold = true })
    hl(0, 'IncSearch',           { fg = '#ffffff',  bg = '#ff00ff',  nocombine = true, bold = true })
    hl(0, 'Visual',              { fg = '#c18401',  bg = 'Blue',     nocombine = true, bold = true })
    hl(0, 'StatusLine',          { fg = 'Black',    bg = 'Blue',     nocombine = true })
    hl(0, 'Comment',             { fg = '#767676',  bg = '#808080', })
    hl(0, '@comment',            { fg = '#767676',  bg = '#808080', })
    hl(0, 'SpecialComment',      { fg = '#008080',  bg = 'NONE', })
    hl(0, 'WhiteSpace',          { fg = 'Blue',     bg = 'NONE', })
    hl(0, 'WinSeparator',        { fg = '#767676',  bg = 'NONE',  })
    hl(0, 'SpecialKey',          { fg = '#444444',  bg = 'NONE',  })
    hl(0, 'SignColumn',          { fg = '#008080',  bg = 'NONE',  })
    hl(0, 'LineNr',              { fg = '#444444',  bg = 'NONE',  })
    hl(0, 'CursorLineNr',        { fg = 'White',    bg = '#767676', bold = true })
    hl(0, 'CursorColumn',        { fg = 'Blue',     bg = 'NONE',     reverse =true, nocombine = true, blend = 80 })
--  hl(0, 'CursorLine',          { bg = 'NONE',     fg = 'NONE',     bold = true, reverse = true })
--  hl(0, 'CursorLine',          { bg = '#c18401',  fg = 'NONE',     bold = true, nocombine = true })
--  hl(0, 'CursorLine',          { bg = 'Black',    fg = 'NONE',     bold = true, nocombine = true })
--  hl(0, 'CursorLine',          { bg = 'Black',    fg = 'NONE',     nocombine = true })
--  hl(0, 'CursorLine',          { bg = 'NONE',     fg = 'NONE',     blend = 10, nocombine = true, reverse = true })
    hl(0, 'CursorLine',          { fg = 'Blue',     bg = 'NONE',     reverse   = true,  nocombine = true })
--  hl(0, 'TSCurrentScope',      { fg = '#22aa77',  bg = 'White', nocombine = true, })
    hl(0, 'TSCurrentScope',      { fg = 'NONE',     bg = 'NONE',     nocombine = true })
    hl(0, 'LspReferenceText',    { bg = 'NONE' })
    hl(0, '@string',             { fg = '#8787af',  bg = '#767676' })
    hl(0, 'String',              { fg = '#8787af',  bg = '#767676' })
    hl(0, '@conditional',        { fg = '#8787af',  bg = '#767676' })

    hl(0, '@function',           { fg = '#00afd7',  bg = '#767676',     bold = true })
    hl(0, '@function.call',      { fg = '#00afd7',  bg = '#767676' })
    hl(0, '@function.builtin',   { fg = '#00afd7',  bg = '#767676',  nocombine = true, blend = 10 })
    hl(0, 'Function',            { fg = '#00afd7',  bg = '#767676' })
    hl(0, 'PreProc',             { fg = 'Cyan',     bg = 'NONE' })
    hl(0, 'shDerefSimple',       { fg = '#008080',  bg = 'NONE' })
    hl(0, 'shDerefSimpleNE',     { fg = 'Cyan',     bg = 'NONE' })
    hl(0, 'shColon',             { bg = '#22aa77',  fg = 'NONE',     link = 'shDerefSimple' })

    hl(0, 'FileStyleIgnorePattern',  { bg  = 'NONE', })
    hl(0, 'NewLineWin',              { fg  = '#999999', })
    hl(0, 'NonText',             { fg = 'NONE',     bg = 'NONE', })
    hl(0, 'rstEmphasis',         { fg = '#22aa77',  bg = 'NONE', })
    hl(0, 'manItalic',           { fg = '#22aa77',  bg = 'NONE', })
    hl(0, 'Keyword',             { fg = '#22aa77',  bg = 'NONE', })
    hl(0, 'NvimTreeFolderIcon',  { fg = 'NONE',     bg = 'NONE', })
    hl(0, 'SpellBad',            { fg = '#a2aa77',  bg = 'NONE', })
    hl(0, 'SpellLocal',          { fg = '#a2aa77',  bg = 'NONE', })
    hl(0, 'SpellRare',           { fg = '#a2aa77',  bg = 'NONE', })
    hl(0, 'SpellCap',            { fg = '#a2aa77',  bg = 'NONE', })

    hl(0, 'VertSplit',           { fg = 'NONE',     bg = 'NONE',     nocombine = true, })
    hl(0, 'EndOfBuffer',         { fg = 'NONE',     bg = 'NONE', })
    hl(0, 'NvimInternalError',   { fg = 'Brown',    bg = 'NONE', })
    hl(0, 'ErrorMsg',            { fg = 'NONE',     bg = '#aa0000', })
    hl(0, 'SyntasticWarning',    { fg = 'Black',    bg = 'NONE', })
    hl(0, 'ALEWarning',          { fg = 'Black',    bg = 'NONE', })
    hl(0, 'SyntasticError',      { fg = '#aa0000',  bg = 'NONE', })
    hl(0, 'ALEError',            { fg = '#aa0000',  bg = 'NONE', })
    hl(0, 'CocUnderline',        { fg = 'NONE',     bg = 'NONE',     undercurl = true })
    hl(0, 'DiagnosticError',     { fg = '#aa0000',  bg = 'NONE', })
    hl(0, 'DiagnosticWarn',      { fg = 'Brown',    bg = 'NONE', })
    hl(0, 'CocInlayHint',        { fg = 'Blue',     bg = 'NONE', })
    hl(0, 'VimwikiCode',         { fg = 'Teal',     bg = 'NONE', })
--  hl(0, 'VimwikiCode',         { fg = 'NONE',     bg = 'NONE' })
    hl(0, 'VimwikiPre',          { fg = 'NONE',     bg = 'NONE', })
    hl(0, 'VimwikiBold',         { fg = 'NONE',     bg = 'NONE',     bold      = true })
    hl(0, 'VimwikiItalic',       { fg = '#cc0000',  bg = 'NONE',     italic    = true })


    hl(0, 'shDerefVar',          { fg = 'Teal',     bg = 'NONE' })
    hl(0, 'shFor',               { fg = 'Teal',     bg = 'NONE' })
--  The spaces between expressions
--  indent_blankline ?
    hl(0, 'shDo',                { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'shExpr',              { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'shFunctionOne',       { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'Statement',           { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'htmlItalic',          { fg = 'Orange',   bg = 'NONE' })
    hl(0, 'Whitespace',          { fg = 'NONE',     bg = 'NONE' })
    hl(0, 'CtrlSpaceSelected',   { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'CtrlSpaceNormal',     { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'CtrlSpaceSearch',     { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'CtrlSpaceStatus',     { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'NeotestNamespace',    { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'DevIconBazelWorkspace',
                                 { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'htmlLeadingSpace',    { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'xmlNamespace',        { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'pythonSpaceError',    { fg = 'Magenta',  bg = 'NONE',   })

    hl(0, 'IndentBlanklineSpaceChar',
                                 { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'IndentBlanklineSpaceCharBlankline',
                                 { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'ShowTrailingWhitespace',
                                 { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'ExtraWhitespace',     { fg = 'Magenta',  bg = 'NONE',   })
    hl(0, 'diffLine',            { fg = 'Brown',    bg = 'NONE',   })
    hl(0, 'diffAdded',           { fg = 'Cyan',     bg = 'Black',   })
    hl(0, 'Extmarksf',           { fg = '#22aa77',  bg = 'Black',   })
    hl(0, '@variable',           { fg = '#d7ffff',  bg = '#767676' })
    hl(0, '@variable.builtin',   { fg = '#d7ffff',  bg = '#767676' })
    hl(0, '@variable.lua',       { fg = '#d7ffff',  bg = '#767676' })
    hl(0, 'PmenuSel',            { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'Constant',            { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'PreProc',             { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'Define',              { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'Type',                { fg = 'Cyan',     bg = 'NONE' })
    hl(0, 'cmakeArguments',      { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'Tag',                 { fg = '#22aa77',  bg = 'NONE' })
    hl(0, 'Character',           { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconFsi',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconNi',           { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconBash',         { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconWav',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'DevIconRmd',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@textReference',      { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@constant',           { fg = '#d79999',  bg = 'NONE' })
    hl(0, '@constructor',        { fg = '#c18401',  bg = 'NONE' })
    hl(0, 'DiffText',            { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'MatchParen',          { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@attriute',           { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@parameter',          { fg = '#d79999',  bg = 'NONE' })
    hl(0, '@type.builtin',       { fg = '#ff4444',  bg = 'NONE' })
    hl(0, 'NoiceAttr120',        { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@keyword',            { fg = '#c18401',  bg = 'NONE' })
    hl(0, 'LspReferenceWrite',   { fg = '#ff4444',  bg = 'NONE' })
    hl(0, '@symbol',             { fg = '#22aa77',  bg = 'NONE' })
    hl(0, '@text.emphasis',      { fg = '#22aa77',  bg = 'NONE' })
--  hl(0, '@spell',              { fg = 'White',    bg = 'NONE' })
    hl(0, '@spell',              { fg = '#808080',  bg = '#767676' })
    hl(0, '@label',              { fg = 'Brown',    bg = 'Black' })
    hl(0, '@punctuation',        { fg = '#c18401',  bg = 'Black' })
    hl(0, '@punctuation.special',{ fg = '#c18401',  bg = 'Black' })
    hl(0, '@punctuation.bracket',{ fg = '#c18401',  bg = 'Black' })
    hl(0, '@operator',           { fg = '#c18401',  bg = 'Black' })
--  @punctuation.bracket




--  @constant.bash links to @constant
--  @none.bash links to @none bash
--  @punctuation.special.bash links to @punctuation.special bash

end


--  https://vi.stackexchange.com/questions/18768/highlighting-tabs-trailing-space-and-non-breaking-space-by-colors-not-chars
vim.cmd([[
" set nolist
hi  TabChar             ctermbg=1
hi  TrailingSpaceChar   ctermbg=2
hi  NBSP                ctermbg=3
syn match TabChar " "
syn match TrailingSpaceChar " *$"
syn match NBSP " "

hi  MatchParen term=reverse cterm=bold,underline ctermfg=168 ctermbg=16 gui=bold,underline guifg=#e8c675

]])

local function config_file()
--  vim.cmd[[
	--  if &filetype =~? '\v(conf)'
    if string.find(vim.bo.filetype, "conf") == 0 then return false end

    if vim.opt_local.background:get() == 'dark' then

        hl(0, 'String',          { fg = 'White',    bg = 'Magenta',  })
        hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',     bold = true, nocombine = true })
    --  hl(0, '@comment',        { fg = 'Black',    bg = 'DarkGray', })
        hl(0, '@comment',        { fg = 'Black',    bg = 'DarkGrey',     })
        hl(0, 'Comment',         { fg = 'Black',    bg = 'DarkGrey',     })
    else
        hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',     bold = true, nocombine = true })
    --  hl(0, '@comment',        { fg = 'DarkGrey', bg = 'Brown',     })
    --  hl(0, '@comment',        { fg = 'Black',    bg = 'Cyan',     })
        hl(0, '@comment',        { fg = '#000000',  bg = '#808080',     })
    --  hl(0, '@comment',        { fg = '#585858',  bg = '#767676',     })
    --  hl(0, 'Comment',         { fg = 'DarkGrey', bg = 'Brown',     })
    --  hl(0, 'Comment',         { fg = 'Black',    bg = 'Cyan',     })
    --  When set fg == 'NONE', it will be overrided by the Normal fg
    --  hl(0, 'Comment',         { fg = 'NONE',     bg = 'White',     })
        hl(0, 'Comment',         { fg = '#000000',  bg = '#808080',     })
        hl(0, 'confComment',     { fg = '#000000',  bg = '#808080', nocombine = true })
    --  hl(0, 'Comment',         { fg = '#585858',  bg = '#767676',     })
    end
--          ]]
end

--  local function lua_file()
--  --  vim.cmd[[
--  	--  if &filetype =~? '\v(conf)'
--      if string.find(vim.bo.filetype, "lua") == 0 then return false end
--  
--      if vim.opt_local.background:get() == 'dark' then
--  
--          hl(0, 'String',          { fg = 'White',    bg = 'Magenta',  })
--          hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',     bold = true, nocombine = true })
--      --  hl(0, '@comment',        { fg = 'Black',    bg = 'DarkGray', })
--          hl(0, '@comment',        { fg = 'Black',    bg = 'DarkGrey',     })
--          hl(0, 'Comment',         { fg = 'Black',    bg = 'DarkGrey',     })
--      else
--          hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',     reverse = true, bold = true, nocombine = true })
--      --  hl(0, '@comment',        { fg = 'DarkGrey', bg = 'Brown',     })
--      --  hl(0, '@comment',        { fg = 'Black',    bg = 'Cyan',     })
--          hl(0, '@comment',        { fg = '#808080',  bg = '#767676',     })
--      --  hl(0, '@comment',        { fg = '#585858',  bg = '#767676',     })
--      --  hl(0, 'Comment',         { fg = 'DarkGrey', bg = 'Brown',     })
--      --  hl(0, 'Comment',         { fg = 'Black',    bg = 'Cyan',     })
--      --  When set fg == 'NONE', it will be overrided by the Normal fg
--      --  hl(0, 'Comment',         { fg = 'NONE',     bg = 'White',     })
--          hl(0, 'Comment',         { fg = '#808080',  bg = '#767676',     })
--      --  hl(0, 'Comment',         { fg = '#585858',  bg = '#767676',     })
--          hl(0, 'Comment',         { fg = '#767676',  bg = '#808080', })
--          hl(0, '@comment',        { fg = '#767676',  bg = '#808080', })
--      end
--  --          ]]
--  end

local function insert_leave()
    hl(0, 'Cursor',          { fg = 'White',    bg = 'NONE',    reverse = true, blend = 10, nocombine = true })
    hl(0, 'TermCursor',      { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    hl(0, 'lCursor',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    hl(0, 'Cursor2',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    if vim.opt_local.background:get() == 'dark' then
    --  hl(0, 'CursorColumn',    { fg = 'NONE',     bg = 'Blue',    nocombine = true })
        hl(0, 'CursorColumn',    { fg = 'NONE',     bg = 'White',   bold = true, reverse =true, nocombine = true, blend = 80 })
        --  Correct setting of CursorLine
    --  hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'White',   bold = true, blend = 80, reverse = true,  nocombine = true })
    --  hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'Yellow',  bold = true, reverse = true,  nocombine = true })
        hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',    bold = true, reverse = true,  nocombine = true })
        vim.o.winhighlight = 'Normal:ActiveWindow,NormalNC:InactiveWindow'
    else
    --  hl(0, 'CursorColumn',    { fg = 'Blue',     bg = 'NONE',    bold = true, reverse =true, nocombine = true, blend = 80 })
        hl(0, 'CursorColumn',    { fg = 'NONE',     bg = '#000076', bold = true, nocombine = true })
    --  hl(0, 'CursorLine',      { fg = 'White',    bg = 'Blue',    bold = true, blend = 10, nocombine = true })
    --  hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',    bold = true, reverse =true, nocombine = true, blend = 80 })
        hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',    bold = true, nocombine = true })
        hl(0, 'Comment',         { fg = '#767676',  bg = '#808080', })
        hl(0, '@comment',        { fg = '#767676',  bg = '#808080', })
        hl(0, '@spell',          { fg = 'Black',  bg = '#808080' })
        vim.o.winhighlight = 'Normal:InactiveWindow,NormalNC:ActiveWindow'
    end

    --  vim.o.winhighlight = 'Normal:ActiveWindow,NormalNC:InactiveWindow'
    config_file()
--  lua_file()
end

vim.api.nvim_create_autocmd({ "WinLeave",  "BufLeave",  "BufWinLeave", }, {
    desc     = 'Color Dynamic',
    group    = vim.api.nvim_create_augroup('color_win_leave', { clear = true }),
    pattern  = "*",
    callback = function()
    --  hl(0, 'Cursor',          { fg = 'White',    bg = 'NONE',    reverse = true, blend = 10, nocombine = true })
    --  hl(0, 'TermCursor',      { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    --  hl(0, 'lCursor',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    --  hl(0, 'Cursor2',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    --  if vim.opt_local.background:get() == 'dark' then
    --  --  hl(0, 'CursorColumn',    { fg = 'NONE',     bg = 'Blue',    nocombine = true })
    --      hl(0, 'CursorColumn',    { fg = 'NONE',     bg = 'Blue',    nocombine = true, blend = 80 })
    --      hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',   bold = true, blend = 80, nocombine = true })
    --  else
    --      hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    --  end
    insert_leave() --  ruins conf file curosrline highlight
    --  if vim.opt_local.background:get() == 'dark' and default_background == 'dark' then
        vim.opt.winhighlight = 'Normal:ActiveWindow,NormalNC:InactiveWindow'
    --  else
    --      vim.opt.winhighlight = 'Normal:InactiveWindow,NormalNC:ActiveWindow'
    --  end
        vim.cmd[[redraw!]]
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    desc     = 'Color Dynamic',
    group    = vim.api.nvim_create_augroup('color_enter', { clear = true }),
    pattern  = "*",
    callback = function(args)
--  vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
--      desc = 'Color Dynamic',
--      group = vim.api.nvim_create_augroup('color_enter', { clear = true }),
--      pattern = "*",
--      callback = function(args)
        hl(0, 'Cursor',          { fg = 'White',    bg = 'NONE',    reverse = true, blend = 10, nocombine = true })
        hl(0, 'TermCursor',      { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
        hl(0, 'lCursor',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
        hl(0, 'Cursor2',         { fg = 'NONE',     bg = 'NONE',    blend = 10, nocombine = true })
    --  hl(0, 'CursorColumn',    { fg = 'NONE',     bg = 'Blue',    nocombine = true })
        hl(0, 'CursorColumn',    { fg = 'Blue',     bg = 'NONE',    reverse =true, nocombine = true, blend = 80 })
        hl(0, 'CursorLine',      { fg = 'NONE',     bg = 'NONE',    bold = true, nocombine = true })
    end,
})

local function switch(background)
--  print("background", background)
    if background == 'dark' then
        --  if vim.opt_local.background:get() ~= 'dark' then
        --  print("colorscheme", 'late dark')
            --  vim.cmd("colorscheme modus-vivendi")
            --

            --  vim.cmd("colorscheme onehalf-lush-dark")
            --  vim.api.nvim_command("colorscheme onehalf-lush-dark")
            --  vim.api.nvim_command("colorscheme " .. vim.g.colors_name .. '-dark')

            --  vim.cmd("colorscheme no-clown-fiesta")
            --  vim.cmd("colorscheme nebulous")

            --  vim.cmd("colorscheme dracula")

            dark()
        --  end
    else
        --  if vim.opt_local.background:get() == 'dark' then
        --  print("colorscheme", 'late light')
        --  vim.cmd("colorscheme modus-operandi")

        --  vim.cmd("colorscheme onehalf-lush")
        --  vim.api.nvim_command("colorscheme onehalf-lush")
        --  vim.api.nvim_command("colorscheme " .. vim.g.colors_name)

        --  vim.cmd("colorscheme gruvbox")

        light()

        --  end
    end
        insert_leave()
    --  force a full redraw:
    --  vim.cmd("mode")
    --  This line might override colorscheme
    --  Recursively sourcing in this file
    --  vim.cmd.source(os.getenv("DOT_CONFIG") .. '/editor/nvim/after/plugin' .. "/colors.lua")
end

vim.api.nvim_create_autocmd({ "VimEnter",  "BufEnter", "WinEnter", "BufWinEnter",  "InsertLeave", "CmdlineLeave" }, {
    desc     = 'Color Dynamic',
    group    = vim.api.nvim_create_augroup('color_leave', { clear = true }),
    pattern  = "*",
    callback = function()
        switch(vim.o.background) --  ruins conf file curosrline highlight
        --  if vim.opt_local.background:get() == 'dark' and default_background == 'dark' then
            vim.opt.winhighlight = 'Normal:ActiveWindow,NormalNC:InactiveWindow'
        --  else
        --      vim.opt.winhighlight = 'Normal:InactiveWindow,NormalNC:ActiveWindow'
        --  end
        vim.cmd[[redraw!]]
    end,
})

--  set.bg              = 'dark'
--  set.background      = 'dark'
--  vim.o.background    = 'dark'
--  vim.opt_local.background   = 'dark'
--  vim.opt_global.background  = 'dark'
--  vim.api.nvim_set_option_value('background', 'dark', { scope = 'local' })

    set.bg              = default_background
    set.background      = default_background
    vim.o.background    = default_background
--  vim.api.nvim_set_option_value('background', default_background, { scope = 'local' })
    vim.api.nvim_set_option_value('background', default_background, { scope = 'global' })

--  switch(vim.opt_local.background:get())
    switch(vim.opt.background:get())

vim.api.nvim_create_autocmd({ "OptionSet" }, {
    group    = vim.api.nvim_create_augroup("nvim_background", { clear = true }),
    pattern  = { "background" },
    callback = function()
        switch(vim.o.background)
        vim.opt.winhighlight = 'Normal:ActiveWindow,NormalNC:InactiveWindow'
        vim.cmd[[redraw!]]
    end,
})


--  Does not exist
--  vim.api.nvim_command("colorscheme onehalf-lush-dark")
--  For one-half-dark
    hl(0, '@comment', { fg = 'Black', bg = 'DarkGray', })


vim.api.nvim_create_autocmd({ "VimEnter",  "BufEnter", "WinEnter", "BufWinEnter",  "InsertLeave", "CmdlineLeave" }, {
    desc     = 'Color Dynamic',
    group    = vim.api.nvim_create_augroup('config_file', { clear = true }),
    pattern  = "*",
    callback = config_file,
})









function! s:HL(key, fg, bg)
  execute 'highlight! ' a:key ' guifg=' a:fg ' guibg=' a:bg
endfunction

"highlight! link StatusLine TermCursor
"highlight! StatusLine guifg=#333333 guibg=gb.background

"highlight! link StatusLineNC VertSplit
" Error
highlight! link User2 ErrorMsg

" Warning
highlight! link User3 WarningMsg
highlight! link User4 IncSearch
" Read Mode
highlight! link User5 ErrorMsg

highlight! link User6 DiffAdd

highlight! User3 guifg=#CC0019 guibg=#333333

highlight StatusLine NONE
highlight StatusLineNC NONE

let s:gb = {}
let s:gb.text    = ['#EFC72B', 12]
let s:gb.back    = ['#EFC72B', 12]
let s:gb.back    = ['#584E4C', 12]
let s:gb.nc_back = ['none', 12]
let s:gb.nc_text = ['#C6ABA6', 234]
let s:gb.user6_back = ['#C6ABA6', 234]

call s:HL('StatusLine',   '#EFC72B', '#584E4C')
call s:HL('StatusLineNC', '#888888', '#564947')

call s:HL('User1',   '#EFC72B', '#584E4C')
call s:HL('User2',   '#EFC72B', '#584E4C')
call s:HL('User3',   '#EFC72B', '#584E4C')
call s:HL('User4',   '#000000', '#56B647')
call s:HL('User6',   '#584E4C', '#EFC72B')

"statusline setup
set statusline=

set statusline+=%4*%{&paste?'\ \ PASTE\ ':''}
set statusline+=
set statusline+=%*
set statusline+=\ %-0.30f

"modified flag
set statusline+=%5*%{&modified?'+':''}
set statusline+=%*
set statusline+=\ %(❪%0.25{GetGitStatus()}❫%)

set statusline+=%=      "left/right separator

"display an error if fileformat isn't unix
set statusline+=%2*
set statusline+=%([%R%H%{&ff!='unix'?','.&ff:''}%{(&fenc!='utf-8'&&&fenc!='')?','.&fenc:''}]%)

set statusline+=%3*
set statusline+=%([%{NeoMakeErrorCount()}%{StatuslineLongLineWarning()}%{StatuslineTabWarning()}%{StatuslineTrailingSpaceWarning()}]%)

set statusline+=%6*
set statusline+=%y  "filetype
set statusline+=%([%3v]%)  "cursor column

set laststatus=2

if has('title')
  set titlestring=%t%(\ [%R%M]%)
endif
set showmode

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

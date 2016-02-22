highlight! StatusLine     ctermfg=7       ctermbg=18 cterm=NONE
highlight! StatusLineNC   ctermfg=8       ctermbg=235 cterm=NONE
" Error
highlight! User2          ctermfg=255     ctermbg=160 cterm=NONE
" Warning
highlight! User3          ctermfg=154     ctermbg=18 cterm=NONE
highlight! User4          ctermfg=18      ctermbg=34 cterm=NONE
" Read Mode
highlight! User5          ctermfg=154     ctermbg=18 cterm=NONE
highlight! User6          ctermfg=45      ctermbg=18 cterm=NONE

"statusline setup
set statusline=
"set statusline+=\ %{Mode()}
set statusline+=%4*%{&paste?'\ \ PASTE\ ':''}
set statusline+=%*
set statusline+=\ %-0.30f

"modified flag
set statusline+=%5*%{&modified?'+':''}
set statusline+=%*
set statusline+=\ %(❪%0.25{GetGitStatus()}❫%)

set statusline+=%=      "left/right separator

"display a warning if fileformat isnt unix
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

function! s:HL(key, fg, bg)
  execute 'highlight! ' a:key ' cterm=none gui=none guifg=' a:fg ' guibg=' a:bg
endfunction

highlight! clear StatusLine
highlight! StatusLine NONE
highlight! clear StatusLineNC
highlight! StatusLineNC NONE

call s:HL('SLMain',     '#000000', '#7cafc2')
call s:HL('SLMiddle',   '#959590', '#333333')
call s:HL('SLError',    '#ff2222', '#282828')
call s:HL('SLModified', '#EFC72B', '#584E4C')
call s:HL('SLPaste',    '#000000', '#efc72b')
call s:HL('SLModified', '#ffffff', '#7cafc2')

call s:HL('User1',        '#959590', '#333333')
call s:HL('User2',        '#959590', '#333333')
call s:HL('User3',        '#959590', '#333333')
call s:HL('User4',        '#000000', '#7C6515')

highlight! link StatusLine    SLMain
highlight! link StatusLineNC  SLMiddle
highlight! link User1         SLMiddle
highlight! link User2         SLError
highlight! link User3         SLModified
highlight! link User4         SLPaste

function! SyntaxItem()
  if exists("g:show_highlight_group")
    return synIDattr(synID(line("."),col("."),1),"name")
  else
    return ''
  endif
endfunction

"statusline setup
set statusline=
set statusline+=%1*%(\ %{SyntaxItem()}\ %)

" Paste
set statusline+=%4*%(\ %{&paste?'PASTE':''}\ %)

" FileName
set statusline+=%*%(\ %-0.30t\ %)

" Modified/ReadOnly
set statusline+=%2*%(%m%r%)
set statusline+=%1*%(\ «%0.30{GetGitStatus()}»%)

set statusline+=%=      "left/right separator

"display an error if fileformat isn't unix
set statusline+=%2*
set statusline+=%([%R%H%{&ff!='unix'?','.&ff:''}%{(&fenc!='utf-8'&&&fenc!='')?','.&fenc:''}]%)
set statusline+=%([%{NeoMakeErrorCount()}%{StatuslineLongLineWarning()}%{StatuslineTabWarning()}%{StatuslineTrailingSpaceWarning()}]%)

set statusline+=%*
set statusline+=%([%v%),%(%p%%]%)  "cursor column
set statusline+=%y"filetype

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

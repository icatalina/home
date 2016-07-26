" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
""  let g:ctrlp_use_caching = 0
endif

command! -nargs=+ -complete=file -bar Ags silent! grep! <args>|cwindow|redraw!

" nnoremap K :!grep "\b<C-R><C-W>\b"<CR>:cw<CR>

"@n \\ > Trigger AG search
nnoremap \\ :Ack!<SPACE>
nnoremap <Leader>\ "zyiw:Ack! <C-R>=fnameescape(@z)<CR>

"@v \\ > Trigger AG Search for the selected word
vnoremap \\ "zy:Ack! <C-r>=fnameescape(@z)<CR>

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

cnoreabbrev ag Ack!
cnoreabbrev aG Ack!
cnoreabbrev Ag Ack!
cnoreabbrev AG Ack!

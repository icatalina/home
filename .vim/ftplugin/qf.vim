setlocal nonumber
setlocal colorcolumn=
setlocal scrolloff=1                       " Minium number of lines above and below the cursor
setlocal sidescrolloff=1                  " Minium number of characters left and right of the cursor

nnoremap <buffer> <silent> <C-C> :cclose<CR>
nnoremap <buffer> <silent> q     :cclose<CR>
nnoremap <buffer> <silent> <C-^> :cclose<CR>
nnoremap <buffer> <silent> gf <CR>

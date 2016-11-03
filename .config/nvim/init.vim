" init.vim
" Neovim init (in place of vimrc)

" ============================================================================
" Python setup
" Skips if python is not installed in a pyenv virtualenv
" ============================================================================

" ----------------------------------------------------------------------------
" Python 2
" ----------------------------------------------------------------------------

" python2 off
let s:pyenv_python2 = glob(expand('$PYENV_ROOT/versions/neovim2/bin/python'))
if !empty(s:pyenv_python2)
  let g:python_host_prog = s:pyenv_python2
else
  let g:loaded_python_provider = 1
endif

" ----------------------------------------------------------------------------
" Python 3
" ----------------------------------------------------------------------------

let s:pyenv_python3 = glob(expand('$PYENV_ROOT/versions/neovim3/bin/python'))
if !empty(s:pyenv_python3)
  let g:python3_host_prog = s:pyenv_python3
else
  let g:loaded_python3_provider = 1
endif

" =============================================================================
" GUI variants
" =============================================================================

try
  " Neovim-qt Guifont command
  command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  " Set the font to DejaVu Sans Mono:h13
  Guifont Fira Mono For Powerline:h8
endtry

execute 'source ' . fnamemodify($MYVIMRC, ':p:h') . '/vimrc'

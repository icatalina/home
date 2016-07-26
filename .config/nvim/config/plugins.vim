call plug#begin()

Plug 'junegunn/vim-plug'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind', 'NERDTree'] }
Plug 'terryma/vim-multiple-cursors'
Plug 'benekastah/neomake', { 'on':  'Neomake' }
Plug 'scrooloose/nerdcommenter'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
" Deprecated, moved to ACK - Plug 'rking/ag.vim', { 'on': 'Ag' }
Plug 'mileszs/ack.vim', { 'on': 'Ack'}
Plug 'jeetsukumaran/vim-buffergator', { 'on': 'BuffergatorToggle' }
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'Raimondi/delimitMate'

" Javascript Functionallity
Plug '29decibel/vim-stringify', { 'for': 'javascript' }
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }

"" Syntaxes
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'dansomething/ftl-vim-syntax', { 'for': 'ftl' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'evidens/vim-twig'
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss', 'less'] }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'hdima/python-syntax', { 'for': 'python' }
Plug 'evanmiller/nginx-vim-syntax'

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

"" Updated sass/scss syntax
Plug 'tpope/vim-haml'

"" Custom TextObjects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'lucapette/vim-textobj-underscore'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

" Colorschemes
" Plug 'chriskempson/base16-vim'

if version > 703

  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

endif

let s:localFile = expand("~/.local/plugins.vim")
if filereadable(s:localFile)
  exec 'source '.fnameescape(s:localFile)
endif

call plug#end()

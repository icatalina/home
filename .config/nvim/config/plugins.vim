call plug#begin()

Plug 'junegunn/vim-plug'

Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'benekastah/neomake', { 'on':  'Neomake' }
Plug 'scrooloose/nerdcommenter'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
Plug 'rking/ag.vim', { 'on': 'Ag' }
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

"" Updated sass/scss syntax
Plug 'tpope/vim-haml'

"" Custom TextObjects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'lucapette/vim-textobj-underscore'

if version > 703
  " Color Schemas
  Plug 'chriskempson/base16-vim'

  " Load on first insert mode
  Plug 'SirVer/ultisnips', { 'on': [] }
  Plug 'honza/vim-snippets', {'on': [] }
  Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': './install.py' }

  augroup load_us_ycm
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe', 'vim-snippets')
                      \| call youcompleteme#Enable() | autocmd! load_us_ycm
  augroup END
endif

let s:localFile = expand("~/.local/plugins.vim")
if filereadable(s:localFile)
  exec 'source '.fnameescape(s:localFile)
endif

call plug#end()

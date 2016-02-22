let $VIMHOME=expand('<sfile>:p:h')


function! Load(files)
  for l:file in a:files
    exec 'so $VIMHOME/config/'.l:file.'.vim'
  endfor
endfunction

call Load(['plugins'])

autocmd! BufReadPost * call SetCursorPosition()
autocmd! BufEnter * :syntax sync minlines=300
autocmd! BufEnter * :let g:bufNum=bufnr('%')
autocmd! Filetype gitcommit setlocal spell textwidth=72

" Share clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard+=unnamed
endif

" Color Scheme
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"

syntax on
filetype plugin indent on


let mapleader = " "

set background=dark                     " Sets a dark background
set cinoptions=:0,(s,u0,U1,g0,t0        " Some indentation options ':h cinoptions' for details
set cmdheight=2                         " Cmd area height
set cursorline                          " Enable cursor line
set copyindent
set expandtab                           " Spaces are used instead of tabs
set fileformats=unix,dos,mac            " Preference for file formats
set gdefault                            " Add g as default on replaces
set hidden                              " enable multiple modified buffers
set ignorecase                          " Ignore case on searches
set lazyredraw                          " The screen will not be redrawn while executing macros, registers and other commands
set list!                               " Toggle Lists
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set magic                               " Enable extended regexes
set matchtime=2                         " Time to jump to the matched bracket
set matchpairs+=<:>                     " Adds < and > as matching brackets
set noshowmode                          " Don't show the current mode (airline.vim takes care of us)
set nostartofline                       " Don't reset cursor to start of line when moving around
set nowrap                              " Prevent lines from wrapping
set numberwidth=3                       " Number of culumns for line numbers
set number                              " Makes the current line to show the linenumber instead of 0
set relativenumber                      " Show relative numbers
set ruler                               " Show Cursor position all the time
set scrolloff=7                         " Minium number of lines above and below the cursor
set shiftround                          " Round the indent to a multiple of shiftwidth
set shiftwidth=2                        " Columns the text is shifted with << >> (0 follows tabstop)
set showcmd                             " Show partial commands as they're being typed on the bar
set showmatch                           " When a bracket is inserted, jump to the matched one for a few ms
set showtabline=0                       " Hide Tabs on the top of the window
set sidescrolloff=10                    " Minium number of characters left and right of the cursor
set smartcase                           " Enables case sensitive search when an uppercase letter is used on the search string
set softtabstop=2                       " Columns used when Tab is hitted in insert mode (-1 follows tabstop)
set splitbelow                          " Open new Split below
set splitright                          " Open new split right
set synmaxcol=400                       " Prevent slow down on logn lines
set tabstop=2                           " How many columns a tab counts for
set textwidth=140                       " Set MAX text width
set ttimeout                            " Enable timeout for key codes
set ttimeoutlen=100                     " Time in ms waited for a key code secuence to complete
set updatetime=200                      " Time in ms to consider vim 'idle'
set visualbell                          " Use visual bell instead of beeping
set whichwrap+=<,>,h,l,[,]              " Let keys move the cursor to the previous/next line when it's on the first/last character on a line
set formatoptions+=tcqjrob              " Configure the formmating options
"c Auto-wrap comments using textwidth, inserting the current comment leader automatically.
"q Allow formatting of comments with 'gq'
"j Where it makes sense, remove a comment leader when joining lines
"r Automatically insert the current comment leader after hitting <Enter> in Insert mode
"o Automatically insert the current comment leader after hitting O in Normal mode
"b Only auto-wrap if you enter a blank at or before the wrap margin

" History & Undo Level
set history=1000
set undolevels=1000
set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set undofile
set backup
set writebackup

if !has('nvim')                         " This options are on by default in NeoVim
  set autoindent                        " Automatically indent new lines
  set autoread                          " Automatically read files that have been changed on disk
  set backspace=indent,eol,start        " Allows backspace to go back lines
  set complete-=i                       " Disables included file completion, seems to be quicker
  set display+=lastline                 " Prevenst @@ when a line is bigger than the screen
  set encoding=utf8                     " Sets file encoding
  set hlsearch                          " Highlight search
  set incsearch                         " Incremental search
  set mouse=a                           " Mouse in All modes
  set smarttab                          " Tab completes to the closest tabstop, delete removes till previous tabstop
  set t_kb=
  set t_kD=[3;*~
  set wildmenu                          " Enhanced command completion
  "" Fix Delete Key
  nmap [3;*~ "_x
  inoremap [3;*~ <C-O>"_x
  autocmd! BufWritePost * Neomake
else
  autocmd! BufReadPost,BufWritePost * Neomake
endif

let g:neomake_html_htmlhint_maker = {
    \ 'args': ['--format', 'unix'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ }
let g:neomake_html_enabled_makers = ['htmlhint']

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

if !empty($BASE16_SHELL)
    let base16colorspace=256
    silent! colorscheme base16-default
else
    silent! colorscheme peachpuff
    highlight! Visual cterm=NONE ctermbg=238 ctermfg=NONE
    highlight! cursorline cterm=none ctermbg=18
endif

highlight! Search cterm=NONE ctermfg=white ctermbg=darkyellow
highlight! SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black
hi cursorlinenr ctermfg=15


call Load([
  \'buffergator',
  \'closetags',
  \'ctrlp',
  \'delimitmate',
  \'functions',
  \'gitgutter',
  \'nerd',
  \'silver-search',
  \'ultisnips',
  \'youcompleteme',
  \'keymaps',
  \'statuslinehelpers',
  \'statusline'
\])


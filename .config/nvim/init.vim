" vim:set fdm=marker:

let $VIMHOME=expand("~/.vim")
let $LOCALFOLDER=expand("~/.local")

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1


" Functions {{{ "

function! FileExists(file)
  return filereadable(glob(a:file))
endfunction

function! Load(files)
  for l:file in a:files
    exec 'so $VIMHOME/config/'.l:file.'.vim'
  endfor
endfunction

" Remove Trailing WhiteSpaces
function! TrimTrailingWhitespace()
    " don't lose user position when trimming trailing whitespace
    let savedPos = winsaveview()
    try
        %s/\s\+$//e
    finally
        call winrestview(savedPos)
    endtry
endfunction

" Inserts a new line
" Inputs: "up" or "down"
" If no input is specified, down is assumed
function! InsertNewLine(...)
    let g:cursor=getpos(".")

    if a:0 > 0 && a:1 == 'up'
        let l:command=':i.'
        let g:cursor[1] = g:cursor[1] + 1
    elseif a:0 == 0 || (a:0 > 0 && a:1 == 'down')
       let l:command=':a.'
    else
        return
    endif

    try
        exec "normal " . l:command
    finally
        keepjumps call setpos(".", g:cursor)
    endtry

endfunction

" Adds the quicklist items to the Argslist
function! QuickListToArgs()
  let l:list = {}
  let l:ouptut = ''

  exe 'silent! argd *'

  for file in getqflist()
    let l:list[bufname(file.bufnr)] = 1
  endfor

  let l:output = join(keys(l:list))
  let g:output = join(keys(l:list))

  exe 'silent! arga' l:output
  exe 'silent! cclose'
  exe 'args'
endfunction

" Meassure file size and disable some stuff if too big
function! LongFiles()
    let l:long = max(map(getline(1,'$'), 'len(v:val)'))
    if l:long > 300
        echo 'File with long lines (' . l:long . 'chars), disabling some stuff...'
        setlocal noautoindent nocindent nosmartindent indentexpr=
        setlocal syntax=OFF
    endif
endfunction

"
" Times the number of times a particular command takes to execute the specified number of times (in seconds).
function! HowLong( command, numberOfTimes )
  " We don't want to be prompted by a message if the command being tried is
  " an echo as that would slow things down while waiting for user input.
  let more = &more
  set nomore
  let startTime = localtime()
  for i in range( a:numberOfTimes )
    execute a:command
  endfor
  let result = localtime() - startTime
  let &more = more
  return result
endfunction

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    else
        call cursor(1,1)
    endif
endfunction

function! CreateIfNotExist(dir)
    if(!isdirectory(a:dir))
        execute "silent !mkdir -p \"" . a:dir . "\" >> /dev/null 2>&1"
    endif
endfunction

" }}} Functions "
" Plugins {{{ "

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

" Javascript Functionallity {{{ "

Plug '29decibel/vim-stringify', { 'for': 'javascript' }
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }

" }}} Javascript Functionallity "
" Syntaxes {{{ "

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
"" Updated sass/scss syntax
Plug 'tpope/vim-haml'

" }}} Syntaxes "
" Custom TextObjects {{{ "

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'lucapette/vim-textobj-underscore'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" }}} Custom TextObjects "

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

" }}} Plugins "
" Settings {{{ "

syntax sync minlines=300

" Share clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard+=unnamed
endif

" Color Scheme
"set t_Co=256
"let &t_AB="\e[48;5;%dm"
"let &t_AF="\e[38;5;%dm"

syntax on
filetype plugin indent on

let mapleader = " "

set cinoptions=:0,(s,u0,U1,g0,t0    " Some indentation options ':h cinoptions' for details
set cmdheight=2                     " Cmd area height
set cursorline                      " Enable cursor line
set copyindent
set expandtab                       " Spaces are used instead of tabs
set fileformats=unix,dos,mac        " Preference for file formats
set gdefault                        " Add g as default on replaces
set hidden                          " enable multiple modified buffers
set ignorecase                      " Ignore case on searches
set lazyredraw                      " The screen will not be redrawn while executing macros, registers and other commands
set list!                           " Toggle Lists
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set magic                           " Enable extended regexes
set matchtime=2                     " Time to jump to the matched bracket
set matchpairs+=<:>                 " Adds < and > as matching brackets
set noshowmode                      " Don't show the current mode (airline.vim takes care of us)
set nostartofline                   " Don't reset cursor to start of line when moving around
set nowrap                          " Prevent lines from wrapping
set numberwidth=3                   " Number of culumns for line numbers
set number                          " Makes the current line to show the linenumber instead of 0
set relativenumber                  " Show relative numbers
set ruler                           " Show Cursor position all the time
set scrolloff=7                     " Minium number of lines above and below the cursor
set shiftround                      " Round the indent to a multiple of shiftwidth
set shiftwidth=2                    " Columns the text is shifted with << >> (0 follows tabstop)
set showcmd                         " Show partial commands as they're being typed on the bar
set showmatch                       " When a bracket is inserted, jump to the matched one for a few ms
set showtabline=0                   " Hide Tabs on the top of the window
set sidescrolloff=10                " Minium number of characters left and right of the cursor
set smartcase                       " Enables case sensitive search when an uppercase letter is used on the search string
set softtabstop=2                   " Columns used when Tab is hitted in insert mode (-1 follows tabstop)
set splitbelow                      " Open new Split below
set splitright                      " Open new split right
set synmaxcol=400                   " Prevent slow down on long lines
set tabstop=2                       " How many columns a tab counts for
set textwidth=140                   " Set MAX text width
set ttimeout                        " Enable timeout for key codes
set ttimeoutlen=100                 " Time in ms waited for a key code secuence to complete
set updatetime=200                  " Time in ms to consider vim 'idle'
set visualbell                      " Use visual bell instead of beeping
set whichwrap+=<,>,[,]              " Let keys move the cursor to the previous/next line when it's on the first/last character on a line
set formatoptions+=tcqjrob          " Configure the formmating options
"                   ^^^^^^
"                   ||||||
"                   ||||| \b Only auto-wrap if you enter a blank at or before the wrap margin
"                   |||| \o Automatically insert the current comment leader after hitting O in Normal mode
"                   ||| \r Automatically insert the current comment leader after hitting <Enter> in Insert mode
"                   || \j Where it makes sense, remove a comment leader when joining lines
"                   | \q Allow formatting of comments with 'gq'
"                    \c Auto-wrap comments using textwidth, inserting the current comment leader automatically.

" History & Undo Level
set history=1000
set undolevels=1000
set undodir=~/.local/tmp
set backupdir=~/.local/tmp
set directory=~/.local/tmp
set backupskip=~/.local/tmp
set undofile
set nobackup
set nowritebackup

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
  "set t_kb=
  "set t_kD=[3;*~
  set wildmenu                          " Enhanced command completion
  "" Fix Delete Key
  "nmap [3;*~ "_x
  "inoremap [3;*~ <C-O>"_x
  autocmd! BufWritePost * Neomake
else
  autocmd! BufReadPost,BufWritePost * Neomake
endif

set background=dark                     " Sets a dark background
let base16colorspace=256
colorscheme base16-default-dark

" }}} Settings "

" BufferGator {{{ "

  let g:buffergator_autodismiss_on_select=1
  let g:buffergator_autoexpand_on_split=0
  let g:buffergator_autoupdate=1
  let g:buffergator_suppress_keymaps=1

  "@n <Leader>b > Toggle BufferGator - Visualize Toggles
  nmap <silent> <Leader>b :BuffergatorToggle<CR>

" }}} BufferGator "
" CloseTags {{{ "

let g:closetag_filenames = "*.html,*.xhtml,*.phtml"

" }}} CloseTags "
" CtrlP {{{ "

"" CtrlP excluded folder
let g:ctrlp_custom_ignore = {
 \ 'dir':  '\v[\/]((.(git|hg|svn|sass-cache))|node_modules|target|min|tmpcss|reports)$',
 \ 'file': '\v\.(exe|so|dll|processed\.scss|css\.js|map)$',
 \ 'link': 'some_bad_symbolic_links',
 \ }

"Make CtrlP Use the CWD
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_cmd = 'CtrlPMRUFiles'

let g:ctrlp_map = ''
let g:ctrlp_prompt_mappings = {
    \ 'PrtHistory(-1)':       ['<c-n>'],
    \ 'PrtHistory(1)':        [],
    \ 'ToggleType(1)':        ['<c-f>', '<c-p>', '<c-u>'],
    \ }

" MAPPINGS

"@n <Leader>pp > CtrlP - Fuzzy search Files
nnoremap <silent> <Leader>pp :CtrlP<CR>
"@n <Leader>pb > CtrlP - Fuzzy search Buffers
nnoremap <silent> <Leader>pb :CtrlPBuffer<CR>
"@n <Leader>pm > CtrlP - Fuzzy search Most Recent Files
"@n <C-P> > CtrlP - Fuzzy search Most Recent Files
nnoremap <silent> <Leader>pm :CtrlPMRU<CR>
nnoremap <silent> <expr> <C-P> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":CtrlPMRUFiles\<cr>"

" For Reference Only
"@ctrlp <F5> > Purge the cache for the current directory to get new files, remove deleted files and apply new ignore options.
"@ctrlp <F7> > Purge the MRU List
"@ctrlp <C-F> > Cycle between modes [file, mru, buffer].
"@ctrlp <C-B> > Cycle between modes [file, mru, buffer] backwards.
"@ctrlp <C-P> > Cycle between modes [file, mru, buffer].
"@ctrlp <C-D> > to switch to filename only search instead of full path.
"@ctrlp <C-R> > to switch to regexp mode.
"@ctrlp <C-J> > Or Arrow Key to navigate Up the list
"@ctrlp <C-K> > Or Arrow Key to navigate Down the list
"@ctrlp <C-T> > To open in a new Tab
"@ctrlp <C-V> > To open in a new Vertical Split
"@ctrlp <C-X> > To open in a new Horizontal Split
"@ctrlp <C-N> > To select next string from prompt
"@ctrlp <C-P> > To select previous string from prompt
"@ctrlp <C-Y> > To create a new file and its parent directories.
"@ctrlp <C-Z> > To mark/unmark multiple files
"@ctrlp <C-O> > To open serveral files marked with <C-Z>


" }}} CtrlP "
" Delimitmate {{{ "

let delimitMate_expand_cr=1
let delimitMate_expand_space=1

" }}} Delimitmate "
" GitGutter {{{ "
let g:gitgutter_enabled = 1
let g:gitgutter_max_signs = 500  " default value
" }}} GitGutter "
" Nerd* {{{ "

" NERDCommenter
let g:nerdcreatedefaultmappings = 0
let g:nerdspacedelims = 1

let g:NERDCustomDelimiters = {
      \ 'javascript' : { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'javascript.jquery': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }
    \ }

"@n \c > Toggle Line Comment NERDCommenter
nmap \c <Plug>NERDCommenterToggle
"@v \c > Toggle Line Comment in selected lines NERDCommenter
vmap \c <Plug>NERDCommenterToggle

"@ <F9> > Toggle Line Comment in any any NERDCommenter
map <F9> :normal \c<CR>
inoremap <F9> <c-o>:normal \c<CR>


" NERDTree
let g:NERDTreeBookmarksFile=expand("~/.local/tmp/nerdtree.bookmarks")
let g:NERDTreeIgnore=['\.DS_Store$', '\.pyc', '__pycache__', '__init__.py']
let g:nerdtree_tabs_open_on_gui_startup=0
let g:NERDTreeMouseMode=1
let g:NERDTreeWinSize=30
let g:NERDTreeMinimalUI=1

"@n <Leader>n > Toggle NERDTree
nnoremap <Leader>n :NERDTreeToggle<cr>
" Find in Nerd Tree
"@n <Leader>N > Find current file in NERDTree
nmap <leader>N :NERDTreeFind<CR>

au BufLeave *NERD_tree_* silent! nunmap <Leader><Enter>
au BufEnter *NERD_tree_* nmap   <Leader><Enter> :norm cdCD<CR>

" }}} Nerd* "
" SilverSearcher - AG {{{ "

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
" }}} SilverSearcher - AG "
" UltiSnips {{{ "
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$HOME.'/.local/UltiSnips'
" }}} UltiSnips "
" YouCompleteMe - Disabled {{{ "
"">> let g:ycm_complete_in_comments = 1
"">> let g:ycm_collect_identifiers_from_comments_and_strings = 1
"">> let g:pymode_rope_complete_on_dot = 0
"">> let g:ycm_min_num_of_chars_for_completion = 2
"">> let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
"">> let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
" }}} YouCompleteMe - Disabled "

" StatusLine - Helpers {{{ "

autocmd cursorHold,bufWritePost,bufEnter * unlet! b:git_branch
function! GetGitStatus()
  if !exists("b:git_branch")

    if expand('%:p') != ''
      let l:branch='git -C '.expand('%:p:h').' status -sb -- ' . expand('%:p') . ' 2> /dev/null | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | sed "s/\(^##\ \|^\s\|\.\{3\}.*\)//g"'
      let l:branchArray=split(substitute(system(l:branch), '\n', ' ', 'g'), ' ')
      if (len(l:branchArray) > 1)
        let l:branchArray=l:branchArray[:1]
        let l:branchArray[1]=tolower(l:branchArray[1])
      endif
      let b:git_branch=join(l:branchArray, '|')
    else
      let b:git_branch=''

    endif

  endif

  return b:git_branch

endfunction

" Recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = ',sp'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

" Return '[&et]' if &et is set wrong
" Return '[mixed-indenting]' if spaces and tabs are used to indent
" Return an empty string if everything is fine
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
          let b:statusline_tab_warning =  ',mi'
        elseif (spaces && !&et)
          let b:statusline_tab_warning = ',!ett'
        elseif (tabs && &et)
          let b:statusline_tab_warning = ',et'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"Recalculate the long line warning when idle and after saving

"Return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let l:long_line_lens = map(range(1, line('$')), "virtcol([v:val, '$'])")
        let l:maxline = max(l:long_line_lens)
        let l:threshold = (&tw ? &tw : 80)

        if l:maxline > l:threshold
            let l:results = FindItemsBiggerThan(l:long_line_lens, l:threshold)
            "let l:longest_line = index(long_line_lens, l:maxline) + 1
            let b:statusline_long_line_warning =  ",L:" . l:results[1].'›' . l:results[0]
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

function! FindItemsBiggerThan(numberlist, min)
  let l:i = 0
  let l:number_of_lines_longer_than_min = 0

  for l:line in a:numberlist

    let l:i = l:i + 1

    if l:line > a:min
      if !exists('l:first_line')
        let l:first_line = l:i
      endif
      let l:number_of_lines_longer_than_min = l:number_of_lines_longer_than_min + 1
    endif

  endfor

  return [l:first_line, l:number_of_lines_longer_than_min]

endfunction

autocmd cursorhold,bufwritepost * unlet! b:neomake_error_count
function! NeoMakeErrorCount()
    if !exists("b:neomake_error_count")

      if exists("*neomake#statusline#LoclistStatus")
        let b:neomake_error_count=neomake#statusline#LoclistStatus()

        if b:neomake_error_count != ''
          let l:first_error=getloclist(winnr())[0]
          let b:neomake_error_count=','.b:neomake_error_count.'›'.l:first_error.lnum.':'.l:first_error.col
        endif

      else
        let b:neomake_error_count=''
      endif

    endif
    return b:neomake_error_count
endfunction

function! SyntaxItem()
  if exists("g:show_highlight_group")
    return synIDattr(synID(line("."),col("."),1),"name")
  else
    return ''
  endif
endfunction

" }}} StatusLine - Helpers "
" StatusLine {{{ "

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

""" Statusline setup
" Cleans previous status line
set statusline=
" Shows the Syntax Highlight if g:show_highlight_group is enabled
set statusline+=%1*%(\ %{SyntaxItem()}\ %)
" Paste MODE On/Off
set statusline+=%4*%(\ %{&paste?'PASTE':''}\ %)
" FileName
set statusline+=%*%(\ %t\ %)
" Modified/ReadOnly
set statusline+=%2*%(%m%r%)
" Git Status
set statusline+=%1*%(\ «%0.30{GetGitStatus()}»%)
" Left/right separator
set statusline+=%=
" Display an error if fileformat is not UNIX
set statusline+=%2*
set statusline+=%([%R%H%{&ff!='unix'?','.&ff:''}%{(&fenc!='utf-8'&&&fenc!='')?','.&fenc:''}]%)
set statusline+=%([%{NeoMakeErrorCount()}%{StatuslineLongLineWarning()}%{StatuslineTabWarning()}%{StatuslineTrailingSpaceWarning()}]%)

set statusline+=%*
set statusline+=%([%v%),%(%p%%]%)  " Cursor column
set statusline+=%y"filetype

if has('title')
  set titlestring=%t%(\ [%R%M]%)
endif

" Shows the status bar all the time
set laststatus=2
" Shows the mode on the bottom of the screen
set showmode

" Show cursor line only on the active buffer
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" }}} StatusLine "

" Keymaps {{{ "

"@v <Leader>su > Unique Sort
vnoremap <Leader>su :sort u<CR>

"@v <Leader>su > Unique Sort
vnoremap <Leader>sU :sort u!<CR>

"@v <Leader>sa > Sort A-Z
vnoremap <Leader>sa :sort i<CR>

"@v <Leader>sA > Sort A-Z - Case Sensitive
vnoremap <Leader>sA :sort<CR>

"@v <Leader>sz > Sort Z-A
vnoremap <Leader>sz :sort! i<CR>

"@v <Leader>sZ > Sort Z-A - Case Sensitive
vnoremap <Leader>sz :sort!<CR>

"@n <Leader>sr > Search aand Replace
nnoremap <Leader>sr :%s/

"@v \/ > Search in Visual Selection
vnoremap \/ <Esc>/\%V

"@v <Leader>sr > Search aand Replace in Visual Selection
vnoremap <Leader>sr <Esc>:%s/\%V

"@n <C-L> > Clean last search
nnoremap <C-L> :nohlsearch<CR>
"@i <C-L> > Clean last search
inoremap <C-L> <C-O>:nohlsearch<CR>

"@n Y > Make Y consistent with D and C, yanking the rest of the line
nnoremap Y y$

"@n <C-_> > Save only if modified
nnoremap <C-_> :update<cr>
"@i <C-_> > Save only if modified
inoremap <C-_> <c-o>:update<cr>
"@v <C-_> > Save only if modified
vnoremap <C-_> <c-c>:update<cr>v

"@ <F11> > Zoom Tmux pane
map <silent> <F11> :silent !tmux resize-pane -Z<CR>

"@i <C-6> > Esc and change to previous buffer
inoremap <C-^> <Esc>:b#<cr>

au BufEnter *buffergator-buffers* silent! nunmap ds
au BufLeave *buffergator-buffers* nmap   ds <Plug>Dsurround

"@ <C-J> > Inserts line above the current one
map <silent> <C-j> :call InsertNewLine('up')<CR>
"@ <C-K> > Inserts line below the current one
map <silent> <C-k> :call InsertNewLine()<CR>

"@n cdw > Remove Trailing Whitespaces
nnoremap <silent> cdw :call TrimTrailingWhitespace()<CR>

"@n cgf > Go to File that will create the file if it doesn't exist
nmap cgf :e <cfile><CR>


" Stringify
" Small plugin that turns your raw templates into concatenated
" strings.

"@n <Leader>g > Converts the line into concatenated strings, 'asdfasdf' + 'asdfasdfa'
nmap <leader>g :call Stringify()<CR>

"@v <Leader>g > Converts the Selection into concatenated strings, 'asdfasdf' + 'asdfasdfa'
vmap <leader>g :call Stringify()<CR>

"@n <C-D> > Generate JSDocs
nmap <silent> <C-d> <Plug>(jsdoc)

"@ <F1> > Relative Numbers
map <silent> <F1> :set relativenumber!<CR>
imap <silent> <F1> <c-o>:set relativenumber!<CR>

"@ <F2> > Paste Toggle
set pastetoggle=<F2>

"@n <F3> > Undo Tree (GundoToggle)
nnoremap <F3> :GundoToggle<CR>

"@ <F7> > Move the items in the QuickList to the ToArgs List
map <F7> :call QuickListToArgs()<CR>

"@ <F12> > Reload BASE16 and Redraw
imap <silent><F12> <c-o>:execute 'silent !source $BASE16_SHELL'<CR><c-o>:redr!<CR>
map <silent><F12> :execute 'silent !source $BASE16_SHELL'<CR>:redr!<CR>

"@n ,p > Paste on next line
nmap ,p :put<CR>

"@n ,P > Paste on next line
nmap ,P :put!<CR>

"@n <Enter> > Creates a new line
nmap <Enter> o<Esc>
"@n ,<Enter> > Creates a new line and keeps cursor position
nmap ,<Enter> O<Esc>

"@n <Leader>, > Moves to the previous item in the location list
nmap <Leader>, :lprev<cr>
"@n <Leader>. > Moves to the next item in the location list
nmap <Leader>. :lnext<cr>

"@n <Leader>f > Prints the current file path and copies it to the clipboard
nmap <Leader>F :echo @%\|silent !printf % \| pbcopy<Esc>
"@n <Leader>f > Prints the current file path
nmap <Leader>f :echo @%<Esc>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

"" Uppercase Commands
if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" }}} Keymaps "

" Highlight options {{{ "

highlight! Visual cterm=NONE ctermbg=238 ctermfg=NONE guibg=#202E39 guifg=NONE gui=NONE
highlight! IncSearch cterm=NONE guibg=#dc9656 guifg=#282828 ctermfg=white ctermbg=darkyellow gui=NONE
highlight! vimHiAttribList guifg=red guibg=#333333 gui=reverse
highlight! vimHiKeyError guifg=red guibg=#333333 gui=reverse
highlight! IncSearch cterm=NONE guibg=#dc9656 guifg=#282828 ctermfg=white ctermbg=darkyellow gui=NONE

" }}} Highlight options "
" Autocommands {{{ "

" Make Jasmine files load the right syntax highlight and snippets
autocmd BufNewFile,BufReadPre *Spec.js,*_spec.js,*.spec.js let b:javascript_lib_use_jasmine = 1
autocmd BufNewFile,BufReadPost *Spec.js,*_spec.js,*.spec.js set ft=jasmine.javascript

" Backend using node and excluding jquery
autocmd BufNewFile,BufReadPre */app/backend/*.js let b:javascript_lib_use_jquery = 0 | let b:javascript_lib_use_angular = 0
autocmd BufNewFile,BufReadPost */app/backend/*.js set ft=node.javascript

" Frontend using angular and jquery
autocmd BufNewFile,BufReadPre */app/**/*.js let b:javascript_lib_use_jquery = 1 | let b:javascript_lib_use_angular = 1
autocmd BufNewFile,BufReadPost */app/**/*.js set ft=angular.javascript

autocmd! BufReadPost * call SetCursorPosition()
autocmd! BufEnter * :let g:bufNum=bufnr('%')
autocmd! Filetype gitcommit setlocal spell textwidth=72

" }}} Autocommands "

" Enabling .local/init.vim for local configurations
if FileExists($LOCALFOLDER . '/init.vim')
  exec 'so $LOCALFOLDER/init.vim'
endif

if !exists('g:snips_dismiss') && (!exists('g:snips_author') || !exists('g:snips_email'))
  echo 'Add your g:snips_author and g:snips_email in your ~/.local/init.vim for UltiSnips to use them, otherwise set g:snips_dismiss = 1 in your .vimrc'
endif

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'
" Enable some Javascript Libraries
let g:used_javascript_libs = 'underscore,angularjs,jquery'
" Avoid snipmate snippets in UltiSnips
let g:UltiSnipsEnableSnipMate=0
" Start Deoplete
let g:deoplete#enable_at_startup = 1

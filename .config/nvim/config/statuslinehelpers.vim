autocmd cursorHold,bufWritePost,bufEnter * unlet! b:git_branch
function! GetGitStatus()
  if !exists("b:git_branch")

    if expand('%:p') != ''
      let l:branch='git -C '.expand('%:p:h').' status -sb -- ' . expand('%:p') . ' 2> /dev/null | sed "s/\(^##\ \|^\s\|\.\{3\}.*\)//g"'
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

"recalculate the trailing whitespace warning when idle, and after saving
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

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
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
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = ',et'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
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

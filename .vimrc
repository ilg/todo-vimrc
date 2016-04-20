autocmd BufRead,BufNewFile *.todo set filetype=markdown
autocmd BufRead,BufNewFile *.todo setlocal foldlevel=9999 foldenable
autocmd BufWinLeave *.todo mkview
autocmd BufWinEnter *.todo silent loadview

" based on https://github.com/jkramer/vim-checkbox/blob/master/plugin/checkbox.vim
" toggle a markdown checkbox
function! ToggleMarkdownCheckbox()
	let line = getline('.')
	if(match(line, "\\[ \\]") != -1)
		let line = substitute(line, "\\[ \\]", "[o]", "")
	elseif(match(line, "\\[o\\]") != -1)
		let line = substitute(line, "\\[o\\]", "[x]", "")
	elseif(match(line, "\\[x\\]") != -1)
		let line = substitute(line, "\\[x\\]", "[ ]", "")
	endif
	call setline('.', line)
endf
autocmd FileType markdown nmap <CR> :call ToggleMarkdownCheckbox()<CR>

" Apply different colors to the syntax groups defined by https://github.com/gonzaloserrano/vim-markdown-todo
autocmd BufEnter *.todo highlight itemBlocked guifg=Gray gui=none  " [x]
autocmd BufEnter *.todo highlight itemTodo guifg=green4 gui=none  " [ ]
autocmd BufEnter *.todo highlight itemInProgress guifg=Blue gui=bold  " [o]
autocmd BufEnter *.todo highlight itemComplete guifg=Red gui=none  " [+]
autocmd BufEnter *.todo highlight itemWontDo guifg=Pink gui=none  " [-]

" based on http://stackoverflow.com/a/4677454/291280 and http://learnvimscriptthehardway.stevelosh.com/chapters/49.html
" fold markdown lists
function! MarkdownListLevel(lnum)
    if getline(a:lnum) =~ '^$'
        return '-1'
    endif
    let h = matchstr(getline(a:lnum), '^ *-')
    if empty(h)
        return '='
    else
        return len(h) - 1
    endif
endfunction
function! MarkdownListFolding(lnum)
    let this_level = MarkdownListLevel(a:lnum)
    if this_level != 0 && this_level == '='
        return this_level
    endif
    if this_level != 0 && this_level == '-1'
        return '0'
    endif
    let next_level = MarkdownListLevel(a:lnum + 1)
    if this_level < next_level
        return '>' . next_level
    else
        return this_level
    endif
endfunction
autocmd FileType markdown setlocal foldexpr=MarkdownListFolding(v:lnum)
autocmd FileType markdown setlocal foldmethod=expr     

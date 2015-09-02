if exists('g:loaded_cocos2dxLua')
	finish
endif
let g:loaded_cocos2dxLua = 1

let s:myfile = readfile(fnamemodify(g:cocos2dx_diction_location, ":p"))
let s:filelen = len(s:myfile)

fu! CocosComplete(findstart, base)
	if a:findstart
		" locate the start of the word
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && (line[start - 1] =~ '\w' || line[start - 1] == '.')
			let start -= 1
		endwhile
		return start
	else
		let i = match(s:myfile, '^'.a:base)
		let endflag = 0
		let findlist = []
		while i < s:filelen
			if s:myfile[i] =~ '^'.a:base
				call add(findlist, s:myfile[i])
				let endflag = 1
			endif
			if endflag == 1 && s:myfile[i] !~ '^'.a:base
				break
			endif
			let i += 1
		endwhile

		return findlist
	endif
endfunction

fu! s:TabCompleteWay()
	" Check if the char before the cursor is an 
	" underscore, letter, number, dot or opening parentheses.
	" If it is, popup autocomplete menu
	if searchpos('[_a-zA-Z0-9.(]\%#', 'nb') != [0, 0] 
		return "\<C-X>\<C-O>"
	else
		return "\<Tab>"
	endif
endfunction

" Omni autocomplete
setlocal omnifunc=CocosComplete
" map <Tab> to <C-x><C-o>, depend on the char defore the cursor
inoremap <silent> <buffer> <Tab> <C-r>=<SID>TabCompleteWay()<CR>

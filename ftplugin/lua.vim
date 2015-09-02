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

setlocal omnifunc=CocosComplete

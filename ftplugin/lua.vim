" ========== code autocomplete =============
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


" ======== binding key to run Quick Player for the project of this Lua file.====
" Check if Vim support Python
if !has('python')
    echo "Error: Run Player Required vim compiled with +python"
   	echo "Vim for Windows,please check Python & Vim both are 32bit version!"
    finish
endif

python << EOF
playerProcess = None
EOF

fu! RunPlayer()
" start python code
python << EOF
import vim
import os
import codecs
import re
import subprocess
import platform
import time

def pyrun():
	# get project "src" dir
	curLuaFilePath = vim.current.buffer.name
	index = curLuaFilePath.rfind("src" + os.sep)
	if index == -1:
		print("Worning:Can't find project dir")
		return
	workDir = curLuaFilePath[0:index]
	srcDir = os.path.join(workDir, "src")

	# get run args from config.lua
	configPath = os.path.join(srcDir, "config.lua")
	mainPath = os.path.join(srcDir, "main.lua")

	# player path for platform
	playerPath = None
	sysstr = platform.system()
	if(sysstr == "Windows"):
		playerPath = "xxx"
		rootFilePath = os.environ.get('QUICK_V3_ROOT')
		playerPath = os.path.join(rootFilePath, "quick/player/win32/player3.exe")
	elif(sysstr == "Darwin"):
		rootFilePath =  os.path.join(os.path.expanduser('~'), ".QUICK_V3_ROOT")
		if False == os.path.exists(rootFilePath):
			print("Error:file " + rootFilePath + " Not Found!")
			return
		fp = codecs.open(rootFilePath,"r","utf-8")
		quickRoot = fp.readline().strip('\n')
		fp.close()
		playerPath = os.path.join(quickRoot, "quick/player/player3.app/Contents/MacOS/player3")
	else:
		print("Error:Wrong host system!")
		return

	# param
	args = [playerPath]
	args.append("-workdir")
	args.append(workDir)
	args.append("-file")
	args.append(mainPath)
	# parse config.lua & add to args
	if os.path.exists(configPath):
		f = codecs.open(configPath,"r","utf-8")
		width = 640
		height = 960
		while True:
			line = f.readline()
			if line:
				# debug
				m = re.match("^DEBUG\s*=\s*(\d+)",line)
				if m:
					debug = m.group(1)
					if debug == "0":
						args.append("-disable-write-debug-log")
						args.append("-disable-console")
					elif debug == "1":
						args.append("-disable-write-debug-log")
						args.append("-console")
					else:
						args.append("-write-debug-log")
						args.append("-console")
				# resolution
				m = re.match("^CONFIG_SCREEN_WIDTH\s*=\s*(\d+)",line)
				if m:
					width = m.group(1)
				m = re.match("^CONFIG_SCREEN_HEIGHT\s*=\s*(\d+)",line)
				if m:
					height = m.group(1)
			else:
				break
		f.close()
		args.append("-size")
		args.append(width + "x" + height)
	
	# kill previous Player
	global playerProcess
	if playerProcess:
		playerProcess.terminate()
		# waiting for end
		while True:
			ret = subprocess.Popen.poll(playerProcess)
			if ret == 0:
				break # end
			elif ret == None:
				time.sleep(0.5) # Process is Runing
			else:
				break # term
		playerProcess = None # clear global var
	# run a new player
	playerProcess = subprocess.Popen(args)

pyrun()
EOF
endfunction

map <F5> :call RunPlayer()<CR>

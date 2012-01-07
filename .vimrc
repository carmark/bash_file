"=============================================================================
" Description: MY vimrc for Linux/Unix Console
" Author:      Simon <carmark.dlut@gmail.com> 
" Last Change: 2010-11-13 21:00:00
"=============================================================================


"-----------------------------------------------
"general
"-----------------------------------------------
filetype on
filetype plugin on "enable load the plugin
set autoindent
"set nowrap  "do not break a long line to two line
set showmatch "光标短暂的跳到与之匹配的括号处
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set hlsearch  "高亮搜索
set number   "总是显示行号


"-----------------------------------------------
"maping 改变键盘映射，将gj为屏幕行映射到crtl-j
"-----------------------------------------------
noremap <c-j> gj
noremap <C-k> gk
noremap \ml carmark.dlut@gmail.com

"----------------------------------------------
"other keys maping
"----------------------------------------------

"----------------------------------------------
"floding setting
"----------------------------------------------
set foldenable
let perl_fold=1
let perl_fold_blocks=1

let ned_fold=1
let ned_fold_blocks=1

"----------------------------------------------
"定义一些缩写，只要输入短词，然后按下space即可
"----------------------------------------------
iab igmail Simon <carmark.dlut@gmail.com>
iab imail Simon <Lei.Xue@sun.com>
iab iname Lei Simon Xue

"-----------------------------------------------
"color
"-----------------------------------------------
colorscheme delek
syntax on


"-----------------------------------------------
"text format/layout
"-----------------------------------------------
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set formatoptions+=mM "so that vim can reformat the multitype line

"----------------------------------------------
"set the status
"----------------------------------------------
set laststatus=2 
"" 状态栏各个状态 
let statusHead	 ="%-.50f\ %h%m%r" 
let statusBreakPoint	="%<" 
let statusSeparator	 ="|" 
let statusFileType	 ="%{((&ft\ ==\ \"help\"\ \|\|\ &ft\ ==\ \"\")?\"\":\"[\".&ft.\"]\")}" 
let statusFileFormat ="[%{(&ff\ ==\ \"unix\")?\"u\":\"d\"}]" 
let statusAscii	 ="\{%b:0x%B\}" 
let statusCwd	 ="%-.50{getcwd()}" 
let statusBody =statusFileType.statusFileFormat.statusSeparator.statusAscii.statusSeparator."\ ".statusBreakPoint.statusCwd 
let statusEncoding	 ="[%{(&fenc\ ==\ \"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]" 
let statusBlank	 ="%=" 
let statusKeymap	 ="%k" 
let statusRuler	 ="%-12.(%lL,%c%VC%)\ %P" 
let statusTime	 ="%{strftime(\"%y-%m-%d\",getftime(expand(\"%\")))}" 
let statusEnd=statusKeymap."\ ".statusEncoding.statusRuler."\ ".statusTime 
"" 最终状态栏的模式字符串 
let statusString=statusHead.statusBody.statusBlank.statusEnd 
set statusline=%!statusString 

"----------------------------------------------
"plugin ned.vim
"----------------------------------------------
au BufNewFile,BufRead *.ned set syntax=ned

"----------------------------------------------
"one key to exec one c/c++ file
"----------------------------------------------
map <c-F5> :call Do_OneFileMake()<CR>
function Do_OneFileMake()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file." | echohl None
	    return
	endif
	let sourcefileename=expand("%:t")
    if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c"))
	    echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
	    return
	endif
    let deletedspacefilename=substitute(sourcefileename,' ','','g')
	if strlen(deletedspacefilename)!=strlen(sourcefileename)
		echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
	    return
    endif

	let outfilename=substitute(sourcefileename,'\(\.[^.]*\)$','','g')
	let toexename=outfilename

	if &filetype=="c"
		set makeprg=gcc\ -o\ %<\ %
	elseif &filetype=="cpp"
	        set makeprg=g++\ -o\ %<\ %
	endif

	if filereadable(outfilename)
		let outdeletedsuccess=delete("./".outfilename)
        if(outdeletedsuccess!=0)
			set makeprg=make
			echohl WarningMsg|echo "Fail to make!I cannot delete the" .outfilename| echohl None
			return
		endif
	endif
	execute "silent make"
    set makeprg=make
    execute "normal:"
	if filereadable(outfilename)
		execute "!./".toexename
	endif
	execute "copen"
endfunction


"----------------------------------------------
"one key to exec one perl script 
"----------------------------------------------
map <c-F6> :call Do_OneFileMake4Perl()<CR>
function Do_OneFileMake4Perl()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg | echo "Fail to make! This file is not in the current dir! " | echohl None
	    return
	endif
	let sourcefileename=expand("%:t")
    if (sourcefileename=="" || &filetype!="perl" )
	    echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
	    return
	endif
    let deletedspacefilename=substitute(sourcefileename,' ','','g')
	if strlen(deletedspacefilename)!=strlen(sourcefileename)
		echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
	    return
    endif

	let outfilename=sourcefileename
	let toexename=outfilename

    execute "normal:"
	if filereadable(outfilename)
		execute "! perl ".toexename
	endif
	execute "copen"
endfunction



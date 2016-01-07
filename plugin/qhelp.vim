" Qhelp.vim - Quickly prints help sections
" Copyright (C) Retorillo <http://github.com/retorillo/>
" Distributed under the terms of the Vim license

" Usage:
" :Qhelp[!] {helptag}

command! -nargs=1 -complete=help -bang Qhelp :call Qhelp("<args>", "<bang>")
cabbrev qhelp <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Qhelp" : "qhelp"<CR>

function! s:CheckTag(str)
	return matchstr(a:str, "\\*[^*]\\{1,\\}\\*$")
endfunction

function! Qhelp(tag, bang)
try
	exec "tab help ". a:tag
	let s:bn = line(".")
	let s:en = line("$")
	let s:cn = s:bn
	let s:tg = 1 
	while s:cn < s:en
		let s:ln  = getline(s:cn)
		let s:ct  = s:CheckTag(s:ln)
		let s:ctb = len(s:ct) > 0
		if s:tg
			let s:tg = s:ctb
		elseif s:ctb
			if (a:bang != "" || confirm("Qhelp stopped at ". s:ct, "&ContinueToRead\nStop") == 2)
				break
			end
			let s:tg = 1
		endif
		echo s:ln
		let s:cn += 1
	endwhile
	tabclose
finally
endtry
endfunction

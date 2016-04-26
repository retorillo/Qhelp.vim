" Qhelp.vim <https://github.com/retorillo/qhelp.vim>
" Distributed under the MIT license
" Copyright (C) 2016 Retorillo

" Usage:
" :Qhelp {helptag}

command! -nargs=1 -complete=help Qhelp :call Qhelp(<f-args>)
cabbrev qhelp <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "Qhelp" : "qhelp"<CR>

function! Qhelp(tag)
   let tab_open = 0
try
	exec "tab help ". a:tag
   let tab_open = 1
	let ln_cur = line(".")
	let ln_end = line("$")
   let lastm = 1

	while ln_cur < ln_end
		let line  = getline(ln_cur)
      let mlist = matchlist(line, "\\*[^*]\\{1,\\}\\*$")

      if !lastm && !empty(mlist)
         if confirm("Qhelp stopped at ".mlist[0], "&Continue\n&Quit", 1) == 2
            break
         endif
		endif

      if line =~ '^<'
         echohl None
      elseif !empty(mlist)
         echohl String
      endif

		echo substitute(line, '^<\|>$', ' ', 'g')

		let ln_cur += 1
      let lastm = !empty(mlist)

      if line =~ '>$'
         echohl Comment
      elseif !empty(mlist)
         echohl None
      endif
	endwhile
finally
   echohl None
   if tab_open
      tabclose
   endif
endtry
endfunction

"==============================================================================
" FILE: autoload/ansibledoc.vim
" AUTHOR: Phong V. Cao <phongvcao@phongvcao.com>
" License: MIT license {{{
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
" }}}
"==============================================================================


let s:ansibledoc_buf_count = 0


function! ansibledoc#AnsibleDoc(...)
    let l:result=ansibledoc#GetQueryResult(a:000)

    if (&filetype != 'ansibledoc.ansible')
        let l:cur_winnr = winnr()
        execute 'normal! \<C-W>b'
        if (winnr() > 1)
            execute 'normal! ' . l:cur_winnr . '\<C-W>w'
            while 1
                if (&filetype == 'ansibledoc.ansible')
                    break
                endif
                execute 'normal! \<C-W>w'
                if (l:cur_winnr ==# winnr())
                    break
                endif
            endwhile
        endif

        if (&filetype != 'ansibledoc.ansible')
            if (g:ansibledoc_split_horizontal ==# 1)
                silent! execute g:ansibledoc_split_size . 'sp ansibledoc.vim' . s:ansibledoc_buf_count
            else
                silent! execute g:ansibledoc_split_size . 'vsp ansibledoc.vim' . s:ansibledoc_buf_count
            endif
        endif
    endif

    silent execute '1,$d'
    setlocal noswapfile readonly number relativenumber filetype=ansibledoc.ansible
    setlocal nobuflisted buftype=nofile bufhidden=hide
    silent! 1s/^/\=l:result/
    1
endfunction


" function! stardict#StarDict(...)
"     let l:expl=stardict#GetDefinition(a:000)
"
"     if (&filetype != 'stardict')
"         let l:cur_winnr = winnr()
"         execute "normal! \<C-W>b"
"         if (winnr() > 1)
"             exe "normal! " . l:cur_winnr . "\<C-W>w"
"             while 1
"                 if (&filetype == 'stardict')
"                     break
"                 endif
"                 exe "normal! \<C-W>w"
"                 if (l:cur_winnr ==# winnr())
"                     break
"                 endif
"             endwhile
"         endif
"         if &filetype != 'stardict'
"             if (g:stardict_split_horizontal ==# 1)
"                 silent! execute g:stardict_split_size . 'sp vim-stardict' . s:stardict_buf_count
"             else
"                 silent! execute g:stardict_split_size . 'vsp vim-stardict' . s:stardict_buf_count
"             endif
"         endif
"     endif
"
"     silent exec "1,$d"
"     setlocal buftype=nofile bufhidden=hide noswapfile readonly filetype=stardict
"     setlocal number relativenumber nobuflisted
"     silent! 1s/^/\=l:expl/
"     1
" endfunction


function! ansibledoc#GetQueryResult(...)
    let l:args_str = ''
    let l:snippet_result = ''

    " If there were no argument issued
    " Show ansible-doc --list
    if (empty(a:000[0]))
        let l:args_str = '--list'
    else
        let l:args_str = join(a:000[0], ' ')
    endif

    return ansibledoc#FormatStr(system('ansible-doc ' . l:args_str))
endfunction


function! ansibledoc#FormatStr(...)
    let l:final_str = substitute(a:000[0], 'Options', 'OPTIONS', "")
    let l:final_str = substitute(l:final_str, 'Requirements:', "REQUIREMENTS:", "")
    let l:final_str = substitute(l:final_str, 'EXAMPLES:', "EXAMPLE:", "")

    return l:final_str
endfunction


" function! stardict#GetDefinition(...)
"     if s:SetPythonPath() != 1
"         return "Cannot set ${PATH} variable!"
"     endif
"
"     let l:argsStr = join(a:000, '\\ ')
"
"     if has('python3')
"         python3 definition = GetDefinitionInner(vim.eval('a:000'))
"         let l:definition = py3eval('definition')
"     elseif has('python')
"         python definition = GetDefinitionInner(vim.eval('a:000'))
"         let l:definition = pyeval('definition')
"     endif
"
"     return l:definition
" endfunction

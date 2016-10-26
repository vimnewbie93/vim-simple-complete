if exists("g:loaded_vim_simple_complete")
  finish
endif
let g:loaded_vim_simple_complete = 1

let g:vsc_tab_complete = get(g:, 'vsc_tab_complete', 1)
let g:vsc_completion_command = get(g:, 'vsc_completion_command', "\<C-P>")

fun! s:Init()
    call s:TypeCompletePlugin()

    if g:vsc_tab_complete
        call s:TabCompletePlugin()
    endif
endfun

fun! s:TabCompletePlugin()
    inoremap <expr> <Tab> <SID>TabComplete()

    fun! s:TabComplete()
        if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
            return g:vsc_completion_command
        else
            return "\<Tab>"
        endif
    endfun
endfun

fun! s:TypeCompletePlugin()
    set completeopt=menu,menuone,noinsert,preview
    imap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
    autocmd InsertCharPre * call s:TypeComplete()

    fun! s:TypeComplete()
        if v:char =~ '\K'
            \ && getline('.')[col('.') - 4] !~ '\K'
            \ && getline('.')[col('.') - 3] =~ '\K'
            \ && getline('.')[col('.') - 2] =~ '\K' " last typed char
            \ && getline('.')[col('.') - 1] !~ '\K'

            call feedkeys(g:vsc_completion_command, 'n')
        end
    endfun
endfun

call s:Init()

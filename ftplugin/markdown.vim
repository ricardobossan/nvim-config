" From https://github.com/plasticboy/vim-markdown
function! s:TableFormat()
    let l:pos = getpos('.')
    normal! {
    " Search instead of `normal! j` because of the table at beginning of file edge case.
    call search('|')
    normal! j
    " Remove everything that is not a pipe, colon or hyphen next to a colon othewise
    " well formated tables would grow because of addition of 2 spaces on the separator
    " line by Tabularize /|.
    let l:flags = (&gdefault ? '' : 'g')
    execute 's/\(:\@<!-:\@!\|[^|:-]\)//e' . l:flags
    execute 's/--/-/e' . l:flags
    Tabularize /|
    " Move colons for alignment to left or right side of the cell.
    execute 's/:\( \+\)|/\1:|/e' . l:flags
    execute 's/|\( \+\):/|:\1/e' . l:flags
    execute 's/ /-/' . l:flags
    call setpos('.', l:pos)
endfunction

command! -buffer TableFormat call s:TableFormat()

" table format
nnoremap <buffer> <leader>tf <cmd>TableFormat<cr>
" table emtpy cell
nnoremap <buffer> <leader>tec <cmd>normal vi\|r <cr>

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

g:vim_markdown_auto_insert_bullets
"let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_fenced_languages = ['csharp=cs', 'bash=sh']
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_conceal = 1
setlocal conceallevel=3

nnoremap <buffer><silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nmap <buffer><silent> gd <cmd>lua vim.lsp.buf.definition()<CR>

"autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
"autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
"autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()

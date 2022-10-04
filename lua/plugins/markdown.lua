vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.cmd [[
""    let g:vim_markdown_folding_style_pythonic = 1
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_fenced_languages = ['csharp=cs', 'bash=sh']
    let g:vim_markdown_toml_frontmatter = 1
    let g:vim_markdown_new_list_item_indent = 0
    setlocal conceallevel=3
    ]]
  end,
})

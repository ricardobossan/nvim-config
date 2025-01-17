-- Most plugins that execute commands expect a POSIX compliant shell.
if string.find(vim.o.shell, 'fish') ~= nil then
  if vim.fn.filereadable('/bin/zsh') == 1 then
    vim.o.shell = '/bin/zsh'
  elseif vim.fn.filereadable('/bin/bash') == 1 then
    vim.o.shell = '/bin/bash'
  end
end

require('vanilla')
require('plugins')
if not vim.g['first_install'] then
  require('colorscheme')
  pcall(require, 'system_config')
end

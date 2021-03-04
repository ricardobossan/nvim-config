if string.find(vim.o.shell, 'fish') ~= nil then
  if vim.fn.filereadable('/bin/zsh') == 1 then
    vim.o.shell = '/bin/zsh'
  elseif vim.fn.filereadable('/bin/bash') == 1 then
    vim.o.shell = '/bin/bash'
  end
end

require('00_vanilla')
require('01_plugins')

-- setup an autocommand to modify themes to my liking
vim.cmd('au! ColorScheme * lua require("colors.post").init()')
-- Ayu
vim.g.ayucolor = 'mirage'
vim.g.ayu_italic_comment = true
vim.g.ayu_experimental_colors = true
-- load colorscheme as soon as possible
vim.cmd('colorscheme ayu')

local config_path = vim.fn.stdpath('config')
if vim.fn.filereadable(config_path .. '/lua/system_config.lua') == 1 then
  -- TODO: use pcall require instead
  require('system_config')
end

require('02_plugins_conf')

vim.cmd('filetype plugin indent on')

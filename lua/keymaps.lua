-- Shorten function name
local keymap = vim.keymap.set

return {
  vanilla = function()
    vim.g.mapleader = ' '
    keymap('n', ';', ':')
    keymap('n', '<leader>l', ':bnext<CR>')
    keymap('n', '<leader>h', ':bprevious<CR>')
    keymap('n', '<leader>bq', ':b# <BAR> bd #<CR>')
    keymap('n', '<leader>br', ':%s/<C-r><C-w>//g<left><left>')
    keymap('n', '<leader>th', ':set hlsearch!<CR>')
    keymap('n', '<leader>tw', ':setlocal wrap!<CR>')
    keymap('n', '<leader>ts', ':setlocal spell!<CR>')
    keymap('n', '<leader>n', ':nohl<CR>')
    keymap('n', '<leader>N', ':Rmhl<CR>')
    keymap('n', 'zS', function() require('helpers.syntax').showCursorHighlights() end)

    keymap('n', '<space>', 'za', {remap = true})
    keymap('n', '<C-space>', 'zA', {remap = true})

    -- Switch
    keymap('n', '<leader>ss', ':call switcher#Switch()<CR>')
    keymap('n', '<leader>sv', ':call switcher#SwitchWithOptions({"edit_command": "vs"})<CR>')
    keymap('n', '<leader>sh', ':call switcher#SwitchWithOptions({"edit_command": "sp"})<CR>')

    -- Wrap
    keymap('x', '<leader>w', ':call wrap#func()<CR>')

    if vim.fn.has('win32') == 1 then
      -- Because Windows is such a great operating system,
      -- doing <C-Z> will completely lock up Neovim in the terminal.
      -- See: https://github.com/neovim/neovim/issues/6660
      keymap('n', '<C-Z>', function() require('term').open() end)
    end

    keymap('t', '<leader>n', '<C-\\><C-N>')

    -- Convenient Control+Backspace insert mode mapping
    keymap('i', '<C-backspace>', '<esc>ciw')
-- Press jk fast to enter
keymap("i", "jk", "<ESC>")
  end,
  fugitive = function()
    keymap('n', '<leader>gs', ':Git<CR>', {silent = true})
    keymap('n', '<leader>gf', ':Git fetch<CR>', {silent = true})
  end,
  fugitive_buffer = function()
    keymap('n', '<leader>gp', ':Git push<CR>', {buffer = true})
  end,
  neotree = function()
    local function n_map(key, opener)
      if opener ~= '' then
        opener = opener .. '<bar>'
      end
      local tree_command = ':' .. opener .. 'Neotree current reveal<CR>'

      keymap('n', '<C-f>' .. key, tree_command)
      keymap('n', '<C-f><C-' .. key .. '>', tree_command)
    end
    keymap('n', '<leader>e', ':NeoTreeFocusToggle<CR>')

    n_map('f', '')
    n_map('v', 'vsplit')
    n_map('x', 'split')
    n_map('h', 'split')
    n_map('t', 'tabedit %')
    n_map('C-e', ':NeoTreeFocusToggle')
  end,
  vsnip = function()
    local function v_map(key, condition, on_true)
      keymap({'i', 's'}, key, function() return condition() ~= 0 and on_true or key end, {expr = true})
    end

    v_map('<C-e>', function() return vim.fn['vsnip#expandable']() end, '<Plug>(vsnip-expand)')
    v_map('<C-j>', function() return vim.fn['vsnip#jumpable'](1) end, '<Plug>(vsnip-jump-next)')
    v_map('<C-k>', function() return vim.fn['vsnip#jumpable'](-1) end, '<Plug>(vsnip-jump-prev)')
  end,
  telescope = function()
    local builtin = require('telescope.builtin')
    local fix_folds = require('plugins.telescope').fix_folds

    keymap('n', '<leader>ff', function() builtin.find_files(fix_folds) end)
    keymap("n", '<leader>ft', function() builtin.live_grep(fix_folds) end)
    keymap('n', '<leader>fb', function() builtin.buffers({ show_all_buffers = true }) end)
    keymap('n', '<leader>fg', function() require('plugins.telescope').rg(fix_folds, false) end)
    keymap('n', '<leader>fG', function()
      require('plugins.telescope').rg(fix_folds, true)
    end)
    keymap('n', '<leader>gb', builtin.git_branches)
    keymap('n', '<leader>gt', function() require('plugins.telescope').tags() end)
  end,
  lsp = function(client)
    if client.name == 'rust_analyzer' then
      keymap('n', 'K', function() require('rust-tools.hover_actions').hover_actions() end)
      keymap('n', '<leader>qk', function() require('rust-tools.hover_actions').hover_actions() end)
    else
      keymap('n', 'K', function() vim.lsp.buf.hover() end)
      keymap('n', '<leader>qk', function() vim.lsp.buf.hover() end)
    end

    keymap('n', '<leader>qK', function() vim.lsp.buf.signature_help() end)
    keymap('n', '<leader>qq', function() vim.diagnostic.open_float() end)
    if vim.fn.has('nvim-0.8') == 1 then
      keymap('n', '<leader>qr', function()
        require('inc_rename').rename()
      end)
    else
      keymap('n', '<leader>qr', function() vim.lsp.buf.rename() end)
    end
    keymap('n', '<leader>qn', function() vim.diagnostic.goto_next() end)
    keymap('n', '<leader>qp', function() vim.diagnostic.goto_prev() end)
    keymap('n', '<leader>qa', function() vim.lsp.buf.code_action() end)

    local builtin = require('telescope.builtin')
    keymap('n', '<leader>qgr', function() builtin.lsp_references() end)
    keymap('n', '<leader>qs', function() builtin.lsp_document_symbols() end)
    keymap('n', '<leader>qd', function() builtin.lsp_document_diagnostics() end)
    keymap('n', '<leader>qwd', function() builtin.lsp_workspace_diagnostics() end)
    keymap('n', '<leader>qws', function() builtin.lsp_workspace_symbols() end)
    keymap('n', '<leader>qgi', function() builtin.lsp_implementations() end)

    if client.name == 'omnisharp' then
      keymap('n', 'gd', function() require('omnisharp_extended').telescope_lsp_definitions() end)
    else
      keymap('n', 'gd', function() builtin.lsp_definitions() end)
    end
  end,
  indent_blankline = function()
    local function remap(lhss)
      for _,lhs in pairs(lhss) do
        keymap('n', lhs, lhs .. ':IndentBlanklineRefresh<CR>', { silent = true })
      end
    end

    remap({'zo', 'zO', 'zc', 'zC', 'za', 'zA', 'zv', 'zx', 'zX', 'zm', 'zM', 'zR', 'zr'})
  end,
  term = function(new_term)
    keymap('t', '<leader>n', '<C-\\><C-N>:b#<CR>', { silent = true, buffer = new_term })
  end,
  dap = function()
    keymap('n', '<F5>', ':DapContinue<CR>')
    keymap('n', '<F10>', ':DapStepOver<CR>')
    keymap('n', '<F11>', ':DapStepInto<CR>')
    keymap('n', '<C-F11>', ':DapStepOut<CR>')

    keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>')
    keymap('n', '<leader>dk', function() require('dap.ui.widgets').hover() end)
  end,
  comments = function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    keymap('n', '<leader>cc', function() require('Comment.api').toggle.linewise.current() end)
    keymap('n', '<leader>cu', function() require('Comment.api').uncomment.linewise.current() end)

    keymap('x', '<leader>cm', function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.blockwise(vim.fn.visualmode())
    end)
    keymap('x', '<leader>cu', function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').uncomment.blockwise(vim.fn.visualmode())
    end)
  end
}

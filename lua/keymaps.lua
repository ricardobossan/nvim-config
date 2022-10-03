-- Shorten function name
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

return {
  vanilla = function()
    --Remap space as leader key
    keymap("", "<Space>", "<Nop>", opts)
    vim.g.mapleader = ' '

    -- Press jk fast to enter
    keymap("i", "jk", "<ESC>")

    -- Create new line without entering insert mode
    keymap('n', 'o', 'o<ESC>', opts)
    keymap('n', 'O', 'O<ESC>', opts)
    keymap('v', 'o', 'o<ESC>', opts)
    keymap('v', 'O', 'O<ESC>', opts)

    -- Stay in indent mode
    keymap("v", "<", "<gv", opts)
    keymap("v", ">", ">gv", opts)

    keymap('n', ';', ':', opts)
    keymap('n', '<leader>l', ':bnext<CR>', opts)
    keymap('n', '<leader>h', ':bprevious<CR>', opts)
    keymap('n', '<leader>bq', ':b# <BAR> bd #<CR>', opts)
    keymap('n', '<leader>br', ':%s/<C-r><C-w>//g<left><left>', opts)
    keymap('n', '<leader>th', ':set hlsearch!<CR>', opts)
    keymap('n', '<leader>tw', ':setlocal wrap!<CR>', opts)
    keymap('n', '<leader>ts', ':setlocal spell!<CR>', opts)
    keymap('n', '<leader>n', ':nohl<CR>', opts)
    keymap('n', '<leader>N', ':Rmhl<CR>', opts)
    keymap('n', 'zS', function() require('helpers.syntax').showCursorHighlights() end)

    keymap('n', '<space>', 'za', {remap = true})
    keymap('n', '<C-space>', 'zA', {remap = true})

    -- Resize with arrows
    keymap("n", "<C-Up>", ":resize -2<CR>", opts)
    keymap("n", "<C-Down>", ":resize +2<CR>", opts)
    keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
    keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

    -- Clear highlights
    keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)


    -- Switch
    keymap('n', '<leader>ss', ':call switcher#Switch()<CR>', opts)
    keymap('n', '<leader>sv', ':call switcher#SwitchWithOptions({"edit_command": "vs"})<CR>', opts)
    keymap('n', '<leader>sh', ':call switcher#SwitchWithOptions({"edit_command": "sp"})<CR>', opts)

    -- Wrap
    keymap('x', '<leader>w', ':call wrap#func()<CR>', opts)



    if vim.fn.has('win32') == 1 then
      -- Because Windows is such a great operating system,
      -- doing <C-Z> will completely lock up Neovim in the terminal.
      -- See: https://github.com/neovim/neovim/issues/6660
      keymap('n', '<C-Z>', function() require('term').open() end)
    end

    keymap('t', '<leader>n', '<C-\\><C-N>', opts)

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
    keymap('n', '<leader>e', ':NeoTreeFocusToggle<CR>', opts)

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

    keymap('n', '<leader>ff', function() builtin.find_files(fix_folds) end, opts)
    keymap("n", '<leader>ft', function() builtin.live_grep(fix_folds) end, opts)
    keymap('n', '<leader>fb', function() builtin.buffers({ show_all_buffers = true }) end, opts)
    keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
    keymap('n', '<leader>fg', function() require('plugins.telescope').rg(fix_folds, false) end, opts)
    keymap('n', '<leader>fG', function()
      require('plugins.telescope').rg(fix_folds, true)
    end, opts)
    keymap('n', '<leader>gb', builtin.git_branches)
    keymap('n', '<leader>gt', function() require('plugins.telescope').tags() end, opts)
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
    keymap('n', '<F5>', ':DapContinue<CR>', opts)
    keymap('n', '<F10>', ':DapStepOver<CR>', opts)
    keymap('n', '<F11>', ':DapStepInto<CR>', opts)
    keymap('n', '<C-F11>', ':DapStepOut<CR>', opts)

    keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', opts)
    keymap('n', '<leader>dk', function() require('dap.ui.widgets').hover() end)
    keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
    keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
    keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
    keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
    keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
    keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
    keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
    keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
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

local function bootstrap()
  local data_path = vim.fn.stdpath('data')
  local packer_path = data_path .. '/site/pack/packer/opt/packer.nvim'
  local not_installed = vim.fn.isdirectory(packer_path) == 0

  if not_installed then
    vim.cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
  end

  vim.cmd('packadd packer.nvim')

  return not_installed
end

local function startup(use)
  use({'wbthomason/packer.nvim', opt = true})

  local function languages()
    -- File Format
    use{'editorconfig/editorconfig-vim', commit = "a8e3e66deefb6122f476c27cee505aaae93f7109"}
    use{'mboughaba/i3config.vim', commit = "5c753c56c033d3b17e5005a67cdb9653bbb88ba7"}
    use{'cespare/vim-toml', branch = 'main', commit = "d36caa6b1cf508a4df1c691f915572fc02143258"}
    -- Glsl
    use{'tikhomirov/vim-glsl', commit = "bfd330a271933c3372fcfa8ce052970746c8e9dd"}
    -- Shell
    use{'PProvost/vim-ps1', commit = "e7cc3b08f6f9e2dc1909f397aa3d5b0a7acb661c"}
    use{'blankname/vim-fish', commit = "5155be4b1e3962187442a977a211a62ecf863ec0"}

    use{'openembedded/bitbake', rtp = 'contrib/vim', commit = "074da4c469d1f4177a1c5be72b9f3ccdfd379d67"}

    use{ -- TreeSitter
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      {'nvim-treesitter/nvim-treesitter-textobjects', commit = "41e8d8964e5c874d9ce5e37d00a52f37f218502e"},
      {'p00f/nvim-ts-rainbow', commit = "fad8badcd9baa4deb2cf2a5376ab412a1ba41797"},
      {'nvim-treesitter/playground', commit = "bcfab84f98a33f2ad34dda6c842046dca70aabf6"},
      { -- hlargs.nvim
      'm-demare/hlargs.nvim',
      config = function()
        require('hlargs').setup({})
      end
    }
  },
  config = function()
    require('plugins.treesitter')
  end,
  commit = "ffd4525fd9e61950520cea4737abc1800ad4aabb"
}

-- vim-markdown
use{'godlygeek/tabular', opt = true, cmd = {'Tabularize'}, commit = "339091ac4dd1f17e225fe7d57b48aff55f99b23a"} -- Tabularize everything
use{'preservim/vim-markdown', commit = "c3f83ebb43b560af066d2a5d66bc77c6c05293b1"}

  end

  local function utility()
    use{ -- Fugitive: Git integration
    {'tpope/vim-fugitive', commit = "dd8107cabf5fe85df94d5eedcae52415e543f208"},
    config = function() require('plugins.fugitive') end
  }
  use{'junegunn/gv.vim', opt = true, cmd = {'GV'}, commit = "1507838ee67f9b298def89cbfc404a0fee4a4b8c"} -- Git log graphical visualisation
  use{ -- autopairs
  'windwp/nvim-autopairs',
  config = function() require('plugins.autopairs') end,
  commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347"
}
--[[ use{ -- Auto close html tags
'alvan/vim-closetag',
config = function()
  vim.g['closetag_filenames'] = '*.html,*.xhtml,*.phtml,*.vue,*.xml,*.jsx,*.tsx'
  vim.g['closetag_filetypes'] = 'html,xhtml,phtml,vue,xml,javascriptreact,javascript.jsx,typescriptreact,typescript.tsx'
  vim.g['closetag_regions'] = {}
end
    } ]]

    use { --nvim-ts-autotag
    {'windwp/nvim-ts-autotag', commit = "99ba1f6d80842a4d82ff49fc0aa094fb9d199219"},
  }

  use {
    {'nvim-neo-tree/neo-tree.nvim', commit = ""},
    requires = {
      {'MunifTanjim/nui.nvim', commit = "4715f6092443f0b8fb9a3bcb0cfd03202bb03477"}
    },
    config = function()
      require('plugins.neo_tree')
    end,
    commit = "e968cda658089b56ee1eaa1772a2a0e50113b902"
  }

  use{ -- Comment.nvim
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup{
      mappings = {
        basic = false,
        extra = false,
        extended = false
      }
    }

    require('keymaps').comments()
  end,
  commit = "a85ca1b96198904e0086eea04580a944e788b7e4"
}
use{'tpope/vim-surround', commit = "bf3480dc9ae7bea34c78fbba4c65b4548b5b1fea"} -- Surround (visually select and surround with what you want)
use{'AndrewRadev/bufferize.vim', opt = true, cmd = {'Bufferize'}, commit = "aa07ff2d536bf841d886a2d980f18c480493af48"} -- Execute commands in a buffer
use{ -- Startify: Nice startup screen
{'mhinz/vim-startify', commit = "df0f1dbdc0689f6172bdd3b8685868aa93446c6f"},
config = function() require('plugins.startify') end
    }
    use{'wellle/targets.vim', commit = "8d6ff2984cdfaebe5b7a6eee8f226a6dd1226f2d"} -- adds text-objects to work with (like 'ci,' for example))
    use{'tpope/vim-repeat', commit = "24afe922e6a05891756ecf331f39a1f6743d3d5a"} -- .
    use{'rhysd/clever-f.vim', commit = "7c573bb1fc6d0d3a959a4f35c17732f5346a996a"} -- Better (visual) f, F, t and T motion

    use{ -- vsnip
    {'hrsh7th/vim-vsnip', commit = "8f199ef690ed26dcbb8973d9a6760d1332449ac9"},
    requires = {'hrsh7th/vim-vsnip-integ', commit = "64c2ed66406c58163cf81fb5e13ac2f9fcdfb52b"},
    config = function()
      require('plugins.vsnip')
    end
  }

  use{ -- cmp
  {'hrsh7th/nvim-cmp', commit = "89df2cb22384f6a0f48695b3b8adbcd069e87036"},
  requires = {
    {'hrsh7th/cmp-buffer', commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"},
    {'hrsh7th/cmp-path', commit = "91ff86cd9c29299a64f968ebb45846c485725f23"},
    {'hrsh7th/cmp-nvim-lsp', commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8"},
    {'hrsh7th/cmp-vsnip', commit = "0abfa1860f5e095a07c477da940cfcb0d273b700"}
  },
  config = function()
    require('plugins.cmp')
  end,
  commit =""
}

use{ -- FixCursorHold
'antoinemadec/FixCursorHold.nvim',
config = function()
  vim.g.cursorhold_updatetime = 100
end,
commit = "5aa5ff18da3cdc306bb724cf1a138533768c9f5e"
    }

    use{ -- todo-comments.nvim
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end,
    commit = "5f9094198563b693439837b593815dc18768fda8"
  }
end

local function interface()
  use{ -- gitsigns.nvim
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end,
  commit = "2300e4eadb69a2c01193165e6a522258bbd0e443"
}
use{'kyazdani42/nvim-web-devicons', commit = "a8cf88cbdb5c58e2b658e179c4b2aa997479b3da"}
use{ -- Ctrlsf Search and replace interface
'dyng/ctrlsf.vim',
config = function()
  vim.g['ctrlsf_populate_qflist'] = true
  --vim.g['ctrlsf_default_view_mode'] = 'compact'
end,
commit = "32236a8b376d9311dec9b5fe795ca99d32060b13"
    }

    use{ -- colorizer
    {'norcalli/nvim-colorizer.lua', commit = "174b7a67ce384318f7500e0d256322e1cbba5e5b"},
    config = function() require('plugins.colorizer') end
  }

  use{ -- Telescope
  'nvim-telescope/telescope.nvim',
  requires = {
    {'nvim-lua/popup.nvim', commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac"},
    {'nvim-lua/plenary.nvim', commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7"}
  },
  config = function()
    require('plugins.telescope').init()
  end,
  commit = "76ea9a898d3307244dce3573392dcf2cc38f340f"
}

use{ -- lualine
'nvim-lualine/lualine.nvim',
config = function() require('plugins.lualine') end,
commit = "2061fcbf3b5db692f4d27d49796418f8f93b7539"
    }

    use{ -- bufferline
    'akinsho/nvim-bufferline.lua',
    branch = 'main',
    config = function()
      require('plugins.bufferline').init()
    end,
    commit = "a61991d307e4af75e606aa1241e419d0f532b968"
  }

  use{ -- indent-blankline
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('plugins.indent_blankline')
  end,
  commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6"
}

use{ -- dressing.nvim
'stevearc/dressing.nvim',
config = function() require('plugins.dressing') end,
commit = "12b808a6867e8c38015488ad6cee4e3d58174182"
    }

    use{ -- notify
    'rcarriga/nvim-notify',
    config = function()
      require('plugins.notify')
    end,
    commit = "7a9be08986b4d98dd685a6b40a62fcba19c1ad27"
  }

  use{ -- vim-illuminate
  'RRethy/vim-illuminate',
  config = function()
    require('illuminate').configure({
      providers = {
        'lsp',
        'treesitter',
        -- 'regex' -- Currently disabled, but might be useful in some cases
      },
      delay = 100,
      under_cursor = false, -- Highlight any word under the cursor
    })
  end,
  commit = "0603e75fc4ecde1ee5a1b2fc8106ed6704f34d14"
}
  end

  local function themes()
    use{'Luxed/ayu-vim', commit = "b1ef49957bfe46dee9cd39bb4b5ec8c381b1b30d"}
  end

  local function lsp_dap()
    use { -- lspconfig
    'neovim/nvim-lspconfig',
    requires = {
      {'mfussenegger/nvim-jdtls', commit = "0422245fdef57aa4eddba3d99aee1afaaf425da7"},
      {'nvim-lua/lsp-status.nvim', commit = "54f48eb5017632d81d0fd40112065f1d062d0629"},
      {'Hoffs/omnisharp-extended-lsp.nvim', commit = "d3fe9f38047fdfb26b85d982be94e78bb42349bb"},
      {'onsails/lspkind-nvim', commit = "c68b3a003483cf382428a43035079f78474cd11e"},
      {'kosayoda/nvim-lightbulb', commit = "56b9ce31ec9d09d560fe8787c0920f76bc208297"},
      {'simrat39/rust-tools.nvim', commit = "348d17a6ef966ba48a5a4b9446bf157403ea4289"},
      {'ray-x/lsp_signature.nvim', commit = "e65a63858771db3f086c8d904ff5f80705fd962b"},
      {'jose-elias-alvarez/nvim-lsp-ts-utils', commit = "821fd95f87940a07f961322e2ac47bd3af478c1f"},

      -- LSP installer
      {'williamboman/mason.nvim', commit = "45606b0e9b01a1565bfc8b57a52ec04f58f5f295"},
      {'williamboman/mason-lspconfig.nvim', commit = "b364c98644b53e351d27313dfdab809df7fde1d3"}
  },
    config = function()
      require('plugins.lsp_status')
      require('plugins.lsp')
    end,
    commit = "c4dcbf8672778480ac19696d4ca1fcea2ed658c2"
  }

  if vim.fn.has('nvim-0.8') == 1 then
    use{ -- inc-rename
    'smjonas/inc-rename.nvim',
    config = function() require('inc_rename').setup() end,
    commit = "09e980117fd7788674a051ce623614a209766fb2"
  }

  use{ -- neodim
  'zbirenbaum/neodim',
  event = 'LspAttach',
  config = function() require('plugins.dim') end,
  commit = "cf61b8797154d1709672bfdde2dd09a7a652f6b2"
}
    end

    use{ -- dap
    'mfussenegger/nvim-dap',
    requires = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text'
    },
    config = function() require('plugins.dap') end,
    commit = "bbd3e7e15ac6b5e7aceb680515f7352d6a0953be"
  }
end

local function tracking()
  use{'ActivityWatch/aw-watcher-vim', opt = true}
end

languages()
utility()
interface()
themes()
lsp_dap()
tracking()
end

local first_install = bootstrap()
vim.g['first_install'] = first_install
require('packer').startup(startup)

if first_install then
  print('First install. Plugins will be automatically installed.')
  print('Restart Neovim once the update is fully finished')
  require('packer').sync()
end

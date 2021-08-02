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
    -- Rust
    use('rust-lang/rust.vim')
    -- Markdown
    use {
      'vim-pandoc/vim-pandoc',
      requires = {'vim-pandoc/vim-pandoc-syntax', 'vim-pandoc/vim-markdownfootnotes'},
      config = function()
        vim.g['pandoc#modules#disabled'] = {'spell'}
      end
    }
    -- File Format
    use('editorconfig/editorconfig-vim')
    use('mboughaba/i3config.vim')
    use('elzr/vim-json')
    use('cespare/vim-toml')
    -- Javascript, Typescript
    use('pangloss/vim-javascript')
    use('heavenshell/vim-jsdoc')
    --use('reasonml-editor/vim-reason-plus')
    --use('herringtondarkholme/yats.vim') -- Typescript syntax
    use('posva/vim-vue')
    -- Html/css
    use('othree/html5.vim')
    use('hail2u/vim-css3-syntax')
    use('cakebaker/scss-syntax.vim')
    -- Glsl
    use('tikhomirov/vim-glsl')
    -- Kotlin
    use('udalov/kotlin-vim')
    -- Haskell
    use('neovimhaskell/haskell-vim')
    use{'hspec/Hspec.vim', opt=true, ft={'haskell'}}
    -- Vimscript
    use('junegunn/vader.vim')
    -- Shell
    use('PProvost/vim-ps1')
    use('blankname/vim-fish')
    -- Lua
    use('tbastos/vim-lua')
    use('leafo/moonscript-vim')
    use('bakpakin/fennel.vim')
    -- Reason
    use('rescript-lang/vim-rescript')
  end

  local function utility()
    use{ -- Git integration
      'tpope/vim-fugitive',
      config = function() require('plugins.fugitive') end
    }
    use{'junegunn/gv.vim', opt = true, cmd = {'GV'}} -- Git log graphical visualisation
    use{
      'windwp/nvim-autopairs',
      config = function() require('plugins.autopairs') end
    }
    use{ -- Auto close html tags
      'alvan/vim-closetag',
      config = function()
        vim.g['closetag_filenames'] = '*.html,*.xhtml,*.phtml,*.vue,*.xml'
        vim.g['closetag_filetypes'] = 'html,xhtml,phtml,vue,xml'
      end
    }
    use{
      'lambdalisue/fern.vim',
      requires = {'lambdalisue/nerdfont.vim', 'lambdalisue/fern-renderer-nerdfont.vim'},
      config = function() require('plugins.fern') end
    }
    use('preservim/nerdcommenter') -- Commenting tool
    use('tpope/vim-surround') -- Surround (visually select and surround with what you want)
    use{'AndrewRadev/bufferize.vim', opt = true, cmd = {'Bufferize'}} -- Execute commands in a buffer
    use{'andrewradev/splitjoin.vim', branch = 'main'} -- Better split and join (gS, gJ)
    use{ -- Nice startup screen
      'mhinz/vim-startify',
      config = function() require('plugins.startify') end
    }
    use('wellle/targets.vim') -- adds text-objects to work with (like 'ci,' for example))
    use('tpope/vim-repeat') -- .
    use{'mattn/emmet-vim', opt = true, ft={'html'}}
    use('rhysd/clever-f.vim') -- Better (visual) f, F, t and T motion
  end

  local function interface()
    use('mhinz/vim-signify') -- Version control gutter signs (git, svn, mercurial, etc.)
    use('godlygeek/tabular') -- Tabularize everything
    use('kyazdani42/nvim-web-devicons')
    use{ -- Search and replace interface
      'dyng/ctrlsf.vim',
      config = function()
        vim.g['ctrlsf_populate_qflist'] = true
        --vim.g['ctrlsf_default_view_mode'] = 'compact'
      end
    }
  end

  local function themes()
    use{'Luxed/ayu-vim', branch = 'experimental-colors'}
  end

  local function lua_plugins()
    use{'hrsh7th/vim-vsnip', requires = {'hrsh7th/vim-vsnip-integ'}}

    use{ -- colorizer
      'norcalli/nvim-colorizer.lua',
      config = function() require('plugins.colorizer') end
    }

    -- Telescope (fuzzy finder)
    use{
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require('plugins.telescope').init()
      end
    }

    -- TreeSitter
    use {
      --'nvim-treesitter/nvim-treesitter',
      'Luxed/nvim-treesitter',
      branch = 'c_sharp',
      run = ':TSUpdate',
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'p00f/nvim-ts-rainbow',
        'nvim-treesitter/playground'
      },
      config = function()
        require('plugins.treesitter')
      end
    }

    -- LSP related plugins
    use {
      'neovim/nvim-lspconfig',
      requires = {
        'tjdevries/nlua.nvim',
        'mfussenegger/nvim-jdtls',
        'nvim-lua/lsp-status.nvim'
      },
      config = function()
        require('plugins.lsp_status')
        require('plugins.lsp')
      end
    }

    -- Completion
    use{
      'hrsh7th/nvim-compe',
      config = function()
        require('plugins.compe')
      end
    }
    use{'kosayoda/nvim-lightbulb'}

    -- Statusline/Tabline
    use{
      'glepnir/galaxyline.nvim',
      config = function()
        require('plugins.galaxyline')
      end
    }
    use{
      'akinsho/nvim-bufferline.lua',
      config = function()
        require('plugins.bufferline').init()
      end
    }

    use{
      'lukas-reineke/indent-blankline.nvim',
      opt = true,
      config = function()
        require('plugins.indent_blankline')
      end
    }

    use('ray-x/lsp_signature.nvim')

    use('jose-elias-alvarez/nvim-lsp-ts-utils')
  end

  local function tracking()
    use{'ActivityWatch/aw-watcher-vim', opt = true}
  end

  languages()
  utility()
  interface()
  themes()
  lua_plugins()
  tracking()
end

local first_install = bootstrap()
require('packer').startup(startup)

if first_install then
  print('First install. Plugins will be automatically installed.')
  print('Restart Neovim once the update is fully finished')
  require('packer').sync()
end
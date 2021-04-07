-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- macros
  local _M = {
    telescope_load = function(ext) return 'require("telescope").load_extension("' .. ext .. '")' end,
  }

  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Core plugins
  use 'tjdevries/astronauta.nvim'
  use {'nvim-lua/plenary.nvim', config = 'require("plenary.filetype").add_file("user")'}
  -- hererocks are broken right now
  use {'kyazdani42/nvim-web-devicons', config = 'require("plugins.nvim-web-devicons")'}

  -- Completion & Linting
  use {'neovim/nvim-lspconfig', config = 'require("user.cfg.lspsettings")'}
  use {'tamago324/nlsp-settings.nvim', requires = 'nvim-lspconfig'}
  use {'glepnir/lspsaga.nvim', requires = 'nvim-lspconfig', config = 'require("plugins.lspsaga")'}
  use {'nvim-lua/lsp-status.nvim', requires = 'nvim-lspconfig'}
  use {'RishabhRD/nvim-lsputils', requires = {'nvim-lspconfig', 'RishabhRD/popfix'}}
  use {'onsails/lspkind-nvim', requires = 'nvim-lspconfig', config = 'require("lspkind").init()'}
  use {
    'kabouzeid/nvim-lspinstall',
    requires = 'nvim-lspconfig',
    cmd = {'LspInstall', 'LspUninstall'},
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    -- Highlighting engine for neovim
    --
    -- I've chosen not to include some modules until some issues they have get fixed.
    -- nvim-ts-rainbow can be added once #5 is fixed (which requires nvim-treesitter#879 merged)
    requires = {
      {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
      {'nvim-treesitter/playground', after = 'nvim-treesitter', as = 'nvim-treesitter-playground'},
      {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'},
      {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'},
      {'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter'},
    },
    run = ':TSUpdate',
    config = 'require("plugins.treesitter")',
  }
  use {'dense-analysis/ale', cmd = 'ALEEnable', config = 'require("plugins.ale")'}
  use {
    'hrsh7th/vim-vsnip',
    requires = {'nvim-lspconfig', {'rafamadriz/friendly-snippets', after = 'vim-vsnip'}},
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'
      local imap, smap = vim.keymap.imap, vim.keymap.smap
      -- Expand
      imap {'<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], expr = true}
      smap {'<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], expr = true}
      -- Expand or jump
      imap {'<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], expr = true}
      smap {'<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], expr = true}
    end,
  }
  use {
    'hrsh7th/nvim-compe',
    requires = {
      {'tzachar/compe-tabnine', run = 'bash install.sh'}, 'vim-vsnip', 'nvim-lspconfig',
      'nvim-treesitter',
    },
    config = 'require("plugins.nvim-compe")',
  }

  -- Filetypes
  use 'leafo/moonscript-vim'
  use 'rhysd/vim-llvm'
  use 'ron-rs/ron.vim'
  use 'bakpakin/fennel.vim'
  use 'aklt/plantuml-syntax'
  use 'tikhomirov/vim-glsl'
  use 'udalov/kotlin-vim'
  use 'YaBoiBurner/requirements.txt.vim'
  use 'teal-language/vim-teal' -- Locally patched ti fix some issues.
  use 'gluon-lang/vim-gluon'
  use 'blankname/vim-fish'
  -- Meson syntax is now manually maintained
  -- toml is handled internally + with nvim-treesitter

  -- CXX
  use {'jackguo380/vim-lsp-cxx-highlight', ft = {'c', 'cpp', 'objc', 'objcpp', 'cc', 'cuda'}}

  -- Lua
  -- use 'tjdevries/manillua.nvim'
  use {'tjdevries/nlua.nvim', ft = 'lua'}
  use {'bfredl/nvim-luadev', cmd = 'Luadev'}
  use {'rafcamlet/nvim-luapad', cmd = {'Lua', 'Luapad', 'LuaRun'}}

  -- Markdown
  use {'plasticboy/vim-markdown', ft = 'markdown'}
  use {'npxbr/glow.nvim', ft = {'markdown', 'pandoc.markdown', 'rmd'}}
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown'}
  -- use 'davidgranstrom/nvim-markdown-preview'

  -- Python
  -- use 'vim-python/python-syntax'
  use {'Vimjas/vim-python-pep8-indent', ft = {'aap', 'bzl', 'cython', 'pyrex', 'python'}}

  -- RST
  use {'stsewd/sphinx.nvim', ft = 'rst'} -- rplugin skipped because it's not useful for me

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim', 'plenary.nvim', 'nvim-web-devicons', 'nvim-treesitter',

      -- Telescope plugins
      'nvim-telescope/telescope-fzy-native.nvim', 'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim', 'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-project.nvim', 'nvim-telescope/telescope-node-modules.nvim',
      'nvim-telescope/telescope-media-files.nvim', 'tamago324/telescope-sonictemplate.nvim',

      {'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sql.nvim'},
      {'nvim-telescope/telescope-cheat.nvim', requires = 'tami5/sql.nvim'},
    },
    config = 'require("plugins.telescope")',
  }
  use {
    'pwntester/octo.nvim',
    -- Lazy loading isn't very helpful for this since the command completions are too useful
    -- I could experiment with a custom loader but not right now.
    requires = {'telescope.nvim', 'plenary.nvim'},
    config = _M.telescope_load('octo'),
  }

  -- User interface
  use {
    'wfxr/minimap.vim',
    cmd = 'Minimap',
    setup = function()
      vim.g.minimap_block_filetypes = {
        'ale-fix-suggest', 'ale-preview-selection', 'ale-preview', 'fugitive', 'LuaTree',
        'tsplayground', 'vista', 'vista_kind', 'vista_markdown',
      }
    end,
  }
  use {'liuchengxu/vista.vim', cmd = 'Vista', setup = 'require("plugins.vista")'} -- TOC & symbol tree
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'plenary.nvim',
    after = 'colorbuddy.nvim', -- Load after theme so it looks better
    config = 'require("gitsigns").setup()',
  }
  use {'rhysd/git-messenger.vim', cmd = 'GitMessenger', keys = {{'n', '<Leader>gm'}}}
  use 'f-person/git-blame.nvim'
  use {
    'norcalli/nvim-colorizer.lua',
    -- Highlights color codes with the actual color
    ft = {'css', 'kitty', 'less', 'lua', 'vim'},
    cmd = 'ColorizerToggle',
    config = function()
      require('colorizer').setup {
        'kitty',
        'less',
        css = {css = true},
        lua = {RGB = false, RRGGBB = true, names = false},
        vim = {RGB = false, RRGGBB = true, names = false},
      }
    end,
  }
  use {'meain/vim-package-info', run = 'npm i'} -- rplugin lazy loads
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'nvim-web-devicons',
    cmd = {'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile'},
  }
  use {
    'glepnir/galaxyline.nvim',
    requires = 'nvim-web-devicons',
    config = 'require("user.statusline")',
  }
  use {
    'akinsho/nvim-bufferline.lua',
    -- Tabline plugin
    -- Issues:
    -- - #14: (feat) Show only buffer in current tab?
    requires = 'nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          mappings = true,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, _) return '(' .. count .. ')' end,
          separator_style = 'slant',
        },
      }
      vim.keymap.nmap {'bb', '<Cmd>BufferLinePick<CR>'}
    end,
  }
  use {'tjdevries/colorbuddy.nvim', config = 'require("colorbuddy").colorscheme("quantumbuddy")'}
  use {
    'tkmpypy/chowcho.nvim',
    requires = 'nvim-web-devicons',
    cmd = 'Chowcho',
    config = function() require('chowcho').setup {icon_enabled = true, border_style = 'rounded'} end,
  }
  use {'yamatsum/nvim-cursorline', config = 'require("plugins.nvim-cursorline").config()'}
  use {'alec-gibson/nvim-tetris', cmd = 'Tetris'}
  use {'dstein64/nvim-scrollview', config = 'vim.g.scrollview_nvim_14040_workaround = true'}
  use {
    'kevinhwang91/nvim-hlslens',
    -- no lazy loading until packer #273 is fixed or a new mechanism is set up
    keys = {{'n', 'n'}, {'n', 'N'}, {'n', '*'}, {'n', '#'}, {'n', 'g*'}, {'n', 'g#'}},
    event = 'CmdlineEnter [/\\?]',
    config = 'require("plugins.nvim-hlslens")',
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    branch = 'lua',
    config = 'require("plugins.indent-blankline")',
  }
  use 'karb94/neoscroll.nvim' -- Smooth scrolling
  use {
    'edluffy/specs.nvim',
    config = function() require('specs').setup {popup = {fader = require('specs').pulse_fader}} end,
  }

  -- Utilities
  use {'tpope/vim-fugitive', config = 'vim.g.fugitive_legacy_commands = false'}
  use {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = function() require('neogit').setup {disable_signs = true} end,
  }
  use 'farmergreg/vim-lastplace'
  use {
    'vimwiki/vimwiki',
    -- Note-taking engine
    event = 'BufNewFile,BufRead *.markdown,*.mdown,*.mdwn,*.wiki,*.mkdn,*.mw,*.md',
    cmd = {
      'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiDiaryIndex', 'VimwikiMakeDiaryNote',
      'VimwikiTabMakeDiaryNote',
    },
    keys = {
      {'n', '<Leader>ww'}, {'n', '<Leader>wt'}, {'n', '<Leader>wi'}, {'n', '<Leader>w<Leader>w'},
      {'n', '<Leader>w<Leader>t'}, {'n', '<Leader>w<Leader>y'}, {'n', '<Leader>w<Leader>m'},
    },
    setup = function()
      vim.g.vimwiki_list = {{path = '~/Documents/VimWiki', nested_syntaxes = {['c++'] = 'cpp'}}}
      vim.g.vimwiki_folding = 'expr'
      vim.g.vimwiki_listsyms = '✗○◐●✓'
      vim.g.vimwiki_global_ext = 0
    end,
  }
  use {
    'oberblastmeister/neuron.nvim',
    -- Neuron-based note-taking engine
    --
    -- This will probably replace vimwiki at some point.
    requires = {'plenary.nvim', 'telescope.nvim'},
    keys = {{'n', 'gzi'}},
    config = function()
      require('neuron').setup {
        virtual_titles = true,
        mappings = true,
        run = nil,
        neuron_dir = '~/Documents/Neuron',
        leader = 'gz',
      }
    end,
  }
  use {
    'hkupty/iron.nvim',
    cmd = {'IronRepl', 'IronSend', 'IronReplHere', 'IronWatchCurrentFile'},
    keys = {{'n', 'ctr'}, {'v', 'ctr'}, {'n', '<LocalLeader>sl'}},
    config = 'require("plugins.iron")',
  }
  use {'lukas-reineke/format.nvim', config = 'require("plugins.format-nvim")'}
  use {'gennaro-tedesco/nvim-jqx', cmd = {'JqxList', 'JqxQuery'}}
  use {'gennaro-tedesco/nvim-peekup', keys = {{'n', [[""]]}}}
  use {
    'rcarriga/vim-ultest',
    requires = 'vim-test/vim-test',
    opt = true,
    cmd = {'Ultest', 'UltestNearest'},
    -- Lazy loading requires strict controls
    setup = 'vim.g.ultest_loaded = true',
    config = function()
      vim.g.ultest_loaded = nil
      vim.api.nvim_exec([[
        UpdateRemotePlugins
        runtime! plugin/ultest.vim
      ]], false)
    end,
  }
  use {
    'mattn/vim-sonictemplate',
    -- Template engine
    cmd = 'Template',
    -- fn load condition allows for telescope integration to load this
    fn = 'sonictemplate#complete',
    keys = {
      {'n', '<C-y>t'}, {'i', '<C-y>t'}, {'n', '<C-y>T'}, {'i', '<C-y>T'}, {'n', '<C-y><C-t>'},
      {'i', '<C-y><C-t>'}, {'i', '<C-y><C-b>'},
    },
  }
  use {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
      local nmap = vim.keymap.nmap
      nmap {'<C-h>', '<Cmd>lua require("Navigator").left()<CR>', silent = true}
      nmap {'<C-j>', '<Cmd>lua require("Navigator").down()<CR>', silent = true}
      nmap {'<C-k>', '<Cmd>lua require("Navigator").up()<CR>', silent = true}
      nmap {'<C-l>', '<Cmd>lua require("Navigator").right()<CR>', silent = true}
      nmap {'<C-\\>', '<Cmd>lua require("Navigator").previous()<CR>', silent = true}
    end,
  }

  -- Integration
  use {
    'editorconfig/editorconfig-vim',
    -- Editorconfig support
    -- Rules that will modify files are disabled, since that's handled elsewhere.
    -- Eventually I'll find or make a unified formatting plugin to replace this.
    config = function()
      vim.g.EditorConfig_exclude_patterns = {
        'davs\\?://.*', 'ftp://.*', 'fugitive://.*', 'https\\?://.*', 'info://.*', 'man://.*',
        'octo://.*', 'output://.*', 'rcp://.*', 'rsync://.*', 'scp://.*', 'sftp://.*', 'term://.*',
      }
      vim.g.EditorConfig_disable_rules = {
        'insert_final_newline', 'max_line_length', 'trim_trailing_whitespace',
      }
    end,
  }
  use {'kdheepak/lazygit.nvim', cmd = 'LazyGit'}
  -- use {'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end}
  -- Spell support for tree-sitter is nice but it causes files to noticably refresh constantly.
  -- It also might be contributing to PID bloat by running hunspell too often.
  -- It's a WIP so some problems can be expected.

  -- Text editing
  use 'tpope/vim-repeat'
  use {
    'phaazon/hop.nvim',
    -- EasyMotion replacement
    --
    -- GitHub Issues:
    -- - #4: (feat) Quick-scope mode
    keys = {
      {'n', '<Leader>hw'}, {'n', '<Leader>hp'}, {'n', '<Leader>hc'}, {'n', '<Leader>hC'},
      {'n', '<Leader>hl'},
    },
    cmd = {'HopWord', 'HopPattern', 'HopChar1', 'HopChar2', 'HopLine'},
    config = function()
      local nmap = vim.keymap.nmap
      nmap {'<Leader>hw', '<Cmd>lua require("hop").hint_words()<CR>'}
      nmap {'<Leader>hp', '<Cmd>lua require("hop").hint_patterns()<CR>'}
      nmap {'<Leader>hc', '<Cmd>lua require("hop").hint_char1()<CR>'}
      nmap {'<Leader>hC', '<Cmd>lua require("hop").hint_char2()<CR>'}
      nmap {'<Leader>hl', '<Cmd>lua require("hop").hint_lines()<CR>'}
    end,
  }
  use {'windwp/nvim-autopairs', config = 'require("nvim-autopairs").setup()'}
  use {
    'tpope/vim-abolish',
    cmd = {'Abolish', 'Subvert', 'S'},
    keys = {{'n', 'cr'}},
    setup = function()
      vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end,
  }
  use {'tpope/vim-commentary', cmd = 'Commentary', keys = {'gc', {'n', 'gcc'}, {'n', 'gcu'}}}
  use {
    'tpope/vim-surround',
    -- This will be replaced by blackCauldron7/surround.nvim eventually
    keys = {
      {'n', 'ds'}, {'n', 'cs'}, {'n', 'cS'}, {'n', 'ys'}, {'n', 'yS'}, {'n', 'yss'}, {'n', 'ySs'},
      {'n', 'ySS'}, {'x', 'S'}, {'x', 'gS'}, {'i', '<C-s>'}, {'i', '<C-g>s'}, {'i', '<C-g>S'},
    },
  }
  use {
    'monaqa/dial.nvim',
    -- Replaces speeddating
    keys = {'<C-a>', '<C-x>', {'v', 'g<C-a>'}, {'v', 'g<C-x>'}},
    config = 'require("plugins.dial")',
  }
  use {
    'AndrewRadev/splitjoin.vim',
    cmd = {'SplitjoinSplit', 'SplitjoinJoin'},
    keys = {{'n', 'gJ'}, {'n', 'gS'}},
  }
  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign', 'LiveEasyAlign'},
    keys = {'<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)'},
    setup = function()
      vim.keymap.vmap {'ga', '<Plug>(LiveEasyAlign)', silent = true}
      vim.keymap.nmap {'ga', '<Plug>(EasyAlign)', silent = true}
    end,
  }
  use {
    'dkarter/bullets.vim',
    ft = {'markdown', 'gitcommit'},
    setup = [[vim.g.bullets_enabled_file_types = {'markdown', 'gitcommit'}]],
  }
  use {
    'kana/vim-textobj-function',
    -- Can act up when lazy-loaded
    requires = 'kana/vim-textobj-user',
    keys = {
      {'x', 'af'}, {'o', 'af'}, {'x', 'if'}, {'o', 'if'}, {'x', 'aF'}, {'o', 'aF'}, {'x', 'iF'},
      {'o', 'iF'},
    },
  }
  use {
    'sgur/vim-textobj-parameter',
    requires = 'kana/vim-textobj-user',
    keys = {{'x', 'a,'}, {'o', 'a,'}, {'x', 'i,'}, {'o', 'i,'}, {'x', 'i2,'}, {'o', 'i2,'}},
  }
  use {
    'rsrchboy/vim-textobj-heredocs',
    requires = 'kana/vim-textobj-user',
    keys = {{'x', 'aH'}, {'o', 'aH'}, {'x', 'iH'}, {'o', 'iH'}},
  }
end)

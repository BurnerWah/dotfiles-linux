-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- Core plugins
  use 'tjdevries/astronauta.nvim'
  use { 'nvim-lua/plenary.nvim', config = function() require'plenary.filetype'.add_file'user' end }

  -- Completion & Linting
  use { 'neovim/nvim-lspconfig', config = function() require'user.cfg.lspsettings' end }
  use {
    'glepnir/lspsaga.nvim',
    requires = 'nvim-lspconfig',
    config = function() require'lspsaga'.init_lsp_saga {
      error_sign = '',
      warn_sign = '',
      hint_sign = '',
      infor_sign = '',
      border_style = 2, -- Rounded border
    } end
  }
  use {
    'RishabhRD/nvim-lsputils',
    requires = { 'nvim-lspconfig', 'RishabhRD/popfix' },
  }
  use { 'kosayoda/nvim-lightbulb', requires = 'nvim-lspconfig' }
  use { 'jubnzv/virtual-types.nvim', requires = 'nvim-lspconfig', cmd = 'EnableVirtualTypes' }
  use { 'onsails/lspkind-nvim', requires = 'nvim-lspconfig', config = function() require'lspkind'.init {} end }
  use { 'anott03/nvim-lspinstall', requires = 'nvim-lspconfig', cmd = 'LspInstall' }
  use {
    'nvim-treesitter/nvim-treesitter',
    --[[ Highlighting engine for neovim

      I've chosen not to include some modules until some issues they have get fixed.
      nvim-treesitter-textobjects can be added once #8 & #27 are fixed
      nvim-ts-rainbow can be added once #5 is fixed (which requires nvim-treesitter#879 merged)
      ]]
    requires = {
      { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
      { 'nvim-treesitter/playground', after = 'nvim-treesitter', as = 'nvim-treesitter-playground' },
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
    },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'maintained',
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true }, -- Indent uses 'tabstop' so it has to be managed in ftplugins.
        playground = { enable = true },
        refactor = {
          highlight_definitions = { enable = true },
          smart_rename = { enable = true },
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      }
      local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
      parser_config.bash.used_by = { 'PKGBUILD' }
    end
  }
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
    disable = true,
    config = function()
      vim.g.coc_filetype_map = {
        catalog = 'xml',
        dtd = 'xml',
        smil = 'xml',
        xsd = 'xml',
      }
      --Welcome to keymap hell.
      vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.api.nvim_set_keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', {})
      vim.cmd [[autocmd init User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&spell', 0)]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&winblend', 10)]]
      vim.cmd [[autocmd init FileType list setlocal nospell]]
    end
  }
  use { 'dense-analysis/ale', config = function() require'user.cfg.ale' end }
  use {
    'hrsh7th/vim-vsnip',
    requires = { 'nvim-lspconfig', 'hrsh7th/vim-vsnip-integ' },
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'
      local remap = vim.api.nvim_set_keymap
      -- Expand
      remap('i', '<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], { expr = true })
      remap('s', '<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], { expr = true })
      -- Expand or jump
      remap('i', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true })
      remap('s', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true })
    end
  }
  use {
    'hrsh7th/nvim-compe',
    requires = {
      { 'tzachar/compe-tabnine', run = 'bash install.sh' },
      'vim-vsnip',
      'nvim-lspconfig',
      'nvim-treesitter',
    },
    config = function()
      vim.o.completeopt = 'menu,menuone,noselect'
      require'compe'.register_source('fish', require'compe_fish') -- Custom source
      require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        source = {
          path = true,
          buffer = true,
          calc = true,
          vsnip = true,
          nvim_lsp = true,
          nvim_lua = true,
          spell = true,
          tags = true,
          tabnine = {
            ignored_filetypes = { 'markdown', 'rst', 'vimwiki' },
            disabled = false,
            priority = 1000, -- Defaults to 5000 which can be problematic
            dup = true, -- Allow duplicate entries (mostly with LSP)
          },
          treesitter = true,
          omni = {
            filetypes = { 'clojure', 'debchangelog', 'mf', 'mp', 'vimwiki' }
          },
          fish = true,
        },
      }
      local remap = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true, expr = true }
      remap('i', '<C-Space>', [[compe#complete()]], opts)
      remap('i', '<CR>', [[compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })]], opts)
      remap('i', '<C-e>', [[compe#close('<C-e>')]], opts)
      remap('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], opts)
      remap('i', '<C-d>', [[compe#scroll({ 'delta': -4 })]], opts)
    end
  }

  -- Filetypes
  use 'leafo/moonscript-vim'
  use 'rhysd/vim-llvm'
  use 'cespare/vim-toml'
  use 'ron-rs/ron.vim'
  use 'bakpakin/fennel.vim'
  use 'aklt/plantuml-syntax'
  use 'tikhomirov/vim-glsl'
  use 'udalov/kotlin-vim'
  use 'YaBoiBurner/requirements.txt.vim'
  use 'YaBoiBurner/vim-teal'
  use 'blankname/vim-fish'
  use { 'mesonbuild/meson', rtp = 'data/syntax-highlighting/vim', opt = true }

  -- CXX
  use { 'jackguo380/vim-lsp-cxx-highlight', ft = { 'c', 'cpp', 'objc', 'objcpp', 'cc', 'cuda' } }

  -- Lua
  use { 'euclidianAce/betterlua.vim', ft = 'lua' }
  use 'tjdevries/manillua.nvim'
  use 'tjdevries/nlua.nvim'
  use { 'bfredl/nvim-luadev', cmd = 'Luadev' }
  use { 'rafcamlet/nvim-luapad', cmd = { 'Lua', 'Luapad', 'LuaRun' } }

  -- Markdown
  use { 'npxbr/glow.nvim', ft = { 'markdown', 'pandoc.markdown', 'rmd' } }
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown' }

  -- Python
  -- use 'vim-python/python-syntax'
  use { 'Vimjas/vim-python-pep8-indent', ft = { 'aap', 'bzl', 'cython', 'pyrex', 'python' } }

  -- RST
  use { 'stsewd/sphinx.nvim', ft = 'rst' }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-treesitter',

      -- Telescope plugins
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-packer.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-node-modules.nvim',

      {'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sql.nvim'},
      {'nvim-telescope/telescope-cheat.nvim', requires = 'tami5/sql.nvim'},
    },
    config = function()
      local telescope = require 'telescope'
      local env = vim.env
      telescope.setup {
        defaults = {
          winblend = 10,
          file_sorter = require'telescope.sorters'.get_fzy_sorter,
        },
        extensions = {
          frecency = {
            show_scores = true,
            ignore_patterns = {
              '*.git/*',
              '*/tmp/*',
              (env.XDG_CACHE_HOME or (env.HOME .. '/.cache')),
            },
            workspaces = {
              conf = (env.XDG_CONFIG_HOME or (env.HOME .. '/.config')),
              data = (env.XDG_DATA_HOME or (env.HOME .. '/.local/share')),
              project = (env.HOME .. '/Projects'),
            },
          },
          fzf_writer = { use_highlighter = true },
        },
      }
      telescope.load_extension('fzy_native')
      telescope.load_extension('fzf_writer')
      telescope.load_extension('gh')
      telescope.load_extension('packer')
      telescope.load_extension('project')
      telescope.load_extension('node_modules')
      telescope.load_extension('frecency')
      telescope.load_extension('cheat')

      local remap = vim.api.nvim_set_keymap
      local opts = { silent = true, noremap = true }

      remap('n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]], opts)
      remap('n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]], opts)
      remap('n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]], opts)
      remap('n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]], opts)
      remap('n', '<leader><leader>', [[<cmd>lua require'telescope'.extensions.frecency.frecency()<CR>]], opts)
      remap('n', '<C-p>', [[<cmd>lua require'telescope'.extensions.project.project{}<CR>]], opts)
    end
  }
  use { 'pwntester/octo.nvim', requires = 'telescope.nvim', opt = true, cmd = 'Octo' }

  -- User interface
  use {
    'wfxr/minimap.vim',
    cmd = 'Minimap',
    setup = function()
      vim.g.minimap_block_filetypes = {
        'ale-fix-suggest',
        'ale-preview-selection',
        'ale-preview',
        'coc-explorer',
        'denite',
        'denite-filter',
        'fugitive',
        'nerdtree',
        'list',
        'LuaTree',
        'tagbar',
        'tsplayground',
        'vista',
        'vista_kind',
        'vista_markdown',
      }
    end
  }
  use {
    'liuchengxu/vista.vim',
    -- Table of contents & symbol tree
    cmd = 'Vista',
    setup = function()
      vim.g['vista#renderer#enable_icon'] = 1
      vim.g['vista#renderer#icons'] = {
        ['func'] = '',
        ['function'] = '',
        ['functions'] = '',
        ['var'] = '',
        ['variable'] = '',
        ['variables'] = '',
        ['const'] = '',
        ['constant'] = '',
        ['constructor'] = '',
        ['method'] = 'ƒ',
        ['enum'] = '了',
        ['enummember'] = '',
        ['enumerator'] = '了',
        ['module'] = '',
        ['modules'] = '',
        ['class'] = '',
        ['struct'] = '',
        ['property'] = '',
        ['interface'] = 'ﰮ',
      }
      vim.g.vista_echo_cursor_strategy = 'floating_win'
      -- nvim_lsp support is now handled dynamically
      vim.g.vista_executive_for = {
        apiblueprint = 'markdown',
        markdown = 'toc',
        pandoc = 'markdown',
        rst = 'toc',
      }
      vim.g.vista_ctags_cmd = {
        -- Consider checking for commands before enabling them.
        go = 'gotags',
        rst = 'rst2ctags',
      }
    end
  }
  use { 'lewis6991/gitsigns.nvim', requires = 'plenary.nvim', config = function() require'gitsigns'.setup() end }
  use {
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger',
    keys = { {'n', '<leader>gm'} },
    config = function()
      vim.cmd [[autocmd init FileType gitmessengerpopup setlocal winblend=10]]
    end
  }
  use 'f-person/git-blame.nvim'
  use {
    'norcalli/nvim-colorizer.lua',
    -- Highlights color codes with the actual color
    ft = { 'css', 'kitty', 'less', 'lua', 'vim' },
    config = function() require'colorizer'.setup {
      'kitty',
      'less',
      css = { css = true },
      lua = { RGB = false, RRGGBB = true, names = false },
      vim = { RGB = false, RRGGBB = true, names = false },
    } end
  }
  use { 'meain/vim-package-info', ft = { 'json', 'requirements', 'toml' }, run = 'npm i' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    opt = true,
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' }
  }
  use {
    'vim-airline/vim-airline',
    --[[ Bottom & Tabline plugin

      This will be replaced at some point, but it'll take a while to do so.
      Some extensions have to be disabled to mitigate how it sets up lazy loading.

      Loading on VimEnter & using a 'setup' instead of a 'config' key seems to fix issues with Packer
    ]]
    requires = {
      'vim-airline/vim-airline-themes',
      { 'ryanoasis/vim-devicons', setup = function() vim.g.webdevicons_enable_nerdtree = 0 end },
    },
    opt = true,
    event = 'VimEnter *',
    setup = function()
      vim.g.airline_theme = 'quantum' -- Modified version is now integrated into dotfiles
      vim.g.airline_powerline_fonts = true
      vim.g.airline_detect_spelllang = false
      vim.g.airline_detect_crypt = false
      vim.g.airline_skip_empty_sections = 1
      vim.g.airline_symbols = {
        -- Stupid way to fix bad icon on my system
        dirty = ' ',
      }
      vim.g['airline#parts#ffenc#skip_expected_string'] = 'utf-8[unix]'
      vim.g['airline#extensions#vista#enabled'] = false -- Deals with Vista's lazy loader
      -- vim.g['airline#extensions#tabline#enabled'] = true -- Enable tabline
      vim.g['airline#extensions#nvimlsp#enabled'] = false
      vim.g.airline_filetype_overrides = {
        LuaTree = { 'LuaTree', '' },
        minimap = { 'Map', '' },
        tsplayground = { 'Tree-Sitter Playground', '' },
        vista = { 'Vista', '' },
        vista_kind = { 'Vista', '' },
        vista_markdown = { 'Vista', '' },
      }
    end
  }
  use {
    'romgrk/barbar.nvim',
    -- Tabline plugin
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local remap = vim.api.nvim_set_keymap
      remap('n', 'bb', [[<cmd>BufferPick<CR>]], {})
    end
  }
  use {
    'tjdevries/colorbuddy.nvim',
    -- Lua color scheme engine
    config = function() require('colorbuddy').colorscheme('user_colors') end
  }
  use {
    'DanilaMihailov/beacon.nvim',
    config = function()
      vim.g.beacon_ignore_filetypes = {
        'minimap',
        'tsplayground',
        'vista',
        'vista_kind',
        'vista_markdown',
      }
    end
  }

  -- Utilities
  use 'tpope/vim-fugitive'
  use 'farmergreg/vim-lastplace'
  use {
    'vimwiki/vimwiki',
    -- Note-taking engine
    event = 'BufNewFile,BufRead *.markdown,*.mdown,*.mdwn,*.wiki,*.mkdn,*.mw,*.md',
    cmd = {
      'VimwikiIndex',
      'VimwikiTabIndex',
      'VimwikiDiaryIndex',
      'VimwikiMakeDiaryNote',
      'VimwikiTabMakeDiaryNote',
    },
    keys = {
      {'n', '<leader>ww'},
      {'n', '<leader>wt'},
      {'n', '<leader>wi'},
      {'n', '<leader>w<leader>w'},
      {'n', '<leader>w<leader>t'},
      {'n', '<leader>w<leader>y'},
      {'n', '<leader>w<leader>m'},
    },
    setup = function()
      vim.g.vimwiki_list = {
        {
          path = '~/Documents/VimWiki',
          nested_syntaxes = {
            ['c++'] = 'cpp',
          }
        }
      }
      vim.g.vimwiki_folding = 'expr'
      vim.g.vimwiki_listsyms = '✗○◐●✓'
      vim.g.vimwiki_global_ext = 0
    end
  }
  use {
    'oberblastmeister/neuron.nvim',
    --[[ Neuron-based note-taking engine

      This will probably replace vimwiki at some point.
    ]]
    requires = { 'plenary.nvim', 'telescope.nvim' },
    opt = true,
    keys = { {'n', 'gzi'} },
    config = function() require'neuron'.setup {
      virtual_titles = true,
      mappings = true,
      run = nil,
      neuron_dir = '~/Documents/Neuron',
      leader = 'gz',
    } end
  }
  use {
    'hkupty/iron.nvim',
    cmd = { 'IronRepl', 'IronSend', 'IronReplHere', 'IronWatchCurrentFile' },
    keys = { {'n', 'ctr'}, {'v', 'ctr'}, {'n', '<localleader>sl'} },
    config = function()
      local iron = require('iron')

      -- Add extra REPLs
      iron.core.add_repl_definitions {
        fennel = { fennel = { command = { 'fennel', '--repl' }}},
        fish = { fish = { command = { 'fish' }}},
        gluon = { gluon = { command = { 'gluon', '-i' }}},
        lua = { croissant = { command = { 'croissant' }}},
      }

      iron.core.set_config {
        preferred = {
          fennel = 'fennel',
          fish = 'fish',
          gluon = 'gluon',
          javascript = 'node',
          lua = 'croissant',
          python = 'ipython',
          sh = 'bash',
          zsh = 'zsh',
        },
      }
    end
  }
  use { 'lukas-reineke/format.nvim', config = function() require'user.cfg.format-nvim' end }
  use { 'HiPhish/awk-ward.nvim', cmd = 'AwkWard' } -- Mirror
  use 'jbyuki/monolithic.nvim'

  -- Integration
  use {
    'editorconfig/editorconfig-vim',
    -- Editorconfig support
    config = function()
      vim.g.EditorConfig_exclude_patterns = {
        [[fugitive://.\*]],
        [[output://.\*]],
        [[scp://.\*]],
        [[term://.\*]],
        [[octo://.\*]],
      }
    end
  }
  use {
    'HiPhish/info.vim', -- mirror
    event = 'BufReadCmd info:*',
    cmd = 'Info',
    ft = 'info',
  }

  -- Text editing
  use 'tpope/vim-repeat'
  -- use 'tpope/vim-endwise'
  use {
    'phaazon/hop.nvim',
    -- EasyMotion replacement
    -- This will eventually be lazy loaded but currently that would require too much maintainence
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>hw', [[<cmd>lua require'hop'.hint_words()<cr>]], {})
    end
  }
  use { 'windwp/nvim-autopairs', opt = true, config = function() require'nvim-autopairs'.setup() end }
  use {
    'Raimondi/delimitMate',
    opt = false,
    config = function()
      vim.g.delimitMate_tab2exit = 0
    end
  }
  use {
    'tpope/vim-abolish',
    cmd = { 'Abolish', 'Subvert', 'S' },
    keys = {{'n', 'cr'}},
    setup = function()
      vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end
  }
  use {
    'tpope/vim-commentary',
    -- This will be replaced by b3nj5m1n/kommentary when it's more complete
    cmd = 'Commentary',
    keys = { 'gc', {'n', 'gcc'}, {'n', 'gcu'} },
  }
  use {
    'tpope/vim-surround',
    -- This will be replaced by blackCauldron7/surround.nvim eventually
    keys = {
      {'n', 'ds'},
      {'n', 'cs'},
      {'n', 'cS'},
      {'n', 'ys'},
      {'n', 'yS'},
      {'n', 'yss'},
      {'n', 'ySs'},
      {'n', 'ySS'},
      {'x', 'S'},
      {'x', 'gS'},
      {'i', '<C-S>'},
      {'i', '<C-G>s'},
      {'i', '<C-G>S'},
    }
  }
  use {
    'monaqa/dial.nvim',
    -- Replaces speeddating
    requires = 'astronauta.nvim',
    opt = true,
    keys = { '<C-a>', '<C-x>', {'v', 'g<C-a>'}, {'v', 'g<C-x>'} },
    config = function()
      local dial = require('dial')
      dial.augends.boolean = dial.augends.common.enum_cyclic {
        name = 'boolean',
        desc = 'Flip a boolean between true and false',
        strlist = {'true', 'false'},
      }
      table.insert(dial.searchlist.normal, dial.augends.boolean)

      vim.keymap.nmap { '<C-a>', '<Plug>(dial-increment)' }
      vim.keymap.nmap { '<C-x>', '<Plug>(dial-decrement)' }
      vim.keymap.vmap { '<C-a>', '<Plug>(dial-increment)' }
      vim.keymap.vmap { '<C-x>', '<Plug>(dial-decrement)' }
      vim.keymap.vmap { 'g<C-a>', '<Plug>(dial-increment-additional)' }
      vim.keymap.vmap { 'g<C-x>', '<Plug>(dial-decrement-additional)' }
    end
  }
  use {
    'AndrewRadev/splitjoin.vim',
    cmd = { 'SplitjoinSplit', 'SplitjoinJoin' },
    keys = { {'n', 'gJ'}, {'n', 'gS'} },
  }
  use {
    'junegunn/vim-easy-align',
    requires = 'astronauta.nvim',
    opt = true,
    cmd = { 'EasyAlign', 'LiveEasyAlign' },
    keys = { {'x', 'ga'}, {'n', 'ga'} },
    config = function()
      vim.keymap.xmap { 'ga', '<Plug>(LiveEasyAlign)' }
      vim.keymap.nmap { 'ga', '<Plug>(EasyAlign)' }
    end
  }
end)

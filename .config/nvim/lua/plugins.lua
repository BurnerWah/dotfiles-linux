-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use, use_rocks)
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Core plugins
  use 'tjdevries/astronauta.nvim'
  use {'nvim-lua/plenary.nvim', config = 'require("plenary.filetype").add_file("user")'}
  use_rocks {'stdlib'} -- Penlight is installed elsewhere
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        override = {
          ['Gemfile'] = {icon = '', color = '#701516', name = 'Gemfile'},
          ['Vagrantfile'] = {icon = '', color = '#1563ff', name = 'Vagrantfile'},
          ['BSDmakefile'] = {icon = '', color = '#6d8086', name = 'Makefile'},
          ['GNUmakefile'] = {icon = '', color = '#6d8086', name = 'Makefile'},
          ['sublime-syntax'] = {icon = '', color = '#ff9800', name = 'SublimeSyntax'},
          ['ron'] = {icon = '', color = '#6d8086', name = 'Ron'},
          ['.luacheckrc'] = {icon = '', color = '#51a0cf', name = 'Lua'},
          ['.busted'] = {icon = '', color = '#51a0cf', name = 'Lua'},
          ['.luacov'] = {icon = '', color = '#51a0cf', name = 'Lua'},
          ['rockspec'] = {icon = '', color = '#51a0cf', name = 'Lua'},
        },
      }
    end,
  }

  -- Completion & Linting
  use {'neovim/nvim-lspconfig', config = 'require("user.cfg.lspsettings")'}
  use {
    'glepnir/lspsaga.nvim',
    requires = 'nvim-lspconfig',
    config = function()
      require('lspsaga').init_lsp_saga {
        error_sign = '',
        warn_sign = '',
        hint_sign = '',
        infor_sign = '',
        code_action_prompt = {virtual_text = false},
        finder_action_keys = {
          open = 'o',
          vsplit = 's',
          split = 'i',
          quit = {'q', '<Esc>'},
          scroll_down = '<C-f>',
          scroll_up = '<C-b>',
        },
        code_action_keys = {quit = {'q', '<Esc>'}, exec = '<CR>'},
        rename_action_keys = {quit = {'<C-c>', '<Esc>'}, exec = '<CR>'},
        border_style = 2, -- Rounded border
      }
      local remap = vim.api.nvim_set_keymap
      local opts = {noremap = true, silent = true}
      remap('n', '<A-d>', [[<Cmd>Lspsaga open_floaterm fish<CR>]], opts)
      remap('t', '<A-d>', [[<C-\><C-n><Cmd>Lspsaga close_floaterm<CR>]], opts)
    end,
  }
  use {'nvim-lua/lsp-status.nvim', requires = 'nvim-lspconfig'}
  use {'RishabhRD/nvim-lsputils', requires = {'nvim-lspconfig', 'RishabhRD/popfix'}}
  use {'jubnzv/virtual-types.nvim', requires = 'nvim-lspconfig', cmd = 'EnableVirtualTypes'}
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
    -- nvim-treesitter-textobjects can be added once #8 & #27 are fixed
    -- nvim-ts-rainbow can be added once #5 is fixed (which requires nvim-treesitter#879 merged)
    requires = {
      {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
      {'nvim-treesitter/playground', after = 'nvim-treesitter', as = 'nvim-treesitter-playground'},
      {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'},
      {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'},
    },
    run = ':TSUpdate',
    config = 'require("plugins.treesitter")',
  }
  use {'dense-analysis/ale', cmd = 'ALEEnable', config = 'require("plugins.ale")'}
  use {
    'hrsh7th/vim-vsnip',
    opt = false,
    requires = {'nvim-lspconfig', 'hrsh7th/vim-vsnip-integ'},
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'
      local remap = vim.api.nvim_set_keymap
      -- Expand
      remap('i', '<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], {expr = true})
      remap('s', '<C-j>', [[vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>']], {expr = true})
      -- Expand or jump
      remap('i', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
            {expr = true})
      remap('s', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
            {expr = true})
    end,
  }
  use {
    'hrsh7th/nvim-compe',
    requires = {
      {'tzachar/compe-tabnine', run = 'bash install.sh'}, 'vim-vsnip', 'nvim-lspconfig',
      'nvim-treesitter',
    },
    config = function()
      vim.o.completeopt = 'menuone,noselect'
      require('compe').register_source('fish', require('compe_fish')) -- custom source
      require('compe').setup {
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
          snippets_nvim = false,
          nvim_lsp = true, -- Priority: 1000
          nvim_lua = true,
          spell = true,
          tags = true,
          tabnine = {
            ignored_filetypes = {
              'alsaconf', 'crontab', 'dircolors', 'dnsmasq', 'dosini', 'fstab', 'group', 'grub',
              'hostconf', 'hostsaccess', 'inittab', 'limits', 'logindefs', 'mailcap', 'markdown',
              'modconf', 'pamconf', 'passwd', 'pinfo', 'protocols', 'ptcap', 'resolv', 'rst',
              'services', 'sshconfig', 'sshdconfig', 'sudoers', 'sysctl', 'udevconf', 'udevperm',
              'updatedb', 'vimwiki', 'wget',
            },
            priority = 900, -- defaults to 5000 which can be problematic
            dup = 0, -- allow duplicate entries (mostly with lsp)
          },
          treesitter = true,
          omni = {filetypes = {'clojure', 'debchangelog', 'mf', 'mp', 'vimwiki'}},
          fish = true,
        },
      }
      local remap = vim.api.nvim_set_keymap
      local opts = {noremap = true, silent = true, expr = true}
      remap('i', '<C-Space>', [[compe#complete()]], opts)
      remap('i', '<C-e>', [[compe#close('<C-e>')]], opts)
      remap('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], opts)
      remap('i', '<C-d>', [[compe#scroll({ 'delta': -4 })]], opts)
    end,
  }

  -- Filetypes
  use 'leafo/moonscript-vim'
  use {'rhysd/vim-llvm', ft = {'llvm', 'mlir'}}
  use 'ron-rs/ron.vim'
  use {'bakpakin/fennel.vim', ft = 'fennel'}
  use 'aklt/plantuml-syntax'
  use {'tikhomirov/vim-glsl', ft = {'glsl', 'elm'}}
  use {'udalov/kotlin-vim', ft = 'kotlin'}
  use {'YaBoiBurner/requirements.txt.vim', ft = 'requirements'}
  use 'teal-language/vim-teal' -- Locally patched ti fix some issues.
  use {'blankname/vim-fish', ft = 'fish'}
  -- Meson syntax is now manually maintained
  -- vim-orgmode is really weird
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
  use {'stsewd/sphinx.nvim', ft = 'rst'}

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim', 'plenary.nvim', 'nvim-web-devicons', 'nvim-treesitter',

      -- Telescope plugins
      'nvim-telescope/telescope-fzy-native.nvim', 'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim', 'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-project.nvim', 'nvim-telescope/telescope-node-modules.nvim',
      'nvim-telescope/telescope-media-files.nvim',

      {'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sql.nvim'},
      {'nvim-telescope/telescope-cheat.nvim', requires = 'tami5/sql.nvim'},
    },
    config = function()
      local telescope = require('telescope')
      local E = vim.env
      telescope.setup {
        defaults = {winblend = 10, file_sorter = require('telescope.sorters').get_fzy_sorter},
        extensions = {
          frecency = {
            show_scores = true,
            ignore_patterns = {'*.git/*', '*/tmp/*', E.XDG_CACHE_HOME or (E.HOME .. '/.cache')},
            workspaces = {
              conf = E.XDG_CONFIG_HOME or (E.HOME .. '/.config'),
              data = E.XDG_DATA_HOME or (E.HOME .. '/.local/share'),
              project = E.HOME .. '/Projects',
            },
          },
          fzf_writer = {use_highlighter = true},
        },
      }
      tablex.foreachi({
        'fzy_native', 'fzf_writer', 'gh', 'project', 'node_modules', 'frecency', 'cheat',
        'media_files',
      }, telescope.load_extension)

      local remap = vim.api.nvim_set_keymap
      local opts = {silent = true, noremap = true}

      remap('n', '<Leader>ff', [[<Cmd>Telescope find_files<CR>]], opts)
      remap('n', '<Leader>fg', [[<Cmd>Telescope live_grep<CR>]], opts)
      remap('n', '<Leader>fb', [[<Cmd>Telescope buffers<CR>]], opts)
      remap('n', '<Leader>fh', [[<Cmd>Telescope help_tags<CR>]], opts)
      remap('n', '<Leader><Leader>', [[<Cmd>Telescope frequency<CR>]], opts)
      remap('n', '<C-p>', [[<Cmd>Telescope project<CR>]], opts)
    end,
  }
  use {'pwntester/octo.nvim', requires = 'telescope.nvim', opt = true, cmd = 'Octo'}

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
      -- Consider checking for commands before enabling them.
      vim.g.vista_ctags_cmd = {go = 'gotags', rst = 'rst2ctags'}
    end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'plenary.nvim',
    -- if this loads before my colorscheme it will look terrible.
    after = 'colorbuddy.nvim',
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
  use {'meain/vim-package-info', ft = {'json', 'requirements', 'toml'}, run = 'npm i'}
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'nvim-web-devicons',
    opt = true,
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
      vim.api.nvim_set_keymap('n', 'bb', [[<Cmd>BufferLinePick<CR>]], {})
    end,
  }
  use {'tjdevries/colorbuddy.nvim', config = 'require("colorbuddy").colorscheme("quantumbuddy")'}
  use {
    'DanilaMihailov/beacon.nvim',
    config = function()
      vim.g.beacon_ignore_filetypes = {
        'minimap', 'tsplayground', 'vista', 'vista_kind', 'vista_markdown',
      }
    end,
  }
  use {
    'tkmpypy/chowcho.nvim',
    cmd = 'Chowcho',
    config = function() require('chowcho').setup {border_style = 'rounded'} end,
  }
  use {'yamatsum/nvim-cursorline', config = 'require("plugins.nvim-cursorline").config()'}
  use {'alec-gibson/nvim-tetris', cmd = 'Tetris'}
  use {
    'dstein64/nvim-scrollview',
    config = function() vim.g.scrollview_nvim_14040_workaround = true end,
  }
  use {
    'dm1try/golden_size',
    config = function()
      local function ignore_by_buftype(types)
        local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
        for _, type in pairs(types) do if type == buftype then return 1 end end
      end
      local golden_size = require('golden_size')
      -- set the callbacks, preserve the defaults
      golden_size.set_ignore_callbacks {
        {ignore_by_buftype, {'nerdtree', 'quickfix', 'terminal'}},
        {golden_size.ignore_float_windows}, -- default one, ignore float windows
        {golden_size.ignore_by_window_flag}, -- default one, ignore windows with w:ignore_gold_size=1
      }
    end,
  }
  use {
    'kevinhwang91/nvim-hlslens',
    keys = {{'n', 'n'}, {'n', 'N'}, {'n', '*'}, {'n', '#'}, {'n', 'g*'}, {'n', 'g#'}},
    config = 'require("plugins.nvim-hlslens")',
  }

  -- Utilities
  use 'tpope/vim-fugitive'
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
    opt = true,
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
    config = function()
      local iron = require('iron')

      -- Add extra REPLs
      iron.core.add_repl_definitions {
        fennel = {fennel = {command = {'fennel', '--repl'}}},
        fish = {fish = {command = {'fish'}}},
        gluon = {gluon = {command = {'gluon', '-i'}}},
        lua = {croissant = {command = {'croissant'}}},
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
    end,
  }
  use {'lukas-reineke/format.nvim', config = 'require("plugins.format-nvim")'}
  use {'HiPhish/awk-ward.nvim', cmd = 'AwkWard'} -- Mirror
  use {'gennaro-tedesco/nvim-jqx', cmd = {'JqxList', 'JqxQuery'}}
  use {'gennaro-tedesco/nvim-peekup', keys = {{'n', [[""]]}}}
  use {
    'rcarriga/vim-ultest',
    requires = 'vim-test/vim-test',
    opt = true,
    cmd = {'Ultest', 'UltestNearest'},
  }

  -- Integration
  use {
    'editorconfig/editorconfig-vim',
    -- Editorconfig support
    config = function()
      vim.g.EditorConfig_exclude_patterns = {
        'davs\\?://.*', 'ftp://.*', 'fugitive://.*', 'https\\?://.*', 'info://.*', 'man://.*',
        'octo://.*', 'output://.*', 'rcp://.*', 'rsync://.*', 'scp://.*', 'sftp://.*', 'term://.*',
      }
    end,
  }
  use {'HiPhish/info.vim', event = 'BufReadCmd info:*', cmd = 'Info', ft = 'info'} -- mirror
  use {'kdheepak/lazygit.nvim', cmd = 'LazyGit'}
  use {'segeljakt/vim-silicon', cmd = 'Silicon'}
  -- use {'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end}
  -- Spell support for tree-sitter is nice but it causes files to noticably refresh constantly.
  -- It also might be contributing to PID bloat by running hunspell too often.
  -- It's a WIP so some problems can be expected.

  -- Text editing
  use 'tpope/vim-repeat'
  use {
    'phaazon/hop.nvim',
    -- EasyMotion replacement
    -- This will eventually be lazy loaded but currently that requires too much maintainence
    --
    -- GitHub Issues:
    -- - #3: (flaw) A lot of hints require 3 keystrokes
    -- - #4: (feat) Quick-scope mode
    -- - #8: (feat) Unable to use other keys like h,j,k,l to cancel hints
    -- - #15: (bug) Incorrect hints position for lines that has tabs in help buffer
    -- - #17: (bug) Incorrect hop window position for floating window
    -- - #19: (feat) Allow to set configuration with a setup function
    config = function()
      local remap = vim.api.nvim_set_keymap
      remap('n', '<Leader>hw', [[<Cmd>lua require'hop'.hint_words()<CR>]], {})
      remap('n', '<Leader>hp', [[<Cmd>lua require'hop'.hint_patterns()<CR>]], {})
      remap('n', '<Leader>hc', [[<Cmd>lua require'hop'.hint_char1()<CR>]], {})
      remap('n', '<Leader>hC', [[<Cmd>lua require'hop'.hint_char2()<CR>]], {})
      remap('n', '<Leader>hl', [[<Cmd>lua require'hop'.hint_lines()<CR>]], {})
    end,
  }
  use {'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end}
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
    config = function()
      local dial = require('dial')
      local nnor, vmap = vim.keymap.nnoremap, vim.keymap.vmap

      -- Boolean flipping
      dial.augends['custom#boolean'] = dial.common.enum_cyclic {
        name = 'boolean',
        desc = 'Flip a boolean between true and false',
        strlist = {'true', 'false'},
      }
      table.insert(dial.config.searchlist.normal, 'custom#boolean')

      -- Keymaps - We add repeat support to this
      nnor {
        '<C-a>', function()
          dial.cmd.increment_normal(vim.v.count1)
          pcall(vim.cmd, [[silent! call repeat#set("\<C-a>", v:count)]])
        end,
      }
      nnor {
        '<C-x>', function()
          dial.cmd.increment_normal(-vim.v.count1)
          pcall(vim.cmd, [[silent! call repeat#set("\<C-x>", v:count)]])
        end,
      }
      -- vim.keymap.nmap {'<C-a>', '<Plug>(dial-increment)'}
      -- vim.keymap.nmap {'<C-x>', '<Plug>(dial-decrement)'}
      vmap {'<C-a>', '<Plug>(dial-increment)'}
      vmap {'<C-x>', '<Plug>(dial-decrement)'}
      vmap {'g<C-a>', '<Plug>(dial-increment-additional)'}
      vmap {'g<C-x>', '<Plug>(dial-decrement-additional)'}
    end,
  }
  use {
    'AndrewRadev/splitjoin.vim',
    cmd = {'SplitjoinSplit', 'SplitjoinJoin'},
    keys = {{'n', 'gJ'}, {'n', 'gS'}},
  }
  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign', 'LiveEasyAlign'},
    keys = {{'n', 'ga'}, {'v', 'ga'}},
    config = function()
      vim.keymap.vmap {'ga', '<Plug>(LiveEasyAlign)', silent = true}
      vim.keymap.nmap {'ga', '<Plug>(EasyAlign)', silent = true}
    end,
  }
  use {
    'dkarter/bullets.vim',
    ft = {'markdown', 'gitcommit'},
    setup = function() vim.g.bullets_enabled_file_types = {'markdown', 'gitcommit'} end,
  }
end)

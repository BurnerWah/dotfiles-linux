-- This file can be loaded by calling `require('plugins')` from your init.lua
return require('packer').startup({
  function(use, use_rocks)
    -- macros
    local _M = {
      cfg = function(name) return 'require("plugins.' .. name .. '")' end,
      telescope_load = function(ext)
        return 'require("telescope").load_extension("' .. ext .. '")'
      end,
      telescope_seqence = function(slug, ext, opts)
        if not slug:find('/') then slug = 'nvim-telescope/' .. slug end
        opts = opts or {}
        return {
          slug,
          after = 'telescope.nvim',
          config = 'require("telescope").load_extension("' .. ext .. '")',
          requires = opts.requires,
          rocks = opts.rocks,
        }
      end,
      telescope_nosequence = function(slug, ext, opts)
        if not slug:find('/') then slug = 'nvim-telescope/' .. slug end
        opts = opts or {}
        return {
          slug,
          event = 'VimEnter *',
          config = 'require("telescope").load_extension("' .. ext .. '")',
          requires = opts.requires,
          rocks = opts.rocks,
        }
      end,
    }

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Core plugins
    use_rocks {
      'compat53', -- Lua 5.3-like libraries
      'penlight', -- Python-like libraries, functions, classes, etc.
      'fun', -- Functional programming for LuaJIT
      'stdlib', -- Enhanced standard library
    }
    use 'tjdevries/astronauta.nvim'
    use {'nvim-lua/plenary.nvim', config = 'require("plenary.filetype").add_file("user")'}
    use {'kyazdani42/nvim-web-devicons', config = _M.cfg('nvim-web-devicons')}
    use {
      'mortepau/codicons.nvim',
      config = function()
        require('codicons').setup()
        local ext = require('codicons.extensions').available()
        require(ext.CompletionItemKind).set()
      end,
    }

    -- Completion & Linting
    use {'neovim/nvim-lspconfig', config = _M.cfg('lspsettings')}
    use {'tamago324/nlsp-settings.nvim', requires = 'nvim-lspconfig'}
    use {
      'glepnir/lspsaga.nvim',
      requires = {'nvim-lspconfig', 'codicons.nvim'},
      config = _M.cfg('lspsaga'),
    }
    use {'nvim-lua/lsp-status.nvim', requires = 'nvim-lspconfig'}
    use {'RishabhRD/nvim-lsputils', requires = {'nvim-lspconfig', 'RishabhRD/popfix'}}
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
        {'nvim-treesitter/nvim-tree-docs', after = 'nvim-treesitter', requires = 'Olical/aniseed'},
        {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'},
        {'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter'},
      },
      run = ':TSUpdate',
      config = _M.cfg('treesitter'),
    }
    use {'dense-analysis/ale', cmd = 'ALEEnable', config = _M.cfg('ale')}
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
        imap {
          '<C-l>',
          [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
          expr = true,
        }
        smap {
          '<C-l>',
          [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']],
          expr = true,
        }
      end,
    }
    use {
      'hrsh7th/nvim-compe',
      requires = {
        {'tzachar/compe-tabnine', run = 'bash install.sh'}, 'vim-vsnip', 'nvim-lspconfig',
        'nvim-treesitter',
      },
      config = _M.cfg('nvim-compe'),
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim', 'plenary.nvim', 'nvim-web-devicons', 'nvim-treesitter',

        -- Telescope plugins
        -- Don't use telescope project
        'nvim-telescope/telescope-symbols.nvim', {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make CC=clang',
          config = _M.telescope_load('fzf'),
        }, _M.telescope_seqence('telescope-fzy-native.nvim', 'fzy_native'),
        _M.telescope_seqence('telescope-fzf-writer.nvim', 'fzf_writer'),
        _M.telescope_nosequence('telescope-github.nvim', 'gh'),
        _M.telescope_nosequence('telescope-node-modules.nvim', 'node_modules'),
        _M.telescope_nosequence('telescope-media-files.nvim', 'media_files'),
        _M.telescope_nosequence('tamago324/telescope-sonictemplate.nvim', 'sonictemplate'),
        _M.telescope_nosequence('dhruvmanila/telescope-bookmarks.nvim', 'bookmarks'),
        _M.telescope_nosequence('telescope-frecency.nvim', 'frecency', {requires = 'tami5/sql.nvim'}),
        _M.telescope_nosequence('telescope-cheat.nvim', 'cheat', {requires = 'tami5/sql.nvim'}),
        _M.telescope_nosequence('telescope-arecibo.nvim', 'arecibo', {
          requires = 'nvim-treesitter',
          rocks = {'openssl', 'lua-http-parser'},
        }),
      },
      config = _M.cfg('telescope'),
    }
    use {
      'pwntester/octo.nvim',
      -- Lazy loading isn't very helpful for this since the command completions are too useful
      -- I could experiment with a custom loader but not right now.
      requires = {'telescope.nvim', 'plenary.nvim'},
      after = 'telescope.nvim',
      config = _M.telescope_load('octo'),
    }

    -- User interface
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
    use {
      'meain/vim-package-info',
      requires = 'codicons.nvim',
      run = 'npm i',
      config = function()
        vim.g.vim_package_info_virutaltext_prefix =
            '  ' .. require('codicons').get('versions') .. ' '
      end,
    } -- rplugin lazy loads
    use {
      'glepnir/galaxyline.nvim',
      requires = {'nvim-web-devicons', 'codicons.nvim'},
      config = 'require("user.statusline")',
    }
    use {
      'akinsho/nvim-bufferline.lua',
      -- Tabline plugin
      -- Issues:
      -- - #14: (feat) Show only buffer in current tab?
      requires = {'nvim-web-devicons', 'codicons.nvim'},
      config = function()
        local codicons = require('codicons')
        require('bufferline').setup {
          options = {
            buffer_close_icon = codicons.get('close'),
            close_icon = codicons.get('close-all'),
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
      config = function()
        require('chowcho').setup {icon_enabled = true, border_style = 'rounded'}
      end,
    }
    use {'yamatsum/nvim-cursorline', config = 'require("plugins.nvim-cursorline").config()'}
    use {'alec-gibson/nvim-tetris', cmd = 'Tetris'}
    use {'dstein64/nvim-scrollview', config = 'vim.g.scrollview_nvim_14040_workaround = true'}
    use {'kevinhwang91/nvim-hlslens', config = _M.cfg('nvim-hlslens')}
    use {'lukas-reineke/indent-blankline.nvim', branch = 'lua', config = _M.cfg('indent-blankline')}
    use 'karb94/neoscroll.nvim' -- Smooth scrolling
    use {
      'edluffy/specs.nvim',
      config = function()
        require('specs').setup {popup = {fader = require('specs').pulse_fader}}
      end,
    }
    -- use {'sunjon/shade.nvim', config = function() require('shade').setup() end}
    -- Turned off because it breaks some random highlights (how?)

    -- Utilities
    use {'tpope/vim-fugitive', config = 'vim.g.fugitive_legacy_commands = false'}
    use {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = {{'n', '<Leader>gy'}, {'v', '<Leader>gy'}},
      config = function() require('gitlinker').setup() end,
    }
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
      config = _M.cfg('iron'),
    }
    use {'mhartington/formatter.nvim', config = _M.cfg('formatter')}
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
    use {
      'kdav5758/TrueZen.nvim',
      opt = true,
      cmd = {'TZAtaraxis', 'TZMinimalist', 'TZBottom', 'TZTop', 'TZLeft'},
      config = function() require('true-zen').setup {cursor_by_mode = true} end,
    }
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
    use {'liuchengxu/vista.vim', cmd = 'Vista', setup = _M.cfg('vista')} -- TOC & symbol tree
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'nvim-web-devicons',
      cmd = {'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile'},
    }
    use {
      'folke/lsp-trouble.nvim',
      requires = {'nvim-lspconfig', 'codicons.nvim'},
      cmd = {
        'LspTroubleOpen', 'LspTroubleWorkspaceOpen', 'LspTroubleDocumentOpen', 'LspTroubleToggle',
        'LspTroubleWorkspaceToggle', 'LspTroubleDocumentToggle',
      },
      config = function()
        local codicons = require('codicons')
        require('trouble').setup {
          fold_open = codicons.get('fold-down'),
          fold_closed = codicons.get('fold-up'),
          signs = {
            error = codicons.get('error'),
            warning = codicons.get('warning'),
            hint = codicons.get('question'),
            information = codicons.get('info'),
          },
        }
      end,
    }
    use {
      'simrat39/symbols-outline.nvim',
      requires = {'nvim-lspconfig', 'codicons.nvim'},
      cmd = 'SymbolsOutline',
      config = function()
        require('symbols-outline').setup()
        local codicons = require('codicons')
        local symbols = require('symbols-outline.symbols')
        tablex.foreach({
          File = 'symbol-file',
          Namespace = 'symbol-namespace',
          Class = 'symbol-class',
          Method = 'symbol-method',
          Property = 'symbol-property',
          Field = 'symbol-field',
          Enum = 'symbol-enum',
          Interface = 'symbol-interface',
          Variable = 'symbol-variable',
          Constant = 'symbol-constant',
          String = 'symbol-string',
          Number = 'symbol-numeric',
          Boolean = 'symbol-boolean',
          Array = 'symbol-array',
          EnumMember = 'symbol-enum-member',
          Struct = 'symbol-structure',
          Event = 'symbol-event',
          Operator = 'symbol-operator',
        }, function(val, key) symbols[key].icon = codicons.get(val) end)
      end,
    }
    use {
      'michaelb/sniprun',
      cmd = {'SnipRun', 'SnipInfo'},
      keys = {'<Plug>SnipRun', '<Plug>SnipRunOperator', '<Plug>SnipInfo'},
      run = 'bash ./install.sh',
      config = function()
        require('sniprun').initial_setup {
          interpreter_options = {
            C_original = {compiler = 'clang'},
            Cpp_original = {compiler = 'clang++ --debug'},
          },
        }
      end,
    }

    -- Filetypes & language features
    -- Some of this stuff isn't managed by packer.
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
    use 'thyrgle/vim-dyon'
    use 'bytecodealliance/cranelift.vim'
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
    use {'iamcco/markdown-preview.nvim', run = 'cd app && pnpm install', ft = 'markdown'}

    -- RST
    use {'stsewd/sphinx.nvim', ft = 'rst'} -- rplugin skipped because it's not useful for me

    -- Rust
    use {
      'simrat39/rust-tools.nvim',
      -- Lazy-loading seems to conflict with nlsp-settings.nvim
      -- ft = 'rust',
      -- opt = true,
      requires = {'nvim-lspconfig', 'nvim-lua/popup.nvim', 'plenary.nvim', 'telescope.nvim'},
      config = function() require('rust-tools').setup() end,
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
          'octo://.*', 'output://.*', 'rcp://.*', 'rsync://.*', 'scp://.*', 'sftp://.*',
          'term://.*',
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
    use {
      'windwp/nvim-autopairs',
      config = function()
        -- local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')
        npairs.setup {
          check_ts = true,
          ts_config = {lua = {'string'}, javascript = {'template_string'}},
        }
      end,
    }
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
      config = _M.cfg('dial'),
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
  end,
  config = {max_jobs = #vim.loop.cpu_info()},
})

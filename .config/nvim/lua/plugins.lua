-- This file can be loaded by calling `require('plugins')` from your init.lua
return require('packer').startup({
  ---@param use fun(opts: table)
  ---@param use_rocks fun(rocks: string|string[])
  function(use, use_rocks)
    -- local use = WRAP(use)
    -- macros
    local _M = {}
    function _M.cfg(name) return 'require("plugins.' .. name .. '")' end
    _M.telescope = {}
    function _M.telescope.load(ext) return 'require("telescope").load_extension("' .. ext .. '")' end
    function _M.telescope._construct(override, slug, ext, opts)
      if not slug:find('/') then slug = 'nvim-telescope/' .. slug end
      opts = vim.tbl_extend('force', opts or {}, override)
      return {
        slug,
        config = _M.telescope.load(ext),
        after = opts.after,
        event = opts.event,
        requires = opts.requires,
        rocks = opts.rocks,
        run = opts.run,
      }
    end
    function _M.telescope:immedeate(...) return self._construct({}, ...) end
    function _M.telescope:sequence(...) return self._construct({after = 'telescope.nvim'}, ...) end
    function _M.telescope:nosequence(...) return self._construct({event = 'VimEnter *'}, ...) end

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
    use {
      'nvim-lua/plenary.nvim',
      config = function() require('plenary.filetype').add_file('user') end,
    }
    use 'iamcco/async-await.lua'
    use 'norcalli/profiler.nvim'
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
    use {
      'neovim/nvim-lspconfig',
      requires = {'tamago324/nlsp-settings.nvim'},
      config = _M.cfg('lspsettings'),
    }
    use {
      'glepnir/lspsaga.nvim',
      requires = {'nvim-lspconfig', 'codicons.nvim'},
      config = _M.cfg('lspsaga'),
    }
    use {
      'nvim-lua/lsp-status.nvim',
      requires = 'nvim-lspconfig',
      config = function()
        local status = require('lsp-status')
        status.register_progress()
        status.config({
          indicator_errors = '',
          indicator_warnings = '',
          indicator_info = '',
          indicator_hint = '',
          select_symbol = function(cursor_pos, symbol)
            if symbol.valueRange then
              local value_range = {
                ['start'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
                ['end'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])},
              }
              return require('lsp-status.util').in_range(cursor_pos, value_range)
            end
          end,
          current_function = true,
        })
      end,
    }
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
        'nvim-telescope/telescope-symbols.nvim',
        _M.telescope:immedeate('telescope-fzf-native.nvim', 'fzf', {run = 'make CC=clang'}),
        _M.telescope:sequence('telescope-fzy-native.nvim', 'fzy_native'),
        _M.telescope:sequence('telescope-fzf-writer.nvim', 'fzf_writer'),
        _M.telescope:nosequence('telescope-github.nvim', 'gh'),
        _M.telescope:nosequence('telescope-node-modules.nvim', 'node_modules'),
        _M.telescope:nosequence('telescope-media-files.nvim', 'media_files'),
        _M.telescope:nosequence('tamago324/telescope-sonictemplate.nvim', 'sonictemplate'),
        _M.telescope:nosequence('dhruvmanila/telescope-bookmarks.nvim', 'bookmarks'),
        _M.telescope:nosequence('telescope-frecency.nvim', 'frecency', {requires = 'tami5/sql.nvim'}),
        _M.telescope:nosequence('telescope-cheat.nvim', 'cheat', {requires = 'tami5/sql.nvim'}),
        _M.telescope:nosequence('telescope-arecibo.nvim', 'arecibo', {
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
      config = _M.telescope.load('octo'),
    }

    -- User interface
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'plenary.nvim',
      -- after = 'colorbuddy.nvim', -- Load after theme so it looks better
      config = function() require('gitsigns').setup({current_line_blame = true}) end,
    }
    use {
      'rhysd/git-messenger.vim',
      cmd = 'GitMessenger',
      keys = '<Plug>(git-messenger)',
      setup = function()
        vim.g.git_messenger_no_default_mappings = true
        vim.keymap.nmap {'<Leader>gm', '<Plug>(git-messenger)'}
      end,
    }
    use {
      'norcalli/nvim-colorizer.lua',
      -- Highlights color codes with the actual color
      ft = {'css', 'kitty', 'less', 'lua', 'vim'},
      cmd = 'ColorizerToggle',
      config = function()
        require('colorizer').setup({
          'kitty',
          'less',
          css = {css = true},
          lua = {RGB = false, RRGGBB = true, names = false},
          vim = {RGB = false, RRGGBB = true, names = false},
        })
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
      opt = true,
      config = 'require("user.statusline")',
    }
    use {
      'hoob3rt/lualine.nvim',
      requires = {'arkav/lualine-lsp-progress'},
      config = function()
        require('lualine').setup({
          options = {theme = 'tokyonight', sections = {lualine_c = {'filename', 'lsp_progress'}}},
        })
      end,
    }
    use {
      'lewis6991/foldsigns.nvim',
      config = function()
        require('foldsigns').setup({exclude = {'GitSigns.*', 'LspSagaLightBulb'}})
      end,
    }
    use {
      'akinsho/nvim-bufferline.lua',
      -- Tabline plugin
      -- Issues:
      -- - #14: (feat) Show only buffer in current tab?
      requires = {'nvim-web-devicons', 'codicons.nvim'},
      -- after = 'colorbuddy.nvim',
      config = function()
        local codicons = require('codicons')
        require('bufferline').setup({
          options = {
            buffer_close_icon = codicons.get('close'),
            close_icon = codicons.get('close-all'),
            mappings = true,
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(count, _) return '(' .. count .. ')' end,
            separator_style = 'slant',
          },
        })
        vim.keymap.nmap {'bb', '<Cmd>BufferLinePick<CR>'}
      end,
    }
    use {
      'tjdevries/colorbuddy.nvim',
      -- event = 'VimEnter *',
      opt = true,
      config = function() require('colorbuddy').colorscheme('quantumbuddy') end,
    }
    use {
      'tiagovla/tokyodark.nvim',
      opt = true,
      config = function() vim.cmd [[colorscheme tokyodark]] end,
    }
    use {
      'folke/tokyonight.nvim',
      opt = false,
      config = function()
        vim.g.tokyonight_style = 'night'
        vim.g.tokyonight_sidebars = {'qf', 'vista_kind', 'terminal', 'packer', 'LspTrouble'}
        vim.cmd [[colorscheme tokyonight]]
      end,
    }
    use {
      'tkmpypy/chowcho.nvim',
      requires = 'nvim-web-devicons',
      cmd = 'Chowcho',
      config = function()
        require('chowcho').setup({icon_enabled = true, border_style = 'rounded'})
      end,
    }
    use {'yamatsum/nvim-cursorline', config = 'require("plugins.nvim-cursorline").config()'}
    use {'alec-gibson/nvim-tetris', cmd = 'Tetris'}
    use {
      'dstein64/nvim-scrollview',
      config = function() vim.g.scrollview_nvim_14040_workaround = true end,
    }
    use {'kevinhwang91/nvim-hlslens', config = _M.cfg('nvim-hlslens')}
    use {'lukas-reineke/indent-blankline.nvim', branch = 'lua', config = _M.cfg('indent-blankline')}
    use 'karb94/neoscroll.nvim' -- Smooth scrolling
    use {
      'edluffy/specs.nvim',
      config = function()
        require('specs').setup({popup = {fader = require('specs').pulse_fader}})
      end,
    }
    -- use {'sunjon/shade.nvim', config = function() require('shade').setup() end}
    -- Turned off because it breaks some random highlights (how?)
    use {'folke/which-key.nvim', config = _M.cfg('which-key')}

    -- Utilities
    use {
      'tpope/vim-fugitive',
      config = function()
        vim.g.fugitive_legacy_commands = false
        vim.g.fugitive_no_maps = true
      end,
    }
    use {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = {{'n', '<Leader>gy'}, {'v', '<Leader>gy'}},
      config = function() require('gitlinker').setup() end,
    }
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      config = function() require('neogit').setup({disable_signs = true}) end,
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
        require('neuron').setup({
          virtual_titles = true,
          mappings = true,
          run = nil,
          neuron_dir = '~/Documents/Neuron',
          leader = 'gz',
        })
      end,
    }
    use {
      'hkupty/iron.nvim',
      cmd = {'IronRepl', 'IronSend', 'IronReplHere', 'IronWatchCurrentFile'},
      -- keys = {{'n', 'ctr'}, {'v', 'ctr'}, {'n', '<LocalLeader>sl'}},
      keys = {
        '<Plug>(iron-repeat-cmd)', '<Plug>(iron-cr)', '<Plug>(iron-interrupt)', '<Plug>(iron-exit)',
        '<Plug>(iron-clear)', '<Plug>(iron-send-motion)', '<Plug>(iron-send-lines)',
        '<Plug>(iron-send-line)', '<Plug>(iron-visual-send)',
      },
      setup = function()
        vim.g.iron_map_defaults = false
        vim.g.iron_map_extended = false
        vim.keymap.nmap {'ctr', '<Plug>(iron-send-motion)'}
        vim.keymap.vmap {'ctr', '<Plug>(iron-visual-send)'}
        vim.keymap.nmap {'cp', '<Plug>(iron-repeat-cmd)'}
        vim.keymap.nmap {'<LocalLeader>sl', '<Plug>(iron-send-line)'}
        vim.keymap.nmap {'c<CR>', '<Plug>(iron-cr)'}
        vim.keymap.nmap {'cst', '<Plug>(iron-interrupt)'}
        vim.keymap.nmap {'cq', '<Plug>(iron-exit)'}
        vim.keymap.nmap {'cl', '<Plug>(iron-clear)'}
      end,
      config = _M.cfg('iron'),
    }
    use {'mhartington/formatter.nvim', config = _M.cfg('formatter')}
    use {
      'rcarriga/vim-ultest',
      requires = 'vim-test/vim-test',
      run = ':UpdateRemotePlugins',
      opt = true,
      cmd = {'Ultest', 'UltestNearest', 'UltestSummary'},
      keys = {'<Plug>(ultest-run-file)', '<Plug>(ultest-run-nearest)'},
      -- out of order rplugin loading is janky but this sorta works
      config = function()
        vim.cmd [[silent UpdateRemotePlugins]]
        vim.cmd [[au init User UltestPositionsUpdate ++once UltestNearest]]
      end,
    }
    use {
      'mattn/vim-sonictemplate',
      -- Template engine
      cmd = 'Template',
      -- fn load condition allows for telescope integration to load this
      fn = 'sonictemplate#complete',
      keys = {'<Plug>(sonictemplate)', '<Plug>(sonictemplate-intelligent)'},
      setup = function()
        vim.keymap.nmap {'<C-y>t', '<Plug>(sonictemplate)'}
        vim.keymap.nmap {'<C-y>T', '<Plug>(sonictemplate-intelligent)'}
      end,
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
      config = function() require('true-zen').setup({cursor_by_mode = true}) end,
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
        require('trouble').setup({
          fold_open = codicons.get('fold-down'),
          fold_closed = codicons.get('fold-up'),
          signs = {
            error = codicons.get('error'),
            warning = codicons.get('warning'),
            hint = codicons.get('question'),
            information = codicons.get('info'),
          },
        })
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
        require('sniprun').initial_setup({
          interpreter_options = {
            C_original = {compiler = 'clang'},
            Cpp_original = {compiler = 'clang++ --debug'},
          },
        })
      end,
    }
    use {
      'sindrets/diffview.nvim',
      cmd = 'DiffviewOpen',
      requires = 'nvim-web-devicons',
      config = _M.cfg('diffview'),
    }

    -- Filetypes & language features
    -- Some of this stuff isn't managed by packer.
    use {
      'leafo/moonscript-vim', 'rhysd/vim-llvm', 'ron-rs/ron.vim', 'bakpakin/fennel.vim',
      'aklt/plantuml-syntax', 'tikhomirov/vim-glsl', 'udalov/kotlin-vim',
      'YaBoiBurner/requirements.txt.vim', 'teal-language/vim-teal', 'gluon-lang/vim-gluon',
      'blankname/vim-fish', 'thyrgle/vim-dyon', 'bytecodealliance/cranelift.vim',
    }
    -- Meson syntax is now manually maintained
    -- toml is handled internally + with nvim-treesitter
    -- vim-teal is patched

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
    use {
      'stsewd/sphinx.nvim',
      -- rplugin skipped because it's not useful for me
      -- fzf integration skipped because i don't use the fzf plugin
      ft = 'rst',
      config = function()
        vim.cmd [[delcommand SphinxRefs]]
        vim.cmd [[delcommand SphinxFiles]]
      end,
    }

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
    use {'gennaro-tedesco/nvim-jqx', cmd = {'JqxList', 'JqxQuery'}, keys = '<Plug>JqxList'}
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
        npairs.setup({
          check_ts = true,
          ts_config = {lua = {'string'}, javascript = {'template_string'}},
        })
      end,
    }
    use {
      'tpope/vim-abolish',
      cmd = {'Abolish', 'Subvert', 'S'},
      keys = {'<Plug>(abolish-coerce)', '<Plug>(abolish-coerce-word)'},
      setup = function()
        vim.g.abolish_no_mappings = true
        vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
        vim.keymap.nmap {'cr', '<Plug>(abolish-coerce-word)'}
      end,
    }
    use {
      'tpope/vim-commentary',
      cmd = 'Commentary',
      keys = {'<Plug>Commentary', '<Plug>CommentaryLine', '<Plug>ChangeCommentary'},
      setup = function()
        vim.keymap.xmap {'gc', '<Plug>Commentary'}
        vim.keymap.nmap {'gc', '<Plug>Commentary'}
        vim.keymap.omap {'gc', '<Plug>Commentary'}
        vim.keymap.nmap {'gcc', '<Plug>CommentaryLine'}
        vim.keymap.nmap {'gcu', '<Plug>Commentary<Plug>Commentary'}
      end,
    }
    use {
      'tpope/vim-surround',
      -- This will be replaced by blackCauldron7/surround.nvim eventually
      keys = {
        '<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround',
        '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround',
        '<Plug>VgSurround', {'i', '<Plug>Isurround'}, {'i', '<Plug>ISurround'},
      },
      setup = function()
        vim.g.surround_no_mappings = true
        vim.keymap.nmap {'ds', '<Plug>Dsurround'}
        vim.keymap.nmap {'cs', '<Plug>Csurround'}
        vim.keymap.nmap {'cS', '<Plug>CSurround'}
        vim.keymap.nmap {'ys', '<Plug>Ysurround'}
        vim.keymap.nmap {'yS', '<Plug>YSurround'}
        vim.keymap.nmap {'yss', '<Plug>Yssurround'}
        vim.keymap.nmap {'ySs', '<Plug>YSsurround'}
        vim.keymap.nmap {'ySS', '<Plug>YSsurround'}
        vim.keymap.xmap {'S', '<Plug>VSurround'}
        vim.keymap.xmap {'gS', '<Plug>VgSurround'}
        vim.keymap.imap {'<C-S>', '<Plug>Isurround'}
        vim.keymap.imap {'<C-G>s', '<Plug>Isurround'}
        vim.keymap.imap {'<C-G>S', '<Plug>ISurround'}
      end,
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
      setup = function() vim.g.bullets_enabled_file_types = {'markdown', 'gitcommit'} end,
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
  config = {max_jobs = #vim.loop.cpu_info(), profile = {enable = true, threshold = 1}},
})

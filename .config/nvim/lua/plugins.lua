return require('packer').startup({
  ---@param use fun(opts: table)
  ---@param use_rocks fun(rocks: string|string[])
  function(use, use_rocks)
    local plugins_dir = vim.loop.os_getenv('XDG_CONFIG_HOME') .. '/nvim/lua/plugins'
    -- use = WRAP(use)
    -- macros
    local _M = {}
    function _M.cfg(name) return 'require("plugins.' .. name .. '")' end
    function _M.do_config(fname) return 'pcall(dofile, "' .. plugins_dir .. '/' .. fname .. '")' end

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Core plugins
    use_rocks({'compat53', 'penlight', 'fun', 'stdlib'})
    use 'tjdevries/astronauta.nvim'
    use {
      'nvim-lua/plenary.nvim',
      config = function() require('plenary.filetype').add_file('user') end,
    }
    use 'iamcco/async-await.lua'
    use 'norcalli/profiler.nvim'
    use {
      'mortepau/codicons.nvim',
      config = function()
        local codicons = require('codicons')
        codicons.setup()
        local ext = require('codicons.extensions').available()
        require(ext.CompletionItemKind).set()
        vim.g.vim_package_info_virutaltext_prefix = '  ' .. codicons.get('versions') .. ' '
      end,
    }

    -- Completion & Linting
    use {
      'neovim/nvim-lspconfig',
      requires = {
        'tamago324/nlsp-settings.nvim',
        {'kabouzeid/nvim-lspinstall', cmd = {'LspInstall', 'LspUninstall'}},
      },
      config = _M.cfg('lspsettings'),
    }
    use {
      'glepnir/lspsaga.nvim',
      requires = {'nvim-lspconfig', 'codicons.nvim'},
      config = _M.do_config('lspsaga.lua'),
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
        {'nvim-treesitter/playground', after = 'nvim-treesitter', as = 'nvim-treesitter-playground'},
        {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'},
        {'nvim-treesitter/nvim-tree-docs', after = 'nvim-treesitter', requires = 'Olical/aniseed'},
        {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'},
        {'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter'},
      },
      run = ':TSUpdate',
      config = _M.do_config('treesitter.lua'),
    }
    use {'dense-analysis/ale', cmd = 'ALEEnable', config = _M.do_config('ale.lua')}
    use {
      'hrsh7th/vim-vsnip',
      requires = {'nvim-lspconfig', {'rafamadriz/friendly-snippets', event = 'VimEnter *'}},
      config = _M.do_config('vim-vsnip.lua'),
    }
    use {
      'hrsh7th/nvim-compe',
      requires = {
        {'tzachar/compe-tabnine', run = 'bash install.sh'}, 'vim-vsnip', 'nvim-lspconfig',
        'nvim-treesitter',
      },
      config = _M.do_config('nvim-compe.lua'),
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'plenary.nvim', {'nvim-lua/popup.nvim', requires = 'plenary.nvim'},
        'kyazdani42/nvim-web-devicons', 'nvim-treesitter', 'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-fzf-writer.nvim', 'nvim-telescope/telescope-node-modules.nvim',
        'nvim-telescope/telescope-media-files.nvim', 'dhruvmanila/telescope-bookmarks.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make CC=clang'},
        {'nvim-telescope/telescope-fzy-native.nvim', requires = 'plenary.nvim'},
        {'nvim-telescope/telescope-github.nvim', requires = {'plenary.nvim', 'nvim-lua/popup.nvim'}},
        {'tamago324/telescope-sonictemplate.nvim', requires = 'plenary.nvim'},
        {'nvim-telescope/telescope-frecency.nvim', requires = {'tami5/sql.nvim', 'plenary.nvim'}},
        {'nvim-telescope/telescope-cheat.nvim', requires = {'tami5/sql.nvim', 'plenary.nvim'}}, {
          'nvim-telescope/telescope-arecibo.nvim',
          requires = 'nvim-treesitter',
          rocks = {'openssl', 'lua-http-parser'},
        },
      },
      config = _M.do_config('telescope.lua'),
    }
    use {'pwntester/octo.nvim', requires = {'telescope.nvim', 'plenary.nvim'}}

    -- User interface
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'plenary.nvim',
      config = function() require('gitsigns').setup({current_line_blame = true}) end,
      event = 'VimEnter *',
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
    use {'meain/vim-package-info', run = 'npm i'} -- rplugin lazy loads
    use {
      'hoob3rt/lualine.nvim',
      requires = {'arkav/lualine-lsp-progress', 'kyazdani42/nvim-web-devicons', 'codicons.nvim'},
      config = function()
        local codicons = require('codicons')
        require('lualine').setup({
          options = {
            theme = 'tokyonight',
            section_separators = {'', ''},
            component_separators = {'', ''},
          },
          sections = {
            lualine_c = {
              'filename', {
                'diagnostics',
                sources = {'nvim_lsp'},
                symbols = {
                  error = codicons.get('error') .. ' ',
                  warn = codicons.get('warning') .. ' ',
                  info = codicons.get('info') .. ' ',
                },
              }, 'lsp_progress',
            },
          },
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
      requires = {'kyazdani42/nvim-web-devicons', 'codicons.nvim'},
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
      'folke/tokyonight.nvim',
      config = function()
        vim.g.tokyonight_style = 'night'
        vim.g.tokyonight_sidebars = {'qf', 'vista_kind', 'terminal', 'packer', 'LspTrouble'}
        vim.cmd [[colorscheme tokyonight]]
      end,
    }
    use {
      'tkmpypy/chowcho.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      opt = true,
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
    use {'kevinhwang91/nvim-hlslens', config = _M.do_config('nvim-hlslens.lua')}
    use {
      'lukas-reineke/indent-blankline.nvim',
      requires = 'nvim-treesitter',
      branch = 'lua',
      config = function()
        vim.g.indent_blankline_buftype_exclude = {'terminal'}
        vim.g.indent_blankline_filetype_exclude = {'help', 'lspinfo', 'packer', 'peek'}
        vim.g.indent_blankline_char = '▏'
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indent_blankline_show_current_context = true
        vim.g.indent_blankline_context_patterns = {
          'class', 'return', 'function', 'method', '^if', '^while', 'jsx_element', '^for',
          '^object', '^table', 'block', 'arguments', 'if_statement', 'else_clause', 'jsx_element',
          'jsx_self_closing_element', 'try_statement', 'catch_clause', 'import_statement',
        }
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_show_trailing_blankline_indent = false
      end,
    }
    use 'karb94/neoscroll.nvim' -- Smooth scrolling
    use {
      'edluffy/specs.nvim',
      config = function()
        require('specs').setup({popup = {fader = require('specs').pulse_fader}})
      end,
    }
    -- use {'sunjon/shade.nvim', config = function() require('shade').setup() end}
    -- Turned off because it breaks some random highlights (how?)
    use {'folke/which-key.nvim', config = _M.do_config('which-key.lua')}

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
      requires = 'plenary.nvim',
      cmd = 'Neogit',
      config = function() require('neogit').setup({disable_signs = true}) end,
    }
    use 'farmergreg/vim-lastplace'
    -- VimWiki - note-taking engine
    use {
      'vimwiki/vimwiki',
      event = 'BufNewFile,BufRead *.markdown,*.mdown,*.mdwn,*.wiki,*.mkdn,*.mw,*.md',
      cmd = {
        'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiDiaryIndex', 'VimwikiMakeDiaryNote',
        'VimwikiTabMakeDiaryNote',
      },
      keys = {
        '<Plug>VimwikiIndex', '<Plug>VimwikiTabIndex', '<Plug>VimwikiUISelect',
        '<Plug>VimwikiDiaryIndex', '<Plug>VimwikiDiaryGenerateLinks', '<Plug>VimwikiMakeDiaryNote',
        '<Plug>VimwikiTabMakeDiaryNote', '<Plug>VimwikiMakeYesterdayDiaryNote',
        '<Plug>VimwikiMakeTomorrowDiaryNote',
      },
      setup = function()
        vim.g.vimwiki_list = {{path = '~/Documents/VimWiki', nested_syntaxes = {['c++'] = 'cpp'}}}
        vim.g.vimwiki_folding = 'expr'
        vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_hl_headers = 1
        vim.g.vimwiki_key_mappings = {global = false}
        vim.keymap.nmap {'<Leader>ww', '<Plug>VimwikiIndex'}
        vim.keymap.nmap {'<Leader>wt', '<Plug>VimwikiTabIndex'}
      end,
    }
    -- neuron.nvim - Neuron-based note-taking engine
    -- this might replace vimwiki at some point
    use {
      'oberblastmeister/neuron.nvim',
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
        vim.keymap.nmap {'<LocalLeader>sl', '<Plug>(iron-send-line)'}
      end,
      config = _M.do_config('iron.lua'),
    }
    use {'mhartington/formatter.nvim', event = 'VimEnter *', config = _M.do_config('formatter.lua')}

    -- ultest - unit test support
    -- lazy loading is very janky
    use {
      'rcarriga/vim-ultest',
      requires = 'vim-test/vim-test',
      run = ':UpdateRemotePlugins',
      opt = true,
      cmd = {'Ultest', 'UltestNearest', 'UltestSummary'},
      keys = {'<Plug>(ultest-run-file)', '<Plug>(ultest-run-nearest)'},
      config = function()
        vim.cmd [[silent UpdateRemotePlugins]]
        vim.cmd [[au init User UltestPositionsUpdate ++once UltestNearest]]
      end,
    }
    -- vim-sonictemplate - Template engine
    -- fn load condition allows for telescope integration to load this
    use {
      'mattn/vim-sonictemplate',
      cmd = 'Template',
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

    -- development fork of kdav5758/TrueZen.nvim
    use {
      '~/Projects/nvim-plugins/TrueZen.nvim',
      cmd = {'TZAtaraxis', 'TZMinimalist', 'TZBottom', 'TZTop', 'TZLeft'},
      config = function()
        require('true-zen').setup({ataraxis = {force_when_plus_one_window = true}})
      end,
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
    -- vista.vim - TOC & symbol tree
    use {
      'liuchengxu/vista.vim',
      cmd = 'Vista',
      setup = require('plugins.vista').setup,
      config = require('plugins.vista').config,
    }
    -- nvim-tree.lua - File tree
    -- Part of this loader is deferred, so we can push a slow step back
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons', 'codicons.nvim'},
      opt = true,
      cmd = {'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile'},
      setup = function() vim.g.nvim_tree_lsp_diagnostics = true end,
      config = function()
        local codicons = require('codicons')
        vim.g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1}
        vim.g.nvim_tree_icons = {
          symlink = codicons.get('file-symlink-file'),
          git_icons = {
            renamed = codicons.get('diff-renamed'),
            deleted = codicons.get('diff-removed'),
            ignored = codicons.get('diff-ignored'),
          },
          folder = {
            default = codicons.get('folder'),
            open = codicons.get('folder-opened'),
            symlink = codicons.get('file-symlink-directory'),
          },
          lsp = {
            hint = codicons.get('question'),
            info = codicons.get('info'),
            warning = codicons.get('warning'),
            error = codicons.get('error'),
          },
        }
        vim.defer_fn(require('nvim-tree').refresh, 50)
      end,
    }
    use {
      'folke/lsp-trouble.nvim',
      requires = {'nvim-lspconfig', 'kyazdani42/nvim-web-devicons', 'codicons.nvim'},
      cmd = {'LspTrouble', 'LspTroubleToggle'},
      opt = true,
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
        local tablex = require('pl.tablex')
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
      requires = 'kyazdani42/nvim-web-devicons',
      opt = true,
      config = _M.do_config('diffview.lua'),
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
    -- sphinx.nvim - Sphinx integration
    -- I just have this for tree-sitter stuff
    use {
      'stsewd/sphinx.nvim',
      ft = 'rst',
      config = function()
        vim.cmd [[delcommand SphinxRefs]]
        vim.cmd [[delcommand SphinxFiles]]
      end,
    }

    -- Rust
    -- rust-tools.nvim - LSP plugin
    -- has a very slow startup time, but rust-analyzer crashes if this is lazy-loaded.
    use {
      'simrat39/rust-tools.nvim',
      requires = {
        'nvim-lspconfig', {'nvim-lua/popup.nvim', requires = 'plenary.nvim'}, 'plenary.nvim',
        'telescope.nvim',
      },
      config = function()
        require('rust-tools').setup({server = {capabilities = {window = {workDoneProgress = true}}}})
      end,
    }

    -- Integration
    -- editorconfig-vim - Editorconfig support
    -- Rules that will modify files are disabled, since that's handled elsewhere.
    -- Eventually I'll find or make a unified formatting plugin to replace this.
    use {
      'editorconfig/editorconfig-vim',
      -- config = function() require('plugins.editorconfig-vim').config() end,
      config = require('plugins.editorconfig-vim').config,
    }
    use {'gennaro-tedesco/nvim-jqx', cmd = {'JqxList', 'JqxQuery'}, keys = '<Plug>JqxList'}
    use {'kdheepak/lazygit.nvim', requires = 'plenary.nvim', cmd = 'LazyGit'}
    -- use {'lewis6991/spellsitter.nvim', config = function() require('spellsitter').setup() end}
    -- Spell support for tree-sitter is nice but it causes files to noticably refresh constantly.
    -- It also might be contributing to PID bloat by running hunspell too often.
    -- It's a WIP so some problems can be expected.

    -- Text editing
    use 'tpope/vim-repeat'
    -- hop.nvim - EasyMotion replacement
    use {
      'phaazon/hop.nvim',
      cmd = {'HopWord', 'HopPattern', 'HopChar1', 'HopChar2', 'HopLine'},
      setup = function()
        local nmap = vim.keymap.nmap
        nmap {'<Leader>hw', '<Cmd>HopWord<CR>'}
        nmap {'<Leader>hp', '<Cmd>HopPattern<CR>'}
        nmap {'<Leader>hc', '<Cmd>HopChar1<CR>'}
        nmap {'<Leader>hC', '<Cmd>HopChar2<CR>'}
        nmap {'<Leader>hl', '<Cmd>HopLine<CR>'}
      end,
    }
    use {
      'windwp/nvim-autopairs',
      requires = 'nvim-treesitter',
      config = function()
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
    -- vim-surround
    -- This could be replaced by blackCauldron7/surround.nvim eventually
    use {
      'tpope/vim-surround',
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
        vim.keymap.nmap {'Ys', '<Plug>Ysurround'}
        vim.keymap.nmap {'YS', '<Plug>YSurround'}
        vim.keymap.nmap {'Yss', '<Plug>Yssurround'}
        vim.keymap.nmap {'YSs', '<Plug>YSsurround'}
        vim.keymap.nmap {'YSS', '<Plug>YSsurround'}
        vim.keymap.xmap {'S', '<Plug>VSurround'}
        vim.keymap.xmap {'gS', '<Plug>VgSurround'}
        vim.keymap.imap {'<C-S>', '<Plug>Isurround'}
        vim.keymap.imap {'<C-G>s', '<Plug>Isurround'}
        vim.keymap.imap {'<C-G>S', '<Plug>ISurround'}
      end,
    }
    -- dial.nvim - Replaces speeddating
    use {
      'monaqa/dial.nvim',
      keys = {'<C-a>', '<C-x>', {'v', 'g<C-a>'}, {'v', 'g<C-x>'}},
      config = _M.do_config('dial.lua'),
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

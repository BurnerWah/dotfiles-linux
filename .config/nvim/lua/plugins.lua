-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- Core plugins
  use 'tjdevries/astronauta.nvim'
  use { 'nvim-lua/plenary.nvim', config = function() require'plenary.filetype'.add_file('user') end }

  -- Completion & Linting
  use {
    'neovim/nvim-lspconfig',
    config = function() require('user.cfg.lspsettings') end
  }
  use {
    'glepnir/lspsaga.nvim',
    requires = 'nvim-lspconfig',
    config = function()
      require'lspsaga'.init_lsp_saga()
      local remap = vim.api.nvim_set_keymap
      local opts = { silent = true, noremap = true }

      remap('n', '<leader>hh', [[<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>]],              opts)
      remap('n', 'gh',         [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]],                 opts)
      remap('n', 'gs',         [[<cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>]],        opts)
      remap('n', 'ca',         [[<cmd>lua require'lspsaga.codeaction'.code_action()<CR>]],              opts)
      remap('v', 'ca',         [[<cmd>'<,'>lua require'lspsaga.codeaction'.range_code_action()<CR>]],   opts)
      remap('n', 'gr',         [[<cmd>lua require'lspsaga.rename'.rename()<CR>]],                       opts)
      remap('n', '<leader>rn', [[<cmd>lua require'lspsaga.rename'.rename()<CR>]],                       opts)
      remap('n', 'gd',         [[<cmd>lua require'lspsaga.provider'.preview_definition()<CR>]],         opts)
      remap('n', '<leader>cd', [[<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>]],    opts)
      remap('n', '[e',         [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]], opts)
      remap('n', '[g',         [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]], opts)
      remap('n', ']e',         [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]], opts)
      remap('n', ']g',         [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]], opts)
      remap('n', '<A-d>',      [[<cmd>lua require'lspsaga.floaterm'.open_float_terminal('fish')<CR>]],  opts)
      remap('t', '<A-d>',      [[<C-\><C-n>:lua require'lspsaga.floaterm'.close_float_terminal()<CR>]], opts)
    end
  }
  use {
    'kosayoda/nvim-lightbulb',
    requires = 'nvim-lspconfig',
    config = function()
      vim.cmd [[autocmd init CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    --[[ Highlighting engine for neovim

      I've chosen not to include some modules until some issues they have get fixed.
      nvim-treesitter-textobjects can be added once #8 & #27 are fixed
      nvim-ts-rainbow can be added once #5 is fixed (which requires nvim-treesitter#879 merged)
      ]]
    requires = {
      { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
      { 'nvim-treesitter/playground', after = 'nvim-treesitter' },
    },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'maintained',
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        indent = { enable = true }, -- Indent uses 'tabstop' so it has to be managed in ftplugins.
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
        },
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            keymaps = { smart_rename = 'grr' }
          },
        },
      }
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.bash.used_by = { 'PKGBUILD' }
    end
  }
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
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
      vim.api.nvim_set_keymap('x', '<leader>a', '<Plug>(coc-codeaction-selected)', {})
      vim.api.nvim_set_keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', {})
      vim.api.nvim_set_keymap('n', '<leader>ac', '<Plug>(coc-codeaction)', {})
      vim.api.nvim_set_keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', {})
      vim.api.nvim_set_keymap('x', 'if', '<Plug>(coc-funcobj-i)', {})
      vim.api.nvim_set_keymap('o', 'if', '<Plug>(coc-funcobj-i)', {})
      vim.api.nvim_set_keymap('x', 'af', '<Plug>(coc-funcobj-a)', {})
      vim.api.nvim_set_keymap('o', 'af', '<Plug>(coc-funcobj-a)', {})
      vim.api.nvim_set_keymap('x', 'ic', '<Plug>(coc-classobj-i)', {})
      vim.api.nvim_set_keymap('o', 'ic', '<Plug>(coc-classobj-i)', {})
      vim.api.nvim_set_keymap('x', 'ac', '<Plug>(coc-classobj-a)', {})
      vim.api.nvim_set_keymap('o', 'ac', '<Plug>(coc-classobj-a)', {})
      vim.cmd [[autocmd init User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&spell', 0)]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&winblend', 10)]]
      vim.cmd [[autocmd init FileType list setlocal nospell]]
    end
  }
  use {
    'dense-analysis/ale',
    config = function()
      vim.g.ale_fix_on_save = true
      vim.g.ale_disable_lsp = true
      vim.g.ale_linters_ignore = {
        --[[
          I'm using this to disable linters that should not be handled by ALE.
          That includes stuff handled by another plugin, and stuff that isn't helpful.

          potential things to convert:
          - fecs [ css, html, javascript ]
          - gawk [ awk ] (packaged)
          - clangcheck [ cpp ] (packaged)
          - cppcheck [ c, cpp ] (packaged)
          - clazy [ cpp ] (packaged)
          - flawfinder [ c, cpp ] (packaged)
          - vale [ asciidoc, mail, markdown, rst, tex, text ]
          - msgfmt [ po ] (packaged)
          - redpen [ asciidoc, markdown, review, rst, tex, text ]
          - textlint [ asciidoc, markdown, rst, tex, text ]
          - chktex [ tex ] (packaged)
          - lacheck [ tex ] (packaged)
        ]]
        asciidoc = { 'alex', 'languagetool', 'proselint', 'writegood' }, -- enabled: redpen, textlint, vale
        bats = { 'shellcheck' }, -- DISABLED
        c = { 'cc', 'clangtidy', 'cpplint' }, -- enabled: cppcheck, flawfinder
        cmake = { 'cmakelint' }, -- DISABLED
        cpp = { 'cc', 'clangtidy', 'cpplint' }, -- enabled: clangcheck, clazy, cppcheck, flawfinder
        css = { 'csslint', 'stylelint' }, -- enabled: fecs
        dockerfile = { 'hadolint' }, -- enabled: dockerfile_lint
        elixir = { 'credo' },
        eruby = { 'erb' },
        fish = { 'fish' }, -- DISABLED
        fountain = { 'proselint' }, -- DISABLED
        gitcommit = { 'gitlint' }, -- DISABLED
        graphql = { 'eslint' }, -- enabled: gqlint
        help = { 'alex', 'proselint', 'writegood' }, -- DISABLED
        html = { 'alex', 'proselint', 'tidy', 'writegood' }, -- enabled: fecs, htmlhint
        javascript = { 'eslint', 'jshint', 'flow', 'standard', 'xo' }, -- enabled: fecs, jscs
        json = { 'jsonlint', 'spectral' }, -- DISABLED
        -- jsonc = { 'jsonlint', 'spectral' },
        less = { 'stylelint' }, -- enabled: lessc
        lua = { 'luacheck', 'luac' }, -- DISABLED
        mail = { 'alex', 'languagetool', 'proselint' }, -- enabled: vale
        markdown = { 'alex', 'languagetool', 'markdownlint', 'proselint', 'writegood' },
        nroff = { 'alex', 'proselint', 'writegood' }, -- DISABLED
        objc = { 'clang' }, -- DISABLED
        objcpp = { 'clang' }, -- DISABLED
        php = { 'phpcs', 'phpstan' },
        po = { 'alex', 'proselint', 'writegood' }, -- enabled: msgfmt
        pod = { 'alex', 'proselint', 'writegood' }, -- DISABLED
        python = { 'flake8', 'mypy', 'pylint' },
        rst = { 'alex', 'proselint', 'rstcheck', 'writegood' }, -- enabled: redpen, textlint, vale
        rust = { 'cargo' }, -- DISABLED
        sass = { 'stylelint' }, -- enabled: sasslint
        scss = { 'stylelint' }, -- enabled: sasslint, scss-lint
        sh = { 'bashate', 'shellcheck' }, -- enabled: shell
        sql = { 'sqlint' }, -- enabled: sqllint
        stylus = { 'stylelint' }, -- DISABLED
        sugarss = { 'stylelint' }, -- DISABLED
        teal = { 'tlcheck' }, -- DISABLED
        tex = { 'alex', 'proselint', 'writegood' }, -- enabled: chktex, lacheck, redpen, textlint, vale
        texinfo = { 'alex', 'proselint', 'writegood' }, -- DISABLED
        typescript = { 'eslint', 'standard', 'tslint', 'xo' }, -- enabled: typecheck
        vim = { 'vint' }, -- enabled: ale_custom_linting_rules
        vimwiki = { 'alex', 'languagetool', 'proselint', 'markdownlint', 'mdl', 'remark-lint', 'writegood' },
        vue = { 'eslint' },
        xhtml = { 'alex', 'proselint', 'writegood' }, -- DISABLED
        xsd = { 'xmllint' }, -- DISABLED
        xml = { 'xmllint' }, -- DISABLED
        xslt = { 'xmllint' }, -- DISABLED
        yaml = { 'spectral', 'yamllint' }, -- enabled: swaglint
        zsh = { 'shell' },
      }
      vim.g.ale_fixers = {
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
        cpp = { 'clangtidy', 'remove_trailing_lines', 'trim_whitespace' },
        go = { 'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace' },
        html = { 'tidy', 'remove_trailing_lines', 'trim_whitespace' },
        markdown = {},
        python = {
          'add_blank_lines_for_python_control_statements',
          'reorder-python-imports',
          'remove_trailing_lines',
          'trim_whitespace',
        },
        rust = { 'rustfmt', 'remove_trailing_lines', 'trim_whitespace' },
        sql = { 'sqlformat', 'remove_trailing_lines', 'trim_whitespace' },
        xml = { 'xmllint' },
      }
      vim.cmd [[autocmd init VimEnter * lua require('user.cleanup.ale')]]
    end
  }
  use {
    'nvim-lua/completion-nvim',
    -- I'd rather use hrsh7th/nvim-compe, but it's lacking in sources
    requires = {
      { 'nvim-treesitter/completion-treesitter', requires = 'nvim-treesitter' },
      { 'aca/completion-tabnine', run = './install.sh' },
      { 'steelsojka/completion-buffers' }
    },
    config = function()
      vim.cmd [[autocmd BufEnter * lua require'completion'.on_attach()]]
      vim.cmd [[set completeopt=menuone,noinsert,noselect]]
      vim.cmd [[set shortmess+=c]]
      vim.g.completion_chain_complete_list = {
        default = {
          default = {
            { complete_items = { 'lsp', 'snippet', 'tabnine' } },
            { complete_items = { 'buffers' } },
            { mode = { '<c-p>' } },
            { mode = { '<c-n>' } },
          },
          comment = {},
        },
        lua = {
          default = {
            { complete_items = { 'lsp', 'snippet', 'tabnine' } },
            { complete_items = { 'ts' } },
            { complete_items = { 'buffers' } },
          },
        },
        markdown = {
          default = {
            { complete_items = { 'snippet' } },
            { complete_items = { 'buffers' } },
          },
        },
        rst = {
          default = {
            { complete_items = { 'snippet' } },
            { complete_items = { 'ts' } },
            { complete_items = { 'buffers' } },
          },
        },
        vimwiki = {
          default = {
            { complete_items = { 'snippet' } },
            { complete_items = { 'buffers' } },
          },
        },
      }
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
  use { 'mesonbuild/meson', rtp = 'data/syntax-highlighting/vim' }

  -- CXX
  use { 'jackguo380/vim-lsp-cxx-highlight', ft = { 'c', 'cpp', 'objc', 'objcpp', 'cc', 'cuda' } }

  -- Lua
  use { 'euclidianAce/BetterLua.vim', ft = 'lua' }
  use 'tjdevries/manillua.nvim'
  use 'tjdevries/nlua.nvim'
  use { 'bfredl/nvim-luadev', cmd = 'Luadev' }
  use { 'rafcamlet/nvim-luapad', cmd = { 'Lua', 'Luapad', 'LuaRun' } }

  -- Markdown
  use { 'npxbr/glow.nvim', ft = { 'markdown', 'pandoc.markdown', 'rmd' } }
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown' }

  -- Python
  use 'vim-python/python-syntax'
  use 'Vimjas/vim-python-pep8-indent'

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
      -- local homedir = os.getenv 'HOME'
      telescope.setup {
        defaults = {
          winblend = 10,
          file_sorter = require'telescope.sorters'.get_fzy_sorter,
        },
        extensions = {
          frecency = {
            show_scores = true,
            ignore_patterns = {'*.git/*', '*/tmp/*', os.getenv 'XDG_CACHE_HOME'},
            workspaces = {
              conf = os.getenv 'XDG_CONFIG_HOME',
              data = os.getenv 'XDG_DATA_HOME',
              project = os.getenv('HOME') .. '/Projects',
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
      remap('n', 'gr', [[<cmd>lua require'telescope.builtin'.lsp_references()<cr>]], opts)
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
      vim.g.vista_echo_cursor_strategy = 'floating_win'
      vim.g.vista_executive_for = {
        apiblueprint = 'markdown',
        c = 'nvim_lsp',
        cpp = 'nvim_lsp',
        css = 'nvim_lsp',
        go = 'nvim_lsp',
        html = 'nvim_lsp',
        javascript = 'nvim_lsp',
        json = 'nvim_lsp',
        jsonc = 'nvim_lsp',
        lua = 'nvim_lsp',
        markdown = 'toc',
        objc = 'nvim_lsp',
        objcpp = 'nvim_lsp',
        pandoc = 'markdown',
        python = 'nvim_lsp',
        rst = 'toc',
        tex = 'nvim_lsp',
        typescript = 'nvim_lsp',
        vala = 'nvim_lsp',
        vim = 'nvim_lsp',
        xml = 'nvim_lsp',
        yaml = 'nvim_lsp',
      }
      vim.g.vista_ctags_cmd = {
        -- Consider checking for commands before enabling them.
        go = 'gotags',
        rst = 'rst2ctags',
      }
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'plenary.nvim',
    config = function() require'gitsigns'.setup() end
  }
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
      { 'tyrannicaltoucan/vim-quantum', config = function() vim.cmd [[AirlineTheme quantum]] end },
      { 'ryanoasis/vim-devicons', config = function() vim.g.webdevicons_enable_nerdtree = 0 end },
    },
    opt = true,
    event = 'VimEnter *',
    setup = function()
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

  -- Utilities
  use 'tpope/vim-fugitive'
  use { 'rliang/termedit.nvim', event = 'VimEnter *' }
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
      }
    end
  }

  -- Text editing
  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use {
    'phaazon/hop.nvim',
    -- EasyMotion replacement
    -- This will eventually be lazy loaded but currently that would require too much maintainence
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>hw', [[<cmd>lua require'hop'.jump_words()<cr>]], {})
    end
  }
  use {
    'windwp/nvim-autopairs',
    config = function() require'nvim-autopairs'.setup() end,
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
    keys = { '<C-a>', '<C-x>', {'x', 'g<C-a>'}, {'x', 'g<C-x>'} },
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
      vim.keymap.xmap { '<C-a>', '<Plug>(dial-increment)' }
      vim.keymap.xmap { '<C-x>', '<Plug>(dial-decrement)' }
      vim.keymap.xmap { 'g<C-a>', '<Plug>(dial-increment-additional)' }
      vim.keymap.xmap { 'g<C-x>', '<Plug>(dial-decrement-additional)' }
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

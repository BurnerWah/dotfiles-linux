-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- Core plugins
  use 'svermeulen/nvim-moonmaker'
  use 'tjdevries/astronauta.nvim'

  -- Completion & Linting
  use {
    'nvim-treesitter/nvim-treesitter',
    --[[
      Highlighting engine for neovim

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
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
        },
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = true },
          smart_rename = {
            enable = true,
            keymaps = { smart_rename = 'grr' }
          },
        },
      }
      --[[
        Enable folding on very simple filetypes
        If the language would normally have an ftplugin, that's preferable to this.
        ]]
      vim.cmd(
        [[autocmd init FileType ]]..
        [[nix,ocaml,php,sparql,teal,toml,turtle,verilog]]..
        [[ setl foldmethod=expr foldexpr=nvim_treesitter#foldexpr()]]
        )
    end
  }
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      vim.g.coc_filetype_map = {
        catalog = 'xml',
        dtd = 'xml',
        smil = 'xml',
        xsd = 'xml',
      }
      --Welcome to keymap hell.
      vim.api.nvim_set_keymap(
        'n', '<leader>hh', [[<cmd>call CocActionAsync('doHover')<cr>]],
        { silent = true, noremap = true }
      )
      vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
      vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
      vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', {})
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
      vim.api.nvim_set_keymap('n', '<C-d>', '<Plug>(coc-range-select)', { silent = true })
      vim.api.nvim_set_keymap('x', '<C-d>', '<Plug>(coc-range-select)', { silent = true })
      vim.api.nvim_set_keymap('n', '<leader>x', '<Plug>(coc-cursors-operator)', {})
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
        ]]
        asciidoc = { 'alex', 'languagetool', 'writegood' },
        bats = { 'shellcheck' },
        c = { 'cc', 'clangtidy', 'cpplint' },
        cmake = { 'cmakelint' },
        cpp = { 'cc', 'clangtidy', 'cpplint' },
        css = { 'stylelint' },
        dockerfile = { 'hadolint' },
        elixir = { 'credo' },
        eruby = { 'erb' },
        fish = { 'fish' },
        gitcommit = { 'gitlint' },
        graphql = { 'eslint' },
        help = { 'alex', 'writegood' },
        html = { 'tidy', 'writegood' },
        javascript = { 'eslint', 'jshint', 'flow', 'standard', 'xo' },
        json = { 'jsonlint' },
        jsonc = { 'jsonlint' },
        less = { 'stylelint' },
        lua = { 'luacheck' },
        mail = { 'alex', 'languagetool' },
        markdown = { 'languagetool', 'markdownlint', 'writegood' },
        nroff = { 'alex', 'writegood' },
        objc = { 'clang' },
        objcpp = { 'clang' },
        php = { 'phpcs', 'phpstan' },
        po = { 'alex', 'writegood' },
        pod = { 'alex', 'writegood' },
        python = { 'flake8', 'mypy', 'pylint' },
        rst = { 'alex', 'rstcheck', 'writegood' },
        rust = { 'cargo' },
        sass = { 'stylelint' },
        scss = { 'stylelint' },
        sh = { 'shellcheck' },
        stylus = { 'stylelint' },
        sugarss = { 'stylelint' },
        teal = { 'tlcheck' },
        tex = { 'alex', 'writegood' },
        texinfo = { 'alex', 'writegood' },
        typescript = { 'eslint', 'standard', 'tslint', 'xo' },
        vim = { 'vint' },
        vimwiki = { 'alex', 'languagetool', 'markdownlint', 'mdl', 'remark-lint', 'writegood' },
        vue = { 'eslint' },
        xhtml = { 'alex', 'writegood' },
        xsd = { 'xmllint' },
        xml = { 'xmllint' },
        xslt = { 'xmllint' },
        yaml = { 'yamllint' },
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
        sql = { 'sql-format', 'remove_trailing_lines', 'trim_whitespace' },
        xml = { 'xmllint' },
      }
      vim.cmd [[autocmd init VimEnter * lua require('user.cleanup.ale')]]
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
  use 'euclidianAce/BetterLua.vim'
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
  use 'stsewd/sphinx.nvim'

  -- Telescope
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'nvim-treesitter',
      },
      config = function()
        vim.api.nvim_set_keymap(
          'n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]],
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]],
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]],
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]],
          { noremap = true, silent = true }
        )
      end
    },
    {
      'nvim-telescope/telescope-github.nvim',
      requires = 'telescope.nvim',
      config = function() require'telescope'.load_extension('gh') end
    },
    {
      'nvim-telescope/telescope-fzy-native.nvim',
      requires = 'telescope.nvim',
      config = function() require'telescope'.load_extension('fzy_native') end
    },
    {
      'nvim-telescope/telescope-project.nvim',
      requires = 'telescope.nvim',
      config = function()
        require'telescope'.load_extension('project')
        vim.api.nvim_set_keymap(
          'n',
          '<C-p>',
          [[<cmd>lua require'telescope'.extensions.project.project{}<CR>]],
          { noremap = true, silent = true }
        )
      end
    },
    {
      'nvim-telescope/telescope-packer.nvim',
      requires = 'telescope.nvim',
      config = function() require'telescope'.load_extension('packer') end
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      requires = { 'tami5/sql.nvim', 'telescope.nvim' },
      config = function()
        require'telescope'.load_extension('frecency')
        vim.api.nvim_set_keymap(
          'n',
          '<leader><leader>',
          [[<cmd>lua require'telescope'.extensions.frecency.frecency()<CR>]],
          { noremap = true, silent = true }
        )
      end
    },
    {
      'nvim-telescope/telescope-cheat.nvim',
      requires = { 'tami5/sql.nvim', 'telescope.nvim' },
      config = function() require'telescope'.load_extension('cheat') end
    },
    { 'nvim-telescope/telescope-fzf-writer.nvim', requires = 'telescope.nvim' },
    { 'nvim-telescope/telescope-symbols.nvim', requires = 'telescope.nvim' },
    { 'pwntester/octo.nvim', requires = 'telescope.nvim' , cmd = 'Octo' }
  }

  -- User interface
  use {
    'wfxr/minimap.vim',
    cmd = 'Minimap',
    config = function()
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
        'todoist',
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
    config = function()
      vim.g['vista#renderer#enable_icon'] = 1
      vim.g.vista_echo_cursor_strategy = 'floating_win'
      vim.g.vista_executive_for = {
        apiblueprint = 'markdown',
        c = 'coc',
        cpp = 'coc',
        cuda = 'coc',
        css = 'coc',
        go = 'coc',
        html = 'coc',
        javascript = 'coc',
        json = 'coc',
        jsonc = 'coc',
        lua = 'coc',
        markdown = 'toc',
        objc = 'coc',
        objcpp = 'coc',
        pandoc = 'markdown',
        python = 'coc',
        rst = 'toc',
        tex = 'coc',
        typescript = 'coc',
        vala = 'coc',
        vim = 'coc',
        vimwiki = 'markdown',
        xml = 'coc',
        yaml = 'coc',
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
    requires = { 'nvim-lua/plenary.nvim' },
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
    config = function()
      require'colorizer'.setup {
        'kitty',
        'less',
        css = { css = true },
        lua = { RGB = false, RRGGBB = true, names = false },
        vim = { RGB = false, RRGGBB = true, names = false },
      }
    end
  }
  use { 'meain/vim-package-info', ft = { 'json', 'requirements', 'toml' }, run = 'npm i' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' }
  }
  use {
    'vim-airline/vim-airline',
    --[[
      Bottom & Tabline plugin
      This will be replaced at some point, but it'll take a while to do so.
      Some extensions have to be disabled to mitigate how it sets up lazy loading.
    ]]
    requires = {
      'vim-airline/vim-airline-themes',
      'tyrannicaltoucan/vim-quantum',
      'ryanoasis/vim-devicons',
    },
    config = function()
      vim.g.airline_powerline_fonts = true
      vim.g.airline_detect_spelllang = false
      vim.g.airline_detect_crypt = false
      vim.g.airline_skip_empty_sections = 1
      vim.g.airline_symbols = {
        -- Stupid way to fix bad icon on my system
        dirty = ' ',
      }
      vim.g['airline#parts#ffenc#skip_expected_string'] = 'utf-8[unix]'
      vim.g['airline#extensions#vista#enabled'] = 0 -- Deals with Vista's lazy loader
      vim.g['airline#extensions#tabline#enabled'] = 1 -- Enable tabline
      vim.g.airline_filetype_overrides = {
        LuaTree = { 'LuaTree', '' },
        minimap = { 'Map', '' },
        todoist = { 'Todoist', '' },
        tsplayground = { 'Tree-Sitter Playground', '' },
        vista = { 'Vista', '' },
        vista_kind = { 'Vista', '' },
        vista_markdown = { 'Vista', '' },
      }
    end
  }
  use {
    'tjdevries/colorbuddy.nvim',
    -- Lua color scheme engine
    config = function() require('colorbuddy').colorscheme('user_colors') end
  }

  -- Utilities
  use 'tpope/vim-fugitive'
  use 'rliang/termedit.nvim'
  use 'farmergreg/vim-lastplace'
  use {
    'lukas-reineke/format.nvim',
    --[[
      Formatting utility
      This will likely replace some of ALE's functionality at some point.
    ]]
    config = function()
      -- TODO configure this
      vim.cmd [[autocmd init BufWritePost * FormatWrite]]
      require'format'.setup {
        markdown = {
          { cmd = [[prettier -w]] }
        }
      }
    end
  }
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
    --[[
      Neuron-based note-taking engine
      This will probably replace vimwiki at some point.
      Currently it doesn't work for me though, since the neuron binary crashes on my system.
    ]]
    requires = { 'nvim-lua/plenary.nvim', 'telescope.nvim' },
    keys = { {'n', 'gzi'} },
    config = function()
      require'neuron'.setup {
        virtual_titles = true,
        mappings = true,
        run = nil,
        neuron_dir = '~/Documents/Neuron',
        leader = 'gz',
      }
    end
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
  use {
    'romgrk/todoist.nvim',
    -- This isn't all that important tbh
    cmd = 'Todoist',
    run = 'npm i',
    config = function()
      vim.g.todoist = {
        icons = {
          unchecked = '  ',
          checked = '  ',
          loading = '  ',
          error = '  ',
        }
      }
    end
  }

  -- Text editing
  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use {
    'windwp/nvim-autopairs',
    config = function() require'nvim-autopairs'.setup() end
  }
  use {
    'tpope/vim-abolish',
    cmd = { 'Abolish', 'Subvert', 'S' },
    keys = {{'n', 'cr'}},
    config = function()
      vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end
  }
  use { 'tpope/vim-commentary', cmd = 'Commentary', keys = { 'gc', {'n', 'gcc'}, {'n', 'gcu'} } }
  use {
    'tpope/vim-surround',
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
    keys = { '<C-a>', '<C-x>', {'v', 'g<C-a>'}, {'v', 'g<C-x>'} },
    config = function()
      vim.api.nvim_set_keymap('n', '<C-a>', '<Plug>(dial-increment)', {})
      vim.api.nvim_set_keymap('n', '<C-x>', '<Plug>(dial-decrement)', {})
      vim.api.nvim_set_keymap('v', '<C-a>', '<Plug>(dial-increment)', {})
      vim.api.nvim_set_keymap('v', '<C-x>', '<Plug>(dial-decrement)', {})
      vim.api.nvim_set_keymap('v', 'g<C-a>', '<Plug>(dial-increment)', {})
      vim.api.nvim_set_keymap('v', 'g<C-x>', '<Plug>(dial-decrement)', {})
    end
  }
  use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }
  use {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign', 'LiveEasyAlign' },
    keys = { {'x', 'ga'}, {'n', 'ga'} },
    config = function()
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(LiveEasyAlign)', {})
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
    end
  }
end)

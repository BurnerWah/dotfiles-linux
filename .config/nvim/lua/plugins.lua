-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  use 'svermeulen/nvim-moonmaker'

  -- Completion & Linting
  use 'neovim/nvim-lspconfig'
  use { 'nvim-treesitter/nvim-treesitter',
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
            keymaps = { smart_rename = 'grr', }
          },
        },
      }
    end
  }
  use { 'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      vim.g.coc_filetype_map = {
        ['catalog'] = 'xml',
        ['dtd'] = 'xml',
        ['vimwiki'] = 'markdown',
        ['smil'] = 'xml',
        ['xsd'] = 'xml',
      }
      --Welcome to keymap hell.
      vim.api.nvim_set_keymap('n', '<leader>hh', [[:call CocActionAsync('doHover')]], {silent = true, noremap = true})
      vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', {silent = true})
      vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', {silent = true})
      vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})
      vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', {silent = true})
      vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
      vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {silent = true})
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
      vim.api.nvim_set_keymap('n', '<C-d>', '<Plug>(coc-range-select)', {silent = true})
      vim.api.nvim_set_keymap('x', '<C-d>', '<Plug>(coc-range-select)', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>x', '<Plug>(coc-cursors-operator)', {})
      vim.cmd [[autocmd init User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&spell', 0)]]
      vim.cmd [[autocmd init User CocOpenFloat call setwinvar(g:coc_last_float_win, '&winblend', 10)]]
    end
  }
  use {
    'dense-analysis/ale',
    config = function()
      vim.g.ale_fix_on_save = true
      vim.g.ale_disable_lsp = true
      vim.g.ale_linters_ignore = {
        ['asciidoc'] = {'alex', 'languagetool', 'writegood'},
        ['bats'] = {'shellcheck'},
        ['c'] = {'cc', 'clangtidy', 'cpplint'},
        ['cmake'] = {'cmakelint'},
        ['cpp'] = {'cc', 'clangtidy', 'cpplint'},
        ['css'] = {'stylelint'},
        ['dockerfile'] = {'hadolint'},
        ['elixir'] = {'credo'},
        ['eruby'] = {'erb'},
        ['fish'] = {'fish'},
        ['gitcommit'] = {'gitlint'},
        ['graphql'] = {'eslint'},
        ['help'] = {'alex', 'writegood'},
        ['html'] = {'tidy', 'writegood'},
        ['javascript'] = {'eslint', 'jshint', 'flow', 'standard', 'xo'},
        ['json'] = {'jsonlint'},
        ['jsonc'] = {'jsonlint'},
        ['less'] = {'stylelint'},
        ['lua'] = {'luacheck'},
        ['mail'] = {'alex', 'languagetool'},
        ['markdown'] = {'languagetool', 'markdownlint', 'writegood'},
        ['nroff'] = {'alex', 'writegood'},
        ['objc'] = {'clang'},
        ['objcpp'] = {'clang'},
        ['php'] = {'phpcs', 'phpstan'},
        ['po'] = {'alex', 'writegood'},
        ['pod'] = {'alex', 'writegood'},
        ['python'] = {'flake8', 'mypy', 'pylint'},
        ['rst'] = {'alex', 'rstcheck', 'writegood'},
        ['rust'] = {'cargo'},
        ['sass'] = {'stylelint'},
        ['scss'] = {'stylelint'},
        ['sh'] = {'shellcheck'},
        ['stylus'] = {'stylelint'},
        ['sugarss'] = {'stylelint'},
        ['teal'] = {'tlcheck'},
        ['tex'] = {'alex', 'writegood'},
        ['texinfo'] = {'alex', 'writegood'},
        ['typescript'] = {'eslint', 'standard', 'tslint', 'xo'},
        ['vim'] = {'vint'},
        ['vimwiki'] = {'alex', 'languagetool', 'markdownlint', 'writegood'},
        ['vue'] = {'eslint'},
        ['xhtml'] = {'alex', 'writegood'},
        ['xsd'] = {'xmllint'},
        ['xml'] = {'xmllint'},
        ['xslt'] = {'xmllint'},
        ['yaml'] = {'yamllint'},
        ['zsh'] = {'shell'},
      }
      vim.g.ale_fixers = {
        ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
        ['cpp'] = {'clangtidy', 'remove_trailing_lines', 'trim_whitespace'},
        ['go'] = {'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace'},
        ['html'] = {'tidy', 'remove_trailing_lines', 'trim_whitespace'},
        ['python'] = {'add_blank_lines_for_python_control_statements', 'reorder-python-imports', 'remove_trailing_lines', 'trim_whitespace'},
        ['rust'] = {'rustfmt', 'remove_trailing_lines', 'trim_whitespace'},
        ['sql'] = {'sql-format', 'remove_trailing_lines', 'trim_whitespace'},
        ['xml'] = {'xmllint'},
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
  use { 'jackguo380/vim-lsp-cxx-highlight', ft = {'c', 'cpp', 'objc', 'objcpp', 'cc', 'cuda'} }

  -- Lua
  use 'euclidianAce/BetterLua.vim'
  use 'tjdevries/manillua.nvim'
  use 'tjdevries/nlua.nvim'
  use { 'bfredl/nvim-luadev', cmd = 'Luadev' }
  use { 'rafcamlet/nvim-luapad', cmd = {'Lua', 'Luapad', 'LuaRun'} }

  -- Markdown
  use { 'npxbr/glow.nvim', ft = { 'markdown', 'pandoc.markdown', 'rmd', 'vimwiki' } }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
    opt = true
  }

  -- Python
  use 'vim-python/python-syntax'
  use 'Vimjas/vim-python-pep8-indent'

  -- RST
  use 'stsewd/sphinx.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'} },
    config = function()
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ff',
        ":lua require('telescope.builtin').find_files()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fg',
        ":lua require('telescope.builtin').live_grep()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fb',
        ":lua require('telescope.builtin').buffers()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fh',
        ":lua require('telescope.builtin').help_tags()<cr>",
        { noremap = true, silent = true }
      )
    end
  }
  use {
    'nvim-telescope/telescope-github.nvim',
    config = function()
      require('telescope').load_extension('gh')
    end
  }
  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    config = function()
      require('telescope').load_extension('fzy_native')
    end
  }
  use {
    'nvim-telescope/telescope-project.nvim',
    config = function()
      require('telescope').load_extension('project')
      vim.api.nvim_set_keymap(
        'n',
        '<C-p>',
        ":lua require'telescope'.extensions.project.project{}<CR>",
        { noremap = true, silent = true }
      )
    end
  }
  use {
    'nvim-telescope/telescope-packer.nvim',
    config = function()
      require('telescope').load_extension('packer')
    end
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    requires = {'tami5/sql.nvim'},
    config = function()
      require'telescope'.load_extension('frecency')
      vim.api.nvim_set_keymap(
        'n',
        '<leader><leader>',
        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        { noremap = true, silent = true }
      )
    end
  }
  use 'nvim-telescope/telescope-fzf-writer.nvim'
  use 'nvim-telescope/telescope-symbols.nvim'
  use { 'pwntester/octo.nvim', cmd = 'Octo' }

  -- User interface
  use {
    'wfxr/minimap.vim',
    cmd = 'Minimap',
    config = function()
      vim.g['minimap_block_filetypes'] = {
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
    cmd = 'Vista',
    config = function()
      vim.g['vista#renderer#enable_icon'] = 1
      vim.g['vista_echo_cursor_strategy'] = 'floating_win'
      vim.g['vista_executive_for'] = {
        ['apiblueprint'] = 'markdown',
        ['c'] = 'coc',
        ['cpp'] = 'coc',
        ['cuda'] = 'coc',
        ['css'] = 'coc',
        ['go'] = 'coc',
        ['html'] = 'coc',
        ['javascript'] = 'coc',
        ['json'] = 'coc',
        ['jsonc'] = 'coc',
        ['lua'] = 'coc',
        ['markdown'] = 'toc',
        ['objc'] = 'coc',
        ['objcpp'] = 'coc',
        ['pandoc'] = 'markdown',
        ['python'] = 'coc',
        ['rst'] = 'toc',
        ['tex'] = 'coc',
        ['typescript'] = 'coc',
        ['vala'] = 'coc',
        ['vim'] = 'coc',
        ['vimwiki'] = 'markdown',
        ['xml'] = 'coc',
        ['yaml'] = 'coc',
      }
      vim.g['vista_ctags_cmd'] = {
        ['go'] = 'gotags',
      }
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup()
    end
  }
  use {
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger',
    keys = {{'n', '<leader>gm'}}
  }
  use 'f-person/git-blame.nvim'
  use {
    'norcalli/nvim-colorizer.lua',
    ft = {'css', 'kitty', 'less', 'lua', 'vim'},
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
  use {
    'meain/vim-package-info',
    ft = {'json', 'requirements', 'toml'},
    run = 'npm install'
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    cmd = {'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile'}
  }
  use {
    'vim-airline/vim-airline',
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
      -- vim.g.airline_symbols['dirty'] = ' '
      vim.g['airline#parts#ffenc#skip_expected_string'] = 'utf-8[unix]'
      vim.g['airline#extensions#vista#enabled'] = 0
      vim.g['airline#extensions#tabline#enabled'] = 1
      vim.g.airline_filetype_overrides = {
        ['LuaTree'] = {'LuaTree', ''},
        ['minimap'] = {'Map', ''},
        ['todoist'] = {'Todoist', ''},
        ['tsplayground'] = {'Tree-Sitter Playground', ''},
        ['vista'] = {'Vista', ''},
        ['vista_kind'] = {'Vista', ''},
        ['vista_markdown'] = {'Vista', ''},
      }
    end
  }
  use {
    'tjdevries/colorbuddy.nvim',
    config = function()
      require('colorbuddy').colorscheme('user_colors')
    end
  }

  -- Utilities
  use 'tpope/vim-fugitive'
  use 'rliang/termedit.nvim'
  use 'farmergreg/vim-lastplace'
  use {
    'lukas-reineke/format.nvim',
    config = function()
      vim.cmd [[autocmd init BufWritePost * FormatWrite]]
    end
  }
  use {
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_list = {
        {
          ['path'] = '~/Documents/VimWiki',
          ['nested_syntaxes'] = {
            ['c++'] = 'cpp',
          }
        }
      }
      vim.g.vimwiki_folding = 'expr'
      vim.g.vimwiki_listsyms = '✗○◐●✓'
    end
  }
  use {
    'hkupty/iron.nvim',
    config = function()
      local iron = require('iron')

      iron.core.add_repl_definitions {
        fennel = { fennel = { command = { 'fennel', '--repl' }}},
        fish   = { fish   = { command = { 'fish' }}},
        gluon  = { gluon  = { command = { 'gluon', '-i' }}},
      }

      iron.core.set_config {
        preferred = {
          fennel = 'fennel',
          fish = 'fish',
          gluon = 'gluon',
          javascript = 'node',
          lua = 'lua',
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
    cmd = 'Todoist',
    run = 'npm i',
    opt = true,
    config = function()
      vim.g['todoist'] = {
        ['icons'] = {
          ['unchecked'] = '  ',
          ['checked'] = '  ',
          ['loading'] = '  ',
          ['error'] = '  ',
        }
      }
    end
  }

  -- Text editing
  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }
  use {
    'tpope/vim-abolish',
    cmd = { 'Abolish', 'Subvert', 'S' },
    keys = {{'n', 'cr'}},
    config = function()
      vim.g['abolish_save_file'] = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end
  }
  use {
    'tpope/vim-commentary',
    cmd = 'Commentary',
    keys = { 'gc', {'n', 'gcc'}, {'n', 'gcu'} }
  }
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
    'tpope/vim-speeddating',
    keys = {
      {'n', '<C-A>'},
      {'n', '<C-X>'},
      {'x', '<C-A>'},
      {'x', '<C-X>'},
      {'n', 'd<C-A>'},
      {'n', 'd<C-X>'},
    }
  }
  use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }
  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign', 'LiveEasyAlign'},
    keys = {
      {'x', 'ga'},
      {'n', 'ga'},
    },
    config = function()
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(LiveEasyAlign)', { noremap = false, silent = false })
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', { noremap = false, silent = false })
    end
  }
end)

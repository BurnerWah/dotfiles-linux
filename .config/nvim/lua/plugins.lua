-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- Filetypes

  -- Markdown
  use {
    'npxbr/glow.nvim',
    ft = { 'markdown', 'pandoc.markdown', 'rmd', 'vimwiki' },
    opt = true
  }

  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
    opt = true
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    },
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
  use 'nvim-telescope/telescope-fzf-writer.nvim'
  use 'nvim-telescope/telescope-symbols.nvim'
  use {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    opt = true,
  }

  -- User interface
  use {
    'wfxr/minimap.vim',
    cmd = 'Minimap',
    opt = true
    -- TODO add config
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Text editing
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }
end)

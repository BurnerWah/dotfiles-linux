======================
 Neovim Configuration
======================

Neovim_ is my preferred text editor. While Vim is acceptable, neovim
gives it that little push it needs to become a proper IDE.

I'm using the nvim 0.5 nighly release. It provides a built-in language client,
and has a much more powerful Lua API.

Most of my configuration is in Lua, with Vim script avoided when possible.

This is partially made possible via packer.nvim_, a plugin manager written in Lua.

.. _Neovim: https://neovim.io/
.. _packer.nvim: https://github.com/wbthomason/packer.nvim

Notable plugins
---------------

- astronauta.nvim_: Support for Lua ``plugins``, ``ftplugins``, and Lua API extensions
- plenary.nvim_: Library of nvim Lua functions.
  This is the underlying library for my custom filetype detection.
- nvim-lspconfig_: Configuration tool for language servers.
  It's a bit complicated to configure servers, but you get used to it.
- lspsaga.nvim_: User interface for the built-in language server.
  It's not perfect, but it's a capable UI.
  This also replaces nvim-lightbulb.
- nvim-compe_: An easy to configure and capable completion engine.
  I've written up a custom completion source for this.
- telescope.nvim_: Fuzzy finder.
- nvim-treesitter_: Plugin to work with nvim's tree-sitter support.
  This provides highlighting, completion, text objects, refactoring,
  folding, and formatting.
- vsnip_: Snippet engine with support for language server snippets.
- lsp-status.nvim_: Statusline objects for the language server.
  This lets us see the current function we're in, and LSP progress messages.
- nvim-bufferline.lua_: Buffer/tabline with LSP diagnostics in the tab info.
  It handle's tabs poorly but otherwise works well.
- galaxyline.nvim_: Statusline plugin.
  I use a custom statusline which works around some issues with galaxyline.
- colorbuddy.nvim_: Color scheme engine. I use a custom theme loosely based on vim-quantum.
- gitsigns.nvim_: Git diff info in ``signcolumn``.
- lspkind-nvim_: Show icons for types from LSP completions.
- format.nvim_: Formatting plugin.
- dial.nvim_: Improved ``<C-a>`` and ``<C-x>`` bindings.
- git-messenger.vim_: Easy way to view git commit info for the current line.
- nvim-hlslens_: Show more search information as virtual text.
- vista.vim_: Tagbar plugin with LSP support.

.. _astronauta.nvim: https://github.com/tjdevries/astronauta.nvim
.. _plenary.nvim: https://github.com/nvim-lua/plenary.nvim
.. _nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
.. _lspsaga.nvim: https://github.com/glepnir/lspsaga.nvim
.. _nvim-compe: https://github.com/hrsh7th/nvim-compe
.. _telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
.. _nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
.. _vsnip: https://github.com/hrsh7th/vim-vsnip
.. _lsp-status.nvim: https://github.com/nvim-lua/lsp-status.nvim
.. _nvim-bufferline.lua: https://github.com/akinsho/nvim-bufferline.lua
.. _galaxyline.nvim: https://github.com/glepnir/galaxyline.nvim
.. _colorbuddy.nvim: https://github.com/tjdevries/colorbuddy.nvim
.. _gitsigns.nvim: https://github.com/lewis6991/gitsigns.nvim
.. _lspkind-nvim: https://github.com/onsails/lspkind-nvim
.. _format.nvim: https://github.com/lukas-reineke/format.nvim
.. _dial.nvim: https://github.com/monaqa/dial.nvim
.. _git-messenger.vim: https://github.com/rhysd/git-messenger.vim
.. _nvim-hlslens: https://github.com/kevinhwang91/nvim-hlslens
.. _vista.vim: https://github.com/liuchengxu/vista.vim

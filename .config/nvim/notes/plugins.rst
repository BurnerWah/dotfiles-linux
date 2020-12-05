##############
 Plugin notes
##############

Dein
####

Dependency checking
===================
The following checks are assumed to always return ``v:true``:

* ``has('nvim')`` - We target neovim
* ``has('nvim-0.4.2')`` - Stable release of neovim
* ``executable('git')`` - Required for plugin manager
* ``executable('tar')`` - Soft dependency of linux
* ``executable('curl')`` - Soft dependency of linux

Checks which imply another check:

* ``has('nvim-x.y.z')`` - implies previous versions
* ``has('node')`` -> ``executable('npm')`` - Dependency


Dein configuration
==================
The ``merged`` option defaults to ``v:true`` unless an ``if`` or ``build``
option is present.

The ``rev`` option breaks ``type__depth``.

Installed
#########

Coc.nvim
========
Language client

Settings
--------
Some settings are in the tools notes.

* ``highlight.colors.enable = false``: Handled by nvim-colorizer.lua
* ``python.jediEnabled = false``: Enables Microsoft Python Language Server

vim-clap
========
Searching utility.

To improve performance, we use the optional ``maple`` binary & the optional
Python extension.
``maple`` is installed in the ``hook_post_update`` step, using an included
function to download it.
The Python extension is built locally, which requires ``make`` and ``cargo``.

vim-fugitive
============
Git support & integration.

Had an issue where it resolved symlinks too aggressively but it seems resolved.

vim-lsp-cxx-highlight
=====================
Provides enhanced highlighting for C/C++ files.

It requires a language server and a compatible language client.

Supported servers: ``ccls``, ``clangd``, & ``cquery``.

Supports built-in language client & Coc.nvim.

Don't check for ``cquery``; it's not maintained.

nvim-moonmaker
==============
Moonmaker can't merge. Doing so will make it clear the merged ``lua``
folder, breaking other plugins.


Avoiding
########

* nim.vim - ``ftplugin`` does too much
* vim-coffee-script - ``ftdetect`` is too aggressive, may cause slowdown
* vim-sparql -- ``ftdetect`` has side-effects
* swift.vim -- ``ftdetect`` may cause slowdown, unnecessary plugin
* python-mode -- Redundancy issues with nvim
* isort.nvim -- Broken

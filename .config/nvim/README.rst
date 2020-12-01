######################
 Neovim Configuration
######################

Neovim_ is my preferred text editor. While Vim is acceptable, neovim
gives it that little push it needs to become a proper IDE.

My preferred plugin manager right now is Dein.vim_, which doesn't have
much in the way of compatibility with other plugin managers.

Some of the essential plugins I'm using include:

.. _Neovim: https://neovim.io/
.. _Dein.vim: https://github.com/Shougo/dein.vim

Dependency Checking
###################

There's an argument to that dependency checks aren't needed, but
I feel like they're a good practice nonetheless.

Generally, we should check for dependencies that might not be present. So,
checking for a command like ``git`` is generally unhelpful, since it's required
by Dein.vim_. Checking for something from ``coreutils`` is unhelpfil, since it's
present on any linux system.

Plugins I Avoid
###############

There's a lot of plugins that I've tried out at some point, and found to work
poorly. To be exhaustive:

* stsewd/isort.nvim_ - Deleted lines erroneously, somewhat redundant with ALE_.
* python-mode/python-mode_ - A lot of redundant functionality, causes more problems than it solves.
* fatih/vim-go_ - A lot of redundant functionality that it's hard to turn off.
* kabbmine/zeavim.vim_ - Too aggressive with mappings. Could be brought back.
* aurieh/discord.nvim_ - Often renders nvim inoperable. Likely a bug.

.. _isort.nvim: https://github.com/stsewd/isort.nvim
.. _python-mode: https://github.com/python-mode/python-mode
.. _vim-go: https://github.com/fatih/vim-go
.. _zeavim.vim: https://github.com/kabbamine/zeavim.vim
.. _discord.nvim: https://github.com/aurieh/discord.nvim

Coc.nvim
########

Coc_ provides language server support for neovim. Admittedly that means
I'm probably going to remove it when `nvim 0.5` releases, as it

Coc also supports VSCode-like extensions, which is... it's fine I guess. The
main problem is that they're converted VSCode extension, so if there's a
problem you have with the VSCode extension, such as vscode-go_ installing local
copies of every tool that it uses except gopls_ for some reason, then you can
expect that to also appear in the Coc equivalent.

The biggest real problems with Coc_ would have to be:

* There isn't a (good) way to disable it for a buffer
* It can mess with your ``runtimepath``
* It doesn't play nicely with other plugins

None of those are deal breakers, but they're worth keeping in mind if you
decide you use it.

.. _Coc: https://github.com/neoclide/coc.nvim
.. _vscode-go: https://marketplace.visualstudio.com/items?itemName=ms-vscode.Go
.. _gopls: https://github.com/golang/tools/tree/master/gopls

Diagnostics
###########

There are currenrly four diagnostic providers: Language servers, ALE_, efm-ls_,
and diagnostic-ls_. Technically Coc extensions are also in there but they're
not my favourite.

diagnostic-ls_ and efm-ls_ cover a lot of the same ground: they run linters &
formatters. I like diagnostic-ls_ a little more since it's easier to configure,
and it's better integrated into Coc. That having been said, it requires node,
while efm-ls_ is a standalone Go binary.

The best source for diagnostics is always the language server. After that,
diagnostic-ls_ & efm-ls_ to manage linters. Then, ALE_ if nothing else works.

Language servers are always turned off in ALE_ since we never want duplicate
servers running.

.. _ALE: https://github.com/dense-analysis/ale
.. _diagnostic-ls: https://github.com/iamcco/diagnostic-languageserver
.. _efm-ls: https://github.com/mattn/efm-langserver

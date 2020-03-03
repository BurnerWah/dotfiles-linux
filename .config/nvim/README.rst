######################
 Neovim Configuration
######################

Neovim is my preferred text editor. While Vim is perfectly acceptable, neovim
gives it that little push it needs to become a proper IDE.

My preferred plugin manager right now is Dein.vim_, which doesn't really have
much in the way of compatibility with other plugin managers.

Some of the essential plugins I'm using include:

.. _Neovim: https://neovim.io/
.. _Dein.vim: https://github.com/Shougo/dein.vim

Coc.nvim
########

Coc.nvim_ provides language server support for neovim. Admittedly that means
I'm probably going to remove it when `nvim 0.5` releases, as it

Coc also supports VSCode-like extensions, which is... it's fine I guess. The
main problem is that they're converted VSCode extension, so if there's a
problem you have with the VSCode extension, such as vscode-go_ installing local
copies of every tool that it uses except gopls_ for some reason, then you can
expect that to also appear in the Coc equivalent.

The biggest real problems with Coc.nvim_ would have to be:

* There isn't a (good) way to disable it for a buffer
* It can screw with your ``runtimepath``
* It doesn't really play nicely with other plugins

Non of those are really deal breakers, but they're worth keeping in mind if you
decide you use it.

.. _Coc.nvim: https://github.com/neoclide/coc.nvim
.. _nvim 0.5: https://github.com/neovim/neovim/milestone/19
.. _vscode-go: https://marketplace.visualstudio.com/items?itemName=ms-vscode.Go
.. _gopls: https://github.com/golang/tools/tree/master/gopls

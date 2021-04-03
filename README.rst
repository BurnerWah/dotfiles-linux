==================
 Jaden's dotfiles
==================

Configuration files for a bunch of random programs.

Tools I use
-----------

* I use Fedora_ as my main OS.
* Desktop environment: GNOME_.
* Editor: neovim_.
* My default shell is Zsh, but for interactive shells I use Fish.
* My primary python REPL is IPython_.
* CXX toolchain: clang_ + LLVM_.
* Coreutils: uutils_

.. _Fedora: https://getfedora.org/
.. _GNOME: https://www.gnome.org/
.. _neovim: https://neovim.io/
.. _IPython: https://ipython.org/
.. _clang: https://clang.llvm.org/
.. _LLVM: https://llvm.org/
.. _uutils: https://github.com/uutils/coreutils

Oddities
--------

* I use the system package manager (DNF) most of the time.
* I use environment variables to make programs use XDG base directories [1]_.
  Some of the methods are from the Arch Linux Wiki [2]_, while others
  are my own.

.. [1] https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
.. [2] https://wiki.archlinux.org/index.php/XDG_Base_Directory


.. vim:ft=rst tw=79

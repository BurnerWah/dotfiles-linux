=======
 Tools
=======

Semi-exhaustive list of tools that integrate with neovim, with notes.

Language Servers
================

Shared:

* diagnostic-ls_ - Linting & formatting (Via coc-diagnostic)
* efm-ls_ - Full language server

Specific:

* gopls_ - ``go``
* vimls_ - ``viml`` (Via coc-vimlsp)
* sqlls_ - ``sql``
* rls_ - ``rust`` (Via coc-rls)
* ccls_ - ``c``, ``cpp``, ``cuda``, ``objc``, ``objcpp``
* pyright_ - ``python`` (Via coc-pyright)
* lua-lsp_ - ``lua`` (Needs update for Lua 5.4)
* dockerls_ - ``dockerfile`` (Via coc-docker)
* LemMinX_ - ``xml`` (Via coc-xml)
* dotls_ - ``dot``
* fortls_ - ``fortran``
* bashls_ - ``sh``
* cssls_ - ``css``, ``less``, ``sass`` (Via coc-css)
* cmakels_ - ``cmake``
* jsonls_ - ``json``, ``jsonc`` (Via coc-json)
* yamlls_ - ``yaml`` (Via coc-yaml)
* htmlls_ - ``html`` (Via coc-html)
* jedils_ - ``python`` (Via coc-jedi)
* pyls_ - ``python``

Considering usage:

* sqls_ - ``sql`` (Go implementation)

.. _efm-ls: https://github.com/mattn/efm-langserver
.. _gopls: https://godoc.org/golang.org/x/tools/gopls
.. _sqlls: https://github.com/joe-re/sql-language-server
.. _sqls: https://github.com/lighttiger2505/sqls
.. _rls: https://github.com/rust-lang/rls
.. _ccls: https://github.com/MaskRay/ccls
.. _pyright: https://github.com/microsoft/pyright
.. _lua-lsp: https://github.com/Alloyed/lua-lsp
.. _dockerls: https://github.com/rcjsuen/dockerfile-language-server-nodejs
.. _LemMinX: https://github.com/eclipse/lemminx
.. _dotls: https://github.com/nikeee/dot-language-server
.. _fortls: https://github.com/hansec/fortran-language-server
.. _bashls: https://github.com/bash-lsp/bash-language-server
.. _cssls: https://github.com/vscode-langservers/vscode-css-languageserver-bin
.. _cmakels: https://github.com/regen100/cmake-language-server
.. _jsonls: https://github.com/vscode-langservers/vscode-json-languageserver
.. _yamlls: https://github.com/redhat-developer/yaml-language-server
.. _htmlls: https://github.com/vscode-langservers/vscode-html-languageserver-bin
.. _jedils: https://github.com/pappasam/jedi-language-server
.. _pyls: https://github.com/palantir/python-language-server

diagnostic-ls
-------------
`GitHub <https://github.com/iamcco/diagnostic-languageserver>`_

Default options:

* ``isStdout``: true
* ``isStderr``: false
* ``formatLines``: 1
* ``offsetLine``: 0
* ``offsetColumn``: 0
* ``debounce``: 100 (min value)


Pre-processed ``args`` entries:

* ``%filename``: file basename
* ``%text``: file contents
* ``%file``: file path, disables stdio
* ``%filepath``: file path, keeps stdio on
* ``%tempfile``: temporary file, disables stdio

Helpful settings:

* Setting ``offsetColumn`` to -1 stops full-line diagnostics from showing up on the next line.

vimls
-----
`GitHub <https://github.com/iamcco/vim-language-server>`_

Set ``vimlsp.suggest.fromRuntimepath`` to ``true``. It runs fine.

Linters
=======

* gitlint_ - ``gitcommit``
* vint_ - ``viml``

gitlint
-------
`GitHub <https://github.com/jorisroovers/gitlint>`_

When set-up with diagnostic-ls_, gitlint doesn't process the STDIN.
Mitigated by using a ``%tempfile``.

vint
----
`GitHub <https://github.com/Vimjas/vint>`_

The default config for diagnostic-ls_ doesn't use vint's ``--json`` flag.

Vint can optionally show style problems.

It's best to leave vint off if vimls_ is enabled, since most diagnostics are the same.

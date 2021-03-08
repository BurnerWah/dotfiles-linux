=======
 Tools
=======

A detailed list of tools I've configured to integrate with nvim, and how.

Language Servers
================

All language servers configured via nvim-lspconfig.

* bash-language-server_
* ccls_ - Clang-family languages.
  Also used for LSP highlighting.
* clangd_ - Clang-family languages.
  Has `optional config file <https://clangd.llvm.org/config.html>`__.
* cmake-language-server_
* cssls_ - CSS, SASS/SCSS, Less.
* deno-lsp_ - JS, TS.
* diagnostic-languageserver_ - Any language.
  Runs linters & formatters on files.
* dockerls_
* dotls (custom config)
* efm-langserver_ - Any language.
  Generic server for linters, formatters, documentation, and completion.
* fortran-language-server_
* gopls_
* htmlls_
* jedi-language-server_
* jsonls_
* lsp4xml (custom config)
* pyls-ms_
* pyright_
* rust-analyzer_
* sql-language-server_
* sqls_
* sumneko-lua_
* texlab_
* tsserver_
* vimls_
* yamlls_

.. _bash-language-server: https://github.com/bash-lsp/bash-language-server
.. _ccls: https://github.com/MaskRay/ccls/wiki
.. _clangd: https://clangd.llvm.org/
.. _cmake-language-server: https://github.com/regen100/cmake-language-server
.. _cssls: https://github.com/vscode-langservers/vscode-css-languageserver-bin
.. _deno-lsp: https://deno.land/
.. _diagnostic-languageserver: https://github.com/iamcco/diagnostic-languageserver
.. _dockerls: https://github.com/rcjsuen/dockerfile-language-server-nodejs
.. _efm-langserver: https://github.com/mattn/efm-langserver
.. _fortran-language-server: https://github.com/hansec/fortran-language-server
.. _gopls: https://pkg.go.dev/golang.org/x/tools/gopls
.. _htmlls: https://github.com/vscode-langservers/vscode-html-languageserver-bin
.. _jedi-language-server: https://github.com/pappasam/jedi-language-server
.. _jsonls: https://github.com/vscode-langservers/vscode-json-languageserver
.. _pyls-ms: https://github.com/Microsoft/python-language-server
.. _pyright: https://github.com/microsoft/pyright
.. _rust-analyzer: https://github.com/rust-analyzer/rust-analyzer
.. _sql-language-server: https://github.com/joe-re/sql-language-server
.. _sqls: https://github.com/lighttiger2505/sqls
.. _sumneko-lua: https://github.com/sumneko/lua-language-server
.. _texlab: https://texlab.netlify.app/
.. _tsserver: https://github.com/theia-ide/typescript-language-server
.. _vimls: https://github.com/iamcco/vim-language-server
.. _yamlls: https://github.com/redhat-developer/yaml-language-server

Linters
=======

I've connected linters up to nvim via efm-langserver, diagnostic-languageserver,
and extracted VSCode Extensions. ALE is a fallback.

* alex_ - Text Languages
  Adapted via the `VSCode extension <https://marketplace.visualstudio.com/items?itemName=TLahmann.alex-linter>`__.
* bashate_ - Bash
* cmake-lint_ - CMake
* cppcheck_ - C/C++
* csslint_ - CSS
* eslint_ - JS, TS, GraphQL, Vue
  Adapted via the `VSCode extension <https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint>`__.
* fish-shell_ - Fish
  Addapted via diagnostic-ls. Detects syntax errors.
* flawfinder_ - C/C++
* gitlint_ - Git commits
* hadolint_ - Dockerfiles
* html-tidy_ - HTML
* jq_ - JSON
* jshint_ - JS, HTML?
  Adapted via a `fork <https://github.com/YaBoiBurner/vscode-jshint>`__ of the
  `VSCode JSHint <https://marketplace.visualstudio.com/items?itemName=dbaeumer.jshint>`__ extension.
* jsonlint_ - JSON
* luacheck_ - Lua
* markdownlint_ - Markdown
* mypy_ - Python
* pylint_ - Python
* rst-lint_ - reStructuredText
* rstcheck_ - reStructuredText
* shellcheck_ - Bash, ksh, ash
* spectral_ - JSON, YAML
  Adapted via the `VSCode extension <https://marketplace.visualstudio.com/items?itemName=stoplight.spectral>`__.
* sqlint_ - SQL
* standard-js_ - JS, TS
* stylelint_ - CSS-like, HTML
  Adapted via the `VSCode extension <https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint>`__.
* textlint_ - Text languages
  Adapted via the `VSCode extension <https://marketplace.visualstudio.com/items?itemName=taichi.vscode-textlint>`__.
* write-good_ - Text Languages
* xmllint_ - XML
* xo-js_ - JS, TS
* zsh-shell_ - Zsh
  Addapted via diagnostic-ls. Detects syntax errors.

.. _alex: https://alexjs.com
.. _bashate: https://github.com/openstack/bashate
.. _cmake-lint: https://github.com/richq/cmake-lint
.. _cppcheck: http://cppcheck.sourceforge.net
.. _csslint: https://github.com/CSSLint/csslint
.. _eslint: https://eslint.org
.. _fish-shell: https://fishshell.com
.. _flawfinder: https://dwheeler.com/flawfinder
.. _gitlint: https://jorisroovers.com/gitlint
.. _hadolint: https://github.com/hadolint/hadolint
.. _html-tidy: https://www.html-tidy.org
.. _jq: https://stedolan.github.io/jq
.. _jshint: https://jshint.com
.. _jsonlint: https://zaa.ch/jsonlint
.. _luacheck: https://github.com/mpeterv/luacheck
.. _markdownlint: https://github.com/DavidAnson/markdownlint
.. _mypy: https://mypy.readthedocs.io/en/stable
.. _pylint: https://pylint.org
.. _rst-lint: https://github.com/twolfson/restructuredtext-lint
.. _rstcheck: https://github.com/myint/rstcheck
.. _shellcheck: https://www.shellcheck.net
.. _spectral: https://stoplight.io/open-source/spectral
.. _sqlint: https://github.com/purcell/sqlint
.. _standard-js: https://standardjs.com
.. _stylelint: https://stylelint.io
.. _textlint: https://textlint.github.io
.. _write-good: https://github.com/btford/write-good
.. _xmllint: http://xmlsoft.org/xmllint.html
.. _xo-js: https://github.com/xojs/xo
.. _zsh-shell: http://zsh.sourceforge.net

Formatters
==========

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

require('navigation')

--local ts_textobjects = {
--  --[[
--    This is here to mitigate nvim-treesitter-textobjects#27
--    Keep synced w/ https://github.com/nvim-treesitter/nvim-treesitter-textobjects#built-in-textobjects
--    until #27 is fixed.
--    ]]
--  ['@class.inner'] = { -- 5
--    c = '@class.inner',
--    cpp = '@class.inner',
--    dart = '@class.inner',
--    go = '@class.inner',
--    javascript = '@class.inner',
--    python = '@class.inner',
--    rst = '@class.inner',
--    rust = '@class.inner',
--    tsx = '@class.inner',
--    typescript = '@class.inner',
--  },
--  ['@class.outer'] = { -- 6
--    c = '@class.outer',
--    cpp = '@class.outer',
--    dart = '@class.outer',
--    go = '@class.outer',
--    javascript = '@class.outer',
--    python = '@class.outer',
--    ql = '@class.outer',
--    rst = '@class.outer',
--    rust = '@class.outer',
--    tsx = '@class.outer',
--    typescript = '@class.outer',
--    verilog = '@class.outer',
--  },
--  ['@comment.outer'] = { -- 7
--    bash = '@comment.outer', -- Custom
--    c = '@comment.outer',
--    cpp = '@comment.outer',
--    css = '@comment.outer', -- Custom
--    dart = '@comment.outer',
--    go = '@comment.outer',
--    html = '@comment.outer', -- Custom
--    java = '@comment.outer', -- Custom
--    javascript = '@comment.outer', -- Custom
--    lua = '@comment.outer',
--    python = '@comment.outer',
--    query = '@comment.outer', -- Custom
--    rst = '@comment.outer',
--    ruby = '@comment.outer', -- Custom
--    rust = '@comment.outer', -- Custom
--    toml = '@comment.outer', -- Custom
--    tsx = '@comment.outer', -- Custom, inhereted from typescript
--    typescript = '@comment.outer', -- Custom, inhereted from javascript
--    verilog = '@comment.outer',
--  },
--  ['@function.inner'] = { -- 10
--    c = '@function.inner',
--    c_sharp = '@function.inner',
--    cpp = '@function.inner',
--    dart = '@function.inner',
--    go = '@function.inner',
--    javascript = '@function.inner',
--    python = '@function.inner',
--    ql = '@function.inner',
--    rst = '@function.inner',
--    rust = '@function.inner',
--    tsx = '@function.inner',
--    typescript = '@function.inner',
--  },
--  ['@function.outer'] = { -- 11
--    c = '@function.outer',
--    c_sharp = '@function.outer',
--    cpp = '@function.outer',
--    dart = '@function.outer',
--    go = '@function.outer',
--    javascript = '@function.outer',
--    lua = '@function.outer',
--    python = '@function.outer',
--    ql = '@function.outer',
--    rst = '@function.outer',
--    rust = '@function.outer',
--    txt = '@function.outer',
--    typescript = '@function.outer',
--    verilog = '@function.outer',
--  },
--  ['@parameter.inner'] = { -- 14
--    c = '@parameter.inner',
--    cpp = '@parameter.inner',
--    dart = '@parameter.inner',
--    go = '@parameter.inner',
--    javascript = '@parameter.inner',
--    lua = '@parameter.inner',
--    python = '@parameter.inner',
--    rust = '@parameter.inner',
--    tsx = '@parameter.inner',
--    typescript = '@parameter.inner',
--  },
--}

--require'nvim-treesitter.configs'.setup {
--  ensure_installed = 'maintained',
--  highlight = { enable = true },
--  incremental_selection = {
--    enable = true,
--    keymaps = {
--      init_selection = 'gnn',
--      node_incremental = 'grn',
--      scope_incremental = 'grc',
--      node_decremental = 'grm',
--    },
--  },
--  textobjects = {
--    --[[
--      NOTE We cant use [count]s (fixed by nvim-treesitter-textobjects#8)
--      NOTE Move mappings don't work in visual mode (nvim-treesitter-textobjects#6)
--           They miss mapmodes v, x, and o
--      NOTE thus far, maps like '[(' or '[{' don't work, even with custom objects.
--      FIXME objects ALWAYS get mapped (nvim-treesitter-textobjects#27)
--      ]]
--    select = {
--      enable = true,
--      keymaps = {
--        ['af'] = ts_textobjects["@function.outer"],
--        ['if'] = ts_textobjects["@function.inner"],
--        ['ac'] = ts_textobjects["@class.outer"],
--        ['ic'] = ts_textobjects["@class.inner"],

--        -- Temporary mitigation for #6
--        [']]'] = ts_textobjects["@class.outer"],
--        ['[['] = ts_textobjects["@class.outer"],
--        [']['] = ts_textobjects["@class.outer"],
--        ['[]'] = ts_textobjects["@class.outer"],
--        [']m'] = ts_textobjects["@function.outer"],
--        [']M'] = ts_textobjects["@function.outer"],
--        ['[m'] = ts_textobjects["@function.outer"],
--        ['[M'] = ts_textobjects["@function.outer"],
--        ['[*'] = ts_textobjects["@comment.outer"],
--        [']*'] = ts_textobjects["@comment.outer"],
--        ['[/'] = ts_textobjects["@comment.outer"],
--        [']/'] = ts_textobjects["@comment.outer"],
--      },
--    },
--    swap = {
--      enable = true,
--      swap_next = { ['<leader>a'] = ts_textobjects["@parameter.inner"], },
--      swap_prev = { ['<leader>A'] = ts_textobjects["@parameter.inner"], },
--    },
--    move = {
--      enable = true,
--      goto_next_start = {
--        [']m'] = ts_textobjects["@function.outer"],
--        [']]'] = ts_textobjects["@class.outer"],
--      },
--      goto_next_end = {
--        [']M'] = ts_textobjects["@function.outer"],
--        [']['] = ts_textobjects["@class.outer"],
--        [']*'] = ts_textobjects["@comment.outer"],
--        [']/'] = ts_textobjects["@comment.outer"],
--      },
--      goto_previous_start = {
--        ['[m'] = ts_textobjects["@function.outer"],
--        ['[['] = ts_textobjects["@class.outer"],
--        ['[*'] = ts_textobjects["@comment.outer"],
--        ['[/'] = ts_textobjects["@comment.outer"],
--      },
--      goto_previous_end = {
--        ['[M'] = ts_textobjects["@function.outer"],
--        ['[]'] = ts_textobjects["@class.outer"],
--      },
--    },
--  },
--  playground = {
--    enable = true,
--    disable = {},
--    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--    persist_queries = false, -- Whether the query persists across vim sessions
--  },
--  refactor = {
--    highlight_definitions = { enable = true },
--    highlight_current_scope = { enable = true },
--    smart_rename = {
--      enable = true,
--      keymaps = { smart_rename = 'grr', }
--    },
--  },
--  rainbow = {
--    --[[
--      Rainbow brackets. We don't want them on a lot of filetypes.
--      NOTE this has pretty severe performance issues (see p00f/nvim-ts-rainbow#5),
--      so it can't be turned on under any circumstances right now.
--      ]]
--    enable = false,
--    disable = {
--      'bash', 'c', 'cpp', 'css', 'dart', 'go', 'html', 'java', 'javascript',
--      'kotlin', 'lua', 'nix', 'ocaml', 'python', 'rst', 'ruby', 'rust', 'teal',
--      'typescript', 'verilog', 'ql',
--    },
--  },
--}

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.bash.used_by = "PKGBUILD"
-- parser_config.html.used_by = "xhtml"

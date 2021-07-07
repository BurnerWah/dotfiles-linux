local tablex = require('pl.tablex')
---Helper to define table for a capture's support
---@param capture string Capture group
local async
async = vim.loop.new_async(vim.schedule_wrap(function()

  ---@param langs string[] Supported languages
  ---@return table<string, string>
  local function make_support_table(capture, langs)
    assert(type(capture) == 'string')
    assert(type(langs) == 'table')
    -- vim.validate {capture = {capture, 'string'}, langs = {langs, 'table'}}
    local R = {}
    tablex.foreach(langs, function(lang) R[lang] = capture end)
    return R
  end

  -- Support table for various text objects (that i'm using)
  -- remove once nvim-treesitter-textobjects#27 is fixed
  local text_objects = {
    class = {
      inner = make_support_table('@class.inner', {
        'c', 'cpp', 'dart', 'go', 'html', 'java', 'javascript', 'php', 'python', 'rst', 'rust',
        'tsx', 'typescript',
      }),
      outer = make_support_table('@class.outer', {
        'c', 'cpp', 'dart', 'go', 'html', 'java', 'javascript', 'php', 'python', 'ql', 'rst',
        'rust', 'tsx', 'typescript', 'verilog',
      }),
    },
    comment = {
      outer = make_support_table('@comment.outer', {
        'bash', 'c', 'cpp', 'css', 'dart', 'fennel', 'go', 'html', 'java', 'javascript', 'jsonc',
        'lua', 'python', 'query', 'rst', 'ruby', 'rust', 'toml', 'verilog',
        -- custom: css, fennel, html, java, javascript, jsonc, query, ruby, rust, toml
      }),
    },
    fn = {
      inner = make_support_table('@function.inner', {
        'bash', 'c', 'c_sharp', 'cpp', 'dart', 'fennel', 'go', 'html', 'java', 'javascript', 'php',
        'python', 'ql', 'rst', 'rust', 'tsx', 'typescript',
        -- custom: fennel
      }),
      outer = make_support_table('@function.outer', {
        'bash', 'c', 'c_sharp', 'cpp', 'dart', 'fennel', 'go', 'html', 'java', 'javascript', 'lua',
        'php', 'python', 'ql', 'rst', 'rust', 'tsx', 'typescript', 'verilog',
        -- custom: fennel
      }),
    },
    parameter = {
      inner = make_support_table('@parameter.inner', {
        'c', 'cpp', 'dart', 'go', 'java', 'javascript', 'lua', 'php', 'python', 'rust', 'tsx',
        'typescript',
      }),
    },
    -- beyond this are custom captures
    string = {
      double = {
        inner = make_support_table('@string.double.inner', {'json', 'jsonc'}),
        outer = make_support_table('@string.double.outer', {
          'bash', 'javascript', 'json', 'jsonc', 'lua', 'query', 'rust', 'toml',
        }),
      },
      single = {
        outer = make_support_table('@string.single.outer', {'bash', 'javascript', 'lua', 'toml'}),
      },
    },
    ambig = {
      braces = {
        inner = make_support_table('@ambig.braces.inner', {'json', 'jsonc'}),
        outer = make_support_table('@ambig.braces.outer', {'json', 'jsonc', 'lua', 'query', 'toml'}),
      },
      brackets = {
        inner = make_support_table('@ambig.brackets.inner', {'json', 'jsonc'}),
        outer = make_support_table('@ambig.brackets.outer', {'css', 'json', 'jsonc', 'toml'}),
      },
      parens = {
        inner = make_support_table('@ambig.parens.inner', {'bash'}),
        outer = make_support_table('@ambig.parens.outer', {'bash', 'css', 'lua', 'query'}),
      },
    },
  }

  require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained',
    ignore_install = {'kotlin', 'verilog'}, -- These parsers are really big
    highlight = {enable = true},
    incremental_selection = {enable = true},
    indent = {enable = true}, -- Indent uses 'tabstop' so it has to be managed in ftplugins.
    playground = {enable = true},
    refactor = {highlight_definitions = {enable = true}, smart_rename = {enable = true}},
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = text_objects.fn.outer,
          ['if'] = text_objects.fn.inner,
          ['ac'] = text_objects.class.outer,
          ['ic'] = text_objects.class.inner,
          -- Vim-like
          ['a\''] = text_objects.string.single.outer,
          ['a"'] = text_objects.string.double.outer,
          ['i"'] = text_objects.string.double.inner,
          ['a/'] = text_objects.comment.outer,
          ['a*'] = text_objects.comment.outer,
          -- Ambiguous selections
          ['a['] = text_objects.ambig.braces.outer,
          ['a]'] = text_objects.ambig.braces.outer,
          ['i['] = text_objects.ambig.braces.inner,
          ['i]'] = text_objects.ambig.braces.inner,
          ['a{'] = text_objects.ambig.brackets.outer,
          ['a}'] = text_objects.ambig.brackets.outer,
          ['i{'] = text_objects.ambig.brackets.inner,
          ['i}'] = text_objects.ambig.brackets.inner,
          ['a('] = text_objects.ambig.parens.outer,
          ['a)'] = text_objects.ambig.parens.outer,
          ['i('] = text_objects.ambig.parens.inner,
          ['i)'] = text_objects.ambig.parens.inner,
          ['a`'] = {
            bash = '@ambig.tilde.outer',
            javascript = '@string.template.outer',
            lua = '@string.any.outer',
            toml = '@string.any.outer', -- mostly for multi-line strings
          },
          ['i`'] = {bash = '@ambig.tilde.inner'},
        },
      },
      move = {
        enable = true,
        goto_next_start = {[']m'] = text_objects.fn.outer, [']]'] = text_objects.class.outer},
        goto_next_end = {
          [']M'] = text_objects.fn.outer,
          [']['] = text_objects.class.outer,
          [']*'] = text_objects.comment.outer,
          [']/'] = text_objects.comment.outer,
        },
        goto_previous_start = {
          ['[m'] = text_objects.fn.outer,
          ['[['] = text_objects.class.outer,
          ['[*'] = text_objects.comment.outer,
          ['[/'] = text_objects.comment.outer,
        },
        goto_previous_end = {['[M'] = text_objects.fn.outer, ['[]'] = text_objects.class.outer},
      },
      swap = {
        enable = true,
        swap_next = {['<Leader>a'] = text_objects.parameter.inner},
        swap_previous = {['<Leader>A'] = text_objects.parameter.inner},
      },
    },
    textsubjects = {
      enable = true,
      keymaps = {['.'] = 'textsubjects-smart', [';'] = 'textsubjects-container-outer'},
    },
    autotag = {enable = true},
    context_commentstring = {enable = true},
    autopairs = {enable = true},
    tree_docs = {enable = true},
  })
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.bash.used_by = {'PKGBUILD'}

  async:close()
end))

async:send()

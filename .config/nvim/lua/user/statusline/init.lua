-- Incomplete statusline config loosely based on nvcode (but with increasingly significant changes)
local gl = require('galaxyline')
local codicons = require('codicons')
local gls = gl.section
gl.short_line_list = {'LuaTree', 'dbui', 'minimap', 'vista', 'vista_kind', 'vista_markdown'}
local condit = require('galaxyline.condition')
local lsp_status = require('user.statusline.lsp')
-- TODO integrate better with gitsigns.nvim
-- TODO integrate better with tree-sitter

local colors = {
  bg = '#292929',
  bg_dark = '#0f0f0f',
  yellow = '#d5b875',
  cyan = '#69c5ce',
  darkblue = '#05111d', -- derived -> #4593de #247acb #1d609f #154574 #0d2b49 #05111d
  indigo_dark5 = '#101644', -- derived
  green = '#87bb7c',
  orange = '#d7956e',
  deep_orange = '#e64a19',
  purple = '#8562d2',
  deep_purple = '#512da8',
  deep_purple_dark3 = '#160c2f',
  magenta = '#d16d9e', -- TODO
  grey = '#bdbdbd',
  gray3 = '#757575',
  gray_dark = '#a4a4a4',
  blue = '#70ace5',
  red = '#dd7186', -- NOTE consider changing this
}

local mode = {
  get = function() return vim.in_fast_event() and 'fallback' or vim.api.nvim_get_mode().mode end,
  color = {
    fallback = colors.purple,
    n = colors.purple,
    no = colors.magenta,
    i = colors.green,
    v = colors.blue,
    [''] = colors.blue,
    V = colors.blue,
    c = colors.purple,
    s = colors.orange,
    S = colors.orange,
    [''] = colors.orange,
    ic = colors.yellow,
    R = colors.red,
    Rv = colors.red,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!'] = colors.red,
    t = colors.red,
  },
  name = {
    fallback = 'NVCode',
    n = 'NORMAL',
    no = 'OP PENDING',
    v = 'VISUAL',
    V = 'V-LINE',
    [''] = 'V-BLOCK',
    s = 'SELECT',
    S = 'S-LINE',
    [''] = 'S-BLOCK',
    i = 'INSERT',
    ic = 'INSERT COMPL',
    R = 'REPLACE',
    Rv = 'V REPLACE',
    c = 'COMMAND',
    -- cv = colors.red,
    -- ce = colors.red,
    -- r = colors.cyan,
    -- rm = colors.cyan,
    -- ['r?'] = colors.cyan,
    -- ['!'] = colors.red,
    t = 'TERMINAL',
  },
}

-- Small structure to retain color (helps avoid issues with odd buffers)
local cache = {FileIcon = {fg = nil}, ViMode = {fg = nil, name = nil}}

gls.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color & name according the vim mode
      if not vim.in_fast_event() then
        cache.ViMode.fg = mode.color[mode.get() or 'fallback'] or mode.color['fallback']
        cache.ViMode.name = mode.name[mode.get() or 'fallback'] or mode.name['fallback']
      end
      vim.cmd('hi GalaxyViMode guibg=' .. cache.ViMode.fg)
      vim.cmd('hi ViModeSeparator guifg=' .. cache.ViMode.fg)
      return ('  %s '):format(cache.ViMode.name)
      -- vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode.color[mode.get() or 'n'])
      -- vim.api.nvim_command('hi ViModeSeparator guifg=' .. mode.color[mode.get() or 'n'])
      -- return ('  %s '):format(mode.name[mode.get() or 'fallback'] or 'NVCode')
    end,
    separator = ' ',
    separator_highlight = {
      colors.yellow, function()
        if not condit.buffer_not_empty() and vim.bo.buflisted then
          return (condit.check_git_workspace() and colors.deep_purple or colors.bg)
        end
        return colors.darkblue
      end,
    },
    highlight = {colors.bg, nil, 'bold'},
  },
}
gls.left[2] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condit.buffer_not_empty,
    highlight = {
      function()
        local c = require('galaxyline.provider_fileinfo').get_file_icon_color()
        cache.FileIcon.fg = (vim.bo.buflisted and c or cache.FileIcon.fg)
        return cache.FileIcon.fg
      end, colors.darkblue,
    },
  },
  FileType = {
    provider = function() return vim.bo.filetype end,
    condition = condit.buffer_not_empty,
    separator = ' ',
    separator_highlight = {colors.darkblue, colors.darkblue},
    highlight = {colors.gray3, colors.darkblue},
  },
}
gls.left[3] = {
  FileName = {
    provider = {'FileName', 'FileSize'},
    condition = condit.buffer_not_empty,
    separator = '',
    separator_highlight = {
      function()
        return (condit.check_git_workspace() and colors.deep_purple or colors.darkblue)
      end, colors.darkblue,
    },
    highlight = {colors.grey, colors.darkblue},
  },
  FileNameFallbackSep = {
    provider = function() return '' end,
    condition = function() return condit.buffer_not_empty() and not condit.check_git_workspace() end,
    highlight = {colors.darkblue, colors.bg},
  },
}
gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condit.check_git_workspace,
    highlight = {colors.deep_orange, colors.deep_purple},
  },
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    separator = '',
    separator_highlight = {colors.deep_purple, colors.bg},
    condition = condit.check_git_workspace,
    highlight = {colors.grey, colors.deep_purple},
  },
}
gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condit.hide_in_width,
    icon = ' ' .. codicons.get('diff-added') .. ' ',
    highlight = {colors.green, colors.bg},
  },
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condit.hide_in_width,
    icon = ' ' .. codicons.get('diff-modified') .. ' ',
    highlight = {colors.blue, colors.bg},
  },
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condit.hide_in_width,
    icon = ' ' .. codicons.get('diff-removed') .. ' ',
    highlight = {colors.red, colors.bg},
  },
}
gls.left[10] = {
  LspStart = {provider = lsp_status.lsp_string('█'), highlight = {colors.bg_dark, colors.bg}},
}
gls.left[11] = {
  LspMessages = {provider = lsp_status.messages, highlight = {colors.grey, colors.bg_dark, 'bold'}},
}
gls.left[12] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red, colors.bg_dark},
  },
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow, colors.bg_dark},
  },
}
gls.left[14] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.blue, colors.bg_dark},
  },
}
gls.left[15] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.orange, colors.bg_dark},
  },
}
gls.left[16] = {
  LspEnd = {provider = lsp_status.lsp_string(''), highlight = {colors.bg_dark, colors.bg}},
}
gls.right[1] = {
  CurrentFunction = {provider = lsp_status.current_function, highlight = {colors.grey, colors.bg}},
}
gls.right[2] = {
  FileFormat = {
    -- This version shows icons instead of text
    provider = require('user.statusline.fileinfo').fileformat,
    separator = ' ',
    separator_highlight = {colors.bg, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.darkblue, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[4] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' |',
    separator_highlight = {colors.darkblue, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
  ScrollBar = {provider = 'ScrollBar', highlight = {colors.yellow, colors.purple}},
}

gls.short_line_left[1] = {
  LeftEnd = {
    provider = function() return ' ' end,
    separator = ' ',
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.purple, colors.bg},
  },
}

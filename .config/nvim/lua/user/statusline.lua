-- Incomplete statusline config loosely based on nvcode (but with increasingly significant changes)
local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'LuaTree', 'dbui', 'minimap', 'vista', 'vista_kind', 'vista_markdown'}
local condit = require('galaxyline.condition')

local colors = {
  bg = '#292929',
  yellow = '#d5b875',
  cyan = '#69c5ce',
  darkblue = '#081633', -- TODO
  green = '#87bb7c',
  orange = '#d7956e',
  deep_orange = '#e64a19',
  purple = '#8562d2',
  deep_purple = '#512da8',
  magenta = '#d16d9e', -- TODO
  grey = '#c0c0c0', -- TODO
  blue = '#70ace5',
  red = '#dd7186', -- NOTE consider changing this
}

local mode = {
  get = function() return vim.api.nvim_get_mode().mode end,
  color = {
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

gls.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color & name according the vim mode
      vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode.color[mode.get()])
      vim.api.nvim_command('hi ViModeSeparator guifg=' .. mode.color[mode.get()])
      return ('  %s '):format(mode.name[mode.get()] or 'NVCode')
    end,
    separator = ' ',
    separator_highlight = {
      colors.yellow, function()
        if not condit.buffer_not_empty() then return colors.bg end
        return colors.bg
      end,
    },
    highlight = {colors.bg, nil, 'bold'},
  },
}
gls.left[3] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condit.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
  },
}
gls.left[4] = {
  FileName = {
    provider = {'FileName', 'FileSize'},
    condition = condit.buffer_not_empty,
    separator = '',
    separator_highlight = {
      function() return (condit.check_git_workspace() and colors.deep_purple or colors.bg) end,
      colors.bg,
    },
    highlight = {colors.grey, colors.bg},
  },
}
gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condit.check_git_workspace,
    -- highlight = {colors.orange, colors.bg},
    -- highlight = {colors.orange, colors.purple},
    highlight = {colors.deep_orange, colors.deep_purple},
  },
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    separator = ' ',
    separator_highlight = {colors.purple, colors.bg},
    condition = condit.check_git_workspace,
    highlight = {colors.grey, colors.deep_purple},
  },
}
gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condit.hide_in_width,
    -- separator = ' ',
    -- separator_highlight = {colors.purple,colors.bg},
    icon = '  ',
    highlight = {colors.green, colors.bg},
  },
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condit.hide_in_width,
    -- separator = ' ',
    -- separator_highlight = {colors.purple,colors.bg},
    icon = '  ',
    highlight = {colors.blue, colors.bg},
  },
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condit.hide_in_width,
    -- separator = ' ',
    -- separator_highlight = {colors.purple,colors.bg},
    icon = '  ',
    highlight = {colors.red, colors.bg},
  },
}
gls.left[10] = {
  LeftEnd = {
    provider = function() return ' ' end,
    separator = ' ',
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.purple, colors.bg},
  },
}
gls.left[11] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red, colors.bg},
  },
}
gls.left[12] = {Space = {provider = function() return '' end}}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow, colors.bg},
  },
}
gls.left[14] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '   ',
    highlight = {colors.blue, colors.bg},
  },
}
gls.left[15] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '   ',
    highlight = {colors.orange, colors.bg},
  },
}
gls.right[1] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {colors.bg, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.darkblue, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[3] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' |',
    separator_highlight = {colors.darkblue, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[4] = {ScrollBar = {provider = 'ScrollBar', highlight = {colors.yellow, colors.purple}}}

gls.short_line_left[1] = {
  LeftEnd = {
    provider = function() return ' ' end,
    separator = ' ',
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.purple, colors.bg},
  },
}

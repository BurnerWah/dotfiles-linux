-- WIP port of my variant of tyrannicaltoucan/vim-quantum to colorbuddy
local Color, c, Group, g, s = require('colorbuddy').setup()

vim.o.bg = 'dark'
vim.g.colors_name = 'quantum'
vim.g.airline_theme = 'quantum'

-- Base colors
Color.new('gray_1', '#212121')
Color.new('gray_2', '#292929')
Color.new('gray_3', '#474646')
Color.new('gray_4', '#6a6c6c')
Color.new('gray_5', '#b7bdc0')
Color.new('red',    '#dd7186')
Color.new('green',  '#87bb7c')
Color.new('yellow', '#d5b875')
Color.new('blue',   '#70ace5')
Color.new('purple', '#a48add')
Color.new('cyan',   '#69c5ce')
Color.new('orange', '#d7956e')
Color.new('indigo', '#7681de')

-- Core - Vim
--        group,          fg,       bg,       styles
Group.new('ColorColumn',  nil,      c.gray_2)
Group.new('Cursor',       c.gray_2, c.gray_5)
Group.new('CursorColumn', nil,      c.gray_2)
Group.new('CursorLine',   nil,      c.gray_2, s.NONE)
Group.new('CursorLineNr', c.cyan,   c.gray_2, s.NONE)
Group.new('Directory',    c.blue,   nil)
Group.new('DiffAdd',      c.green,  c.gray_2, s.NONE)
Group.new('DiffChange',   c.yellow, c.gray_2, s.NONE)
Group.new('DiffDelete',   c.red,    c.gray_2, s.NONE)
Group.new('DiffText',     c.blue,   c.gray_2, s.NONE)
Group.new('ErrorMsg',     c.red,    c.gray_1, s.bold)
Group.new('FoldColumn',   c.gray_4, c.gray_1)
Group.new('Folded',       c.gray_3, c.gray_1)
Group.new('IncSearch',    c.yellow, nil)
Group.new('LineNr',       c.gray_3, nil)
Group.new('MatchParen',   c.gray_4, c.cyan,   s.bold)
Group.new('ModeMsg',      c.green,  nil)
Group.new('MoreMsg',      c.green,  nil)
Group.new('NonText',      c.gray_4, nil,      s.NONE)
Group.new('Normal',       c.gray_5, c.gray_1, s.NONE)
Group.new('Pmenu',        c.gray_5, c.gray_3)
Group.new('PmenuSbar',    nil,      c.gray_2)
Group.new('PmenuSel',     c.gray_2, c.cyan)
Group.new('PmenuThumb',   nil,      c.gray_4)
Group.new('Question',     c.blue,   nil,      s.NONE)
Group.new('Search',       c.gray_1, c.yellow)
Group.new('SignColumn',   c.gray_5, c.gray_1)
Group.new('SpecialKey',   c.gray_4, nil)
Group.new('SpellCap',     c.blue,   c.gray_2, s.undercurl)
Group.new('SpellBad',     nil,      nil,      s.undercurl) -- defaults: c.red, c.gray_2, s.undercurl
Group.new('StatusLine',   c.gray_5, c.gray_3, s.NONE)
Group.new('StatusLineNC', c.gray_2, c.gray_4)
Group.new('TabLine',      c.gray_4, c.gray_2, s.NONE)
Group.new('TabLineFill',  c.gray_4, c.gray_2, s.NONE)
Group.new('TabLineSel',   c.yellow, c.gray_3, s.NONE)
Group.new('Title',        c.green,  nil,      s.NONE)
Group.new('VertSplit',    c.gray_4, c.gray_1, s.NONE)
Group.new('Visual',       c.gray_5, c.gray_3)
Group.new('WarningMsg',   c.red,    nil)
Group.new('WildMenu',     c.gray_2, c.cyan)
Group.new('Conceal',      c.indigo, nil,  s.bold)

-- Core - Standard syntax
--        group,        fg,       bg,       styles
Group.new('Comment',    c.gray_4, nil,      s.italic)
Group.new('Constant',   c.orange, nil)
Group.new('String',     c.green,  nil)
Group.new('Character',  c.green,  nil)
Group.new('Identifier', c.red,    nil,      s.NONE)
Group.new('Function',   c.blue,   nil)
Group.new('Statement',  c.purple, nil,      s.NONE)
Group.new('Operator',   c.cyan,   nil)
Group.new('PreProc',    c.cyan,   nil)
Group.new('Include',    c.blue,   nil)
Group.new('Define',     c.purple, nil,      s.NONE)
Group.new('Macro',      c.purple, nil)
Group.new('Type',       c.yellow, nil,      s.NONE)
Group.new('Typedef',    c.yellow, nil,      s.bold)
Group.new('Structure',  c.cyan,   nil)
Group.new('Special',    c.indigo, nil)
Group.new('Underlined', c.blue,   nil,      s.NONE)
Group.new('Error',      c.red,    c.gray_1, s.bold)
Group.new('Todo',       c.orange, c.gray_1, s.bold)

-- Core - Special syntax
Group.new('healthSuccess', c.green:light(), nil)

-- Lang - CSS
Group.new('cssAttrComma',      c.gray_5,        nil)
Group.new('cssPseudoClassId',  c.yellow,        nil)
Group.new('cssBraces',         c.gray_5,        nil)
Group.new('cssClassName',      c.yellow,        nil)
Group.new('cssClassNameDot',   g.cssClassName,  g.cssClassName)
Group.new('cssFunctionName',   g.Function,      g.Function, g.Function)
Group.new('cssImportant',      c.cyan,          nil)
Group.new('cssIncludeKeyword', c.purple,        nil)
Group.new('cssTagName',        c.red,           nil)
Group.new('cssMediaType',      c.orange,        nil)
Group.new('cssProp',           c.gray_5,        nil)
Group.new('cssSelectorOp',     c.cyan,          nil)
Group.new('cssSelectorOp2',    g.cssSelectorOp, g.cssSelectorOp)

-- Lang - Git commit
Group.new('gitcommitHeader',        c.purple, nil)
Group.new('gitcommitUnmerged',      c.green,  nil)
Group.new('gitcommitSelectedFile',  c.green,  nil)
Group.new('gitcommitDiscardedFile', c.red,    nil)
Group.new('gitcommitUnmergedFile',  c.yellow, nil)
Group.new('gitcommitSelectedType',  c.green,  nil)
Group.new('gitcommitSummary',       c.blue,   nil)
Group.new('gitcommitDiscardedType', c.red,    nil)
-- NOTE consider adding gitcommitDiscardedArrow, gitcommitSelectedArrow, & gitcommitUnmergedArrow

-- Lang - HTML
Group.new('htmlTag',            c.blue,    nil)
Group.new('htmlEndTag',         g.htmlTag, g.htmlTag)
Group.new('htmlLink',           c.red,     nil)
Group.new('htmlTitle',          c.gray_5,  nil)
Group.new('htmlSpecialTagName', c.purple,  nil)

-- Lang - JS
Group.new('javaScriptBraces',     c.gray_5, nil)
Group.new('javaScriptNull',       c.orange, nil)
Group.new('javaScriptIdentifier', c.purple, nil)
Group.new('javaScriptNumber',     c.orange, nil)
Group.new('javaScriptRequire',    c.cyan,   nil)
Group.new('javaScriptReserved',   c.purple, nil)
Group.new('jsFunction',           c.purple, nil)
Group.new('jsArrowFunction',      c.purple, nil)
Group.new('jsAsyncKeyword',       c.purple, nil)
Group.new('jsExtendsKeyword',     c.purple, nil)
Group.new('jsClassKeyword',       c.purple, nil)
Group.new('jsDocParam',           c.green,  nil)
Group.new('jsDocTags',            c.cyan,   nil)
Group.new('jsForAwait',           c.purple, nil)
Group.new('jsFlowArgumentDef',    c.yellow, nil)
Group.new('jsFrom',               c.purple, nil)
Group.new('jsImport',             c.purple, nil)
Group.new('jsExport',             c.purple, nil)
Group.new('jsExportDefault',      c.purple, nil)
Group.new('jsFuncCall',           c.blue,   nil)
Group.new('jsGlobalObjects',      c.yellow, nil)
Group.new('jsGlobalNodeObjects',  c.yellow, nil)
Group.new('jsModuleAs',           c.purple, nil)
Group.new('jsNull',               c.orange, nil)
Group.new('jsStorageClass',       c.purple, nil)
Group.new('jsTemplateBraces',     c.red,    nil)
Group.new('jsTemplateExpression', c.red,    nil)
Group.new('jsThis',               c.red,    nil)
Group.new('jsUndefined',          c.orange, nil)

-- Lang - JSON
Group.new('jsonBraces', c.gray_5, nil)

-- Lang - Less
Group.new('lessAmpersand',    c.red,    nil)
Group.new('lessClassChar',    c.yellow, nil)
Group.new('lessCssAttribute', c.gray_5, nil)
Group.new('lessFunction',     c.blue,   nil)
Group.new('lessVariable',     c.purple, nil)

-- Lang - Markdown
Group.new('markdownBold',              c.yellow,             nil, s.bold)
Group.new('markdownCode',              c.cyan,               nil)
Group.new('markdownCodeBlock',         g.markdownCode,       g.markdownCode)
Group.new('markdownCodeDelimiter',     g.markdownCode,       g.markdownCode)
Group.new('markdownHeadingDelimiter',  c.green,              nil)
Group.new('markdownHeadingRule',       c.gray_4,             nil)
Group.new('markdownId',                c.purple,             nil)
Group.new('markdownItalic',            c.blue,               nil, s.italic)
Group.new('markdownListMarker',        c.orange,             nil)
Group.new('markdownOrderedListMarker', g.markdownListMarker, g.markdownListMarker)
Group.new('markdownRule',              c.gray_4,             nil)
Group.new('markdownUrl',               c.purple,             nil)
Group.new('markdownUrlTitleDelimiter', c.green,              nil)

-- Lang - Ruby
Group.new('rubyInterpolation',          c.cyan,   nil)
Group.new('rubyInterpolationDelimiter', c.indigo, nil)
Group.new('rubyRegexp',                 c.cyan,   nil)
Group.new('rubyRegexpDelimiter',        c.indigo, nil)
Group.new('rubyStringDelimiter',        c.green,  nil)

-- Lang - Rust
Group.new('rustAssert',    c.yellow,    nil)
Group.new('rustPanic',     c.red,       nil)
Group.new('rustStructure', g.Structure, g.Structure, g.Structure)

-- Lang - Sass
Group.new('sassAmpersand', c.red,    nil)
Group.new('sassClassChar', c.yellow, nil)
Group.new('sassMixinName', c.blue,   nil)
Group.new('sassVariable',  c.purple, nil)

-- Lang - Vimwiki
Group.new('VimwikiBoldCharT', nil, nil, s.bold)

-- Lang - XML
Group.new('xmlAttrib',  c.yellow, nil)
Group.new('xmlTag',     c.blue,   nil)
Group.new('xmlEndTag',  g.xmlTag, g.xmlTag)
Group.new('xmlTagName', g.xmlTag, g.xmlTag)

-- Plugin - Vim-Fugitive
Group.new('diffAdded',   c.green, nil)
Group.new('diffRemoved', c.red,   nil)

-- Plugin - Vim-Gittgutter
Group.new('GitGutterAdd',          c.green,  nil)
Group.new('GitGutterChange',       c.yellow, nil)
Group.new('GitGutterChangeDelete', c.orange, nil)
Group.new('GitGutterDelete',       c.red,    nil)

-- Plugin - Vim-Signify
Group.new('SignifySignAdd',    g.GitGutterAdd,    g.GitGutterAdd)
Group.new('SignifySignChange', g.GitGutterChange, g.GitGutterChange)
Group.new('SignifySignDelete', g.GitGutterDelete, g.GitGutterDelete)

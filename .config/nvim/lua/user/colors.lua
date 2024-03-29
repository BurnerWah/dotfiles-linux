-- WIP port of my variant of tyrannicaltoucan/vim-quantum to colorbuddy
local colorbuddy = require('colorbuddy')
local Color, c = colorbuddy.Color, colorbuddy.colors
local Group, g = colorbuddy.Group, colorbuddy.groups
local s = colorbuddy.styles

-- vim.g.colors_name = 'quantum'

-- Base colors
Color.new('gray0', '#212121')
Color.new('gray1', '#292929')
Color.new('gray2', '#424242')
Color.new('gray3', '#757575')
Color.new('gray4', '#9e9e9e')
Color.new('gray5', '#bdbdbd')
Color.new('gray6', '#e0e0e0')
Color.new('gray7', '#ffffff')
Color.new('red', '#dd7186')
Color.new('green', '#87bb7c')
Color.new('yellow', '#d5b875')
Color.new('blue', '#70ace5')
Color.new('purple', '#a48add')
Color.new('cyan', '#69c5ce')
Color.new('orange', '#d7956e')
Color.new('indigo', '#7681de')
Color.new('brown', '#a52a2a')

-- Core - Vim
--        group,          fg,       bg,      styles
Group.new('Normal', c.gray5, c.gray0)
Group.new('LineNr', c.gray2)
Group.new('SignColumn', g.Normal, g.Normal, g.Normal)
Group.new('Cursor', c.gray1, c.gray5)
Group.new('CursorLine', nil, c.gray1)
Group.new('Pmenu', c.gray5, c.gray2)
Group.new('PmenuSel', c.gray1, c.cyan)
Group.new('PmenuSbar', nil, c.gray1)
Group.new('PmenuThumb', nil, c.gray3)
Group.new('StatusLine', c.gray5, c.gray2)
Group.new('StatusLineNC', c.gray1, c.gray3)
Group.new('Visual', c.gray5, c.gray2)

Group.new('Special', c.indigo)
Group.new('NonText', c.gray3)
Group.new('Conceal', c.indigo, nil, s.bold)

Group.new('Search', c.gray0, c.yellow)
Group.new('TabLine', c.gray3, c.gray1)
Group.new('TabLineFill', c.gray3, c.gray1)
Group.new('TabLineSel', c.yellow, c.gray2)

Group.new('Comment', c.gray3, nil, s.italic)
-- Group.new('Character',  c.green)
-- Group.new('Define',     c.purple)
-- Group.new('Error',      c.red,    c.gray0, s.bold)
-- Group.new('Number', c.red)
-- Group.new('Constant',   c.orange)
-- Group.new('Identifier', c.red)
-- Group.new('Include',    c.blue)
-- Group.new('Operator',   c.cyan)
-- Group.new('PreProc',    c.cyan)
-- Group.new('Statement',  c.purple)
-- Group.new('String',     c.green)
-- Group.new('Structure',  c.cyan)
Group.new('Todo', c.orange, nil, s.bold)
-- Group.new('Typedef',    c.yellow, nil,     s.bold)
-- Group.new('Type',       c.yellow)

Group.new('Folded', c.gray2, c.gray0)

-- Group.new('Function',   c.blue, nil, s.bold)

Group.new('ColorColumn', nil, c.gray1)
Group.new('CursorColumn', nil, c.gray1)
Group.new('CursorLineNr', c.cyan, c.gray1)
-- Group.new('Directory',    c.blue)
Group.new('DiffAdd', c.green, c.gray1)
Group.new('DiffChange', c.yellow, c.gray1)
Group.new('DiffDelete', c.red, c.gray1)
Group.new('DiffText', c.blue, c.gray1)
Group.new('ErrorMsg', c.red, c.gray0, s.bold)
Group.new('FoldColumn', c.gray3, c.gray0)
Group.new('IncSearch', c.yellow)
Group.new('MatchParen', c.gray3, c.cyan, s.bold)
Group.new('ModeMsg', c.green)
Group.new('MoreMsg', c.green)
Group.new('Question', c.blue)
Group.new('SpecialKey', c.gray3)
Group.new('SpellCap', c.blue, c.gray1, s.undercurl)
Group.new('SpellBad', nil, nil, s.undercurl) -- pld: c.red, c.gray1, s.undercurl
Group.new('Title', c.green)
Group.new('VertSplit', c.gray3, c.gray0)
Group.new('WarningMsg', c.red)
Group.new('WildMenu', c.gray1, c.cyan)
Group.new('EndOfBuffer', c.gray0)

-- Core - Standard syntax
--        group,        fg,       bg,      styles
-- Group.new('Macro',      c.purple)
Group.new('Underlined', c.blue, nil, s.underline)
Group.new('Delimiter', g.Special, g.Special, g.Special)

-- Core - Special syntax
Group.new('healthSuccess', c.green:light())
Group.new('LspReferenceText', g.Visual, g.Visual, g.Visual)
Group.new('LspReferenceRead', g.Visual, g.Visual, g.Visual)
Group.new('LspReferenceWrite', g.Visual, g.Visual, g.Visual)
Group.new('LspDiagnosticsDefaultError', c.red:dark())
Group.new('LspDiagnosticsDefaultWarning', c.orange:dark())
Group.new('LspDiagnosticsDefaultInformation', c.blue:light())

-- Plugin - nvim-treesitter
Group.new('TSPunctDelimiter', c.indigo:dark())
Group.new('TSConstBuiltin', g.Special, g.Special, g.Special)
Group.new('TSStringRegex', g.String, g.String, g.String)
Group.new('TSURI', g.Underlined, g.Underlined, g.Underlined + s.italic) -- std: Underlined

-- Lang - CSS
Group.link('cssAttrComma', g.TSPunctDelimiter) -- std: Special; old: Normal
Group.new('cssPseudoClassId', g.Identifier, g.Identifier, g.Identifier) -- std: PreProc; old: c.yellow
Group.link('cssBraces', g.Delimiter) -- std: Function; old: Normal
Group.link('cssClassName', g.Identifier) -- std: Function; old: c.yellow
Group.link('cssClassNameDot', g.cssClassName) -- std: Function; old: c.yellow
Group.new('cssImportant', g.Keyword, g.Keyword, g.Keyword) -- std: Special; old: c.cyan
Group.new('cssTagName', g.Type, g.Type, g.Type) -- std: Statement; old: c.red
Group.new('cssMediaType', c.orange) -- std: Special; old: c.orange
Group.new('cssProp', g.Identifier, g.Identifier, g.Identifier) -- std: StorageClass; old: Normal
Group.link('cssSelectorOp', g.Operator) -- std: Special; old: c.cyan
Group.link('cssSelectorOp2', g.Operator) -- std: Special; old: c.cyan

-- Lang - Git commit
Group.new('gitcommitHeader', c.purple)
Group.new('gitcommitSummary', c.blue)
Group.new('gitcommitSelectedFile', c.green, nil, s.bold)
Group.new('gitcommitSelectedType', g.gitcommitSelectedFile)
Group.new('gitcommitSelectedArrow', g.gitcommitSelectedFile)
Group.new('gitcommitDiscardedFile', c.red)
Group.new('gitcommitDiscardedType', g.gitcommitDiscardedFile)
Group.new('gitcommitDiscardedArrow', g.gitcommitDiscardedFile)
Group.new('gitcommitUnmerged', c.green)
Group.new('gitcommitUnmergedFile', c.yellow)
Group.new('gitcommitUnmergedArrow', g.gitcommitUnmergedFile)

-- Lang - HTML
Group.link('htmlTag', g.Label)
Group.link('htmlEndTag', g.Label)
Group.link('htmlLink', g.TSURI)
Group.new('htmlTitle', c.gray5) -- std: Title; old: c.gray5
Group.new('htmlSpecialTagName', c.purple) -- std: Exception; old: c.purple

-- Lang - JS
-- NOTE jsArrowFunction is weird since it covers operators, delimiters, & a variable
Group.link('javaScriptBraces', g.Delimiter)
Group.link('javaScriptParens', g.Delimiter)
Group.link('javaScriptNull', g.TSConstBuiltin)
Group.new('javaScriptIdentifier', c.blue) -- std: Identifier; old: c.purple
Group.link('javaScriptNumber', g.Number)
Group.link('javaScriptRegexpString', g.TSStringRegex)

Group.link('jsFunction', g.Keyword) -- std: Type; old: c.purple
Group.new('jsArrowFunction', c.purple) -- std: Type; old: c.purple
Group.new('jsDocParam', c.green) -- std: Label; old: c.green
Group.new('jsDocTags', g.Keyword, g.Keyword, g.Keyword) -- std: Special; old: c.cyan
Group.new('jsFlowArgumentDef', c.yellow) -- std: PreProc; old: c.yellow
Group.new('jsExport', g.Keyword, g.Keyword, g.Keyword) -- std: Include; old: c.purple
Group.new('jsExportDefault', g.Conditional, g.Conditional, g.Conditional) -- std: StorageClass; old: c.purple
Group.new('jsFuncCall', c.blue) -- std: Function; old: c.blue
Group.new('jsGlobalObjects', c.yellow) -- std: Constant; old: c.yellow
Group.new('jsGlobalNodeObjects', g.jsGlobalObjects) -- std: Constant; old: c.yellow
Group.link('jsNull', g.javaScriptNull) -- std: Type; old: c.orange
Group.new('jsStorageClass', g.Keyword, g.Keyword, g.Keyword) -- std: StorageClass; old: c.purple
Group.link('jsTemplateBraces', g.Delimiter) -- std: Noise; old: c.red
Group.new('jsTemplateExpression', c.red) -- std: Undefined; old: c.red
Group.link('jsThis', g.TSVariableBuiltin) -- std: Special; old: c.red
Group.link('jsSuper', g.TSVariableBuiltin) -- std: Constant
Group.new('jsUndefined', c.orange) -- std: Type; old: c.orange

-- Lang - JSON
Group.link('jsonNull', g.TSConstBuiltin) -- std: Function

-- Lang - Less
Group.link('lessAmpersand', g.cssProp)
Group.new('lessClassChar', c.yellow)
Group.new('lessCssAttribute', c.gray5)
Group.link('lessFunction', g.Function)
Group.new('lessVariable', c.purple)

-- Lang - Markdown
Group.new('markdownBold', c.yellow, nil, s.bold)
Group.new('markdownCode', c.cyan)
Group.link('markdownCodeBlock', g.markdownCode)
Group.link('markdownCodeDelimiter', g.markdownCode)
Group.new('markdownHeadingDelimiter', c.green)
Group.new('markdownHeadingRule', c.gray3)
Group.new('markdownId', c.purple)
Group.new('markdownItalic', c.blue, nil, s.italic)
Group.new('markdownListMarker', c.orange)
Group.link('markdownOrderedListMarker', g.markdownListMarker)
Group.new('markdownRule', c.gray3)
Group.link('markdownLinkText', g.Label)
Group.link('markdownUrl', g.TSURI)
Group.new('markdownUrlTitleDelimiter', c.green)

-- Lang - Ruby
Group.new('rubyInterpolation', c.cyan)
Group.new('rubyInterpolationDelimiter', c.indigo)
Group.new('rubyRegexp', c.cyan)
Group.new('rubyRegexpDelimiter', c.indigo)
Group.new('rubyStringDelimiter', c.green)

-- Lang - Rust
Group.new('rustAssert', c.yellow)
Group.new('rustPanic', c.red)
Group.link('rustStructure', g.Structure)

-- Lang - Sass
Group.link('sassAmpersand', g.cssProp)
Group.new('sassClassChar', c.yellow)
Group.new('sassMixinName', c.blue)
Group.new('sassVariable', c.purple)

-- Lang - Vimwiki
Group.new('VimwikiBoldCharT', nil, nil, s.bold)

-- Lang - XML
Group.new('xmlAttrib', c.yellow) -- std: Type; old: c.yellow
Group.new('xmlTag', c.blue) -- std: Function; old: c.blue
Group.link('xmlEndTag', g.xmlTag) -- std: Function; old: c.blue
Group.link('xmlTagName', g.xmlTag) -- std: Identifier; old: c.blue

-- Plugin - Vim-Gittgutter
Group.new('GitGutterAdd', c.green)
Group.new('GitGutterChange', c.yellow)
Group.new('GitGutterChangeDelete', c.orange)
Group.new('GitGutterDelete', c.red)

-- Plugin - indent-blankline
Group.new('IndentBlanklineChar', c.purple:dark():dark()) -- this looks really nice IMO

-- Plugin - gitsigns.nvim
Group.link('GitSignsAdd', g.GitGutterAdd)
Group.link('GitSignsChange', g.GitGutterChange)
Group.link('GitSignsDelete', g.GitGutterDelete)
Group.link('GitSignsCurrentLineBlame', g.NonText)

-- Plugin - which-key.nvim
Group.link('WhichKey', g.Function)
Group.link('WhichKeySeparator', g.DiffAdded)
Group.link('WhichKeyGroup', g.Keyword)
Group.link('WhichKeyDesc', g.Identifier)
Group.link('WhichKeyFloat', g.NormalFloat)
Group.link('WhichKeyValue', g.Comment)

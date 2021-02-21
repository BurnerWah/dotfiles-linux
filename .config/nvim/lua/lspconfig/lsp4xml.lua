local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local expand = vim.fn.expand

-- Helper function to simplify file associations
local function gen_associations(associations)
  assert(type(associations) == 'table', 'Invalid Association')
  local R = {}
  for _, A in ipairs(associations) do table.insert(R, {pattern = A[1], systemId = A[2]}) end
  return R
end

local server_name = 'lsp4xml'

configs[server_name] = {
  default_config = {
    cmd = {
      'java', '-Xmx64M', '-cp', expand('~/.local/lib/jvm/org.eclipse.lemminx-uber.jar'),
      'org.eclipse.lemminx.XMLServerLauncher',
    },
    filetypes = {'catalog', 'docbk', 'dtd', 'smil', 'xsd', 'xml'},
    root_dir = util.root_pattern('.git', vim.fn.getcwd()),
    settings = {
      xml = {
        catalogs = {'/etc/xml/catalog', expand('~/.config/xml/catalog.xml')},
        server = {workDir = '~/.cache/lemminx'},
        fileAssociations = gen_associations {
          {'**/*.aiml', 'https://github.com/dotcypress/aiml/raw/master/AIML.xsd'},
          {'**/*.doap', 'http://usefulinc.com/ns/doap'},
          {'**/*.smil', 'https://www.w3.org/2008/SMIL30/SMIL30Language.dtd'},
          {'**/*.svg', 'https://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'},
        },
      },
    },
  },
}

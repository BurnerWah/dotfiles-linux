require('symbols-outline').setup()
local codicons = require('codicons')
local symbols = require('symbols-outline.symbols')
local tablex = require('pl.tablex')
tablex.foreach({
  File = 'symbol-file',
  Namespace = 'symbol-namespace',
  Class = 'symbol-class',
  Method = 'symbol-method',
  Property = 'symbol-property',
  Field = 'symbol-field',
  Enum = 'symbol-enum',
  Interface = 'symbol-interface',
  Variable = 'symbol-variable',
  Constant = 'symbol-constant',
  String = 'symbol-string',
  Number = 'symbol-numeric',
  Boolean = 'symbol-boolean',
  Array = 'symbol-array',
  EnumMember = 'symbol-enum-member',
  Struct = 'symbol-structure',
  Event = 'symbol-event',
  Operator = 'symbol-operator',
}, function(val, key) symbols[key].icon = codicons.get(val) end)

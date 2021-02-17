-- Script to clean up dead ALE commands & maps (namely LSP stuff)
local unmap = {
  'ale_documentation', 'ale_find_references', 'ale_go_to_definition', 'ale_go_to_definition_in_tab',
  'ale_go_to_definition_in_split', 'ale_go_to_definition_in_vsplit', 'ale_go_to_type_definition',
  'ale_go_to_type_definition_in_tab', 'ale_go_to_type_definition_in_split',
  'ale_go_to_type_definition_in_vsplit', 'ale_hover', 'ale_import', 'ale_rename', 'ale_code_action',
}
for _, map in ipairs(unmap) do vim.cmd('unmap <Plug>(' .. map .. ')') end
vim.cmd [[iunmap <Plug>(ale_complete)]]

local delcom = {
  'ALEComplete', 'ALEDocumentation', 'ALEFindReferences', 'ALEGoToDefinition',
  'ALEGoToTypeDefinition', 'ALEHover', 'ALEImport', 'ALEOrganizeImports', 'ALERename',
  'ALECodeAction', 'ALESymbolSearch', 'ALEStopAllLSPs',
}
for _, cmd in ipairs(delcom) do vim.cmd('delcommand ' .. cmd) end

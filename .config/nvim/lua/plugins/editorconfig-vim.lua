local M = {}

--- Type conversion helper
local as = {
  mappings = {bool = {['true'] = true, ['false'] = false}},
  ---Parse a boolean from editorconfig
  ---@param self table
  ---@param option string
  ---@return boolean?
  bool = function(self, option) return self.mappings.bool[option] end,
}

local success, fail = 0, 1

function M.config()
  vim.g.EditorConfig_exclude_patterns = {
    'davs\\?://.*', 'ftp://.*', 'fugitive://.*', 'https\\?://.*', 'info://.*', 'man://.*',
    'octo://.*', 'output://.*', 'rcp://.*', 'rsync://.*', 'scp://.*', 'sftp://.*', 'term://.*',
  }
  vim.g.EditorConfig_disable_rules = {
    'insert_final_newline', 'max_line_length', 'trim_trailing_whitespace',
  }
  vim.cmd [[call editorconfig#AddNewHook(function('user#abstract#editorconfig_hook'))]]
end

--- Editorconfig Hook
---
--- This has to return an integer, as editorconfig-vim compares it against
--- the result of a viml `type(0)`.
--- @param config table<string, any>
--- @return integer standard vim return code
function M.hook(config)
  local status = success

  --[[Read configuration]]
  local shfmt = {
    ---@type string?
    shell_variant = config.shell_variant,
    ---@type boolean?
    binary_next_line = as:bool(config.binary_next_line),
    ---@type boolean?
    switch_case_indent = as:bool(config.switch_case_indent),
    ---@type boolean?
    space_redirects = as:bool(config.space_redirects),
    ---@type boolean?
    keep_padding = as:bool(config.keep_padding),
    ---@type boolean?
    function_next_line = as:bool(config.function_next_line),
  }

  --[[Commit configuration]]
  if not vim.tbl_isempty(shfmt) then vim.b.shfmt = shfmt end

  return status
end

return M

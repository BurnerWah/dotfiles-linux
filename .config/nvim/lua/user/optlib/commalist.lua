local M = {}

function M.new(name, scope)
  vim.validate {name = {name, 'string'}, scope = {scope, 'string', true}}
  scope = scope or 'o'
  print(vim[scope][name])

  local self = setmetatable(vim.split(vim[scope][name], ','), {
    __index = M,
    __add = function(A, B)
      for index, value in ipairs(B) do if vim.tbl_contains(A, value) then B[index] = nil end end
      vim.list_extend(A, B)
      vim[scope][name] = table.concat(A, ',')
      return A
    end,
    __sub = function(A, B)
      for index, value in ipairs(A) do if vim.tbl_contains(B, value) then A[index] = nil end end
      vim[scope][name] = table.concat(A, ',')
      return A
    end,
  })
  return self
end

return M

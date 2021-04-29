--- @class vlib.dsl
--- vlib DSL
local dsl = {}
local let_scopes = {g = true, b = true, w = true}

--- @alias vlib.dsl.KV table<string, any>

--- Let multiple values at once
--- @param T vlib.dsl.KV
function dsl.let(T)
  local scope, opts = unpack(vim.tbl_islist(T) and {T[1], T[2]} or {'g', T})
  assert(let_scopes[scope], 'Scope is invalid')
  assert(not vim.tbl_islist(opts), 'Expected a map, but got a list')
  for key, value in pairs(opts) do vim[scope][key] = value end
end

return dsl

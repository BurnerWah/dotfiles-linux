local Import = {_name = 'Import'}

class(nil, nil, Import)

function Import:_init(keys)
  assert(type(keys) == 'table')
  for k, v in ipairs(keys) do self[k] = v end
end

function Import:from(mod)
  assert(type(mod) == 'string')
  local m = require(mod)
  assert(type(m) == 'table')
  local R = {}
  for k, v in ipairs(self) do R[k] = m[v] end
  return unpack(R)
end

return Import

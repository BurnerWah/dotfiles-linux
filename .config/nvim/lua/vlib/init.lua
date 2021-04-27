local M, mt = {}, {}
local modules = {fn = true, fnproxy = true}
function mt.__index(_, name)
  if modules[name] then
    rawset(M, name, require('vlib.' .. name))
    return M[name]
  end
  -- Fall back on un-abstracted vim stdlib
  if vim[name] then
    rawset(M, name, vim[name])
    return M[name]
  end
end
setmetatable(M, mt)
return M

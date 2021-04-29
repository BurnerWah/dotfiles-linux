--- @meta
--- @class vlib
--- A higher-level abstraction for vim
--- @field dsl vlib.dsl
--- @field fn vlib.fn
--- @field fnproxy vlib.fnproxy
local M, mt = {}, {}
local modules = {dsl = true, fn = true, fnproxy = true}
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

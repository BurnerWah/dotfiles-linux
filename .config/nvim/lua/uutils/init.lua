-- Require this to create the global uutils table
-- It will lazy load parts of uutils as needed
local env = {}
local modules = {import = true}
local mt = {}
function mt.__index(t, name)
  local found = modules[name]
  if found then
    rawset(env, name, require('uutils.' .. name))
    return env[name]
  end
end
setmetatable(env, mt)
uutils = env

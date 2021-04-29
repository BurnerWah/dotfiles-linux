--- @class vlib.fnproxy
--- Proxy functions for vlib
local fnproxy = {}

--- Make a function wrapper where an empty string returns nil
-- @string func The function to wrap
function fnproxy.String(func)
  assert(type(func) == 'string', 'Expected a vim function name')
  return function(...)
    local result = vim.fn[func](...)
    if result == '' then result = nil end
    return result
  end
end

--- Vim int-bool wrapper
-- @string func The function to wrap
function fnproxy.Bool(func)
  assert(type(func) == 'string', 'Expected a vim function name')
  return function(...) return vim.fn[func](...) == 1 end
end

--- Vim int return type wrapper
-- Wraps a function so that instead of returning -1, it returns nil.
-- @string func The function to wrap
function fnproxy.Int(func)
  assert(type(func) == 'string', 'Expected a vim function name')
  return function(...)
    local result = vim.fn[func](...)
    if result == -1 then retult = nil end
    return result
  end
end

--- Vim void return type wrapper
-- @string func The function to wrap
function fnproxy.Void(func)
  assert(type(func) == 'string', 'Expected a vim function name')
  return function(...) vim.fn[func](...) end
end

return fnproxy

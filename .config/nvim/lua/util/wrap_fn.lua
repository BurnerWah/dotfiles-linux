local wrap_fn = {}
setmetatable(wrap_fn, wrap_fn)

function wrap_fn:__call(func, func_type)
  assert(type(self.factory[func_type]) == "function", "invalid input")
  return self.factory[func_type](func)
end

local factory = {}

function factory.Boolean(func)
  assert(type(func) == "function", "Error")
  return function(...)
    return func(...) == 1
  end
end
factory.boolean = factory.Boolean
factory.Bool = factory.Boolean
factory.bool = factory.Boolean

wrap_fn.factory = factory

return wrap_fn

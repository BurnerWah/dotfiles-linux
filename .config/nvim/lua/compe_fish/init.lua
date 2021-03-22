-- This is heavily based off of the compe-zsh source
local compe = require('compe')
local Job = require('plenary.job')

local Source = {}

function Source.new()
  local self = setmetatable({}, {__index = Source})
  self.executable_fish = vim.fn.executable('fish') == 1
  return self
end

function Source.get_metadata(_)
  return {priority = 100, dup = 0, menu = '[Fish]', filetypes = {'fish'}}
end

function Source.determine(_, context)
  return compe.helper.determine(context, {keyword_pattern = '\\S\\+$'})
end

function Source.documentation(_, args)
  if not args.completed_item.info then return args.abort() end
  args.callback(args.completed_item.info)
end

function Source.complete(self, args)
  if not self.executable_fish then return args.abort() end
  self:collect(args.context.line, args.callback)
end

function Source.collect(_, input, callback)
  local results = {}
  local job = Job:new{
    command = 'fish',
    args = {'-c', string.format([[complete --do-complete='%s']], input)},
    cwd = vim.fn.getcwd(),
    on_stdout = function(_, data)
      local pieces = vim.split(data, '	', true)
      if #pieces > 1 then
        -- It's not useful for us to complete abbreviations
        if not pieces[2]:find('^Abbreviation:') then
          table.insert(results, {word = pieces[1], info = pieces[2]})
        end
      else
        table.insert(results, {word = pieces[1]})
      end
    end,
    on_exit = function(_, _, _) callback({items = results}) end,
  }

  job:start()
  return results
end

return Source:new()

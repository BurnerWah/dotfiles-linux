local Job = require 'plenary.job'
local file = io.open(vim.fn.stdpath('config') .. '/lua/user/data/gen/generated_schemas.lua', 'w+')
io.output(file)
-- Output header
io.write [[
-- File generated based on schemastore
-- Re-run generator instead of editing
return {
-- Manually inserted schemas
{fileMatch={"*.ipynb"}, url="https://github.com/jupyter/nbformat/raw/master/nbformat/v4/nbformat.v4.schema.json"},
-- Generated entries
]]

local curl = Job:new{
  command = 'curl',
  args = {'-L', 'https://www.schemastore.org/api/json/catalog.json'},
}

local jq = Job:new{
  command = 'jq',
  args = {
    '-c',
    [[.schemas|map(select(has("fileMatch") and has("url")))[]|{fileMatch:.fileMatch,url:.url}]],
  },
  writer = curl,
  -- cwd = vim.fn.getcwd(),
  on_stdout = function(_, data)
    line = data:gsub([[^{"fileMatch":.(.*).,"url":(".+")}$]], [[
{fileMatch={%1}, url=%2},
]])
    io.write(line)
  end,
  on_exit = function(_, _, _)
    io.write('}')
    io.close(file)
  end,
}

jq:start()

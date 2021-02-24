-- this is used to generated a JSON file of vim's options that can be processed for use in a typeshed
local options = require('temp.options-clean') -- this should be extracted from vim source code
local output_file = io.open(vim.env.HOME .. '/nvim-options.json', 'w+')
io.output(output_file)
io.write(vim.fn.json_encode(options))
io.close(output_file)
print('options.lua successfully parsed')

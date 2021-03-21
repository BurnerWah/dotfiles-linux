local nnor, nmap = vim.keymap.nnoremap, vim.keymap.nmap
local feedkeys, replace_termcodes = vim.api.nvim_feedkeys, vim.api.nvim_replace_termcodes
local hlslens = require('hlslens')
-- This will let us delete the search end keymap when we're done with it
nnor {
  '<Plug>(UserEndHlslens)',
  function()
    feedkeys(replace_termcodes(':nohlsearch<CR>', true, false, true), 'n', true)
    vim.cmd [[nunmap <Leader>l]]
  end,
  silent = true,
}

local mapgen = {
  iterate = function(key)
    return function()
      -- This used to use vim.cmd, but that broke. Feedkeys works better anyway though.
      feedkeys(vim.v.count1 .. key, 'n', true)
      hlslens.start()
      nmap {'<Leader>l', '<Plug>(UserEndHlslens)', silent = true}
    end
  end,
  search = function(key)
    return function()
      feedkeys(key, 'n', true)
      hlslens.start()
      nmap {'<Leader>l', '<Plug>(UserEndHlslens)', silent = true}
    end
  end,
}

nnor {'n', mapgen.iterate('n'), silent = true}
nnor {'N', mapgen.iterate('N'), silent = true}

nnor {'*', mapgen.search('*')}
nnor {'#', mapgen.search('#')}
nnor {'g*', mapgen.search('g*')}
nnor {'g#', mapgen.search('g#')}

hlslens.get_config().override_line_lens = function(lnum, loc, idx, r_idx, count, hls_ns)
  local sfw = vim.v.searchforward == 1
  local indicator, text, chunks
  local a_r_idx = math.abs(r_idx)
  if a_r_idx > 1 then
    indicator = string.format('%d%s', a_r_idx, sfw ~= (r_idx > 1) and '▲' or '▼')
  elseif a_r_idx == 1 then
    indicator = sfw ~= (r_idx == 1) and '▲' or '▼'
  else
    indicator = ''
  end

  if loc ~= 'c' then
    text = string.format('[%s %d]', indicator, idx)
    chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
  else
    if indicator ~= '' then
      text = string.format('[%s %d/%d]', indicator, idx, count)
    else
      text = string.format('[%d/%d]', idx, count)
    end
    chunks = {{' ', 'Ignore'}, {text, 'HlSearchLensCur'}}
    vim.api.nvim_buf_clear_namespace(0, hls_ns, lnum - 1, lnum)
  end
  vim.api.nvim_buf_set_virtual_text(0, hls_ns, lnum - 1, chunks, {})
end

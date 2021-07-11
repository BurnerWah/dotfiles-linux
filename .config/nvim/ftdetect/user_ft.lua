local has_agrp, agrp = pcall(require, 'agrp')

if not has_agrp then return end

-- Macros & function factories

-- join strings with `,`
local function join(...) return table.concat({...}, ',') end

local ft_ignore_pat = vim.regex(vim.g.ft_ignore_pat)
local function StarSetf(ft)
  return function()
    print(vim.fn.expand('<amatch>'))
    if ft_ignore_pat:match_str(vim.fn.expand('<amatch>')) then vim.cmd('setf ' .. ft) end
  end
end

agrp.set({
  {
    ['BufNewFile,BufRead'] = {
      --
      {'*/.vscode/*.json', 'setf jsonc'}, -- Plenary engine
      {'*', require('user.ft').detect_ft}, -- Misc
      {'*/.cargo/config,*/.cargo/credentials', 'setf toml'}, {'*/tmp/*.repo', 'setf dosini'},
      {'*/dbus-1/*.conf', 'setf xml'}, {'*/share/zsh/history', 'setf zshhist'},
      {'*/waybar/config', 'setf jsonc'}, {'*/bat/config', 'setf argfile'},
      {'*/silicon/config', 'setf argfile'}, {'lit.*cfg', 'setf python'}, {
        join('*-requirements.{txt,in}', 'requirements-*.{txt,in}', '*/requirements/*.{txt,in}'),
        'setf requirements',
      }, {join('*/etc/alsa/*.conf', '*/share/alsa/alsa.conf.d/*.conf'), 'setf alsaconf'},
      {
        join('*/dbus-1/*.service', '*/flatpak/app/*/metadata', '*/flatpak/overrides/*'),
        'setf desktop',
      }, {join('*/.config/git/ignore', '*.git/info/exclude'), 'setf gitignore'},
      {'*/etc/DIR_COLORS.*', StarSetf('dircolors')}, {
        join('*/share/zsh/*/functions/*', '*/share/zsh/*/scripts/*', '*/share/zsh/site-functions/*',
             '*/.config/zsh/functions/*'), StarSetf('zsh'),
      },
    },
  },
})

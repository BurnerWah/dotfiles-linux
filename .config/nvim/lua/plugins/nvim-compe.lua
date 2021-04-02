vim.o.completeopt = 'menuone,noselect'
require('compe').register_source('fish', require('compe_fish')) -- custom source
require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    vsnip = true,
    snippets_nvim = false,
    nvim_lsp = true, -- Priority: 1000
    nvim_lua = true,
    spell = true,
    tags = true,
    tabnine = {
      ignored_filetypes = {
        'alsaconf', 'crontab', 'dircolors', 'dnsmasq', 'dosini', 'fstab', 'group', 'grub',
        'hostconf', 'hostsaccess', 'inittab', 'limits', 'logindefs', 'mailcap', 'markdown',
        'modconf', 'pamconf', 'passwd', 'pinfo', 'protocols', 'ptcap', 'resolv', 'rst', 'services',
        'sshconfig', 'sshdconfig', 'spec', 'sudoers', 'sysctl', 'udevconf', 'udevperm', 'updatedb',
        'vimwiki', 'wget',
      },
      priority = 900, -- defaults to 5000 which can be problematic
      dup = 0, -- allow duplicate entries (mostly with lsp)
    },
    treesitter = true,
    omni = {filetypes = {'clojure', 'debchangelog', 'mf', 'mp', 'vimwiki'}},
    fish = true,
  },
}
local remap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true, expr = true}
remap('i', '<C-Space>', [[compe#complete()]], opts)
remap('i', '<C-e>', [[compe#close('<C-e>')]], opts)
remap('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], opts)
remap('i', '<C-d>', [[compe#scroll({ 'delta': -4 })]], opts)

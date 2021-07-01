local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  vim.o.completeopt = 'menuone,noselect'
  require('compe').register_source('fish', require('compe_fish')) -- custom source
  require('compe').setup({
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
      nvim_lsp = true, --[[Priority: 1000]]
      nvim_lua = true,
      spell = true,
      tags = true,
      tabnine = {
        ignored_filetypes = {
          'alsaconf', 'crontab', 'dircolors', 'dnsmasq', 'dosini', 'fstab', 'group', 'grub',
          'hostconf', 'hostsaccess', 'inittab', 'limits', 'logindefs', 'mailcap', 'markdown',
          'modconf', 'pamconf', 'passwd', 'pinfo', 'protocols', 'ptcap', 'resolv', 'rst',
          'services', 'sshconfig', 'sshdconfig', 'spec', 'sudoers', 'sysctl', 'udevconf',
          'udevperm', 'updatedb', 'vimwiki',
        },
        priority = 900, --[[defaults to 5000 which can be problematic]]
        dup = 0, --[[allow duplicate entries (mostly with lsp)]]
        sort = true,
      },
      treesitter = true,
      omni = {filetypes = {'clojure', 'debchangelog', 'mf', 'mp', 'vimwiki'}},
      fish = true,
      orgmode = true,
    },
  })

  vim.keymap.inoremap {'<C-Space>', [[compe#complete()]], silent = true, expr = true}
  vim.keymap.inoremap {'<C-e>', [[compe#close('<C-e>')]], silent = true, expr = true}
  vim.keymap.inoremap {'<C-f>', [[compe#scroll({ 'delta': +4 })]], silent = true, expr = true}
  vim.keymap.inoremap {'<C-d>', [[compe#scroll({ 'delta': -4 })]], silent = true, expr = true}

  async:close()
end))
async:send()

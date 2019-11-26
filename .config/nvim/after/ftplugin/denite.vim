nn <silent><buffer><expr> <CR> denite#do_map('do_action')
nn <silent><buffer><expr> d denite#do_map('do_action', 'delete')
nn <silent><buffer><expr> p denite#do_map('do_action', 'preview')
nn <silent><buffer><expr> q denite#do_map('quit')
nn <silent><buffer><expr> i denite#do_map('open_filter_buffer')
nn <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'

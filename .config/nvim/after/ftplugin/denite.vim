" Maps
nnor <silent><buffer><expr> <CR> denite#do_map('do_action')
nnor <silent><buffer><expr> d denite#do_map('do_action', 'delete')
nnor <silent><buffer><expr> p denite#do_map('do_action', 'preview')
nnor <silent><buffer><expr> q denite#do_map('quit')
nnor <silent><buffer><expr> i denite#do_map('open_filter_buffer')
nnor <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'

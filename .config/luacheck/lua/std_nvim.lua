-- Notes:
-- I'm not including the entries in certain tables.
-- A lot of them are included, but right now I don't intend to include fields
-- for vim.api, vim.o, vim.bo, or vim.wo.
-- Maybe that'll change in the future.
--
-- Just use these to define basic common structures
local RO = {read_only = true}
local ROC = {read_only = true, other_fields = true}
local RW = {read_only = false}
local RWC = {read_only = false, other_fields = true}

-- common structures
local S = {
  ['complete-items'] = {
    fields = {'word', 'abbr', 'menu', 'info', 'kind', 'icase', 'equal', 'dup', 'empty', 'user_data'},
  },
}
return {
  read_globals = {
    vim = {
      fields = {
        loop = ROC,
        highlight = {fields = {'create', 'link', 'on_yank', 'range'}},
        'regex',
        api = ROC, -- There's too much stuff to justify including here
        'version',
        'in_fast_event',
        'NIL',
        'empty_dict',
        'region',
        'register_keystroke_callback',
        'rpcnotify',
        'rpcrequest',
        'stricmp',
        'str_utfindex',
        'str_byteindex',
        'schedule',
        'defer_fn',
        'wait',
        'type_idx',
        'val_idx',
        types = {fields = {'array', 'dictionary', 'float'}},
        'call',
        'cmd',
        fn = ROC,
        g = RWC,
        b = RWC,
        w = RWC,
        t = RWC,
        v = {
          -- a lot of v: values are read-only.
          -- they also tend to only be valid at specific times, but luacheck can't deal with that.
          -- v:lua isn't accessible via the Lua API (but it's just _G anyway)
          -- v:true & v:false aren't accessible via the Lua API (use true and false)
          -- v:beval_* doesn't make sense in neovim
          -- v:key & v:val are functionally inaccessable in Lua
          read_only = true,
          fields = {
            'argv',
            'char',
            'charconvert_from',
            'charconvert_to',
            'cmdarg',
            'cmdbang',
            completed_item = {
              fields = {
                'word', 'abbr', 'menu', 'info', 'kind', 'icase', 'equal', 'dup', 'empty',
                'user_data',
              },
            },
            'count',
            'count1',
            'ctype', -- controlled by :lang
            'dying',
            'exiting',
            'echospace',
            errmsg = RW,
            errors = RW,
            event = ROC, -- autocmd event data; fields not set to keep formatting cleaner
            'exception',
            'fcs_reason',
            fcs_choice = RW, -- I THINK this is RW?
            'fname_in',
            'fname_out',
            'fname_new',
            'fname_diff',
            folddashes = RW, -- RO in sandbox
            foldlevel = RW, -- RO in sandbox
            foldend = RW, -- RO in sandbox
            foldstart = RW, -- RO in sandbox
            hlsearch = RW,
            'insertmode',
            'lang', -- controlled by :lang
            'lc_time', -- controlled by :lang
            'lnum', -- RO in sandbox
            'mouse_win',
            'mouse_winid',
            'mouse_lnum',
            'mouse_col',
            msgpack_types = ROC,
            'null', -- always nil
            'oldfiles', -- technically RW but don't fuck with it
            'option_new',
            'option_old',
            'option_type',
            'operator',
            'prevcount',
            'profiling',
            'progname',
            'progpath',
            'register',
            'scrollstart',
            'servername',
            searchforward = RW,
            'shell_error',
            statusmsg = RW,
            'stderr',
            'swapname',
            swapchoice = RW,
            'swapcommand',
            't_bool',
            't_dict',
            't_float',
            't_func',
            't_list',
            't_number',
            't_string',
            termresponse = RW,
            testing = RW,
            this_session = RW,
            'throwpoint',
            'version',
            'vim_did_enter',
            warningmsg = RW,
            windowid = RW,
          },
        },
        env = RWC,
        o = {
          -- Only includes locked variables
          read_only = false,
          other_fields = true,
          fields = {
            compatible = RO,
            cp = RO,
            edcompatible = RO,
            ed = RO,
            encoding = RO,
            enc = RO,
            highlight = RO,
            hl = RO,
            maxcombine = RO,
            mco = RO,
            ttyfast = RO,
            tf = RO,
          },
        },
        bo = {read_only = false, other_fields = true, fields = {channel = RO}},
        wo = RWC,
        'inspect', -- This has fields but I don't wanna deal with them
        'make_meta_accessor',
        'paste',
        'schedule_wrap',
        'deep_equal',
        'deepcopy',
        'endswith',
        'gsplit',
        'is_callable',
        'is_valid',
        'list_extend',
        'pesc',
        'split',
        'startswith',
        'tbl_add_reverse_lookup',
        'tbl_contains',
        'tbl_count',
        'tbl_deep_extend',
        'tbl_extend',
        'tbl_filter',
        'tbl_flatten',
        'tbl_isempty',
        'tbl_islist',
        'tbl_keys',
        'tbl_map',
        'tbl_values',
        'trim',
        'validate',
        'uri_from_bufnr',
        'uri_from_fname',
        'uri_to_bufnr',
        'uri_to_fname',
        -- Undocumented
        'funcref',
        log = {fields = {levels = {fields = {'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR'}}}},
        -- Modules
        F = {fields = {'if_nil', 'ok_or_nil', 'npcall'}},
        lsp = {
          fields = {
            'buf_attach_client',
            'buf_get_clients',
            'buf_is_attached',
            'buf_notify',
            'buf_request',
            'buf_request_sync',
            'client',
            'client_is_stopped',
            'get_active_clients',
            'get_buffers_by_client_id',
            'get_client_by_id',
            'get_log_path',
            'omnifunc',
            'set_log_level',
            'start_client',
            'stop_client',
            'with',
            buf = {
              fields = {
                'add_workspace_folder', 'clear_references', 'code_action', 'completion',
                'declaration', 'definition', 'document_highlight', 'document_symbol',
                'execute_command', 'formatting', 'formatting_sync', 'hover', 'implementation',
                'incoming_calls', 'list_workspace_folders', 'outgoing_calls', 'range_code_action',
                'range_formatting', 'references', 'remove_workspace_folder', 'rename',
                'server_ready', 'signature_help', 'type_definition', 'workspace_symbol',
              },
            },
            diagnostic = {
              fields = {
                'clear', 'get', 'get_all', 'get_count', 'get_line_diagnostics', 'get_next',
                'get_next_pos', 'get_prev', 'get_prev_pos', 'get_virtual_text_chunks_for_line',
                'goto_next', 'goto_prev', 'on_publish_diagnostics', 'save', 'set_loclist',
                'set_signs', 'set_underline', 'set_virtual_text', 'show_line_diagnostics',
              },
            },
            handlers = {other_fields = true, read_only = false, fields = {'progress_callback'}},
            util = {
              fields = {
                'apply_text_document_edit', 'apply_text_edits', 'apply_workspace_edit',
                'buf_clear_references', 'buf_highlight_references', 'character_offset',
                'close_preview_autocmd', 'convert_input_to_markdown_lines',
                'convert_signature_help_to_markdown_lines', 'extract_completion_items',
                'fancy_floating_markdown', 'focusable_float', 'focusable_preview',
                'get_effective_tabstop', 'get_progress_messages', 'jump_to_location',
                'locations_to_items', 'lookup_section', 'make_floating_popup_options',
                'make_formatting_params', 'make_given_range_params', 'make_position_params',
                'make_range_params', 'make_text_document_params', 'make_workspace_params',
                'open_floating_preview', 'parse_snippet', 'preview_location', 'set_lines',
                'set_loclist', 'set_qflist', 'symbols_to_items',
                'text_document_completion_list_to_complete_items', 'trim_empty_lines',
                'try_trim_markdown_code_blocks',
              },
            },
            log = {fields = {'get_filename', 'set_level', 'should_log'}},
            rpc = {
              fields = {'format_rpc_error', 'notify', 'request', 'rpc_response_error', 'start'},
            },
            protocol = {
              other_fields = true,
              read_only = false,
              fields = {'make_client_capabilities', 'resolve_capabilities'},
            },
          },
        },
        treesitter = {
          fields = {
            'get_parser',
            'get_string_parser',
            'get_query_files',
            'get_query',
            'parse_query',
            'get_node_text',
            'add_predicate',
            'add_directive',
            'list_predicates',
            'require_language',
            'inspect_language',
            highlighter = {other_fields = true}, -- too lazy to do right now
          },
        },
        -- Non-standard but still present in my case
        keymap = {
          fields = {
            'map', 'noremap', 'nmap', 'nnoremap', 'vmap', 'vnoremap', 'xmap', 'xnoremap', 'smap',
            'snoremap', 'omap', 'onoremap', 'imap', 'inoremap', 'lmap', 'lnoremap', 'cmap',
            'cnoremap', 'tmap', 'tnoremap',
          },
        },
      },
    },
  },
  globals = {
    -- Non-standard
    'packer_plugins',
  },
}

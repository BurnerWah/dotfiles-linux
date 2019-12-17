"""GNU Debugger Configuration File."""
import gdb

import gdb_dashboard

import gdb_stack_inspector

from xdg.BaseDirectory import xdg_cache_home

gdb.execute('set history save')
gdb.execute('set history filename ' + xdg_cache_home + '/gdb_history')
gdb.execute('set verbose off')
gdb.execute('set print pretty on')
gdb.execute('set print array off')
gdb.execute('set print array-indexes on')
gdb.execute('set python print-stack full')

gdb_dashboard.Dashboard.start()
gdb_stack_inspector.StackVisualizer()
# gdb.execute('python Dashboard.start()')

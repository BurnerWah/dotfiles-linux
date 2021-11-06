# This extends the standard rpm completions
source $__fish_data_dir/completions/rpm.fish

set rpm_query -c rpm -n "__fish_contains_opt -s q query"

complete $rpm_query -l recommends -d 'List capabilities this package recommends'
complete $rpm_query -l suggests -d 'List capabilities this package suggests'
complete $rpm_query -l supplements -d 'List capabilities this package supplements'
complete $rpm_query -l enhances -d 'List capabilities this package enhances'

set -e rpm_query

set rpm_select -c rpm -n "__fish_contains_opt -s q -s V query verify"

complete $rpm_select -l whatconflicts -d 'Query all packages that conflict with a capability'
complete $rpm_select -l whatobsoletes -d 'Query all packages that obsolete a capability'
complete $rpm_select -l whatrecommends -d 'Query all packages that recommends a capability'
complete $rpm_select -l whatsuggests -d 'Query all packages that suggest a capability'
complete $rpm_select -l whatsupplements -d 'Query all packages that supplement a capability'
complete $rpm_select -l whatenhances -d 'Query all packages that enhance a capability'

set -e rpm_select

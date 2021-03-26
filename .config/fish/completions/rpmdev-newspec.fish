# rpmdev-newspec(1) completion
# target version: 2.4

set -l prog rpmdev-newspec

complete -c $prog -x

complete -c $prog -r -s o -l output -d "Output the specfile to FILE (- for STDOUT)"
complete -c $prog -x -s t -l type -d "Force use of the TYPE spec template" -a "dummy lib minimal ocaml perl php-pear python R ruby"
complete -c $prog -s m -l macros -d "Emit templates using macros instead of shell style variables"
complete -c $prog -x -s r -l rpm-version -d "Ignore spec file constructs not needed by a rpm(build) version"
complete -c $prog -s h -l help -d "Show this usage message and exit"
complete -c $prog -s v -l version -d "Print version information and exit"

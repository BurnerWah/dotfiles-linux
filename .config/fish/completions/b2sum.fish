# b2sum(1) completion
# target version: coreutils 8.32

set -l has_check "__fish_contains_opt -s c check"

complete -c b2sum -r

complete -c b2sum    -s b -l binary         -d "Read in binary mode"
complete -c b2sum    -s c -l check          -d "Read sums from files & check them" -n "! $has_check"
complete -c b2sum -x -s l -l length         -d "Digest length in bits"
complete -c b2sum         -l tag            -d "Create a BSD-style checksum"
complete -c b2sum    -s t -l text           -d "Read in text mode (default)"
complete -c b2sum    -s z -l zero           -d "End each output line with NUL"
complete -c b2sum         -l ignore-missing -d "Don't fail or report status for missing files"         -n "$has_check"
complete -c b2sum         -l quiet          -d "Don't print OK for each successfully verified file"    -n "$has_check"
complete -c b2sum         -l status         -d "Don't output anything, status code shows success"      -n "$has_check"
complete -c b2sum         -l strict         -d "Exit non-zero for improperly formatted checksum lines" -n "$has_check"
complete -c b2sum    -s w -l warn           -d "Warn about improperly formatted checksum lines"        -n "$has_check"
complete -c b2sum         -l help           -d "Print help & exit"
complete -c b2sum         -l version        -d "Print version info & exit"

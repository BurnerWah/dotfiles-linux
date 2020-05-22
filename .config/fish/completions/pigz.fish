# pigz(1) completion
# target version: 2.4
#
# The CLI for pigz is an extension of gzip, so we should be relying on the
# completion of gzip whenever possible
#
# It would be nice to share more of this code with the unpigz completions

set -l has_zopfli "__fish_contains_opt -s 11"
set -l has_format "__fish_contains_opt -s K zip -s z zlib"
set -l has_time   "__fish_contains_opt -s m no-time -s M time"

complete -c pigz -w gzip

complete -c gzip -x -s d -l decompress  -d "Decompress the compressed input" -a "(
  __fish_complete_suffix .gz
  __fish_complete_suffix .tgz
  __fish_complete_suffix .zz
  __fish_complete_suffix .zip
)\t"
# the \t at the end stops the flag's description from being applied to files

complete -c pigz -x -s b -l blocksize   -d "Set block size to mmmK (default: 128K)"
complete -c pigz    -s i -l independent -d "Compress blocks independently for damage recovery"
complete -c pigz -x -s p -l processes   -d "Allow up to N compression threads"
complete -c pigz    -s R -l rsyncable   -d "Input-determined block locations for rsync"
complete -c pigz    -s k -l keep        -d "Don't delete original file after processing"

complete -c pigz    -s m -l no-time -d "Don't store/restore mod time" -n "! $has_time"
complete -c pigz    -s M -l time    -d "Store/restore mod time"       -n "! $has_time"

complete -c pigz    -o 11              -d "Use the zopfli algorithm (better compression but slower)"   -n "! $has_zopfli"
complete -c pigz    -s F -l first      -d "Do iterations first, before block split (default: last)"    -n "$has_zopfli"
complete -c pigz -x -s I -l iterations -d "Number of iterations for optimization (default: 15)"        -n "$has_zopfli"
complete -c pigz -x -s J -l maxsplits  -d "Max number of split blocks (default: 15)"                   -n "$has_zopfli"
complete -c pigz    -s O -l opeblock   -d "Don't split into smaller blocks (default: block splitting)" -n "$has_zopfli"

complete -c pigz    -s K -l zip  -d "Compress to PKWare zip (.zip) single entry format" -n "! $has_format"
complete -c pigz    -s z -l zlib -d "Compress to zlib (.zz) instead of gzip format"     -n "! $has_format"

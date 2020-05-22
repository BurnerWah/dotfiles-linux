# unpigz completion
#
# Adapted from pigz completion

set -l has_format "__fish_contains_opt -s K zip -s z zlib"
set -l has_time   "__fish_contains_opt -s m no-time -s M time"

complete -c unpigz -w gunzip

complete -c unipgz -x -a "(
  __fish_complete_suffix .gz
  __fish_complete_suffix .tgz
  __fish_complete_suffix .zz
  __fish_complete_suffix .zip
)"

complete -c unpigz    -s i -l independent -d "Decompress blocks independently for damage recovery"
complete -c unpigz    -s k -l keep        -d "Don't delete original file after processing"
complete -c unpigz    -s R -l rsyncable   -d "Input-determined block locations for rsync"
complete -c unpigz -x -s b -l blocksize   -d "Set block size to mmmK (default: 128K)"
complete -c unpigz -x -s p -l processes   -d "Allow up to N decompression threads"

complete -c unpigz    -s m -l no-time -d "Don't restore mod time" -n "! $has_time"
complete -c unpigz    -s M -l time    -d "Restore mod time"       -n "! $has_time"

complete -c unpigz    -s K -l zip  -d "Decompress PKWare zip (.zip) single entry format" -n "! $has_format"
complete -c unpigz    -s z -l zlib -d "Decompress zlib (.zz) instead of gzip format"     -n "! $has_format"

# Unified pigz/unpigz completion
# Modeled after gzip/gunzip

set -l has_zopfli "__fish_contains_opt -s 11"
set -l has_format "__fish_contains_opt -s K zip -s z zlib"

complete -c pigz -w gzip
complete -c unpigz -w gunzip

complete -c gzip -x -s d -l decompress -d "Decompress the compressed input" -a "(
    __fish_complete_suffix .gz
    __fish_complete_suffix .tgz
)\t"
# the \t at the end stops the flag's description from being applied to files

complete -c{pigz,unpigz} -x -s b -l blocksize -d "Set block size to mmmK (default: 128K)"
complete -c{pigz,unpigz} -x -s p -l processes -d "Allow up to N threads"
complete -c{pigz,unpigz} -s K -l zip -d "Use to PKWare zip (.zip) single entry format" -n "! $has_format"
complete -c{pigz,unpigz} -s z -l zlib -d "Use to zlib (.zz) instead of gzip format" -n "! $has_format"

complete -c pigz -o 11 -d "Use the zopfli algorithm (better compression but slower)" -n "! $has_zopfli"
complete -c pigz -s F -l first -d "Do iterations first, before block split (default: last)" -n "$has_zopfli"
complete -c pigz -x -s I -l iterations -d "Number of iterations for optimization (default: 15)" -n "$has_zopfli"
complete -c pigz -x -s J -l maxsplits -d "Max number of split blocks (default: 15)" -n "$has_zopfli"
complete -c pigz -s O -l opeblock -d "Don't split into smaller blocks (default: block splitting)" -n "$has_zopfli"

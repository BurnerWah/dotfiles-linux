# lzma(1) completion
# FIXME find some way to remove xz(1) args we don't need
# FIXME find some way to ignore .xz & .txz files
complete -c lzma -w xz
complete -c lzma -s d -l decompress -l uncompress -d Decompress -x -a "(
  __fish_complete_suffix .lzma
  __fish_complete_suffix .tlz
)
"

# brotli(1) - file compression tool
# NOTE brotli actually requires the --flag=value form
set -l has __fish_contains_opt

complete -c brotli -s{0,1,2,3,4,5,6,7,8,9} -d "Compression level (0-9)"

complete -c brotli -x -s d -l decompress -d "Decompress the compressed input" \
    -a "(__fish_complete_suffix .br)\t"

complete -c brotli -s c -l stdout -d "Compress to stdout"
complete -c brotli -s f -l force -d Overwrite
complete -c brotli -s h -l help -d "Display help and exit"
complete -c brotli -s j -l rm -d "Remove source files" -n "! $has -s j rm -s k keep"
complete -c brotli -s k -l keep -d "Keep source files" -n "! $has -s j rm -s k keep"
complete -c brotli -s n -l no-copy-stat -d "Don't copy file attributes"
complete -rc brotli -s o -l output= -d "Output file"
complete -c brotli -s t -l test -d "Check integrity"
complete -c brotli -s v -l verbose -d "Display compression ratios"
complete -xc brotli -s w -l lgwin= -d "LZ77 window size"
complete -xc brotli -s S -l suffix= -d Suffix
complete -c brotli -s V -l version -d "Display version and exit"
complete -c brotli -s Z -l best -d "Use high compression setting"

complete -xc brotli -s q -d "Compression level (0-11)" -n "! $has -s Z best" -a "(seq 0 11)\t"
for i in (seq 0 11)
    complete -c brotli -l quality=$i -d "Compression level (0-11)"
end

set -l has __fish_contains_opt
set -l modes base64 base64url base32 base32hex base16 base2msbf base2lsbf

complete -c basenc -l base64 -d "Same as 'base64' program" -n "! $has $modes"
complete -c basenc -l base64url -d "File- and url-safe base64" -n "! $has $modes"
complete -c basenc -l base32 -d "Same as 'base32' program" -n "! $has $modes"
complete -c basenc -l base32hex -d "Extended hex alphabet base32" -n "! $has $modes"
complete -c basenc -l base16 -d "Hex encoding" -n "! $has $modes"
complete -c basenc -l base2msbf -d "Bit string with most significant bit (msb) first" -n "! $has $modes"
complete -c basenc -l base2lsbf -d "Bit string with least significant bit (lsb) first" -n "! $has $modes"
complete -c basenc -s d -l decode -d "Decode data"
complete -c basenc -s i -l ignore-garbage -d "When decoding, ignore non-alphabet characters" -n "$has -s d decode"
complete -c basenc -x -s w -l wrap -d "Wrap encoded lines after COLS character (default 76)"
complete -c basenc -l z85 -d "Ascii85-like  encoding  (ZeroMQ spec:32/Z85)"
complete -c basenc -l help -d "Display help & exit"
complete -c basenc -l version -d "Display version & exit"

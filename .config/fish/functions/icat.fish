# this is meant to future-proof the icat alias. It should be a relatively
# stable interface to draw images (I.E. icat <image> should work)
# function icat -w "kitty +kitten icat"
#     switch $argv[1]
#         case "*.svg"
#             command kitty +kitten icat $argv
#         case "*"
#             if command -qs viu
#                 command viu $argv
#             end
#     end
# end
switch "$TERM"
    case xterm-kitty
        function icat -w "kitty +kitten icat"
            command kitty +kitten icat $argv
        end
end

# set -l ppid (rg '^PPid:' /proc/$fish_pid/status | string match -r '\d+')

# switch (basename (readlink -f /proc/$ppid/exe))
#     case kitty
#         function icat -w "kitty +kitten icat"
#             command kitty +kitten icat $argv
#         end
#     case wezterm-gui
#         function icat -w "wezterm imgcat"
#             command wezterm imgcat $argv
#         end
# end

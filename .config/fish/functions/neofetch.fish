# Simple neofetch(1) wrapper
# it's just here to tell neofetch what shell we're in instead of using $SHELL
if command -qs neofetch
    function neofetch
        set -lx SHELL (command -s fish)
        command neofetch $argv
    end
end

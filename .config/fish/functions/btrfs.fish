function btrfs
    # Apply some defaults to btrfs commands in a kinda awkward way
    if isatty stdout
        switch $argv[1]
            case "d*"
                if string match -q -- "u*" $argv[2]
                    set argv $argv[1..2] -H $argv[3..-1]
                end
            case "f*"
                switch $argv[2]
                    case df "u*"
                        set argv $argv[1..2] -H $argv[3..-1]
                    case du
                        set argv $argv[1..2] --si $argv[3..-1]
                end
        end
    end
    command btrfs $argv
end

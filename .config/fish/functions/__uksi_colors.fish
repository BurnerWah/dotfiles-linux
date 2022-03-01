function __uksi_colors
    switch $argv[1]
        case push
            printf "\e]30001\e\\"
        case pop
            printf "\e]30101\e\\"
    end
end

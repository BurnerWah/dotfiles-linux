# Wrapper that improves a few brew(1) commands
function brew -d "The Missing Package Manager for macOS"
    switch $argv[1]

        # Colorized concatenation of formulae
        case cat
            if [ $argv[2] != --help ] && command -qs bat
                command brew $argv \
                    | bat --language=ruby --paging=never --color=auto --style=plain
            else
                command brew $argv
            end

            # unmodified commands
        case '*'
            command brew $argv
    end
end
